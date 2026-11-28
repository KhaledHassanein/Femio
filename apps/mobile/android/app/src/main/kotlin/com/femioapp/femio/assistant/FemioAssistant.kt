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
//
// `privateImage` is the same phone-only call with one page picture of a document she chose to
// have read (ADR-087): the image is decoded, scaled down and handed to Gemini Nano; it never
// leaves the phone, and there is no cloud fallback.
//
// A third call, `check`, sends one fixed public sentence to the cloud model only, so she (and
// the owner testing a build) can see whether Cloud boost really reaches Google, and if not,
// why: App Check refused the app, the API is off, no network, quota, and so on. Failures are
// written to logcat with that reason; the log never holds her text.

package com.femioapp.femio.assistant

import android.content.Context
import android.content.Intent
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.net.Uri
import android.os.SystemClock
import android.util.Log
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
import com.google.firebase.ai.type.InvalidAPIKeyException
import com.google.firebase.ai.type.PermissionMissingException
import com.google.firebase.ai.type.QuotaExceededException
import com.google.firebase.ai.type.RequestTimeoutException
import com.google.firebase.ai.type.ServiceDisabledException
import com.google.firebase.ai.type.UnsupportedUserLocationException
import com.google.firebase.ai.InferenceMode
import com.google.firebase.ai.InferenceSource
import com.google.firebase.ai.OnDeviceConfig
import com.google.firebase.ai.OnDeviceModelOption
import com.google.firebase.ai.type.PublicPreviewAPI
import com.google.firebase.ai.type.content
import com.google.firebase.ai.type.generationConfig
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.TimeoutCancellationException
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import kotlinx.coroutines.withTimeout

/** Channel name shared with `lib/data/assistant_channel.dart`. */
const val ASSISTANT_CHANNEL = "com.femioapp.femio/assistant"

/** Output budget for on-device calls; Google advises staying under 256 tokens. */
private const val ON_DEVICE_MAX_OUTPUT_TOKENS = 200

/** Output budget for reading one document page: about 25 short result lines. */
private const val SCAN_MAX_OUTPUT_TOKENS = 256

/** A page picture is scaled so its longer side is at most this many pixels before Nano reads it. */
private const val SCAN_MAX_SIDE_PX = 1024

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

/** Logcat tag for assistant failures (reason codes only, never her text). */
private const val LOG_TAG = "femio-ai"

/** The longest part of an exception message written to logcat. */
private const val LOG_MESSAGE_LIMIT = 300

/** The fixed, public sentence the Cloud boost check sends. Nothing about her. */
const val CLOUD_CHECK_PROMPT = "Reply with the single word OK."

@OptIn(PublicPreviewAPI::class)
class FemioAssistant(private val context: Context, messenger: BinaryMessenger) : MethodChannel.MethodCallHandler {
    private val channel = MethodChannel(messenger, ASSISTANT_CHANNEL)
    private val scope = CoroutineScope(SupervisorJob() + Dispatchers.Main)
    private var app: FirebaseApp? = null

