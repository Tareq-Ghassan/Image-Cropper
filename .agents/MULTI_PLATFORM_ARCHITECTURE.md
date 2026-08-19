# DocScanner SDK Multi-Platform Architecture

This document explains the architecture of the DocScanner SDK across all supported platforms.

## 🏗️ Architecture Overview

DocScanner SDK follows a **native-first architecture** where each platform has its own **native SDK implementation**, and **Flutter acts as a unified wrapper** that provides a consistent API across all platforms.

```
┌─────────────────────────────────────────────────────────────┐
│                   Flutter Application                        │
│                  (Cross-Platform API)                        │
└──────────────────┬──────────────────────────────────────────┘
                   │
        ┌──────────┴──────────┐
        │   Flutter Plugin    │
        │  (doc_scanner_sdk)  │
        └──────────┬──────────┘
                   │
     ┌─────────────┴─────────────┐
     │   Platform Channels       │
     └──┬────┬────┬────┬────┬───┘
        │    │    │    │    │
   ┌────▼┐ ┌─▼──┐ ┌▼───┐ ┌▼──┐ ┌▼────┐ ┌▼─────┐
   │ iOS │ │And │ │Web │ │Win│ │macOS│ │Linux │
   │ SDK │ │ SDK│ │SDK │ │SDK│ │ SDK │ │ SDK  │
   └─────┘ └────┘ └────┘ └───┘ └─────┘ └──────┘
     ▲       ▲      ▲      ▲      ▲        ▲
     │       │      │      │      │        │
  Native  Native Native Native Native  Native
  AVFnd   Camera Media  Win  AVFnd   OpenCV
  Vision    X    Pipe   Media Vision  dlib
```

## 📁 Repository Structure

```
DocumentScanner-SDK/                    # Main umbrella repository
├── android/            →  [SUBMODULE]  # DocScannerSDK-Android
│   ├── src/main/
│   │   ├── java/com/docscanner/sdk/
│   │   └── res/
│   ├── build.gradle
│   └── README.md
├── ios/                →  [SUBMODULE]  # DocScannerSDK-iOS
│   ├── Sources/DocScannerSDK/
│   ├── Package.swift
│   ├── DocScannerSDK.podspec
│   └── README.md
├── web/                →  [SUBMODULE]  # DocScannerSDK-Web
│   ├── src/
│   │   ├── core/
│   │   ├── utils/
│   │   └── types/
│   ├── package.json
│   ├── tsconfig.json
│   └── README.md
├── windows/            →  [SUBMODULE]  # DocScannerSDK-Windows
│   └── DocScanner.SDK.Windows/
│       └── README.md
├── macos/              →  [SUBMODULE]  # DocScannerSDK-macOS
│   ├── Sources/DocScannerSDK/
│   ├── Package.swift
│   └── README.md
├── linux/              →  [SUBMODULE]  # DocScannerSDK-Linux
│   ├── src/
│   ├── include/docscanner/
│   └── README.md
├── flutter/            →  [SUBMODULE]  # DocScannerSDK-Flutter
│   ├── lib/
│   │   ├── doc_scanner_sdk.dart
│   │   └── src/
│   ├── android/        (wraps android/)
│   ├── ios/            (wraps ios/)
│   ├── web/            (wraps web/)
│   ├── example/
│   ├── pubspec.yaml
│   └── README.md
├── .agents/
│   ├── MULTI_PLATFORM_ARCHITECTURE.md
│   ├── CREATE_REPOS.md
│   ├── SUBMODULES_SETUP.md
│   └── WORKFLOW_RULES.md
├── README.md
├── LICENSE
└── .gitmodules
```

## 🎯 Platform SDK Details

### 1. Android SDK (Kotlin + CameraX)

**Location**: `android/` (submodule: DocScannerSDK-Android)

**Technology Stack**:
- Language: Kotlin
- Camera: CameraX / Legacy Camera API
- UI: Android View System
- Build: Gradle

**Key Features**:
- Fixed crop overlay with customizable border
- SurfaceView for camera preview
- Auto-focus and flash support
- Portrait and landscape orientation
- Aspect ratio preservation
- Pixel-perfect cropping

**Publishing**: JitPack (automatic from GitHub releases)

---

### 2. iOS SDK (Swift + AVFoundation)

**Location**: `ios/` (submodule: DocScannerSDK-iOS)

**Technology Stack**:
- Language: Swift 5.9
- Camera: AVFoundation
- Vision: Vision Framework (optional)
- Build: Swift Package Manager + CocoaPods

**Key Features**:
- AVCaptureSession for camera
- CALayer overlay
- Auto-focus and flash
- Orientation handling
- High-quality image capture

**Publishing**: 
- Swift Package Manager (GitHub releases)
- CocoaPods Trunk

---

### 3. Web SDK (TypeScript + WebRTC)

**Location**: `web/` (submodule: DocScannerSDK-Web)

**Technology Stack**:
- Language: TypeScript
- Camera: MediaDevices API (WebRTC)
- Rendering: Canvas API
- Build: TypeScript + Rollup

**Key Features**:
- WebRTC camera access
- Canvas-based overlay
- Client-side cropping
- Blob output for upload
- Cross-browser support

**Browser Support**:
- Chrome/Edge 90+
- Firefox 88+
- Safari 15+

**Publishing**: NPM (`@docscanner/sdk-web`)

---

### 4. Windows SDK (C#)

**Location**: `windows/` (submodule: DocScannerSDK-Windows)

**Technology Stack**:
- Language: C# / .NET 6.0
- Camera: DirectShow / Media Foundation
- UI: WPF / WinUI
- Build: MSBuild

**Status**: 🚧 In Development

**Publishing**: NuGet (`DocScanner.SDK.Windows`)

