# DocScanner SDK Examples

Each platform ships its own example app. Camera, white crop rectangle, and
crop-on-capture live in the **native** SDK — examples only host those UIs.

| Platform | Path | Notes |
|----------|------|-------|
| Android | [android/example](android/example) | Launches `DocScannerActivity` |
| iOS | [ios/Example](ios/Example) | Embeds `DocScannerCamera.previewView` |
| Flutter | [flutter/example](flutter/example) | Calls `DocScanner.scanDocument()` |
| Web | [web/example](web/example) | MediaDevices + canvas crop |
| Windows | [windows/example](windows/example) | .NET host |
| macOS | [macos/example](macos/example) | SPM example |
| Linux | [linux/example](linux/example) | CMake example |

## Clone with examples

```bash
git clone --recursive https://github.com/Tareq-Ghassan/DocumentScanner-SDK.git
cd DocumentScanner-SDK/android/example && ./gradlew :app:assembleDebug
cd ../../flutter/example && flutter run
```

See [.agents/WORKFLOW_RULES.md](.agents/WORKFLOW_RULES.md).
