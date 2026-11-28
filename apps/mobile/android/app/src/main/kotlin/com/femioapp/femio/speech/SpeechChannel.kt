// Speech to text that never leaves the phone (owner 2026-11-27 and 2026-11-28, ADR-086).
//
// Why it exists: she asked for a microphone on Ask femio, Say it and After a visit. On a phone
// with Gemini Nano speech ready, GeminiDictation transcribes on the phone with it; otherwise
// Android's own on-device recognizer (SpeechRecognizer.createOnDeviceSpeechRecognizer, Android
// 12+) turns her voice into words on the phone. When its offline pack for her language is
// missing, she can ask Android to download it ("downloadPack"). femio never records, keeps or sends audio. There
// is deliberately no
// fallback to the ordinary recognizer, which may send audio to a server: when the phone has no
// on-device recognizer, Dart says why and suggests the keyboard's own mic. The privacy tripwire
// (scripts/analytics-lint.mjs) allows RECORD_AUDIO only while this file keeps to that.
// The microphone permission is asked the first time she taps the mic, never at start.

package com.femioapp.femio.speech

import android.Manifest
import android.app.Activity
import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.provider.Settings
import android.speech.RecognitionListener
import android.speech.RecognizerIntent
import android.speech.SpeechRecognizer
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel
import java.util.Locale

class SpeechChannel(private val activity: Activity, messenger: BinaryMessenger) {
    private val channel = MethodChannel(messenger, "femio/speech")
    private var recognizer: SpeechRecognizer? = null
    private val nano = GeminiDictation { channel.invokeMethod("partial", it) }

    // The "listen" call waiting for her words, and its language while the permission is asked.
    private var pending: MethodChannel.Result? = null
    private var pendingLocale: String? = null

    init {
        channel.setMethodCallHandler { call, result ->
            when (call.method) {
                "listen" -> listen(call.argument<String>("locale").orEmpty(), result)
                "stop" -> {
                    if (nano.active) nano.stop() else recognizer?.stopListening()
                    result.success(null)
                }
                "appSettings" -> {
                    openAppSettings()
                    result.success(null)
                }
                "downloadPack" -> result.success(downloadPack(call.argument<String>("locale").orEmpty()))
                else -> result.notImplemented()
            }
        }
    }

    /** "ok", or the reason code Dart turns into her words. Android 12–12L cannot tell in advance. */
    private fun availability(): String = when {
        Build.VERSION.SDK_INT < Build.VERSION_CODES.S -> "old_android"
        Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU &&
            !SpeechRecognizer.isOnDeviceRecognitionAvailable(activity) -> "not_available"
        else -> "ok"
    }

    private fun listen(locale: String, result: MethodChannel.Result) {
        if (pending != null) return result.error("busy", null, "busy")
        val why = availability()
        if (why != "ok") return result.error(why, null, why)
        pending = result
        if (ContextCompat.checkSelfPermission(activity, Manifest.permission.RECORD_AUDIO) == PackageManager.PERMISSION_GRANTED) {
            start(locale)
        } else {
            pendingLocale = locale
            ActivityCompat.requestPermissions(activity, arrayOf(Manifest.permission.RECORD_AUDIO), PERMISSION_REQUEST)
        }
    }

    /** Called from MainActivity with every permission answer; true when it was ours. */
    fun onPermissionResult(requestCode: Int, grantResults: IntArray): Boolean {
        if (requestCode != PERMISSION_REQUEST) return false
        val locale = pendingLocale
        pendingLocale = null
        if (grantResults.firstOrNull() == PackageManager.PERMISSION_GRANTED && locale != null) {
            start(locale)
        } else {
            // No rationale after a refusal means Android will not ask again: only Settings can.
            val canAskAgain = ActivityCompat.shouldShowRequestPermissionRationale(activity, Manifest.permission.RECORD_AUDIO)
            finish(error = if (canAskAgain) "no_permission" else "no_permission_settings")
        }
        return true
    }

    /** Gemini Nano speech when the phone has it ready, else Android's on-device recognizer. */
    private fun start(locale: String) {
        nano.start(locale, fallback = { startOnDevice(locale) }, done = { text, error -> finish(text, error) })
    }

    /**
     * The language tags to try, best first. Recognizers name their offline packs by region
     * ("en-US", "ar-EG"), and a bare "en" can be refused although an English pack is installed,
     * so the phone's own region comes first when it speaks the same language, then a common
     * region, then the bare language.
     */
    private fun speechTags(locale: String): List<String> {
        val lang = locale.substringBefore('-').lowercase()
        if (lang.isEmpty()) return listOf("")
        val device = Locale.getDefault()
        return listOfNotNull(
            locale.takeIf { it.contains('-') },
            device.toLanguageTag().takeIf { device.language == lang && device.country.isNotEmpty() },
            DEFAULT_REGION[lang]?.let { "$lang-$it" },
            lang,
        ).distinct()
    }

