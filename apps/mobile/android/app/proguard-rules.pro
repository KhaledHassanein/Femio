# R8 keep rules for femio's release build (minify + shrinkResources are on in build.gradle.kts).
#
# Why these exist (REL-12, R14.15): R8 removes or renames code it cannot see being used. Flutter
# reaches femio's Kotlin through method channels by name, and the Firebase AI Logic on-device
# library is a beta (firebase-ai-ondevice 16.0.0-beta08) whose consumer rules have not been
# proven on a minified build on a phone. A stripped class there fails only at runtime, on her
# phone, so these rules trade a little APK size for not finding out the hard way. Remove a rule
# only after a minified build has run Say it, Ask femio and the Cloud boost consent on a device.

# Flutter's own classes; the plugins we ship declare their own keep rules.
-keep class io.flutter.** { *; }
-dontwarn io.flutter.embedding.**

# femio's own Kotlin: the assistant bridge, files, lock and widget channels, and the widget
# provider Android instantiates by name from the manifest.
-keep class com.femioapp.femio.** { *; }

# Firebase AI Logic (cloud and on-device) and App Check: requests and responses are serialised
# with kotlinx.serialization, which reads generated serializers and annotations at runtime.
-keep class com.google.firebase.ai.** { *; }
-keep class com.google.firebase.appcheck.** { *; }
-keepattributes *Annotation*, Signature, InnerClasses, EnclosingMethod, RuntimeVisibleAnnotations
-keepclassmembers class **$$serializer { *; }
-keepclasseswithmembers class * { kotlinx.serialization.KSerializer serializer(...); }
-dontwarn com.google.firebase.ai.**
