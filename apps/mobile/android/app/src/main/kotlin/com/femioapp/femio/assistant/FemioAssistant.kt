// The one place the app talks to an AI model (ADR-078 §5): Firebase AI Logic, hybrid.
//
// Why it exists: the Dart side may not hold a network client (privacy tripwire), and the
// Firebase AI Logic on-device SDK is Android-only, so the model calls live here behind one
// method channel. Two kinds of call, never mixed:
//   - `private`  : her own words or record, run with InferenceMode.ONLY_ON_DEVICE (Gemini Nano
//                  through Android AICore). If Nano is absent the call fails and Dart falls back
//                  to its rules; it never falls back to the cloud.
//   - `hybrid`   : only with her opt-in (Cloud boost, ADR-079): a prompt Dart built from one of
//                  the two cloud-safe types (CloudSafeText or PseudonymisedProfile) plus public
//                  registry passages, run with InferenceMode.PREFER_ON_DEVICE: Gemini Nano when
//                  the phone has it, the cloud model when it does not. No tools, no web search:
//                  every answer stands on the bundled trusted-source registry.
// Config comes from git-ignored `apps/mobile/assistant.env` through BuildConfig; without it the
// assistant reports "not configured" and every feature stays on the phone's rules.

package com.femioapp.femio.assistant

import android.content.Context
import android.content.Intent
import android.net.Uri
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
import com.google.firebase.ai.type.generationConfig
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import kotlinx.coroutines.withTimeout

/** Channel name shared with `lib/data/assistant_channel.dart`. */
const val ASSISTANT_CHANNEL = "com.femioapp.femio/assistant"

/** Output budget for on-device calls; Google advises staying under 256 tokens. */
private const val ON_DEVICE_MAX_OUTPUT_TOKENS = 200

/** Output budget for a cloud answer (about 120 words in any of the four languages). */
private const val CLOUD_MAX_OUTPUT_TOKENS = 400

/**
 * The longest a model call may run, matching `assistantCallTimeout` in
 * lib/data/assistant_gateway.dart (SEC-12). Dart stops waiting at 20 s; without this the
 * native call would carry on, and a cloud request could still complete after she was told
 * the rules answer stands. Cancelling the coroutine cancels the SDK's request.
 */
private const val CALL_TIMEOUT_MS = 20_000L

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
                    "hybrid" -> result.success(hybrid(call.argument<String>("prompt").orEmpty()))
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
        val model = model(InferenceMode.ONLY_ON_DEVICE)
        val response = withTimeout(CALL_TIMEOUT_MS) { withContext(Dispatchers.IO) { model.generateContent(prompt) } }
        return mapOf("text" to response.text, "source" to sourceName(response))
    }

    /**
     * Runs [prompt] on the phone when Gemini Nano is ready, otherwise in the cloud
     * (PREFER_ON_DEVICE). Dart only calls this with text built from a cloud-safe type and
     * public registry passages, and only after she switched Cloud boost on.
     */
    private suspend fun hybrid(prompt: String): Map<String, Any?> {
        val model = model(InferenceMode.PREFER_ON_DEVICE)
        val response = withTimeout(CALL_TIMEOUT_MS) { withContext(Dispatchers.IO) { model.generateContent(prompt) } }
        return mapOf("text" to response.text, "source" to sourceName(response))
    }

    /** "ON_DEVICE" or "IN_CLOUD", spelled here so Dart never depends on the SDK's toString. */
    private fun sourceName(response: GenerateContentResponse): String =
        if (response.inferenceSource == InferenceSource.ON_DEVICE) "ON_DEVICE" else "IN_CLOUD"

    private fun model(mode: InferenceMode): GenerativeModel {
        val firebase = firebase() ?: throw IllegalStateException("not_configured")
        val maxTokens = if (mode == InferenceMode.ONLY_ON_DEVICE) ON_DEVICE_MAX_OUTPUT_TOKENS else CLOUD_MAX_OUTPUT_TOKENS
        return Firebase.ai(app = firebase, backend = GenerativeBackend.googleAI()).generativeModel(
            modelName = BuildConfig.FEMIO_AI_CLOUD_MODEL,
            generationConfig = generationConfig { maxOutputTokens = maxTokens },
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

/**
 * Opens a source page in her browser. Only https links are opened; anything else is refused, so
 * a bad registry entry cannot launch another app. Returns whether a page was opened.
 */
fun openInBrowser(context: Context, url: String): Boolean {
    val uri = Uri.parse(url)
    if (uri.scheme != "https") return false
    context.startActivity(Intent(Intent.ACTION_VIEW, uri).addFlags(Intent.FLAG_ACTIVITY_NEW_TASK))
    return true
}
