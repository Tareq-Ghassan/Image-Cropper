# ProGuard rules for DocScanner SDK

# Keep public API
-keep public class com.docscanner.sdk.DocScannerActivity { *; }
-keep public class com.docscanner.sdk.ScanViewModel { *; }
-keep public class com.docscanner.sdk.OverlayView { *; }

# Keep CameraX
-keep class androidx.camera.** { *; }
-dontwarn androidx.camera.**

# Keep Kotlin Coroutines
-keepnames class kotlinx.coroutines.internal.MainDispatcherFactory {}
-keepnames class kotlinx.coroutines.CoroutineExceptionHandler {}
-keepclassmembers class kotlinx.coroutines.** {
    volatile <fields>;
}

# Keep data binding
-keep class * extends androidx.databinding.ViewDataBinding { *; }

# Keep navigation component
-keep class * implements androidx.navigation.Navigator { *; }

# AndroidX
-keep class androidx.lifecycle.** { *; }
-keep class androidx.fragment.** { *; }
-keep class com.google.android.material.** { *; }

# Bitmap operations
-keep class android.graphics.** { *; }

# Remove logging in release
-assumenosideeffects class android.util.Log {
    public static *** d(...);
    public static *** v(...);
    public static *** i(...);
}
