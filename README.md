# DocScanner SDK

<div align="center">

![Version](https://img.shields.io/badge/version-1.0.0-blue.svg)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Platform](https://img.shields.io/badge/platform-android%20%7C%20ios%20%7C%20web%20%7C%20windows%20%7C%20macos%20%7C%20linux-blue)](https://github.com/Tareq-Ghassan/DocumentScanner-SDK)
[![pub package](https://img.shields.io/pub/v/doc_scanner_sdk.svg)](https://pub.dev/packages/doc_scanner_sdk)

**Universal Document Capture with Fixed Crop Overlay**

*White rectangle crop-on-capture across all major platforms with native performance*

[Features](#-features) •
[Platforms](#-platform-support) •
[Quick Start](#-quick-start) •
[Examples](#-examples) •
[Documentation](#-documentation) •
[Architecture](#-architecture)

</div>

---

## What is DocScanner SDK?

DocScanner SDK is a **native-first document capture solution** for Android, iOS, Web, Windows, macOS, and Linux. Each platform owns the camera preview, the **white crop rectangle overlay**, and the crop-on-capture logic. Flutter is a thin wrapper that calls those native APIs.

Use it to:

- Capture ID cards, passports, and documents inside a fixed frame
- Crop the image to the white rectangle when the user taps capture
- Feed OCR / KYC pipelines with consistently framed photos
- Ship one UX pattern across mobile, desktop, and web

### How crop-on-capture works

1. **Live camera preview** is shown by the native SDK
2. A **white rectangle overlay** is drawn on top (native UI — not Flutter)
3. The user aligns the document inside the frame
4. On **capture**, the native SDK crops the bitmap/pixel buffer to that rectangle
5. The cropped image path (or bytes) is returned to the host app / Flutter plugin

---

## Features

- White crop rectangle overlay (color, stroke, radius, margins configurable)
- Crop-on-capture aligned to the visible overlay
- Front / back / single-side scan flows
- Opt-in live preview via PlatformViews (Flutter) or native preview views
- Camera permission helpers
- Flash / autofocus where the platform supports them
- Independent per-platform releases (same model as FaceDetection-GazePoint)

### Platform technologies

| Platform | Stack |
|----------|--------|
| Android | Kotlin, CameraX, ImageCapture |
| iOS | Swift, AVFoundation, Vision |
| Web | TypeScript, MediaDevices, Canvas |
| Windows | C#, .NET 6+, Windows Media Capture |
| macOS | Swift, AVFoundation |
| Linux | C++, OpenCV, Video4Linux2 |
| Flutter | Dart wrapper → MethodChannel / PlatformView → native SDKs |

---

## Platform Support

| Platform | Min Version | Package | Status |
|----------|-------------|---------|--------|
| Android | API 24+ | [JitPack](https://jitpack.io/#Tareq-Ghassan/DocScannerSDK-Android) | Stable |
| iOS | 16.0+ | [SPM](https://github.com/Tareq-Ghassan/DocScannerSDK-iOS) / CocoaPods | Stable |
| Web | Modern browsers | [NPM](https://www.npmjs.com/) `@docscanner/sdk-web` | Stable |
| Windows | 10 (1903+) | NuGet `DocScanner.SDK.Windows` | Stable |
| macOS | 13.0+ | [SPM](https://github.com/Tareq-Ghassan/DocScannerSDK-macOS) | Stable |
| Linux | Ubuntu 20.04+ | Source | Stable |
| Flutter | 3.38.4+ | [pub.dev](https://pub.dev/packages/doc_scanner_sdk) | Stable |

---

## Quick Start

### Flutter (recommended cross-platform)

```yaml
dependencies:
  doc_scanner_sdk: ^1.0.0
```

```dart
import 'package:doc_scanner_sdk/doc_scanner_sdk.dart';

final scanner = DocScanner();
await scanner.initialize(
  options: ScanOptions(previewEnabled: true, showCropOverlay: true),
);

if (await scanner.requestCameraPermission()) {
  final result = await scanner.scanDocument();
  print(result.frontImagePath);
}
```

Full docs: [flutter/README.md](flutter/README.md)

### Native Android

```kotlin
implementation 'com.github.Tareq-Ghassan:DocScannerSDK-Android:1.0.1'
```

```kotlin
val intent = DocScannerActivity.createIntent(
    context,
    ScanOptions(showCropOverlay = true, scanBothSides = false)
)
startActivityForResult(intent, REQ)
```

### Native iOS

```swift
.package(url: "https://github.com/Tareq-Ghassan/DocScannerSDK-iOS.git", from: "1.0.0")
```

```swift
let camera = DocScannerCamera()
camera.configure(DocScannerOptions(showCropOverlay: true))
// Present camera.previewView; call camera.capture() → cropped UIImage
```

---

## Architecture

**Native-first.** Flutter does **not** reimplement camera, overlay, or crop math.

```
Flutter App
   └── doc_scanner_sdk (MethodChannel + PlatformView)
          ├── Android → DocScannerSDK-Android (JitPack)
          ├── iOS     → source snapshot of DocScannerSDK-iOS
          ├── macOS   → source snapshot of DocScannerSDK-macOS
          ├── Web     → Dart MediaDevices + canvas crop
          └── Windows / Linux → native SDKs (stubs → full ports)
```

Repository layout (git submodules), matching [FaceDetection-GazePoint](https://github.com/Tareq-Ghassan/FaceDetection-GazePoint):

```
DocumentScanner-SDK/
├── android/   → DocScannerSDK-Android
├── ios/       → DocScannerSDK-iOS
├── flutter/   → DocScannerSDK-Flutter
├── web/       → DocScannerSDK-Web
├── windows/   → DocScannerSDK-Windows
├── macos/     → DocScannerSDK-macOS
├── linux/     → DocScannerSDK-Linux
├── .agents/   .cursor/rules/   .github/
├── EXAMPLES.md  TESTING.md  PUBLISHING_GUIDE.md
└── check-pana-score.sh
```

See [.agents/MULTI_PLATFORM_ARCHITECTURE.md](.agents/MULTI_PLATFORM_ARCHITECTURE.md) and [.agents/WORKFLOW_RULES.md](.agents/WORKFLOW_RULES.md).

---

## Examples

| SDK | Example |
|-----|---------|
| Android | [android/example](android/example) |
| iOS | [ios/Example](ios/Example) |
| Flutter | [flutter/example](flutter/example) |
| Web | [web/example](web/example) |
| Windows | [windows/example](windows/example) |
| macOS | [macos/example](macos/example) |
| Linux | [linux/example](linux/example) |

More: [EXAMPLES.md](EXAMPLES.md)

---

## Documentation

- [EXAMPLES.md](EXAMPLES.md) — per-platform sample apps
- [TESTING.md](TESTING.md) — native vs Flutter test matrix
- [PUBLISHING_GUIDE.md](PUBLISHING_GUIDE.md) — tags, releases, pub.dev / JitPack / SPM
- [check-pana-score.sh](check-pana-score.sh) — local pana 160/160 before pub.dev
- [.agents/](.agents/) — agent workflow, releases, submodules, pana

---

## Clone

```bash
git clone --recursive https://github.com/Tareq-Ghassan/DocumentScanner-SDK.git
cd DocumentScanner-SDK
git submodule update --init --remote
```

---

## License

MIT © Tareq Abu Saleh — see [LICENSE](LICENSE)
