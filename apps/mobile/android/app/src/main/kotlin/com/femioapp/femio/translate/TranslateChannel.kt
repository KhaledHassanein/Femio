// The phone's own translator for the AI on this phone (ADR-087 §6): Google's ML Kit
// on-device translation between English and her app language.
//
// Why it exists: Gemini Nano is validated for English only, so when she writes in Arabic,
// French or Spanish femio can translate her question to English, let Nano answer, and translate
// the answer back, all on the phone. The language file (about 30 MB) is downloaded from Google
// only when she taps Download in Assistant settings; after that translation works offline. Her
// words are never sent: ML Kit sends Google only technical usage data (device model, app
// version, timings, sizes, the language pair), which the privacy notice lists.

package com.femioapp.femio.translate

import com.google.android.gms.tasks.Tasks
import com.google.mlkit.common.model.DownloadConditions
import com.google.mlkit.common.model.RemoteModelManager
import com.google.mlkit.nl.translate.TranslateLanguage
import com.google.mlkit.nl.translate.TranslateRemoteModel
import com.google.mlkit.nl.translate.Translation
import com.google.mlkit.nl.translate.TranslatorOptions
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import java.util.concurrent.TimeUnit

/** Channel name shared with `lib/data/translate_channel.dart`. */
const val TRANSLATE_CHANNEL = "femio/translate"

/** The only languages femio translates between (the app's four). */
private val LANGUAGES = setOf("en", "ar", "fr", "es")

/** The longest text translated in one call; Ask answers are about 120 words. */
private const val MAX_TEXT_CHARS = 4000

/** How long one translation may take before the AI answer is shown in English instead. */
private const val TRANSLATE_TIMEOUT_S = 10L

/** How long a language download may take. */
private const val DOWNLOAD_TIMEOUT_S = 600L

class TranslateChannel(messenger: BinaryMessenger) {
    private val channel = MethodChannel(messenger, TRANSLATE_CHANNEL)
    private val scope = CoroutineScope(SupervisorJob() + Dispatchers.Main)

    init {
        channel.setMethodCallHandler { call, result ->
            scope.launch {
                val value: Any? = try {
                    withContext(Dispatchers.IO) {
                        when (call.method) {
                            "ready" -> ready(call.argument<String>("lang").orEmpty())
                            "download" -> download(call.argument<String>("lang").orEmpty())
                            "remove" -> remove(call.argument<String>("lang").orEmpty())
                            "translate" -> translate(
                                call.argument<String>("text").orEmpty(),
                                call.argument<String>("from").orEmpty(),
                                call.argument<String>("to").orEmpty(),
                            )
                            else -> Unknown
                        }
                    }
                } catch (_: Exception) {
                    // Any failure means "no translation": Dart keeps the untranslated path.
                    null
                }
                if (value === Unknown) result.notImplemented() else result.success(value)
            }
        }
    }

    /** Stops answering calls; called when the Flutter engine goes away. */
    fun dispose() {
        channel.setMethodCallHandler(null)
    }

    private fun model(lang: String) = TranslateRemoteModel.Builder(lang).build()

    /** Whether the language file for [lang] is on the phone (English always is). */
    private fun ready(lang: String): Boolean {
        if (lang !in LANGUAGES) return false
        if (lang == "en") return true
        return Tasks.await(RemoteModelManager.getInstance().isModelDownloaded(model(lang)), TRANSLATE_TIMEOUT_S, TimeUnit.SECONDS)
    }

    /** Downloads the language file for [lang]; she asked for it, on any network. */
    private fun download(lang: String): Boolean {
        if (lang !in LANGUAGES || lang == "en") return false
        Tasks.await(
            RemoteModelManager.getInstance().download(model(lang), DownloadConditions.Builder().build()),
            DOWNLOAD_TIMEOUT_S,
            TimeUnit.SECONDS,
        )
        return true
    }

    /** Deletes the language file for [lang] from the phone. */
    private fun remove(lang: String): Boolean {
        if (lang !in LANGUAGES || lang == "en") return false
        Tasks.await(RemoteModelManager.getInstance().deleteDownloadedModel(model(lang)), TRANSLATE_TIMEOUT_S, TimeUnit.SECONDS)
        return true
    }

    /** [text] from [from] to [to], on the phone only; null when a language file is missing. */
    private fun translate(text: String, from: String, to: String): String? {
        if (from !in LANGUAGES || to !in LANGUAGES || from == to || text.isBlank() || text.length > MAX_TEXT_CHARS) return null
        if (!ready(from) || !ready(to)) return null
        val source = TranslateLanguage.fromLanguageTag(from) ?: return null
        val target = TranslateLanguage.fromLanguageTag(to) ?: return null
        val translator = Translation.getClient(TranslatorOptions.Builder().setSourceLanguage(source).setTargetLanguage(target).build())
        try {
            return Tasks.await(translator.translate(text), TRANSLATE_TIMEOUT_S, TimeUnit.SECONDS)
        } finally {
            translator.close()
        }
    }
}

/** Marks a method the channel does not know. */
private object Unknown