---

### 5. macOS SDK (Swift + AVFoundation)

**Location**: `macos/` (submodule: DocScannerSDK-macOS)

**Technology Stack**:
- Language: Swift 5.9
- Camera: AVFoundation (same as iOS)
- UI: AppKit
- Build: Swift Package Manager

**Publishing**:
- Swift Package Manager
- CocoaPods

---

### 6. Linux SDK (C++ + OpenCV)

**Location**: `linux/` (submodule: DocScannerSDK-Linux)

**Technology Stack**:
- Language: C++17
- Camera: Video4Linux2 (V4L2)
- Processing: OpenCV
- Build: CMake

**Status**: 🚧 In Development

**Publishing**: Source (CMake install)

---

### 7. Flutter Plugin (Dart)

**Location**: `flutter/` (submodule: DocScannerSDK-Flutter)

**Technology Stack**:
- Language: Dart 3.6+
- Platform Channels: MethodChannel
- Build: Flutter plugin architecture

**Purpose**: 
- Wraps all native SDKs
- Provides unified Dart API
- Handles platform-specific implementations

**Publishing**: pub.dev (`doc_scanner_sdk`)

---

## 🔄 Data Flow

### Scan Document Flow

```
Flutter App
    │
    ├─> scanner.scanDocument()
    │       │
    │       └─> Platform Channel
    │               │
    │               ├─> Android: Launch MainActivityLib
    │               │       └─> PhotoFragment (Camera + Overlay)
    │               │           └─> Capture & Crop
    │               │               └─> Return file path
    │               │
    │               ├─> iOS: Present CameraViewController
    │               │       └─> AVCaptureSession + Overlay
    │               │           └─> Capture & Crop
    │               │               └─> Return file path
    │               │
    │               └─> Web: Show camera modal
    │                       └─> MediaDevices + Canvas
    │                           └─> Capture & Crop
    │                               └─> Return Blob
    │
    └─> ScanResult {
            frontImagePath: String,
            timestamp: DateTime,
            isSuccess: true
        }
```

## 📦 Creating GitHub Submodules

To set up the complete multi-platform architecture, each platform SDK should be in its own GitHub repository and added as a submodule.

### Step 1: Create Separate Repositories

Create these GitHub repositories:
1. `DocScannerSDK-Android`
2. `DocScannerSDK-iOS`
3. `DocScannerSDK-Web`
4. `DocScannerSDK-Windows`
5. `DocScannerSDK-macOS`
6. `DocScannerSDK-Linux`
7. `DocScannerSDK-Flutter`

### Step 2: Push Code to Repositories

```bash
# For each platform, initialize git and push:

# Android
cd android/
git init
git add .
git commit -m "Initial commit: Android SDK"
git remote add origin https://github.com/Tareq-Ghassan/DocScannerSDK-Android.git
git push -u origin main

# Repeat for iOS, Web, etc.
```

### Step 3: Add as Submodules

In the main repository:

```bash
cd DocumentScanner-SDK/

# Remove directories (after pushing them)
rm -rf android/ ios/ web/ windows/ macos/ linux/ flutter/

# Add as submodules
git submodule add https://github.com/Tareq-Ghassan/DocScannerSDK-Android.git android
git submodule add https://github.com/Tareq-Ghassan/DocScannerSDK-iOS.git ios
git submodule add https://github.com/Tareq-Ghassan/DocScannerSDK-Web.git web
git submodule add https://github.com/Tareq-Ghassan/DocScannerSDK-Windows.git windows
git submodule add https://github.com/Tareq-Ghassan/DocScannerSDK-macOS.git macos
git submodule add https://github.com/Tareq-Ghassan/DocScannerSDK-Linux.git linux
git submodule add https://github.com/Tareq-Ghassan/DocScannerSDK-Flutter.git flutter

# Commit
git add .gitmodules android ios web windows macos linux flutter
git commit -m "feat: add all platform SDKs as submodules"
git push
```

## 🚀 Development Workflow

### Cloning with Submodules

```bash
# Clone with submodules
git clone --recurse-submodules https://github.com/Tareq-Ghassan/DocumentScanner-SDK.git

# Or if already cloned
cd DocumentScanner-SDK
git submodule update --init --recursive
```

### Working on a Platform SDK

```bash
# Work on Android SDK
cd android/
# Make changes
git add .
git commit -m "feat: improve camera performance"
git push

# Update main repo to point to new commit
cd ..
git add android
git commit -m "chore: update Android SDK submodule"
git push
```

## 📊 Platform Comparison

| Feature | Android | iOS | Web | Windows | macOS | Linux |
|---------|---------|-----|-----|---------|-------|-------|
| **Language** | Kotlin | Swift | TypeScript | C# | Swift | C++ |
| **Camera API** | CameraX | AVFoundation | WebRTC | DirectShow | AVFoundation | V4L2 |
| **Min Version** | API 24 | iOS 16 | - | Win 10 | macOS 13 | Ubuntu 20.04 |
| **Status** | ✅ Ready | ✅ Ready | ✅ Ready | 🚧 Dev | ✅ Ready | 🚧 Dev |
| **Publishing** | JitPack | SPM/CocoaPods | NPM | NuGet | SPM/CocoaPods | Source |

## 🎓 Benefits of This Architecture

1. **Native Performance**: Each platform uses its best-available APIs
2. **Platform Optimization**: Leverage platform-specific features
3. **Independent Development**: Each SDK can evolve independently
4. **Easy Maintenance**: Clear separation of concerns
5. **Flexible Integration**: Use native SDKs directly or via Flutter
6. **Consistent API**: Flutter provides unified interface
7. **Version Control**: Each SDK has its own versioning

---

**Last Updated**: August 19, 2026
