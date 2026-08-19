# DocScanner SDK - iOS

[![Platform](https://img.shields.io/badge/platform-iOS%2016.0%2B-blue.svg)](https://developer.apple.com/ios/)
[![Swift](https://img.shields.io/badge/Swift-5.9-orange.svg)](https://swift.org)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![SPM](https://img.shields.io/badge/SPM-compatible-brightgreen.svg)](https://swift.org/package-manager/)

iOS SDK for document scanning with fixed crop area overlay. Perfect for ID cards, passports, and document OCR.

## Features

- 📷 **Camera Preview** - Real-time AVFoundation camera preview
- ⬜ **Fixed Crop Area** - Overlay with customizable border
- 📸 **Auto Crop** - Pixel-perfect cropping using Vision framework
- 🎯 **High Accuracy** - Native iOS performance
- 🔄 **Front/Back Support** - Capture both document sides
- 💾 **File Management** - Automatic saving and cleanup
- 📐 **Orientation Support** - Handles device rotation

## Requirements

- iOS 16.0+
- Xcode 15.0+
- Swift 5.9+

## Installation

### Swift Package Manager

Add to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/Tareq-Ghassan/DocScannerSDK-iOS.git", from: "1.0.0")
]
```

Or in Xcode:
1. File > Add Package Dependencies
2. Enter: `https://github.com/Tareq-Ghassan/DocScannerSDK-iOS`

### CocoaPods

Add to your `Podfile`:

```ruby
pod 'DocScannerSDK', '~> 1.0.0'
```

## Quick Start

### 1. Import the SDK

```swift
import DocScannerSDK
```

### 2. Request Camera Permission

Add to your `Info.plist`:

```xml
<key>NSCameraUsageDescription</key>
<string>We need camera access to scan documents</string>
```

Request permission:

```swift
let scanner = DocScanner.shared

if await scanner.requestCameraPermission() {
    // Permission granted
}
```

### 3. Scan a Document

```swift
do {
    let result = try await scanner.scanDocument()
    
    if result.isSuccess, let frontPath = result.frontImagePath {
        let image = UIImage(contentsOfFile: frontPath)
        // Use the image
    }
} catch {
    print("Scan failed: \(error)")
}
```

### 4. Scan Both Sides

```swift
do {
    let result = try await scanner.scanBothSides()
    
    if result.isSuccess {
        if let frontPath = result.frontImagePath {
            let frontImage = UIImage(contentsOfFile: frontPath)
        }
        if let backPath = result.backImagePath {
            let backImage = UIImage(contentsOfFile: backPath)
        }
    }
} catch {
    print("Scan failed: \(error)")
}
```

## Customization

### Configure Scan Options

```swift
let options = ScanOptions(
    borderColor: .green,
    borderWidth: 3.0,
    borderRadius: 15.0,
    overlayMargin: 30.0,
    overlayHeight: 250.0,
    enableFlash: false,
    enableAutoFocus: true,
    imageQuality: 0.95
)

let result = try await scanner.scanDocument(options: options)
```

## API Reference

### DocScanner

Main SDK class.

#### Methods

- `requestCameraPermission()` - Request camera permission
- `hasCameraPermission()` - Check camera permission status
- `scanDocument(options:)` - Scan single document
- `scanBothSides(options:)` - Scan both sides
- `getVersion()` - Get SDK version

### ScanOptions

Configuration struct.

#### Properties

- `borderColor: UIColor` - Overlay border color
- `borderWidth: CGFloat` - Border width
- `borderRadius: CGFloat` - Corner radius
- `overlayMargin: CGFloat` - Margin from edges
- `overlayHeight: CGFloat` - Overlay height
- `enableFlash: Bool` - Enable flash
- `enableAutoFocus: Bool` - Enable auto-focus
- `imageQuality: CGFloat` - Image quality (0.0-1.0)

### ScanResult

Result struct.

#### Properties

- `frontImagePath: String?` - Front image path
- `backImagePath: String?` - Back image path
- `timestamp: Date` - Scan timestamp
- `isSuccess: Bool` - Success status
- `errorMessage: String?` - Error message

## Example

See the [Example](Example/) directory for a complete sample app.

```swift
import UIKit
import DocScannerSDK

class ScannerViewController: UIViewController {
    
    private let scanner = DocScanner.shared
    private var frontImageView: UIImageView!
    private var backImageView: UIImageView!
    
    @objc func scanButtonTapped() {
        Task {
            guard await scanner.requestCameraPermission() else {
                showAlert("Camera permission required")
                return
            }
            
            do {
                let result = try await scanner.scanBothSides()
                
                if result.isSuccess {
                    if let frontPath = result.frontImagePath {
                        frontImageView.image = UIImage(contentsOfFile: frontPath)
                    }
                    if let backPath = result.backImagePath {
                        backImageView.image = UIImage(contentsOfFile: backPath)
                    }
                }
            } catch {
                showAlert("Scan failed: \(error.localizedDescription)")
            }
        }
    }
}
```

## Architecture

```
DocScannerSDK-iOS/
├── Sources/DocScannerSDK/
│   ├── DocScanner.swift
│   ├── ScanOptions.swift
│   ├── ScanResult.swift
│   ├── Camera/
│   │   ├── CameraViewController.swift
│   │   └── OverlayView.swift
│   └── Utils/
│       ├── ImageCropper.swift
│       └── FileManager+Extensions.swift
├── Tests/DocScannerSDKTests/
├── Example/
├── Package.swift
└── DocScannerSDK.podspec
```

## License

MIT License - Copyright (c) 2024-2026 Tareq Abu Saleh

## Support

- **Issues**: [GitHub Issues](https://github.com/Tareq-Ghassan/DocScannerSDK-iOS/issues)
- **Main Project**: [DocumentScanner-SDK](https://github.com/Tareq-Ghassan/DocumentScanner-SDK)
