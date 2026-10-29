import java.util.Properties

plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// Release signing (R4.11). The upload key never enters git: `android/key.properties`
// (ignored) names a keystore the owner keeps outside the repository. When the file is
// absent the release build falls back to the debug key so `flutter build apk --release`
// still produces a testable APK; Play rejects that APK, which is the intended reminder.
val keyProperties = Properties().apply {
    val file = rootProject.file("key.properties")
    if (file.exists()) file.inputStream().use { load(it) }
}
val hasReleaseKey = keyProperties.getProperty("storeFile") != null

// AdMob app id (ADR-076). `apps/mobile/ads.env` (git-ignored, shape in ads.env.example) holds
// the owner's real ids as KEY=VALUE lines; the Dart side reads the same file through
// `--dart-define-from-file=ads.env`. Without the file the build uses Google's published TEST app
// id, so nobody can ship real ads by accident.
val googleTestAdmobAppId = "ca-app-pub-3940256099942544~3347511713"
val adsEnv = mutableMapOf<String, String>().apply {
    val file = rootProject.file("../ads.env")
    if (file.exists()) {
        file.readLines()
            .map { it.trim() }
            .filter { it.isNotEmpty() && !it.startsWith("#") && it.contains("=") }
            .forEach { put(it.substringBefore("=").trim(), it.substringAfter("=").trim()) }
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
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        // Uses the version code from pubspec.yaml. When using split APKs, 1000 * ABI_VERSION
        // is added automatically by Flutter. (https://developer.android.com/studio/build/configure-apk-splits#configure-APK-versions)
        // You can force using the value of versionCode by specifying the `-P force-version-code-ignoring-abi=true`
        // flag during build.
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        manifestPlaceholders["admobAppId"] = adsEnv["FEMIO_ADMOB_APP_ID"] ?: googleTestAdmobAppId
    }

    buildTypes {
        release {
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
}

flutter {
    source = "../.."
}
