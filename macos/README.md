# DocScanner SDK - macOS

[![Platform](https://img.shields.io/badge/platform-macOS%2013.0%2B-blue.svg)](https://developer.apple.com/macos/)
[![Swift](https://img.shields.io/badge/Swift-5.9-orange.svg)](https://swift.org)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![SPM](https://img.shields.io/badge/SPM-compatible-brightgreen.svg)](https://swift.org/package-manager/)

macOS SDK for document scanning with fixed crop area overlay.

## Features

- 📷 **AVFoundation** - Native macOS camera access
- ⬜ **Fixed Crop Overlay** - CALayer-based overlay
- 📸 **Auto Crop** - Precise cropping
- 🎯 **High Performance** - Native macOS performance
- 🖥️ **AppKit Support** - Native Mac UI
- 💻 **SwiftUI Support** - Modern SwiftUI integration

## Requirements

- macOS 13.0 (Ventura) or later
- Xcode 15.0+
- Swift 5.9+

## Installation

### Swift Package Manager

Add to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/Tareq-Ghassan/DocScannerSDK-macOS.git", from: "1.0.0")
]
```

### CocoaPods

```ruby
pod 'DocScannerSDK-macOS', '~> 1.0.0'
```

## Quick Start

### 1. Add Permission

Add to your `Info.plist`:

```xml
<key>NSCameraUsageDescription</key>
<string>We need camera access to scan documents</string>
```

### 2. Import and Use

```swift
import DocScannerSDK

let scanner = DocScanner.shared

// Request permission
if await scanner.requestCameraPermission() {
    // Scan document
    do {
        let result = try await scanner.scanDocument()
        
        if result.isSuccess, let path = result.frontImagePath {
            let image = NSImage(contentsOfFile: path)
            // Use image
        }
    } catch {
        print("Scan failed: \(error)")
    }
}
```

## API Reference

### DocScanner

Main SDK class.

```swift
class DocScanner {
    static let shared: DocScanner
    
    func requestCameraPermission() async -> Bool
    func hasCameraPermission() -> Bool
    func scanDocument(options: ScanOptions) async throws -> ScanResult
    func scanBothSides(options: ScanOptions) async throws -> ScanResult
    func getVersion() -> String
}
```

### ScanOptions

```swift
struct ScanOptions {
    let borderColor: NSColor
    let borderWidth: CGFloat
    let borderRadius: CGFloat
    let overlayMargin: CGFloat
    let overlayHeight: CGFloat
    let enableFlash: Bool
    let enableAutoFocus: Bool
    let imageQuality: CGFloat
}
```

### ScanResult

```swift
struct ScanResult {
    let frontImagePath: String?
    let backImagePath: String?
    let timestamp: Date
    let isSuccess: Bool
    let errorMessage: String?
}
```

## Example

```swift
import AppKit
import DocScannerSDK

class ScannerViewController: NSViewController {
    
    @IBOutlet weak var frontImageView: NSImageView!
    @IBOutlet weak var backImageView: NSImageView!
    
    @IBAction func scanButtonClicked(_ sender: Any) {
        Task {
            let scanner = DocScanner.shared
            
            guard await scanner.requestCameraPermission() else {
                showAlert("Camera permission required")
                return
            }
            
            do {
                let result = try await scanner.scanBothSides()
                
                if result.isSuccess {
                    if let frontPath = result.frontImagePath {
                        frontImageView.image = NSImage(contentsOfFile: frontPath)
                    }
                    if let backPath = result.backImagePath {
                        backImageView.image = NSImage(contentsOfFile: backPath)
                    }
                }
            } catch {
                showAlert("Scan failed: \(error.localizedDescription)")
            }
        }
    }
}
```

## SwiftUI Example

```swift
import SwiftUI
import DocScannerSDK

struct ScannerView: View {
    @State private var frontImage: NSImage?
    @State private var backImage: NSImage?
    
    var body: some View {
        VStack {
            if let frontImage = frontImage {
                Image(nsImage: frontImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 200)
            }
            
            if let backImage = backImage {
                Image(nsImage: backImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 200)
            }
            
            Button("Scan Document") {
                scanDocument()
            }
        }
        .padding()
    }
    
    func scanDocument() {
        Task {
            let scanner = DocScanner.shared
            
            guard await scanner.requestCameraPermission() else {
                return
            }
            
            do {
                let result = try await scanner.scanBothSides()
                
                if result.isSuccess {
                    if let frontPath = result.frontImagePath {
                        frontImage = NSImage(contentsOfFile: frontPath)
                    }
                    if let backPath = result.backImagePath {
                        backImage = NSImage(contentsOfFile: backPath)
                    }
                }
            } catch {
                print("Scan error: \(error)")
            }
        }
    }
}
```

## Architecture

```
DocScannerSDK-macOS/
├── Sources/DocScannerSDK/
│   ├── DocScanner.swift
│   ├── ScanOptions.swift
│   ├── ScanResult.swift
│   ├── Camera/
│   │   ├── CameraViewController.swift
│   │   └── OverlayView.swift
│   └── Utils/
│       └── ImageCropper.swift
├── Tests/DocScannerSDKTests/
├── Example/
├── Package.swift
└── DocScannerSDK.podspec
```

## License

MIT License - Copyright (c) 2024-2026 Tareq Abu Saleh

## Support

- **Issues**: [GitHub Issues](https://github.com/Tareq-Ghassan/DocScannerSDK-macOS/issues)
- **Main Project**: [DocumentScanner-SDK](https://github.com/Tareq-Ghassan/DocumentScanner-SDK)
