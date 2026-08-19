# DocScanner SDK - Android

[![](https://jitpack.io/v/Tareq-Ghassan/DocScannerSDK-Android.svg)](https://jitpack.io/#Tareq-Ghassan/DocScannerSDK-Android)
[![API](https://img.shields.io/badge/API-24%2B-brightgreen.svg?style=flat)](https://android-arsenal.com/api?level=24)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

Android SDK for document scanning with fixed crop area overlay. Perfect for ID cards, passports, and document OCR.

## Features

- 📷 **Camera Preview** - Real-time camera preview with overlay
- ⬜ **Fixed Crop Area** - White bordered rectangle overlay for precise document capture
- 📸 **Auto Crop** - Automatically crops captured image to the overlay bounds
- 🎯 **High Accuracy** - Pixel-perfect cropping based on overlay dimensions
- 🔄 **Front/Back Support** - Capture both sides of documents
- 💾 **File Management** - Automatic file saving and cleanup
- 📐 **Orientation Support** - Handles device rotation automatically

## Installation

### Gradle (JitPack)

Add JitPack repository in your root `build.gradle`:

```gradle
allprojects {
    repositories {
        maven { url 'https://jitpack.io' }
    }
}
```

Add the dependency:

```gradle
dependencies {
    implementation 'com.github.Tareq-Ghassan:DocScannerSDK-Android:1.0.0'
}
```

## Quick Start

### 1. Add Camera Permission

In your `AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
<uses-feature android:name="android.hardware.camera" android:required="true" />
```

### 2. Launch Scanner

```kotlin
import com.docscanner.sdk.DocScannerActivity

// Launch the scanner
val intent = Intent(this, DocScannerActivity::class.java)
startActivityForResult(intent, REQUEST_CODE_SCAN)

// Handle result
override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
    super.onActivityResult(requestCode, resultCode, data)
    if (requestCode == REQUEST_CODE_SCAN && resultCode == Activity.RESULT_OK) {
        val frontImagePath = data?.getStringExtra("FRONT_IMAGE_PATH")
        val backImagePath = data?.getStringExtra("BACK_IMAGE_PATH")
        
        // Use the image paths
        frontImagePath?.let { path ->
            val bitmap = BitmapFactory.decodeFile(path)
            // Process the bitmap
        }
    }
}
```

## API Reference

### DocScannerActivity

Main activity that handles document scanning.

**Result Extras:**
- `FRONT_IMAGE_PATH` - Path to front image file
- `BACK_IMAGE_PATH` - Path to back image file

### PhotoFragment

Handles camera preview and capture with overlay.

**Features:**
- Auto-focus with continuous picture mode
- Auto-flash
- Rotation handling
- Aspect ratio preservation
- Pixel-perfect cropping

### IdViewModel

ViewModel for managing captured images.

```kotlin
class IdViewModel : ViewModel() {
    val FrontFile: LiveData<String>
    val BackFile: LiveData<String>
    val NumButton: LiveData<Int>
}
```

## Customization

### Overlay Border

Customize the overlay border in `res/drawable/border.xml`:

```xml
<shape xmlns:android="http://schemas.android.com/apk/res/android">
    <stroke android:width="2dp" android:color="#FFFFFF" />
    <corners android:radius="10dp" />
</shape>
```

### Layout

Modify overlay size in `fragment_photo.xml`:

```xml
<View
    android:id="@+id/border_camera"
    android:layout_width="match_parent"
    android:layout_height="210dp"
    android:layout_marginStart="50dp"
    android:layout_marginEnd="50dp"
    android:background="@drawable/border" />
```

## Architecture

```
DocScannerSDK-Android/
├── src/main/
│   ├── java/com/docscanner/sdk/
│   │   ├── DocScannerActivity.kt
│   │   ├── PhotoFragment.java
│   │   ├── IdFragment.kt
│   │   └── IdViewModel.kt
│   ├── res/
│   │   ├── layout/
│   │   │   ├── activity_doc_scanner.xml
│   │   │   ├── fragment_photo.xml
│   │   │   └── fragment_id.xml
│   │   ├── drawable/
│   │   │   ├── border.xml
│   │   │   └── ic_camera.xml
│   │   └── navigation/
│   │       └── nav_graph.xml
│   └── AndroidManifest.xml
├── build.gradle
└── README.md
```

## Requirements

- **Minimum SDK**: API 24 (Android 7.0)
- **Target SDK**: API 35 (Android 15)
- **Kotlin**: 1.9.0+
- **Java**: 17

## Example App

See the [example](example/) directory for a complete sample application.

## Publishing

This SDK is published to JitPack automatically from GitHub releases.

To publish a new version:

1. Create a new tag: `git tag -a 1.0.0 -m "Release 1.0.0"`
2. Push the tag: `git push origin 1.0.0`
3. Create a GitHub release with the tag

## License

MIT License - Copyright (c) 2024-2026 Tareq Abu Saleh

See [LICENSE](LICENSE) file for details.

## Support

- **Issues**: [GitHub Issues](https://github.com/Tareq-Ghassan/DocScannerSDK-Android/issues)
- **Main Project**: [DocumentScanner-SDK](https://github.com/Tareq-Ghassan/DocumentScanner-SDK)

## Acknowledgments

- Android CameraX team
- MVVM Architecture pattern
- Navigation Component
