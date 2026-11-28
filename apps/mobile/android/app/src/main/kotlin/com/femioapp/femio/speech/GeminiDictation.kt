// Speech to text with Gemini Nano on the phone, when the phone has it (owner 2026-11-28, ADR-088).
//
// Why it exists: ML Kit's GenAI Speech Recognition in Advanced mode runs on Gemini Nano through
// Android AICore. It hears Arabic, English, French and Spanish better than the older on-device
// recognizer, and it also never sends audio: the microphone stream is read and transcribed on
// the phone. When the phone has no Gemini Nano speech feature ready, or it fails before hearing
// a word, SpeechChannel uses Android's own on-device recognizer instead (the fallback the owner
// asked for). Nothing is downloaded from here: a feature that is not ready means the fallback.

package com.femioapp.femio.speech

import android.os.Build
import com.google.mlkit.genai.common.FeatureStatus
import com.google.mlkit.genai.common.audio.AudioSource
import com.google.mlkit.genai.speechrecognition.SpeechRecognition
import com.google.mlkit.genai.speechrecognition.SpeechRecognizerOptions
import com.google.mlkit.genai.speechrecognition.SpeechRecognizerResponse
import com.google.mlkit.genai.speechrecognition.speechRecognizerOptions
import com.google.mlkit.genai.speechrecognition.speechRecognizerRequest
import kotlinx.coroutines.CancellationException
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.Job
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch
import java.util.Locale
import com.google.mlkit.genai.speechrecognition.SpeechRecognizer as NanoRecognizer

/** The app languages Gemini Nano speech supports, as the locales ML Kit expects (Advanced mode). */
private val NANO_LOCALES = mapOf("ar" to "ar-SA", "en" to "en-US", "fr" to "fr-FR", "es" to "es-ES")

/** Stop after this much quiet once some words were heard, like the platform recognizer does. */
private const val QUIET_STOP_MS = 2500L

/** Stop if she has said nothing at all by then. */
private const val NOTHING_HEARD_STOP_MS = 8000L

/** The longest one listen may run. */
private const val MAX_LISTEN_MS = 60_000L

/** After asking ML Kit to stop, how long to wait for it to end the stream before ending it here. */
private const val STOP_GRACE_MS = 2000L

/**
 * One listen with Gemini Nano. [onPartial] gets the running words. [start] calls `fallback`
 * when Nano speech cannot run here, or `done` with her words or a reason code.
 */
internal class GeminiDictation(private val onPartial: (String) -> Unit) {
    private val scope = CoroutineScope(SupervisorJob() + Dispatchers.Main)
    private var client: NanoRecognizer? = null
    private var listen: Job? = null
    private var timer: Job? = null
    private val words = StringBuilder()
    private var heard = false
    private var onDone: ((String?, String?) -> Unit)? = null

    /** True while a Nano listen is running, so "stop" goes here and not to the platform. */
    val active: Boolean get() = listen?.isActive == true

    fun start(locale: String, fallback: () -> Unit, done: (text: String?, error: String?) -> Unit) {
        val tag = NANO_LOCALES[locale.substringBefore('-').lowercase(Locale.ROOT)]
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.S || tag == null) return fallback()
        words.setLength(0)
        heard = false
        onDone = done
        listen = scope.launch {
            val c = try {
                SpeechRecognition.getClient(
                    speechRecognizerOptions {
                        this.locale = Locale.forLanguageTag(tag)
                        preferredMode = SpeechRecognizerOptions.Mode.MODE_ADVANCED
                    },
                )
            } catch (e: Exception) {
                null
            } ?: return@launch handBack(fallback)
            val status = try {
                c.checkStatus()
            } catch (e: Exception) {
                FeatureStatus.UNAVAILABLE
            }
            if (status != FeatureStatus.AVAILABLE) {
                c.close()
                return@launch handBack(fallback)
            }
            client = c
            stopAfter(NOTHING_HEARD_STOP_MS)
            val cap = scope.launch {
                delay(MAX_LISTEN_MS)
                stop()
            }
            try {
                c.startRecognition(speechRecognizerRequest { audioSource = AudioSource.fromMic() }).collect { r ->
                    when (r) {
                        is SpeechRecognizerResponse.PartialTextResponse -> {
                            heard = true
                            stopAfter(QUIET_STOP_MS)
                            onPartial(joined(words, r.text))
                        }
                        is SpeechRecognizerResponse.FinalTextResponse -> {
                            heard = true
                            if (r.text.isNotBlank()) {
                                if (words.isNotEmpty()) words.append(' ')
                                words.append(r.text.trim())
                            }
                            stopAfter(QUIET_STOP_MS)
                            onPartial(words.toString())
                        }
                        is SpeechRecognizerResponse.ErrorResponse -> throw r.e
                        else -> {}
                    }
                }
                deliver()
            } catch (e: CancellationException) {
                close()
                throw e
            } catch (e: Exception) {
                if (heard) {
                    deliver()
                } else {
                    close()
                    handBack(fallback)
                }
            } finally {
                cap.cancel()
            }
        }
    }

    /** Ends the listen; the words heard so far come back through `done`. */
    fun stop() {
        val c = client
        if (c == null) {
            // Still checking whether Nano speech is ready: she stopped before it listened.
            listen?.cancel()
            deliver()
            return
        }
        scope.launch {
            try {
                c.stopRecognition()
            } catch (_: Exception) {
                // Already stopped.
            }
            // If the stream does not end by itself, end it here with what was heard.
            delay(STOP_GRACE_MS)
            if (client === c) {
                deliver()
                listen?.cancel()
            }
        }
    }

    /** Nano speech cannot run: the platform recognizer takes over this listen. */
    private fun handBack(fallback: () -> Unit) {
        if (onDone == null) return
        onDone = null
        fallback()
    }

    /** Hands her words (or "no_speech") to the waiting call, once. */
    private fun deliver() {
        val d = onDone ?: return
        onDone = null
        close()
        val text = words.toString().trim()
        if (text.isEmpty()) d(null, "no_speech") else d(text, null)
    }

    fun dispose() {
        onDone = null
        listen?.cancel()
        close()
    }

    private fun stopAfter(ms: Long) {
        timer?.cancel()
        timer = scope.launch {
            delay(ms)
            stop()
        }
    }

    private fun close() {
        timer?.cancel()
        timer = null
        try {
            client?.close()
        } catch (_: Exception) {
            // Closing twice is harmless.
        }
        client = null
    }

    private fun joined(words: StringBuilder, partial: String): String =
        if (words.isEmpty()) partial else "$words ${partial.trim()}"
}
