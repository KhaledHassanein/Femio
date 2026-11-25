// The app's only Android activity. It hosts Flutter and registers femio's one native bridge,
// the assistant (ADR-078), so model calls stay in Kotlin and out of the Dart code.

package com.femioapp.femio

import com.femioapp.femio.assistant.FemioAssistant
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity : FlutterActivity() {
    private var assistant: FemioAssistant? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        assistant = FemioAssistant(applicationContext, flutterEngine.dartExecutor.binaryMessenger)
    }

    override fun cleanUpFlutterEngine(flutterEngine: FlutterEngine) {
        assistant?.dispose()
        assistant = null
        super.cleanUpFlutterEngine(flutterEngine)
    }
}
