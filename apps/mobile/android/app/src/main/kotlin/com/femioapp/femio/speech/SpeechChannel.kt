// Speech to text that never leaves the phone (owner 2026-11-27, ADR-086).
//
// Why it exists: she asked for a microphone on Ask femio and Say it. Android's own on-device
// recognizer (SpeechRecognizer.createOnDeviceSpeechRecognizer, Android 12+) turns her voice
// into words on the phone; femio never records, keeps or sends audio. There is deliberately no
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

class SpeechChannel(private val activity: Activity, messenger: BinaryMessenger) {
    private val channel = MethodChannel(messenger, "femio/speech")
    private var recognizer: SpeechRecognizer? = null

    // The "listen" call waiting for her words, and its language while the permission is asked.
    private var pending: MethodChannel.Result? = null
    private var pendingLocale: String? = null

    init {
        channel.setMethodCallHandler { call, result ->
            when (call.method) {
                "listen" -> listen(call.argument<String>("locale").orEmpty(), result)
                "stop" -> {
                    recognizer?.stopListening()
                    result.success(null)
                }
                "appSettings" -> {
                    openAppSettings()
                    result.success(null)
                }
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

    private fun start(locale: String) {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.S) return finish(error = "old_android")
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
            override fun onError(error: Int) = finish(error = reason(error))
            override fun onReadyForSpeech(params: Bundle?) {}
            override fun onBeginningOfSpeech() {}
            override fun onRmsChanged(rmsdB: Float) {}
            override fun onBufferReceived(buffer: ByteArray?) {}
            override fun onEndOfSpeech() {}
            override fun onEvent(eventType: Int, params: Bundle?) {}
        })
        val intent = Intent(RecognizerIntent.ACTION_RECOGNIZE_SPEECH).apply {
            putExtra(RecognizerIntent.EXTRA_LANGUAGE_MODEL, RecognizerIntent.LANGUAGE_MODEL_FREE_FORM)
            if (locale.isNotEmpty()) putExtra(RecognizerIntent.EXTRA_LANGUAGE, locale)
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

    private fun openAppSettings() {
        val intent = Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS, Uri.fromParts("package", activity.packageName, null))
        activity.startActivity(intent)
    }

    fun dispose() {
        finish(error = "other")
        channel.setMethodCallHandler(null)
    }

    private companion object {
        const val PERMISSION_REQUEST = 0x5EE
    }
}
