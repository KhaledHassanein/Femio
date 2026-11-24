// The one place the app talks to an AI model (ADR-078 §5): Firebase AI Logic, hybrid.
//
// Why it exists: the Dart side may not hold a network client (privacy tripwire), and the
// Firebase AI Logic on-device SDK is Android-only, so the model calls live here behind one
// method channel. Two kinds of call, never mixed:
//   - `private`  : her own words or record, run with InferenceMode.ONLY_ON_DEVICE (Gemini Nano
//                  through Android AICore). If Nano is absent the call fails and Dart falls back
//                  to its rules; it never falls back to the cloud.
//   - `grounded` : a general question the phone already redacted (Dart's CloudSafeText), run
//                  with InferenceMode.ONLY_IN_CLOUD and Google Search grounding, so the answer
//                  comes with its web sources and Google's search suggestions.
// Config comes from git-ignored `apps/mobile/assistant.env` through BuildConfig; without it the
// assistant reports "not configured" and every feature stays on the phone's rules.

package com.femioapp.femio.assistant

import android.content.Context
import com.femioapp.femio.BuildConfig
import com.google.firebase.Firebase
import com.google.firebase.FirebaseApp
import com.google.firebase.FirebaseOptions
import com.google.firebase.ai.GenerativeModel
import com.google.firebase.ai.ai
import com.google.firebase.ai.ondevice.DownloadStatus
import com.google.firebase.ai.ondevice.FirebaseAIOnDevice
import com.google.firebase.ai.ondevice.OnDeviceModelStatus
import com.google.firebase.ai.type.GenerateContentResponse
import com.google.firebase.ai.type.GenerativeBackend
import com.google.firebase.ai.InferenceMode
import com.google.firebase.ai.InferenceSource
import com.google.firebase.ai.OnDeviceConfig
import com.google.firebase.ai.type.PublicPreviewAPI
import com.google.firebase.ai.type.Tool
import com.google.firebase.ai.type.content
import com.google.firebase.ai.type.generationConfig
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext

/** Channel name shared with `lib/data/assistant_channel.dart`. */
const val ASSISTANT_CHANNEL = "com.femioapp.femio/assistant"

/** Output budget for on-device calls; Google advises staying under 256 tokens. */
private const val ON_DEVICE_MAX_OUTPUT_TOKENS = 200

/** Output budget for the grounded cloud answer (about 120 words in any of the four languages). */
private const val CLOUD_MAX_OUTPUT_TOKENS = 400

/** Name of the Firebase app instance, so it never clashes with a default app. */
private const val FIREBASE_APP_NAME = "femio-assistant"

@OptIn(PublicPreviewAPI::class)
class FemioAssistant(private val context: Context, messenger: BinaryMessenger) : MethodChannel.MethodCallHandler {
    private val channel = MethodChannel(messenger, ASSISTANT_CHANNEL)
    private val scope = CoroutineScope(SupervisorJob() + Dispatchers.Main)
    private var app: FirebaseApp? = null

    init {
        channel.setMethodCallHandler(this)
    }

    /** Stops answering calls; called when the Flutter engine goes away. */
    fun dispose() {
        channel.setMethodCallHandler(null)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        scope.launch {
            try {
                when (call.method) {
                    "status" -> result.success(status())
                    "download" -> result.success(download())
                    "open" -> result.success(openInBrowser(context, call.argument<String>("url").orEmpty()))
                    "private" -> result.success(private(call.argument<String>("prompt").orEmpty()))
                    "grounded" -> result.success(
                        grounded(call.argument<String>("question").orEmpty(), call.argument<String>("instruction").orEmpty()),
                    )
                    else -> result.notImplemented()
                }
            } catch (e: Exception) {
                // The message is a class name and a short reason, never her text.
                result.error("assistant_failed", e.javaClass.simpleName, null)
            }
        }
    }

    /** Whether Firebase is configured, and the state of the on-device model. */
    private suspend fun status(): Map<String, Any> {
        val onDevice = try {
            when (withContext(Dispatchers.IO) { FirebaseAIOnDevice.checkStatus() }) {
                OnDeviceModelStatus.AVAILABLE -> "available"
                OnDeviceModelStatus.DOWNLOADABLE -> "downloadable"
                OnDeviceModelStatus.DOWNLOADING -> "downloading"
                else -> "unavailable"
            }
        } catch (_: Exception) {
            "unavailable"
        }
        return mapOf("configured" to (firebase() != null), "onDevice" to onDevice)
    }