    private fun startOnDevice(locale: String) = startOnDevice(speechTags(locale))

    /** Tries [tags] in order; a "language" refusal moves on to the next tag. */
    private fun startOnDevice(tags: List<String>) {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.S) return finish(error = "old_android")
        val tag = tags.firstOrNull() ?: return finish(error = "language")
        val r = try {
            SpeechRecognizer.createOnDeviceSpeechRecognizer(activity)
        } catch (e: Exception) {
            null
        } ?: return finish(error = "not_available")
        recognizer = r
        r.setRecognitionListener(object : RecognitionListener {
            override fun onPartialResults(partialResults: Bundle?) {
                firstWords(partialResults)?.let { channel.invokeMethod("partial", it) }
            }
            override fun onResults(results: Bundle?) = finish(text = firstWords(results).orEmpty())
            override fun onError(error: Int) {
                val why = reason(error)
                if (why == "language" && tags.size > 1) {
                    recognizer?.destroy()
                    recognizer = null
                    startOnDevice(tags.drop(1))
                } else {
                    finish(error = why)
                }
            }
            override fun onReadyForSpeech(params: Bundle?) {}
            override fun onBeginningOfSpeech() {}
            override fun onRmsChanged(rmsdB: Float) {}
            override fun onBufferReceived(buffer: ByteArray?) {}
            override fun onEndOfSpeech() {}
            override fun onEvent(eventType: Int, params: Bundle?) {}
        })
        val intent = Intent(RecognizerIntent.ACTION_RECOGNIZE_SPEECH).apply {
            putExtra(RecognizerIntent.EXTRA_LANGUAGE_MODEL, RecognizerIntent.LANGUAGE_MODEL_FREE_FORM)
            if (tag.isNotEmpty()) putExtra(RecognizerIntent.EXTRA_LANGUAGE, tag)
            putExtra(RecognizerIntent.EXTRA_PARTIAL_RESULTS, true)
            putExtra(RecognizerIntent.EXTRA_PREFER_OFFLINE, true)
        }
        try {
            r.startListening(intent)
        } catch (e: Exception) {
            finish(error = "not_available")
        }
    }

    private fun firstWords(bundle: Bundle?): String? =
        bundle?.getStringArrayList(SpeechRecognizer.RESULTS_RECOGNITION)?.firstOrNull()?.takeIf { it.isNotBlank() }

    /** Android's error number as a reason code; the on-device recognizer never uses the network. */
    private fun reason(error: Int): String = when (error) {
        SpeechRecognizer.ERROR_INSUFFICIENT_PERMISSIONS -> "no_permission"
        SpeechRecognizer.ERROR_NO_MATCH, SpeechRecognizer.ERROR_SPEECH_TIMEOUT -> "no_speech"
        SpeechRecognizer.ERROR_LANGUAGE_NOT_SUPPORTED, SpeechRecognizer.ERROR_LANGUAGE_UNAVAILABLE -> "language"
        SpeechRecognizer.ERROR_RECOGNIZER_BUSY -> "busy"
        SpeechRecognizer.ERROR_AUDIO -> "audio"
        else -> "not_available"
    }

    private fun finish(text: String? = null, error: String? = null) {
        recognizer?.destroy()
        recognizer = null
        val r = pending ?: return
        pending = null
        if (error == null) r.success(text) else r.error(error, null, error)
    }

    /**
     * Asks Android to download the offline speech pack for [locale] (Android 13+: the system
     * shows its own download prompt, and the pack comes from the phone's speech service, not
     * femio). Older phones open the voice input settings instead. Returns "started" or "settings".
     */
    private fun downloadPack(locale: String): String {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            try {
                val r = SpeechRecognizer.createOnDeviceSpeechRecognizer(activity)
                val tag = speechTags(locale).first()
                r.triggerModelDownload(Intent(RecognizerIntent.ACTION_RECOGNIZE_SPEECH).apply {
                    if (tag.isNotEmpty()) putExtra(RecognizerIntent.EXTRA_LANGUAGE, tag)
                })
                r.destroy()
                return "started"
            } catch (e: Exception) {
                // Fall through to the settings page.
            }
        }
        try {
            activity.startActivity(Intent(Settings.ACTION_VOICE_INPUT_SETTINGS))
        } catch (e: Exception) {
            openAppSettings()
        }
        return "settings"
    }

    private fun openAppSettings() {
        val intent = Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS, Uri.fromParts("package", activity.packageName, null))
        activity.startActivity(intent)
    }

    fun dispose() {
        nano.dispose()
        finish(error = "other")
        channel.setMethodCallHandler(null)
    }

    private companion object {
        const val PERMISSION_REQUEST = 0x5EE

        /** A common region per app language, tried when the phone's own region is another language's. */
        val DEFAULT_REGION = mapOf("en" to "US", "ar" to "EG", "fr" to "FR", "es" to "ES")
    }
}
