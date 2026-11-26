// The Kotlin end of the home-screen widget's method channel (R9.11).
//
// Why it exists: Dart (lib/data/home_widget_bridge.dart) computes the widget's two display
// strings and sends them here over `femio/widget`; this file hands them to the widget
// provider and does nothing else. It has no way to read her record and opens no connection.

package com.femioapp.femio.widget

import android.content.Context
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel

class HomeWidgetChannel(private val context: Context, messenger: BinaryMessenger) {
    private val channel = MethodChannel(messenger, "femio/widget")

    init {
        channel.setMethodCallHandler { call, result ->
            when (call.method) {
                "update" -> {
                    val title = call.argument<String>("title")
                    val line = call.argument<String>("line")
                    if (title == null || line == null) {
                        result.error("bad_args", "title and line are required", null)
                    } else {
                        FemioWidgetProvider.save(context, title, line)
                        result.success(null)
                    }
                }
                else -> result.notImplemented()
            }
        }
    }

    fun dispose() = channel.setMethodCallHandler(null)
}
