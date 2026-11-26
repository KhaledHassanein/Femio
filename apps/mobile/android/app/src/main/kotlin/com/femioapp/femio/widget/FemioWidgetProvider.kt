// The home-screen widget: the femio wordmark and one line, nothing else (R9.11).
//
// Why it exists: she can keep femio one tap away on her home screen. The widget is neutral
// by default ("femio" and "Open femio", no health word) and shows the pregnancy week or the
// next-period range only after she turns that on in Settings. It never reads her sealed
// record: Dart decides the words (domain/home_widget.dart) and hands over two finished
// strings, which are stored here and drawn as they are. A tap opens the app.

package com.femioapp.femio.widget

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.ComponentName
import android.content.Context
import android.widget.RemoteViews
import com.femioapp.femio.R

class FemioWidgetProvider : AppWidgetProvider() {

    override fun onUpdate(context: Context, manager: AppWidgetManager, appWidgetIds: IntArray) {
        for (id in appWidgetIds) manager.updateAppWidget(id, render(context))
    }

    companion object {
        // The only two things the widget ever stores. A private file, excluded from every
        // backup and device transfer by the app's rule files.
        private const val PREFS = "femio_widget"
        private const val KEY_TITLE = "title"
        private const val KEY_LINE = "line"

        // Dart sends short lines; this cap only guards the layout from a damaged value.
        private const val MAX_LENGTH = 80

        /** Stores the two display strings Dart computed and redraws every widget on the screen. */
        fun save(context: Context, title: String, line: String) {
            context.getSharedPreferences(PREFS, Context.MODE_PRIVATE).edit()
                .putString(KEY_TITLE, title.take(MAX_LENGTH))
                .putString(KEY_LINE, line.take(MAX_LENGTH))
                .apply()
            val manager = AppWidgetManager.getInstance(context)
            val ids = manager.getAppWidgetIds(ComponentName(context, FemioWidgetProvider::class.java))
            for (id in ids) manager.updateAppWidget(id, render(context))
        }

        /**
         * The widget's views. Before the app has ever pushed anything (the widget was added
         * first), it falls back to the neutral wordmark and the phone-language "Open femio".
         */
        private fun render(context: Context): RemoteViews {
            val prefs = context.getSharedPreferences(PREFS, Context.MODE_PRIVATE)
            val views = RemoteViews(context.packageName, R.layout.femio_widget)
            views.setTextViewText(R.id.widget_title, prefs.getString(KEY_TITLE, null) ?: "femio")
            views.setTextViewText(
                R.id.widget_line,
                prefs.getString(KEY_LINE, null) ?: context.getString(R.string.widget_neutral_line),
            )
            val launch = context.packageManager.getLaunchIntentForPackage(context.packageName)
            if (launch != null) {
                val tap = PendingIntent.getActivity(
                    context, 0, launch, PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
                )
                views.setOnClickPendingIntent(R.id.widget_root, tap)
            }
            return views
        }
    }
}
