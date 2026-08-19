# Changelog

All notable changes to doc_scanner_sdk will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2026-08-19

### Added

- Initial release of DocScanner SDK for Flutter
- Android support with CameraX
- iOS support with AVFoundation
- Web support with MediaDevices API
- macOS support with AVFoundation
- Windows and Linux platform stubs
- `DocScannerSdk` class with `scanDocument()` and `scanBothSides()` methods
- `ScanResult` model with image paths and metadata
- `ScanOptions` model for customizing scanner behavior
- Example app demonstrating all features
- Comprehensive documentation
- MIT License

### Platform Implementations

- **Android (API 24+)**: Full implementation with CameraX, custom overlay, tap-to-focus
- **iOS (16.0+)**: Full implementation with AVFoundation and Vision framework
- **Web**: MediaDevices API integration with canvas-based cropping
- **macOS (13.0+)**: AVFoundation implementation
- **Windows**: Placeholder (in development)
- **Linux**: Placeholder (in development)

[1.0.0]: https://github.com/Tareq-Ghassan/DocScannerSDK-Flutter/releases/tag/v1.0.0
