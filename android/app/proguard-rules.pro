-dontwarn org.slf4j.impl.StaticLoggerBinder
# Allow all networking traffic
-keep class okhttp3.** { *; }
-keep class retrofit2.** { *; }
-keepattributes *Annotation*
-dontwarn okhttp3.**
-dontwarn retrofit2.**
