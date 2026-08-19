# DocScanner SDK - Flutter

[![pub package](https://img.shields.io/pub/v/doc_scanner_sdk.svg)](https://pub.dev/packages/doc_scanner_sdk)
[![Platform](https://img.shields.io/badge/platform-android%20%7C%20ios%20%7C%20web%20%7C%20windows%20%7C%20macos%20%7C%20linux-blue)](https://github.com/Tareq-Ghassan/DocumentScanner-SDK)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

Flutter plugin for cross-platform document scanning with fixed crop area overlay. Perfect for ID cards, passports, and document OCR.

## Features

- 📷 **Camera Preview** - Real-time camera preview with overlay
- ⬜ **Fixed Crop Area** - White bordered rectangle overlay for precise document capture
- 📸 **Auto Crop** - Automatically crops captured image to overlay bounds
- 🎯 **Cross-Platform** - Works on Android, iOS, Web, Windows, macOS, and Linux
- 🔄 **Front/Back Support** - Capture both sides of documents
- 💾 **File Management** - Automatic file saving and cleanup
- 🎨 **Customizable** - Configure overlay color, size, and camera settings

## Platform Support

| Platform | Supported | Native SDK |
|----------|-----------|------------|
| 🤖 Android | ✅ | [DocScannerSDK-Android](https://github.com/Tareq-Ghassan/DocScannerSDK-Android) |
| 🍎 iOS | ✅ | [DocScannerSDK-iOS](https://github.com/Tareq-Ghassan/DocScannerSDK-iOS) |
| 🌐 Web | ✅ | [DocScannerSDK-Web](https://github.com/Tareq-Ghassan/DocScannerSDK-Web) |
| 🪟 Windows | 🚧 | [DocScannerSDK-Windows](https://github.com/Tareq-Ghassan/DocScannerSDK-Windows) |
| 🖥️ macOS | ✅ | [DocScannerSDK-macOS](https://github.com/Tareq-Ghassan/DocScannerSDK-macOS) |
| 🐧 Linux | 🚧 | [DocScannerSDK-Linux](https://github.com/Tareq-Ghassan/DocScannerSDK-Linux) |

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  doc_scanner_sdk: ^1.0.0
```

Then run:

```bash
flutter pub get
```

## Quick Start

### 1. Import the Package

```dart
import 'package:doc_scanner_sdk/doc_scanner_sdk.dart';
```

### 2. Request Camera Permission

```dart
final scanner = DocScannerSdk.instance;
final hasPermission = await scanner.requestCameraPermission();

if (!hasPermission) {
  print('Camera permission denied');
  return;
}
```

### 3. Scan a Document

```dart
try {
  // Scan single side
  final result = await scanner.scanDocument();
  
  if (result.isSuccess && result.frontImagePath != null) {
    print('Front image: ${result.frontImagePath}');
    // Use the image
  }
} catch (e) {
  print('Scan failed: $e');
}
```

### 4. Scan Both Sides

```dart
try {
  // Scan both front and back
  final result = await scanner.scanBothSides();
  
  if (result.isSuccess) {
    print('Front: ${result.frontImagePath}');
    print('Back: ${result.backImagePath}');
  }
} catch (e) {
  print('Scan failed: $e');
}
```

## Customization

### Configure Scan Options

```dart
final options = ScanOptions(
  borderColor: '#00FF00',      // Green border
  borderWidth: 3.0,            // 3dp border width
  borderRadius: 15.0,          // 15dp corner radius
  overlayMargin: 30.0,         // 30dp margin from edges
  overlayHeight: 250.0,        // 250dp overlay height
  enableFlash: false,          // Disable flash
  enableAutoFocus: true,       // Enable auto-focus
  imageQuality: 95,            // 95% JPEG quality
);

final result = await scanner.scanDocument(options);
```

## API Reference

### DocScannerSdk

Main class for the SDK.

#### Methods

- `requestCameraPermission()` - Request camera permission
- `hasCameraPermission()` - Check if camera permission is granted
- `scanDocument([options])` - Scan a single document
- `scanBothSides([options])` - Scan both front and back
- `getVersion()` - Get SDK version

### ScanOptions

Configuration options for scanning.

#### Properties

- `borderColor` - Overlay border color (hex string)
- `borderWidth` - Border width in dp
- `borderRadius` - Corner radius in dp
- `overlayMargin` - Margin from screen edges in dp
- `overlayHeight` - Overlay height in dp
- `enableFlash` - Enable camera flash
- `enableAutoFocus` - Enable auto-focus
- `imageQuality` - JPEG quality (0-100)

### ScanResult

Result of a scan operation.

#### Properties

- `frontImagePath` - Path to front image
- `backImagePath` - Path to back image (null if single scan)
- `timestamp` - Timestamp of scan
- `isSuccess` - Whether scan was successful
- `errorMessage` - Error message if failed

## Example

See the [example](example/) directory for a complete sample application.

```dart
import 'package:flutter/material.dart';
import 'package:doc_scanner_sdk/doc_scanner_sdk.dart';
import 'dart:io';

class ScannerPage extends StatefulWidget {
  @override
  _ScannerPageState createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  File? _frontImage;
  File? _backImage;

  Future<void> _scanDocument() async {
    final scanner = DocScannerSdk.instance;
    
    if (!await scanner.hasCameraPermission()) {
      final granted = await scanner.requestCameraPermission();
      if (!granted) return;
    }

    try {
      final result = await scanner.scanBothSides();
      
      if (result.isSuccess) {
        setState(() {
          if (result.frontImagePath != null) {
            _frontImage = File(result.frontImagePath!);
          }
          if (result.backImagePath != null) {
            _backImage = File(result.backImagePath!);
          }
        });
      }
    } catch (e) {
      print('Scan error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Document Scanner')),
      body: Column(
        children: [
          if (_frontImage != null)
            Image.file(_frontImage!, height: 200),
          if (_backImage != null)
            Image.file(_backImage!, height: 200),
          ElevatedButton(
            onPressed: _scanDocument,
            child: Text('Scan Document'),
          ),
        ],
      ),
    );
  }
}
```

## Platform-Specific Setup

### Android

Minimum SDK version: 24 (Android 7.0)

The plugin automatically handles permissions. Make sure your `AndroidManifest.xml` includes:

```xml
<uses-permission android:name="android.permission.CAMERA" />
<uses-feature android:name="android.hardware.camera" android:required="true" />
```

### iOS

Add to your `Info.plist`:

```xml
<key>NSCameraUsageDescription</key>
<string>We need camera access to scan documents</string>
```

### Web

Works with modern browsers that support WebRTC MediaDevices API.

## Architecture

The Flutter plugin wraps native SDKs for each platform:

- **Android**: Uses CameraX and custom SurfaceView
- **iOS**: Uses AVFoundation and Vision framework
- **Web**: Uses MediaDevices API and Canvas
- **macOS**: Uses AVFoundation
- **Windows/Linux**: In development

## Contributing

Contributions are welcome! Please see the [contributing guide](../CONTRIBUTING.md).

## License

MIT License - Copyright (c) 2024-2026 Tareq Abu Saleh

See [LICENSE](../LICENSE) file for details.

## Links

- **Main Project**: [DocumentScanner-SDK](https://github.com/Tareq-Ghassan/DocumentScanner-SDK)
- **pub.dev**: [doc_scanner_sdk](https://pub.dev/packages/doc_scanner_sdk)
- **Issues**: [GitHub Issues](https://github.com/Tareq-Ghassan/DocumentScanner-SDK/issues)

## Support

If you find this package useful, please consider giving it a ⭐ on [GitHub](https://github.com/Tareq-Ghassan/DocumentScanner-SDK)!
