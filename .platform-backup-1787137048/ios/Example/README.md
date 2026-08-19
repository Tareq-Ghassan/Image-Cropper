# iOS Example

Example iOS app demonstrating the DocScanner SDK.

## Setup

### Swift Package Manager

1. In Xcode, go to **File > Add Package Dependencies**
2. Enter: `https://github.com/Tareq-Ghassan/DocScannerSDK-iOS`
3. Click **Add Package**

### CocoaPods

Add to your `Podfile`:
```ruby
pod 'DocScannerSDK', '~> 1.0.0'
```

Then run:
```bash
pod install
```

## Usage Example

```swift
import UIKit
import DocScannerSDK

class ViewController: UIViewController {
    
    @IBOutlet weak var frontImageView: UIImageView!
    @IBOutlet weak var backImageView: UIImageView!
    
    @IBAction func scanButtonTapped(_ sender: UIButton) {
        Task {
            await scanDocument()
        }
    }
    
    private func scanDocument() async {
        let scanner = DocScanner.shared
        
        // Request permission
        guard await scanner.requestCameraPermission() else {
            showAlert("Camera permission required")
            return
        }
        
        do {
            // Scan both sides
            let result = try await scanner.scanBothSides()
            
            if result.isSuccess {
                // Display front image
                if let frontPath = result.frontImagePath,
                   let frontImage = UIImage(contentsOfFile: frontPath) {
                    frontImageView.image = frontImage
                }
                
                // Display back image
                if let backPath = result.backImagePath,
                   let backImage = UIImage(contentsOfFile: backPath) {
                    backImageView.image = backImage
                }
            }
        } catch {
            showAlert("Scan failed: \\(error.localizedDescription)")
        }
    }
    
    private func showAlert(_ message: String) {
        let alert = UIAlertController(
            title: "Document Scanner",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
```

## Requirements

- iOS 16.0+
- Xcode 15.0+
- Swift 5.9+
- Camera permission in `Info.plist`:

```xml
<key>NSCameraUsageDescription</key>
<string>We need camera access to scan documents</string>
```

## SwiftUI Example

```swift
import SwiftUI
import DocScannerSDK

struct ContentView: View {
    @State private var frontImage: UIImage?
    @State private var backImage: UIImage?
    @State private var isScanning = false
    
    var body: some View {
        VStack(spacing: 20) {
            if let frontImage = frontImage {
                Image(uiImage: frontImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 200)
            }
            
            if let backImage = backImage {
                Image(uiImage: backImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 200)
            }
            
            Button("Scan Document") {
                Task {
                    await scanDocument()
                }
            }
            .disabled(isScanning)
        }
        .padding()
    }
    
    private func scanDocument() async {
        isScanning = true
        defer { isScanning = false }
        
        let scanner = DocScanner.shared
        
        guard await scanner.requestCameraPermission() else {
            return
        }
        
        do {
            let result = try await scanner.scanBothSides()
            
            if result.isSuccess {
                if let frontPath = result.frontImagePath {
                    frontImage = UIImage(contentsOfFile: frontPath)
                }
                if let backPath = result.backImagePath {
                    backImage = UIImage(contentsOfFile: backPath)
                }
            }
        } catch {
            print("Error: \\(error)")
        }
    }
}
```

See the [main README](../README.md) for more details.
