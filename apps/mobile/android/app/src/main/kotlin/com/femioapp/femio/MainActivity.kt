// The app's only Android activity. It hosts Flutter and registers femio's native bridges: the
// assistant (ADR-078), so model calls stay in Kotlin and out of the Dart code, and the
// home-screen widget's two-string channel (R9.11).

package com.femioapp.femio

import com.femioapp.femio.assistant.FemioAssistant
import com.femioapp.femio.widget.HomeWidgetChannel
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity : FlutterActivity() {
    private var assistant: FemioAssistant? = null
    private var widget: HomeWidgetChannel? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        assistant = FemioAssistant(applicationContext, flutterEngine.dartExecutor.binaryMessenger)
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
