# Keep Flutter's own classes; the plugins we ship (secure storage, file picker,
# path provider) declare their own keep rules.
-keep class io.flutter.** { *; }
-dontwarn io.flutter.embedding.**
