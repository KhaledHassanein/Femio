// The app's only Android activity. It hosts Flutter and registers femio's two native bridges:
// the assistant (ADR-078), so model calls stay in Kotlin and out of the Dart code, and the
// share sheet (R10.2), so she can send her visit pack with the app she picks. Neither opens a
// network connection of its own.

package com.femioapp.femio

import android.content.Intent
import com.femioapp.femio.assistant.FemioAssistant
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private var assistant: FemioAssistant? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        assistant = FemioAssistant(applicationContext, flutterEngine.dartExecutor.binaryMessenger)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "femio/share").setMethodCallHandler { call, result ->
            if (call.method != "text") return@setMethodCallHandler result.notImplemented()
            val text = call.argument<String>("text")
            if (text.isNullOrEmpty()) return@setMethodCallHandler result.error("no_text", null, null)
            val send = Intent(Intent.ACTION_SEND).apply {
                type = "text/plain"
                putExtra(Intent.EXTRA_TEXT, text)
                call.argument<String>("subject")?.let { putExtra(Intent.EXTRA_SUBJECT, it) }
            }
            startActivity(Intent.createChooser(send, null))
            result.success(true)
        }
    }

    override fun cleanUpFlutterEngine(flutterEngine: FlutterEngine) {
        assistant?.dispose()
        assistant = null
        super.cleanUpFlutterEngine(flutterEngine)
    }
}