    /** Null until tried; false once this phone showed it has no preview (Nano 4) model. */
    @Volatile private var previewWorks: Boolean? = null

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
                // Everything except opening a page runs off the main thread: building the
                // Firebase app, App Check and the model can block, and a blocked main thread
                // froze femio's screen until Android offered to close it (ANR, 27 Nov).
                // The result is still answered on the main thread, as Flutter requires.
                val value: Any? = if (call.method == "open") {
                    openInBrowser(context, call.argument<String>("url").orEmpty())
                } else {
                    withContext(Dispatchers.Default) {
                        when (call.method) {
                            "status" -> status()
                            "download" -> download()
                            "private" -> private(call.argument<String>("prompt").orEmpty())
                            "privateImage" -> privateImage(
                                call.argument<String>("prompt").orEmpty(),
                                call.argument<ByteArray>("image") ?: ByteArray(0),
                            )
                            "hybrid" -> hybrid(call.argument<String>("prompt").orEmpty())
                            "check" -> check()
                            else -> NotImplemented
                        }
                    }
                }
                if (value === NotImplemented) result.notImplemented() else result.success(value)
            } catch (e: Exception) {
                // The message is a class name and a reason code, never her text.
                val reason = failureReason(e)
                logFailure(call.method, reason, e)
                result.error("assistant_failed", e.javaClass.simpleName, reason)
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
    private suspend fun private(prompt: String): Map<String, Any?> =
        withTimeout(CALL_TIMEOUT_MS) {
            onDevice(InferenceMode.ONLY_ON_DEVICE, ON_DEVICE_MAX_OUTPUT_TOKENS) { model ->
                withContext(Dispatchers.IO) { model.generateContent(prompt) }
            }
        }

    /**
     * Runs [call] with the newest on-device model the phone has: Gemini Nano 4 (the PREVIEW
     * category) first, then the STABLE model (Nano 3 or 2) if the phone has no preview model.
     * A phone without the preview model is remembered, so later calls go straight to STABLE.
     * A timeout is not a missing model and is passed on. Returns the text, where it ran and which
     * model category answered ("preview" or "stable").
     */
    private suspend fun onDevice(
        mode: InferenceMode,
        tokens: Int,
        call: suspend (GenerativeModel) -> GenerateContentResponse,
    ): Map<String, Any?> {
        val tryPreview = previewWorks != false
        // Only a phone-only call can tell "no preview model" apart from a cloud failure, so only
        // it retries; a hybrid call without the preview model is answered by the cloud anyway.
        if (tryPreview && mode == InferenceMode.ONLY_ON_DEVICE) {
            try {
                return answer(call(model(mode, tokens, OnDeviceModelOption.PREVIEW)), "preview").also { previewWorks = true }
            } catch (e: TimeoutCancellationException) {
                throw e
            } catch (e: Exception) {
                previewWorks = false
                logFailure("preview", failureReason(e), e)
            }
            return answer(call(model(mode, tokens, OnDeviceModelOption.STABLE)), "stable")
        }
        val option = if (tryPreview) OnDeviceModelOption.PREVIEW else OnDeviceModelOption.STABLE
        return answer(call(model(mode, tokens, option)), if (tryPreview) "preview" else "stable")
    }

    /** The reply map; "model" names the on-device category only when the phone answered. */
    private fun answer(response: GenerateContentResponse, category: String): Map<String, Any?> {
        val source = sourceName(response)
        return mapOf("text" to response.text, "source" to source, "model" to if (source == "ON_DEVICE") category else null)
    }

    /**
     * Runs [prompt] with one page picture [image] (PNG or JPEG bytes) on the phone only. The
     * picture is scaled down first; an unreadable picture fails like an absent model, so Dart
     * keeps its "attach only" path.
     */
    private suspend fun privateImage(prompt: String, image: ByteArray): Map<String, Any?> {
        val bitmap = scaledPage(image) ?: throw IllegalArgumentException("unreadable_image")
        try {
            val request = content {
                image(bitmap)
                text(prompt)
            }
            return withTimeout(CALL_TIMEOUT_MS) {
                onDevice(InferenceMode.ONLY_ON_DEVICE, SCAN_MAX_OUTPUT_TOKENS) { model ->
                    withContext(Dispatchers.IO) { model.generateContent(request) }
                }
            }
        } finally {
            bitmap.recycle()
        }
    }

    /**
     * Runs [prompt] on the phone when Gemini Nano is ready, otherwise in the cloud
     * (PREFER_ON_DEVICE). Dart only calls this with text built from a cloud-safe type and
     * public registry passages, and only after she switched Cloud boost on.
     */
    private suspend fun hybrid(prompt: String): Map<String, Any?> =
        withTimeout(CALL_TIMEOUT_MS) {
            // With Nano ready, PREFER_ON_DEVICE runs on the phone; the category picks Nano 4
            // when the phone has it. Without Nano the category is ignored and the cloud answers.
            onDevice(InferenceMode.PREFER_ON_DEVICE, ON_DEVICE_MAX_OUTPUT_TOKENS) { model ->
                withContext(Dispatchers.IO) { model.generateContent(prompt) }
            }
        }

    /**
     * Sends [CLOUD_CHECK_PROMPT] to the cloud model only (ONLY_IN_CLOUD) and reports whether an
     * answer came back, how long it took, or the reason it failed. Dart calls it only while
     * Cloud boost is on.
     */
    private suspend fun check(): Map<String, Any?> {
        val started = SystemClock.elapsedRealtime()
        return try {
            val model = model(InferenceMode.ONLY_IN_CLOUD)
            val response = withTimeout(CALL_TIMEOUT_MS) { withContext(Dispatchers.IO) { model.generateContent(CLOUD_CHECK_PROMPT) } }
            val ok = !response.text.isNullOrBlank()
            if (!ok) Log.w(LOG_TAG, "check: empty answer")
            mapOf(
                "ok" to ok,
                "reason" to if (ok) null else "empty",
                "ms" to (SystemClock.elapsedRealtime() - started).toInt(),
                "source" to sourceName(response),
            )
        } catch (e: Exception) {
            val reason = failureReason(e)
            logFailure("check", reason, e)
            mapOf("ok" to false, "reason" to reason, "ms" to (SystemClock.elapsedRealtime() - started).toInt())
        }
    }

    /** "ON_DEVICE" or "IN_CLOUD", spelled here so Dart never depends on the SDK's toString. */
    private fun sourceName(response: GenerateContentResponse): String =
        if (response.inferenceSource == InferenceSource.ON_DEVICE) "ON_DEVICE" else "IN_CLOUD"

    /**
     * Builds the model for one call. [option] picks the on-device model category; Firebase's
     * default is STABLE (Nano 3 or 2), and Gemini Nano 4 is only reached with PREVIEW
     * (https://firebase.google.com/docs/ai-logic/hybrid/android/configuration-options, read
     * 2026-11-28). Throws "not_configured" when the build carries no Firebase config.
     */
    private fun model(
        mode: InferenceMode,
        onDeviceTokens: Int = ON_DEVICE_MAX_OUTPUT_TOKENS,
        option: OnDeviceModelOption = OnDeviceModelOption.STABLE,
    ): GenerativeModel {
        val firebase = firebase() ?: throw IllegalStateException("not_configured")
        val maxTokens = if (mode == InferenceMode.ONLY_ON_DEVICE) onDeviceTokens else CLOUD_MAX_OUTPUT_TOKENS
        return Firebase.ai(app = firebase, backend = GenerativeBackend.googleAI()).generativeModel(
            modelName = BuildConfig.FEMIO_AI_CLOUD_MODEL,
            generationConfig = generationConfig { maxOutputTokens = maxTokens },
            onDeviceConfig = OnDeviceConfig(mode = mode, maxOutputTokens = onDeviceTokens, modelOption = option),
        )
    }

    /** The Firebase app built from assistant.env, or null when the build carries no config. */
    private fun firebase(): FirebaseApp? {
        app?.let { return it }
        if (BuildConfig.FEMIO_FIREBASE_APP_ID.isBlank() || BuildConfig.FEMIO_FIREBASE_API_KEY.isBlank()) return null
        val builder = FirebaseOptions.Builder()
            .setApplicationId(BuildConfig.FEMIO_FIREBASE_APP_ID)
            .setApiKey(BuildConfig.FEMIO_FIREBASE_API_KEY)
            .setProjectId(BuildConfig.FEMIO_FIREBASE_PROJECT_ID)
        // Play Integrity reads the project number from the sender ID; without it App Check
        // failed with NumberFormatException and every cloud call was refused (Lab 0, 27 Nov).
        projectNumber(BuildConfig.FEMIO_FIREBASE_APP_ID)?.let { builder.setGcmSenderId(it) }
        val options = builder.build()
        val created = FirebaseApp.getApps(context).firstOrNull { it.name == FIREBASE_APP_NAME }
            ?: FirebaseApp.initializeApp(context, options, FIREBASE_APP_NAME)
        AppCheckInstaller.install(created)
        app = created
        return created
    }
}

