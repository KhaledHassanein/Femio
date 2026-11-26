// The app's only Android activity. It hosts Flutter and registers femio's native bridges:
// the assistant (ADR-078), so model calls stay in Kotlin and out of the Dart code; the
// share sheet (R10.2), so she can send her visit pack with the app she picks; and the
// home-screen widget's two-string channel (R9.11). None opens a network connection.

package com.femioapp.femio

import android.content.Intent
import com.femioapp.femio.assistant.FemioAssistant
import com.femioapp.femio.widget.HomeWidgetChannel
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private var assistant: FemioAssistant? = null
    private var widget: HomeWidgetChannel? = null

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
        widget = HomeWidgetChannel(applicationContext, flutterEngine.dartExecutor.binaryMessenger)
    }

    override fun cleanUpFlutterEngine(flutterEngine: FlutterEngine) {
        assistant?.dispose()
        assistant = null
        widget?.dispose()
        widget = null
        super.cleanUpFlutterEngine(flutterEngine)
    }
}
