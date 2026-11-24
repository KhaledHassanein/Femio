// App Check for store builds (ADR-078 §5): Play Integrity proves the request comes from the real
// femio app on a real phone, so nobody can spend the project's AI quota from a copied key.

package com.femioapp.femio.assistant

import com.google.firebase.FirebaseApp
import com.google.firebase.appcheck.FirebaseAppCheck
import com.google.firebase.appcheck.playintegrity.PlayIntegrityAppCheckProviderFactory

object AppCheckInstaller {
    /** Installs the Play Integrity App Check provider on [app]. */
    fun install(app: FirebaseApp) {
        FirebaseAppCheck.getInstance(app).installAppCheckProviderFactory(PlayIntegrityAppCheckProviderFactory.getInstance())
    }
}
