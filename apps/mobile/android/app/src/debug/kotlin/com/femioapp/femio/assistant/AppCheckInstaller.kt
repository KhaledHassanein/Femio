// App Check for debug builds (ADR-078 §5): the debug provider prints a token to logcat that the
// owner registers once in the Firebase console, so a phone without Play Integrity can still call
// Firebase AI Logic during development and for the hackathon demo.

package com.femioapp.femio.assistant

import com.google.firebase.FirebaseApp
import com.google.firebase.appcheck.FirebaseAppCheck
import com.google.firebase.appcheck.debug.DebugAppCheckProviderFactory

object AppCheckInstaller {
    /** Installs the debug App Check provider on [app]. */
    fun install(app: FirebaseApp) {
        FirebaseAppCheck.getInstance(app).installAppCheckProviderFactory(DebugAppCheckProviderFactory.getInstance())
    }
}