/**
 * Decodes [bytes] and scales the picture so its longer side is at most [SCAN_MAX_SIDE_PX];
 * null when the bytes are not a picture Android can read.
 */
internal fun scaledPage(bytes: ByteArray): Bitmap? {
    if (bytes.isEmpty()) return null
    val bounds = BitmapFactory.Options().apply { inJustDecodeBounds = true }
    BitmapFactory.decodeByteArray(bytes, 0, bytes.size, bounds)
    if (bounds.outWidth <= 0 || bounds.outHeight <= 0) return null
    var sample = 1
    while (maxOf(bounds.outWidth, bounds.outHeight) / (sample * 2) >= SCAN_MAX_SIDE_PX) sample *= 2
    val decoded = BitmapFactory.decodeByteArray(bytes, 0, bytes.size, BitmapFactory.Options().apply { inSampleSize = sample })
        ?: return null
    val side = maxOf(decoded.width, decoded.height)
    if (side <= SCAN_MAX_SIDE_PX) return decoded
    val scale = SCAN_MAX_SIDE_PX.toFloat() / side
    val scaled = Bitmap.createScaledBitmap(decoded, (decoded.width * scale).toInt(), (decoded.height * scale).toInt(), true)
    if (scaled !== decoded) decoded.recycle()
    return scaled
}

