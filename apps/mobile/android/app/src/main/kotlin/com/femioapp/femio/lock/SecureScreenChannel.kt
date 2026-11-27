// Screen protection that follows her app lock (SEC-1, SEC-14, ADR-083).
//
// Why it exists: while a PIN is set, Android must not keep a picture of her record. With
// FLAG_SECURE on, the recent-apps thumbnail is blank and screenshots and screen recordings
// come out black. Dart (lib/data/secure_screen.dart) says "on" when she sets a PIN and "off"
// when she removes it; this file applies the flag and remembers one boolean in a private
// preferences file, so the next cold start is protected before Flutter draws its first frame,
// and so the home-screen widget can show only neutral words while the lock is on. The
// boolean says only whether a lock exists; it holds no PIN and nothing from her record.
// No network.

package com.femioapp.femio.lock

import android.app.Activity
import android.content.Context
import android.os.SystemClock
import android.view.WindowManager
import com.femioapp.femio.widget.FemioWidgetProvider
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel

class SecureScreenChannel(private val activity: Activity, messenger: BinaryMessenger) {
    private val channel = MethodChannel(messenger, "femio/secure")

    init {
        channel.setMethodCallHandler { call, result ->
            when (call.method) {
                "set" -> {
                    val on = call.argument<Boolean>("on")
                    if (on == null) {
                        result.error("bad_args", "on is required", null)
                    } else {
                        val changed = LockState.isOn(activity) != on
                        LockState.set(activity, on)
                        val secure = on || LockState.isScreenHidden(activity)
                        activity.runOnUiThread { apply(activity, secure) }
                        // The widget shows details only while no lock is set: redraw it now.
                        if (changed) FemioWidgetProvider.redraw(activity.applicationContext)
                        result.success(null)
                    }
                }
                // Her choice to protect the screen without a PIN (SEC-1).
                "hide" -> {
                    val on = call.argument<Boolean>("on")
                    if (on == null) {
                        result.error("bad_args", "on is required", null)
                    } else {
                        LockState.setScreenHidden(activity, on)
                        val secure = on || LockState.isOn(activity)
                        activity.runOnUiThread { apply(activity, secure) }
                        result.success(null)
                    }
                }
                "hidden" -> result.success(LockState.isScreenHidden(activity))
                // The boot clock for the PIN wait (SEC-N2-1): the user cannot set it.
                "elapsed" -> result.success(SystemClock.elapsedRealtime())
                else -> result.notImplemented()
            }
        }
    }

    fun dispose() = channel.setMethodCallHandler(null)

    companion object {
        /** Adds or clears FLAG_SECURE on [activity]'s window. Call on the UI thread. */
        fun apply(activity: Activity, on: Boolean) {
            if (on) {
                activity.window.addFlags(WindowManager.LayoutParams.FLAG_SECURE)
            } else {
                activity.window.clearFlags(WindowManager.LayoutParams.FLAG_SECURE)
            }
        }
    }
}

/** The one remembered boolean: is an app lock set? Private file, excluded from every backup. */
object LockState {
    private const val PREFS = "femio_lock_state"
    private const val KEY_ON = "lock_on"
    private const val KEY_SCREEN = "screen_hidden"

    /** True when Dart last reported a PIN as set. */
    fun isOn(context: Context): Boolean =
        context.getSharedPreferences(PREFS, Context.MODE_PRIVATE).getBoolean(KEY_ON, false)

    /** Remembers whether a PIN is set. Written synchronously: it must survive a kill right after. */
    fun set(context: Context, on: Boolean) {
        context.getSharedPreferences(PREFS, Context.MODE_PRIVATE).edit().putBoolean(KEY_ON, on).commit()
    }

    /** True when she chose to protect the screen without a PIN (SEC-1). */
    fun isScreenHidden(context: Context): Boolean =
        context.getSharedPreferences(PREFS, Context.MODE_PRIVATE).getBoolean(KEY_SCREEN, false)

    /** Remembers her screen choice. Synchronous, like [set]. */
    fun setScreenHidden(context: Context, on: Boolean) {
        context.getSharedPreferences(PREFS, Context.MODE_PRIVATE).edit().putBoolean(KEY_SCREEN, on).commit()
    }
}
