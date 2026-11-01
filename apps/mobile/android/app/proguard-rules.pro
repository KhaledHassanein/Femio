# Keep Flutter's own classes; the plugins we ship (secure storage, file picker,
# path provider) declare their own keep rules.
-keep class io.flutter.** { *; }
-dontwarn io.flutter.embedding.**

# Room databases are created by reflection: Room looks up `<Name>_Impl` by class name and
# calls its empty constructor. Google's ads SDK pulls in WorkManager, whose WorkDatabase is
# such a class. R8 stripped `WorkDatabase_Impl` from the 0.5.0+5 release build and the app
# died in androidx.startup before Flutter drew a frame ("Failed to create an instance of
# androidx.work.impl.WorkDatabase", found 2026-11-01 on an API 36 emulator). These rules
# keep every Room database and its generated implementation, for any library that adds one.
-keep class * extends androidx.room.RoomDatabase { <init>(); }
-keep class **_Impl extends androidx.room.RoomDatabase { *; }
-keep class androidx.work.impl.WorkDatabase_Impl { *; }
-keep class androidx.work.impl.** extends androidx.room.RoomDatabase { *; }

# flutter_local_notifications saves each scheduled reminder as JSON through Gson, labelling
# style subtypes by class name. R8 renames those classes differently in every build, so after
# an update the boot receiver could not read reminders saved by the previous build. Keep the
# model classes' names (release-hardening review, 2026-11-01; plugin source,
# FlutterLocalNotificationsPlugin.java, and Gson's own gson.pro, which covers none of them).
-keep class com.dexterous.flutterlocalnotifications.models.** { *; }
