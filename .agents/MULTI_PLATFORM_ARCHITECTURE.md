# DocScanner SDK Multi-Platform Architecture

## Native-first

Each platform has its own **native SDK**. Flutter is a **unified wrapper** only.

```
Flutter App
   └── doc_scanner_sdk (MethodChannel)
          ├── Android → DocScannerSDK-Android (JitPack) — CameraX + OverlayView
          ├── iOS     → source snapshot of DocScannerSDK-iOS — AVFoundation
          ├── macOS   → source snapshot of DocScannerSDK-macOS
          ├── Web     → Dart / @docscanner/sdk-web — MediaDevices + canvas
          ├── Windows → DocScanner.SDK.Windows
          └── Linux   → libdocscanner (OpenCV/V4L2)
```

## Crop-on-capture contract

1. Native draws a **white rectangle** over the live preview
2. User aligns the document inside the frame
3. On capture, native crops the image buffer to that rectangle
4. Host / Flutter receives file path or bytes

**Do not** redraw the crop rectangle in Flutter for Android/iOS/macOS.

## Repository structure

```
DocumentScanner-SDK/                 # umbrella
├── android/   → DocScannerSDK-Android (+ example/)
│   └── docscanner-sdk/
├── ios/       → DocScannerSDK-iOS
├── flutter/   → DocScannerSDK-Flutter (+ example/)
│   ├── android/   (JitPack pin)
│   ├── ios/       (source snapshot)
│   └── macos/     (source snapshot)
├── web/       → DocScannerSDK-Web
├── windows/   → DocScannerSDK-Windows
├── macos/     → DocScannerSDK-macOS
├── linux/     → DocScannerSDK-Linux
├── .agents/   .cursor/rules/   .github/
└── EXAMPLES.md  TESTING.md  PUBLISHING_GUIDE.md
```

## Android wiring in Flutter

```gradle
api 'com.github.Tareq-Ghassan:DocScannerSDK-Android:1.0.0'
```

Never copy Kotlin from `android/docscanner-sdk` into `flutter/android`.

## iOS / macOS wiring in Flutter

Refresh the source snapshot under `flutter/ios/doc_scanner_sdk` /
`flutter/macos/doc_scanner_sdk` when releasing those native SDKs.

## Independent releases

Tag each SDK repo separately. Umbrella tags are optional (legacy pub.dev OIDC).
See [RELEASE.md](RELEASE.md) and [WORKFLOW_RULES.md](WORKFLOW_RULES.md).
