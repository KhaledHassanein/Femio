// The app's only Android activity. It hosts Flutter and registers femio's native bridges:
// the assistant (ADR-078), so model calls stay in Kotlin and out of the Dart code; the
// share sheet (R10.2), so she can send her visit pack with the app she picks; the
// home-screen widget's two-string channel (R9.11); her documents' PDF pages and file
// sharing (R11.2); and the screen protection that follows her app lock (SEC-1, ADR-083).
// None opens a network connection.

package com.femioapp.femio

import android.content.Intent
import android.os.Bundle
import com.femioapp.femio.assistant.FemioAssistant
import com.femioapp.femio.files.FilesChannel
import com.femioapp.femio.lock.LockState
import com.femioapp.femio.lock.SecureScreenChannel
import com.femioapp.femio.widget.HomeWidgetChannel
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private var assistant: FemioAssistant? = null
    private var widget: HomeWidgetChannel? = null
    private var files: FilesChannel? = null
    private var secure: SecureScreenChannel? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        // Before the first frame: with a PIN set, not even the launch picture may be captured
        // or kept in recent apps. Dart confirms or corrects the flag once her vault is read.
        SecureScreenChannel.apply(this, LockState.isOn(this))
        super.onCreate(savedInstanceState)
    }

    override fun onResume() {
        super.onResume()
        // Back from the share sheet: a copy she shared more than a few minutes ago has had
        // its chance to be read, so it goes (SEC-15). The newest stays for a slow receiver.
        files?.clearStaleShares()
    }

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
        files = FilesChannel(applicationContext, flutterEngine.dartExecutor.binaryMessenger) { startActivity(it) }
        secure = SecureScreenChannel(this, flutterEngine.dartExecutor.binaryMessenger)
    }

    override fun cleanUpFlutterEngine(flutterEngine: FlutterEngine) {
        assistant?.dispose()
        assistant = null
        widget?.dispose()
        widget = null
        files?.dispose()
        files = null
        secure?.dispose()
        secure = null
        super.cleanUpFlutterEngine(flutterEngine)
    }
}