    /** Downloads Gemini Nano through AICore; true when it is ready to use. */
    private suspend fun download(): Boolean {
        var done = false
        FirebaseAIOnDevice.download().collect { s ->
            if (s is DownloadStatus.DownloadCompleted) done = true
        }
        return done
    }

    /** Runs [prompt] on the phone only. Returns the text and where it ran. */
    private suspend fun private(prompt: String): Map<String, Any?> {
        val model = model(InferenceMode.ONLY_ON_DEVICE, tools = null, instruction = null)
        val response = withContext(Dispatchers.IO) { model.generateContent(prompt) }
        return mapOf("text" to response.text, "source" to sourceName(response))
    }

    /**
     * Answers a redacted general [question] in the cloud with Google Search grounding.
     * Returns the text, the web sources, the search queries and Google's suggestions chip HTML,
     * which the grounding terms require the app to show.
     */
    private suspend fun grounded(question: String, instruction: String): Map<String, Any?> {
        val model = model(InferenceMode.ONLY_IN_CLOUD, tools = listOf(Tool.googleSearch()), instruction = instruction)
        val response: GenerateContentResponse = withContext(Dispatchers.IO) { model.generateContent(question) }
        val grounding = response.candidates.firstOrNull()?.groundingMetadata
        val sources = grounding?.groundingChunks.orEmpty().mapNotNull { chunk ->
            chunk.web?.let { web -> mapOf("title" to (web.title ?: web.domain ?: ""), "uri" to (web.uri ?: "")) }
        }
        return mapOf(
            "text" to response.text,
            "source" to sourceName(response),
            "sources" to sources,
            "queries" to grounding?.webSearchQueries.orEmpty(),
            "suggestionsHtml" to grounding?.searchEntryPoint?.renderedContent,
        )
    }

    /** "ON_DEVICE" or "IN_CLOUD", spelled here so Dart never depends on the SDK's toString. */
    private fun sourceName(response: GenerateContentResponse): String =
        if (response.inferenceSource == InferenceSource.ON_DEVICE) "ON_DEVICE" else "IN_CLOUD"

    private fun model(mode: InferenceMode, tools: List<Tool>?, instruction: String?): GenerativeModel {
        val firebase = firebase() ?: throw IllegalStateException("not_configured")
        val maxTokens = if (mode == InferenceMode.ONLY_ON_DEVICE) ON_DEVICE_MAX_OUTPUT_TOKENS else CLOUD_MAX_OUTPUT_TOKENS
        return Firebase.ai(app = firebase, backend = GenerativeBackend.googleAI()).generativeModel(
            modelName = BuildConfig.FEMIO_AI_CLOUD_MODEL,
            generationConfig = generationConfig { maxOutputTokens = maxTokens },
            tools = tools,
            systemInstruction = instruction?.takeIf { it.isNotBlank() }?.let { content { text(it) } },
            onDeviceConfig = OnDeviceConfig(mode = mode, maxOutputTokens = ON_DEVICE_MAX_OUTPUT_TOKENS),
        )
    }

    /** The Firebase app built from assistant.env, or null when the build carries no config. */
    private fun firebase(): FirebaseApp? {
        app?.let { return it }
        if (BuildConfig.FEMIO_FIREBASE_APP_ID.isBlank() || BuildConfig.FEMIO_FIREBASE_API_KEY.isBlank()) return null
        val options = FirebaseOptions.Builder()
            .setApplicationId(BuildConfig.FEMIO_FIREBASE_APP_ID)
            .setApiKey(BuildConfig.FEMIO_FIREBASE_API_KEY)
            .setProjectId(BuildConfig.FEMIO_FIREBASE_PROJECT_ID)
            .build()
        val created = FirebaseApp.getApps(context).firstOrNull { it.name == FIREBASE_APP_NAME }
            ?: FirebaseApp.initializeApp(context, options, FIREBASE_APP_NAME)
        AppCheckInstaller.install(created)
        app = created
        return created
    }
}
