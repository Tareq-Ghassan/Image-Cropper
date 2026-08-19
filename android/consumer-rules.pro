# Consumer ProGuard rules for apps using this SDK

# Keep public API surface
-keep public class com.docscanner.sdk.DocScannerActivity { *; }
-keep public class com.docscanner.sdk.ScanViewModel { *; }

# CameraX is required
-keep class androidx.camera.** { *; }