/** Marks a method femio's bridge does not know, so the channel answers notImplemented. */
private object NotImplemented

/**
 * The Cloud project number inside a Firebase app ID ("1:<number>:android:<hash>"), or null
 * when the ID does not have that shape. App Check's Play Integrity provider needs it.
 */
internal fun projectNumber(appId: String): String? =
    appId.split(":").getOrNull(1)?.takeIf { it.isNotEmpty() && it.all(Char::isDigit) }

/**
 * Names why a model call failed, as a short code Dart turns into words: `app_check`,
 * `service_disabled`, `api_key`, `quota`, `permission`, `location`, `network`, `timeout`,
 * `not_configured`, `on_device_unavailable` or `other`. Reads the exception and its causes.
 */
internal fun failureReason(e: Throwable): String {
    val chain = generateSequence(e) { it.cause }.take(6).toList()
    val text = chain.joinToString(" ") { "${it.javaClass.simpleName} ${it.message.orEmpty()}" }.lowercase()
    fun any(predicate: (Throwable) -> Boolean) = chain.any(predicate)
    return when {
        any { it is IllegalStateException && it.message == "not_configured" } -> "not_configured"
        any { it is TimeoutCancellationException || it is RequestTimeoutException } -> "timeout"
        "app check" in text || "appcheck" in text || "app_check" in text || "attestation" in text -> "app_check"
        any { it is ServiceDisabledException } || "service_disabled" in text || "has not been used" in text -> "service_disabled"
        any { it is InvalidAPIKeyException } || "api key not valid" in text -> "api_key"
        any { it is QuotaExceededException } || "quota" in text || "billing" in text || "resource_exhausted" in text -> "quota"
        any { it is UnsupportedUserLocationException } || "location is not supported" in text -> "location"
        any { it is PermissionMissingException } || "permission_denied" in text || "403" in text -> "permission"
        "ondevice" in text || "aicore" in text -> "on_device_unavailable"
        any { it is java.io.IOException } || "unable to resolve host" in text || "failed to connect" in text -> "network"
        else -> "other"
    }
}

/** Writes one failure to logcat: the call, the reason code, the exception class and a short message. */
private fun logFailure(method: String?, reason: String, e: Throwable) {
    val message = e.message.orEmpty().take(LOG_MESSAGE_LIMIT)
    Log.w(LOG_TAG, "$method failed [$reason]: ${e.javaClass.simpleName}: $message")
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
