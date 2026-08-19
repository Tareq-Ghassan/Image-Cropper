# DocumentScanner SDK

<div align="center">

![Version](https://img.shields.io/badge/version-1.0.0-blue.svg)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Platform](https://img.shields.io/badge/platform-android%20%7C%20ios%20%7C%20web%20%7C%20windows%20%7C%20macos%20%7C%20linux-blue)](https://github.com/Tareq-Ghassan/DocumentScanner-SDK)
[![pub package](https://img.shields.io/pub/v/doc_scanner_sdk.svg)](https://pub.dev/packages/doc_scanner_sdk)

**Universal Document Scanning with Fixed Crop Area Overlay**

*Cross-platform document capture for ID cards, passports, and OCR*

[Features](#-features) •
[Platforms](#-platform-support) •
[Quick Start](#-quick-start) •
[Examples](#-examples) •
[Documentation](#-documentation) •
[Architecture](#-architecture)

</div>

---

## 🌟 What is DocumentScanner SDK?

DocumentScanner SDK is a comprehensive, **universal document scanning solution** that works seamlessly across Android, iOS, Web, Windows, macOS, and Linux. It provides a camera preview with a fixed crop area overlay, perfect for capturing documents that need precise alignment for OCR processing.

### Use Cases

- 📇 **ID Card Scanning** - Capture national IDs, driver's licenses
- 🛂 **Passport Scanning** - Scan passport MRZ zones
- 💳 **Credit Card Capture** - Card number recognition
- 📄 **Document Digitization** - Business cards, receipts, forms
- 🔍 **OCR Input** - Provide properly aligned images for text recognition
- 🏦 **KYC Verification** - Know Your Customer document capture

### How It Works

1. **Camera Preview** - Opens device camera with real-time preview
2. **Fixed Overlay** - Displays a bordered rectangle in the center
3. **User Alignment** - User positions document within the overlay
4. **Capture** - Tap button to capture photo
5. **Auto Crop** - SDK automatically crops to overlay bounds
6. **Return Image** - Provides cropped image path/blob to your app

<img src="docs/demo.png" alt="Document Scanner Demo" width="300"/>

---

## ✨ Features

### Core Capabilities

- 📷 **Camera Preview** - Real-time camera feed with overlay
- ⬜ **Fixed Crop Area** - White bordered rectangle overlay
- 📸 **Auto Crop** - Pixel-perfect cropping to overlay bounds
- 🔄 **Front/Back Support** - Capture both sides of documents
- 🎯 **High Accuracy** - Precise alignment for OCR
- 💾 **File Management** - Automatic saving and cleanup
- 📐 **Orientation Support** - Handles device rotation
- 🎨 **Customizable** - Configure colors, sizes, camera settings

### Platform-Specific Technologies

- **Android** - CameraX API with SurfaceView
- **iOS** - AVFoundation with CALayer overlay
- **Web** - MediaDevices API with Canvas
- **Windows** - Media Foundation (in development)
- **macOS** - AVFoundation with AppKit
- **Linux** - V4L2 with OpenCV (in development)

---

## 📱 Platform Support

| Platform | Min Version | Status | Package |
|----------|-------------|--------|---------|
| 🤖 **Android** | API 24+ (7.0) | ✅ Stable | [JitPack](https://jitpack.io/#Tareq-Ghassan/DocScannerSDK-Android) |
| 🍎 **iOS** | 16.0+ | ✅ Stable | [SPM](https://github.com/Tareq-Ghassan/DocScannerSDK-iOS) / [CocoaPods](https://cocoapods.org) |
| 🌐 **Web** | Modern Browsers | ✅ Stable | [NPM](https://www.npmjs.com/package/@docscanner/sdk-web) |
| 🪟 **Windows** | 10 1903+ | 🚧 Dev | [NuGet](https://www.nuget.org/) |
| 🖥️ **macOS** | 13.0+ | ✅ Stable | [SPM](https://github.com/Tareq-Ghassan/DocScannerSDK-macOS) |
| 🐧 **Linux** | Ubuntu 20.04+ | 🚧 Dev | Source |
| 🎯 **Flutter** | 3.38.4+ | ✅ Stable | [pub.dev](https://pub.dev/packages/doc_scanner_sdk) |

---

## 🚀 Quick Start

### Flutter (Recommended for Cross-Platform)

```yaml
dependencies:
  doc_scanner_sdk: ^1.0.0
```

```dart
import 'package:doc_scanner_sdk/doc_scanner_sdk.dart';

final scanner = DocScannerSdk.instance;

// Request permission
if (await scanner.requestCameraPermission()) {
  // Scan document
  final result = await scanner.scanDocument();
  
  if (result.isSuccess && result.frontImagePath != null) {
    // Use the cropped image
    final image = File(result.frontImagePath!);
  }
}
```

👉 **[Full Flutter Documentation →](flutter/README.md)**

### Native Platforms

Each platform has its own native SDK:

- 🤖 **Android** `1.0.0` — [DocScannerSDK-Android](https://github.com/Tareq-Ghassan/DocScannerSDK-Android)
- 🍎 **iOS** `1.0.0` — [DocScannerSDK-iOS](https://github.com/Tareq-Ghassan/DocScannerSDK-iOS)
- 🌐 **Web** `1.0.0` — [DocScannerSDK-Web](https://github.com/Tareq-Ghassan/DocScannerSDK-Web)
- 🖥️ **macOS** `1.0.0` — [DocScannerSDK-macOS](https://github.com/Tareq-Ghassan/DocScannerSDK-macOS)

---

## 📚 Examples

### Flutter Example

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

  Future<void> _scanBothSides() async {
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
            onPressed: _scanBothSides,
            child: Text('Scan Document'),
          ),
        ],
      ),
    );
  }
}
```

### Android Example

```kotlin
import com.docscanner.sdk.DocScannerActivity

// Launch scanner
val intent = Intent(this, DocScannerActivity::class.java)
startActivityForResult(intent, REQUEST_CODE_SCAN)

// Handle result
override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
    if (requestCode == REQUEST_CODE_SCAN && resultCode == Activity.RESULT_OK) {
        val frontPath = data?.getStringExtra("FRONT_IMAGE_PATH")
        val backPath = data?.getStringExtra("BACK_IMAGE_PATH")
        
        frontPath?.let { path ->
            val bitmap = BitmapFactory.decodeFile(path)
            // Use bitmap
        }
    }
}
```

### iOS Example

```swift
import DocScannerSDK

let scanner = DocScanner.shared

Task {
    guard await scanner.requestCameraPermission() else {
        print("Permission denied")
        return
    }
    
    do {
        let result = try await scanner.scanBothSides()
        
        if result.isSuccess,
           let frontPath = result.frontImagePath,
           let backPath = result.backImagePath {
            let frontImage = UIImage(contentsOfFile: frontPath)
            let backImage = UIImage(contentsOfFile: backPath)
            // Use images
        }
    } catch {
        print("Scan failed: \(error)")
    }
}
```

### Web Example

```typescript
import { DocScanner } from '@docscanner/sdk-web';

const scanner = DocScanner.getInstance();

async function scanDocument() {
  if (!await scanner.hasCameraPermission()) {
    const granted = await scanner.requestCameraPermission();
    if (!granted) return;
  }

  try {
    const result = await scanner.scanDocument();
    
    if (result.isSuccess && result.frontImageBlob) {
      const imageUrl = URL.createObjectURL(result.frontImageBlob);
      document.getElementById('preview').src = imageUrl;
    }
  } catch (error) {
    console.error('Scan failed:', error);
  }
}
```

---

## 🏗️ Architecture

DocumentScanner SDK uses **one GitHub repository per platform**. This umbrella repository contains submodules pointing to each platform SDK.

```
DocumentScanner-SDK/               # Umbrella repo (this repo)
├── android/   → DocScannerSDK-Android
├── ios/       → DocScannerSDK-iOS
├── flutter/   → DocScannerSDK-Flutter
├── web/       → DocScannerSDK-Web
├── windows/   → DocScannerSDK-Windows
├── macos/     → DocScannerSDK-macOS
└── linux/     → DocScannerSDK-Linux
```

Each platform SDK is independently versioned and published to its respective package manager.

**Learn More**: [Architecture Documentation](.agents/MULTI_PLATFORM_ARCHITECTURE.md)

---

## 📖 Documentation

### Getting Started

- 📦 **Installation** - Platform-specific setup guides in each SDK repository
- 🎯 **Quick Start** - See examples above
- 🔧 **API Reference** - Full API documentation in each platform's README

### Advanced Topics

- 🎨 **Customization** - Configure overlay colors, sizes, camera settings
- 📊 **Best Practices** - Tips for optimal scanning
- 🐛 **Troubleshooting** - Common issues and solutions
- 🔌 **Platform Integration** - Platform-specific integration guides

### For Contributors

- 🛠️ **[Creating Repositories](.agents/CREATE_REPOS.md)** - How to set up platform repos
- 📝 **[Workflow Rules](.agents/WORKFLOW_RULES.md)** - Development workflow and conventions
- 🤖 **[Architecture](.agents/MULTI_PLATFORM_ARCHITECTURE.md)** - System architecture

---

## 📊 Performance

Expected performance across platforms:

| Metric | Target | Notes |
|--------|--------|-------|
| **Capture Time** | < 1s | Time from tap to cropped image |
| **Accuracy** | 99%+ | Pixel-perfect cropping |
| **File Size** | 200-500 KB | JPEG compressed (quality 95) |
| **Memory Usage** | 50-100 MB | Varies by platform |

---

## 🤝 Contributing

We welcome contributions! Here's how you can help:

1. 🐛 **Report Bugs** - [Open an issue](https://github.com/Tareq-Ghassan/DocumentScanner-SDK/issues)
2. 💡 **Suggest Features** - Share your ideas
3. 📝 **Improve Documentation** - Help make docs clearer
4. 🔧 **Submit Pull Requests** - Fix bugs or add features

### Development Setup

```bash
# Clone with submodules
git clone --recurse-submodules https://github.com/Tareq-Ghassan/DocumentScanner-SDK.git

# Or if already cloned
cd DocumentScanner-SDK
git submodule update --init --recursive
```

**Contributing Guide**: [WORKFLOW_RULES.md](.agents/WORKFLOW_RULES.md)

---

## 📝 License

MIT License - Copyright (c) 2024-2026 Tareq Abu Saleh

See [LICENSE](LICENSE) file for details.

---

## 🙏 Acknowledgments

- **Google** - Android CameraX API
- **Apple** - iOS AVFoundation and Vision frameworks
- **WebRTC** - MediaDevices API for web
- **OpenCV** - Computer vision for Linux
- **Flutter** - Amazing cross-platform framework
- All **contributors** who have helped improve this project

---

## 📞 Support

- **Issues**: [GitHub Issues](https://github.com/Tareq-Ghassan/DocumentScanner-SDK/issues)
- **Discussions**: [GitHub Discussions](https://github.com/Tareq-Ghassan/DocumentScanner-SDK/discussions)
- **Flutter Package**: [pub.dev/packages/doc_scanner_sdk](https://pub.dev/packages/doc_scanner_sdk)

---

## 🌟 Star History

If you find this project useful, please consider giving it a star ⭐

[![Star History Chart](https://api.star-history.com/svg?repos=Tareq-Ghassan/DocumentScanner-SDK&type=Date)](https://star-history.com/#Tareq-Ghassan/DocumentScanner-SDK&Date)

---

<div align="center">

**Made with ❤️ by [Tareq Ghassan](https://github.com/Tareq-Ghassan)**

[⬆ Back to Top](#documentscanner-sdk)

</div>
