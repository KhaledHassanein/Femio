import java.util.Properties

plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// Release signing (R4.11). The upload key never enters git: `android/key.properties`
// (ignored) names a keystore the owner keeps outside the repository. Without that file a
// release build FAILS (SEC-9, ADR-083): a debug-signed "release" APK fails Play Integrity
// (Cloud boost then breaks) and can never be upgraded by the Play build, so it must not be
// produced by accident. A tester who knowingly wants one passes
// `flutter build apk --release -P allowDebugSigning=true` (or sets FEMIO_ALLOW_DEBUG_SIGNING=1).
// Debug and profile builds are unaffected.
val keyProperties = Properties().apply {
    val file = rootProject.file("key.properties")
    if (file.exists()) file.inputStream().use { load(it) }
}
val hasReleaseKey = keyProperties.getProperty("storeFile") != null
val allowDebugSigning = (findProperty("allowDebugSigning")?.toString() == "true") ||
    System.getenv("FEMIO_ALLOW_DEBUG_SIGNING") == "1"

// Checked once the task graph is known, so only a build that would package a release fails;
// configuring the project (debug builds, IDE sync, `flutter test`) never needs the key.
gradle.taskGraph.whenReady {
    val packagesRelease = allTasks.any { task ->
        task.project == project && Regex("^(assemble|bundle|package|sign)\\w*Release\\w*$").matches(task.name)
    }
    if (packagesRelease && !hasReleaseKey && !allowDebugSigning) {
        throw GradleException(
            "Release signing key missing: android/key.properties was not found (see key.properties.example). " +
                "Refusing to sign a release with the debug key. To build a debug-signed release for local " +
                "testing only, pass -P allowDebugSigning=true.",
        )
    }
}

// Firebase AI Logic config for the assistant (ADR-078). `apps/mobile/assistant.env` (git-ignored,
// shape in assistant.env.example) holds the owner's Firebase ids. Without it the fields are empty
// and the assistant reports "not configured": every feature runs on the phone's rules.
val assistantEnv = mutableMapOf<String, String>().apply {
    val file = rootProject.file("../assistant.env")
    if (file.exists()) {
        file.readLines()
            .map { it.trim() }
            .filter { it.isNotEmpty() && !it.startsWith("#") && it.contains("=") }
            .forEach { put(it.substringBefore("=").trim(), it.substringAfter("=").trim()) }
    }
}
fun assistantField(key: String, fallback: String = "") = "\"" + (assistantEnv[key] ?: fallback) + "\""

// A release without the Firebase ids ships an assistant that says "not configured" and a Cloud
// boost that can never work (found 2026-11-27: a signed build made from a checkout with no
// assistant.env). Like the signing key, a release that would package without them FAILS; a
// tester who wants a rules-only build passes `-P allowNoAssistant=true`.
val allowNoAssistant = findProperty("allowNoAssistant")?.toString() == "true"
gradle.taskGraph.whenReady {
    val packagesRelease = allTasks.any { task ->
        task.project == project && Regex("^(assemble|bundle|package|sign)\\w*Release\\w*$").matches(task.name)
    }
    val missing = listOf("FEMIO_FIREBASE_APP_ID", "FEMIO_FIREBASE_API_KEY", "FEMIO_FIREBASE_PROJECT_ID")
        .filter { assistantEnv[it].isNullOrBlank() }
    if (packagesRelease && missing.isNotEmpty() && !allowNoAssistant) {
        throw GradleException(
            "Firebase AI Logic ids missing from apps/mobile/assistant.env: ${missing.joinToString()}. " +
                "Copy assistant.env.example and fill it (git-ignored). For a rules-only release, pass " +
                "-P allowNoAssistant=true.",
        )
    }
}

android {
    namespace = "com.femioapp.femio"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
        // flutter_local_notifications schedules reminders with java.time, which older
        // Android versions lack; desugaring backports it (R4.4).
        isCoreLibraryDesugaringEnabled = true
    }

    signingConfigs {
        if (hasReleaseKey) {
            create("release") {
                storeFile = rootProject.file(keyProperties.getProperty("storeFile"))
                storePassword = keyProperties.getProperty("storePassword")
                keyAlias = keyProperties.getProperty("keyAlias")
                keyPassword = keyProperties.getProperty("keyPassword")
            }
        }
    }

    defaultConfig {
        // Permanent once on Play: changing it would be a different app.
        applicationId = "com.femioapp.femio"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        // Android 8.0 (API 26) at least: firebase-ai-ondevice requires it (ADR-078).
        minSdk = maxOf(26, flutter.minSdkVersion)
        targetSdk = flutter.targetSdkVersion
        // Uses the version code from pubspec.yaml. When using split APKs, 1000 * ABI_VERSION
        // is added automatically by Flutter. (https://developer.android.com/studio/build/configure-apk-splits#configure-APK-versions)
        // You can force using the value of versionCode by specifying the `-P force-version-code-ignoring-abi=true`
        // flag during build.
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        buildConfigField("String", "FEMIO_FIREBASE_APP_ID", assistantField("FEMIO_FIREBASE_APP_ID"))
        buildConfigField("String", "FEMIO_FIREBASE_API_KEY", assistantField("FEMIO_FIREBASE_API_KEY"))
        buildConfigField("String", "FEMIO_FIREBASE_PROJECT_ID", assistantField("FEMIO_FIREBASE_PROJECT_ID"))
        buildConfigField("String", "FEMIO_AI_CLOUD_MODEL", assistantField("FEMIO_AI_CLOUD_MODEL", "gemini-3.5-flash-lite"))
    }

    buildFeatures {
        buildConfig = true
    }

    buildTypes {
        release {
            // The debug key is reachable only with allowDebugSigning (see the check at the top).
            signingConfig = if (hasReleaseKey) signingConfigs.getByName("release") else signingConfigs.getByName("debug")
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(getDefaultProguardFile("proguard-android-optimize.txt"), "proguard-rules.pro")
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
    // The assistant (ADR-078): Firebase AI Logic with on-device Gemini Nano. The on-device
    // library is not in the Firebase BoM yet, so both are pinned here.
    implementation("com.google.firebase:firebase-ai:18.2.0")
    implementation("com.google.firebase:firebase-ai-ondevice:16.0.0-beta08")
    // App Check: the debug provider in debug builds only, Play Integrity in store builds.
    debugImplementation("com.google.firebase:firebase-appcheck-debug:20.1.0")
    implementation("com.google.firebase:firebase-appcheck-playintegrity:20.1.0")
    // FileProvider for sharing a document she chooses to send (R11.2).
    implementation("androidx.core:core:1.13.1")
    // On-device translation for the AI on this phone (ADR-087 §6): Gemini Nano is validated in
    // English, so her question and its answer are translated on the phone. The language file
    // downloads only when she taps Download; her words never leave the phone.
    implementation("com.google.mlkit:translate:17.0.3")
    // Speech to text with Gemini Nano on the phone when it is ready (ADR-088);
    // Android's on-device recognizer is the fallback. Audio is never sent.
    implementation("com.google.mlkit:genai-speech-recognition:1.0.0-alpha2")
}

flutter {
    source = "../.."
}
