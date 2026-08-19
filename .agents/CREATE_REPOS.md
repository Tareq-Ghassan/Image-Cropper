# Creating GitHub Repositories for Platform SDKs

This guide explains how to create separate GitHub repositories for each platform SDK and set them up as submodules in the main umbrella repository.

## Prerequisites

- GitHub account
- Git installed locally
- GitHub CLI (`gh`) installed (optional but recommended)

## Step 1: Create GitHub Repositories

Create the following repositories on GitHub:

1. **DocScannerSDK-Android** - Android native SDK
2. **DocScannerSDK-iOS** - iOS native SDK  
3. **DocScannerSDK-Web** - Web/TypeScript SDK
4. **DocScannerSDK-Windows** - Windows C# SDK
5. **DocScannerSDK-macOS** - macOS Swift SDK
6. **DocScannerSDK-Linux** - Linux C++ SDK
7. **DocScannerSDK-Flutter** - Flutter plugin wrapper

### Using GitHub Web Interface

1. Go to https://github.com/new
2. Repository name: `DocScannerSDK-Android`
3. Description: `Android SDK for document scanning with fixed crop area`
4. Public/Private: Choose based on your needs
5. Do NOT initialize with README (we'll push existing code)
6. Click "Create repository"

Repeat for each platform.

### Using GitHub CLI (Faster)

```bash
# Create all repositories at once
gh repo create DocScannerSDK-Android --public --description "Android SDK for document scanning"
gh repo create DocScannerSDK-iOS --public --description "iOS SDK for document scanning"
gh repo create DocScannerSDK-Web --public --description "Web SDK for document scanning"
gh repo create DocScannerSDK-Windows --public --description "Windows SDK for document scanning"
gh repo create DocScannerSDK-macOS --public --description "macOS SDK for document scanning"
gh repo create DocScannerSDK-Linux --public --description "Linux SDK for document scanning"
gh repo create DocScannerSDK-Flutter --public --description "Flutter plugin for document scanning"
```

## Step 2: Push Existing Code to Each Repository

Now we'll push the code from each platform directory to its respective repository.

### Android SDK

```bash
cd /path/to/DocumentScanner-SDK/android

# Initialize git if not already
git init
git add .
git commit -m "Initial commit: Android SDK

- Camera preview with fixed crop overlay
- Auto-focus and flash support
- Pixel-perfect cropping
- JitPack publishing configuration"

# Add remote and push
git branch -M main
git remote add origin https://github.com/Tareq-Ghassan/DocScannerSDK-Android.git
git push -u origin main

# Create first release
git tag -a v1.0.0 -m "Release v1.0.0"
git push origin v1.0.0
```

### iOS SDK

```bash
cd /path/to/DocumentScanner-SDK/ios

git init
git add .
git commit -m "Initial commit: iOS SDK

- AVFoundation camera integration
- Swift Package Manager support
- CocoaPods support
- Vision framework ready"

git branch -M main
git remote add origin https://github.com/Tareq-Ghassan/DocScannerSDK-iOS.git
git push -u origin main

git tag -a v1.0.0 -m "Release v1.0.0"
git push origin v1.0.0
```

### Web SDK

```bash
cd /path/to/DocumentScanner-SDK/web

git init
git add .
git commit -m "Initial commit: Web SDK

- WebRTC camera access
- TypeScript implementation
- Canvas-based cropping
- NPM publishing ready"

git branch -M main
git remote add origin https://github.com/Tareq-Ghassan/DocScannerSDK-Web.git
git push -u origin main

git tag -a v1.0.0 -m "Release v1.0.0"
git push origin v1.0.0
```

### Windows SDK

```bash
cd /path/to/DocumentScanner-SDK/windows

git init
git add .
git commit -m "Initial commit: Windows SDK

- C# .NET 6 implementation
- Media Foundation camera API
- NuGet package structure"

git branch -M main
git remote add origin https://github.com/Tareq-Ghassan/DocScannerSDK-Windows.git
git push -u origin main
```

### macOS SDK

```bash
cd /path/to/DocumentScanner-SDK/macos

git init
git add .
git commit -m "Initial commit: macOS SDK

- Swift implementation
- AVFoundation camera
- AppKit support
- SPM and CocoaPods ready"

git branch -M main
git remote add origin https://github.com/Tareq-Ghassan/DocScannerSDK-macOS.git
git push -u origin main

git tag -a v1.0.0 -m "Release v1.0.0"
git push origin v1.0.0
```

### Linux SDK

```bash
cd /path/to/DocumentScanner-SDK/linux

git init
git add .
git commit -m "Initial commit: Linux SDK

- C++ implementation
- OpenCV integration
- V4L2 camera support
- CMake build system"

git branch -M main
git remote add origin https://github.com/Tareq-Ghassan/DocScannerSDK-Linux.git
git push -u origin main
```

### Flutter Plugin

```bash
cd /path/to/DocumentScanner-SDK/flutter

git init
git add .
git commit -m "Initial commit: Flutter Plugin

- Cross-platform Dart API
- Platform channels for all platforms
- pub.dev publishing ready
- Example app included"

git branch -M main
git remote add origin https://github.com/Tareq-Ghassan/DocScannerSDK-Flutter.git
git push -u origin main

git tag -a v1.0.0 -m "Release v1.0.0"
git push origin v1.0.0
```

## Step 3: Convert Directories to Submodules

Back in the main `DocumentScanner-SDK` repository:

```bash
cd /path/to/DocumentScanner-SDK

# Remove the directories (make sure they're pushed first!)
rm -rf android/ ios/ web/ windows/ macos/ linux/ flutter/

# Add each as a submodule
git submodule add https://github.com/Tareq-Ghassan/DocScannerSDK-Android.git android
git submodule add https://github.com/Tareq-Ghassan/DocScannerSDK-iOS.git ios
git submodule add https://github.com/Tareq-Ghassan/DocScannerSDK-Web.git web
git submodule add https://github.com/Tareq-Ghassan/DocScannerSDK-Windows.git windows
git submodule add https://github.com/Tareq-Ghassan/DocScannerSDK-macOS.git macos
git submodule add https://github.com/Tareq-Ghassan/DocScannerSDK-Linux.git linux
git submodule add https://github.com/Tareq-Ghassan/DocScannerSDK-Flutter.git flutter

# Commit the submodule additions
git add .gitmodules android ios web windows macos linux flutter
git commit -m "feat: add all platform SDKs as submodules

- Android SDK (JitPack)
- iOS SDK (SPM/CocoaPods)
- Web SDK (NPM)
- Windows SDK (NuGet)
- macOS SDK (SPM/CocoaPods)
- Linux SDK (CMake)
- Flutter Plugin (pub.dev)"

git push
```

## Step 4: Create GitHub Releases

For each repository that's ready for publishing, create a GitHub release:

### Using GitHub Web Interface

1. Go to the repository (e.g., `DocScannerSDK-Android`)
2. Click "Releases" → "Create a new release"
3. Tag version: `v1.0.0`
4. Release title: `Release 1.0.0`
5. Description: Describe what's included
6. Click "Publish release"

### Using GitHub CLI

```bash
# Android
gh release create v1.0.0 --repo Tareq-Ghassan/DocScannerSDK-Android \
  --title "Release 1.0.0" \
  --notes "Initial release of Android SDK"

# iOS
gh release create v1.0.0 --repo Tareq-Ghassan/DocScannerSDK-iOS \
  --title "Release 1.0.0" \
  --notes "Initial release of iOS SDK"

# Web
gh release create v1.0.0 --repo Tareq-Ghassan/DocScannerSDK-Web \
  --title "Release 1.0.0" \
  --notes "Initial release of Web SDK"

# Flutter
gh release create v1.0.0 --repo Tareq-Ghassan/DocScannerSDK-Flutter \
  --title "Release 1.0.0" \
  --notes "Initial release of Flutter Plugin"
```

## Step 5: Configure Publishing

### Android (JitPack)

JitPack automatically publishes from GitHub releases. Just add the release tag and it's ready!

Users can then add:
```gradle
implementation 'com.github.Tareq-Ghassan:DocScannerSDK-Android:1.0.0'
```

### iOS (CocoaPods)

```bash
cd ios/
pod trunk register email@example.com 'Your Name'
pod trunk push DocScannerSDK.podspec
```

### Web (NPM)

```bash
cd web/
npm login
npm publish --access public
```

### Flutter (pub.dev)

```bash
cd flutter/
flutter pub publish
```

## Step 6: Update Main README

Update the main `DocumentScanner-SDK` README with installation instructions pointing to each submodule repository.

## Verification

After setup, verify everything works:

```bash
# Clone fresh to test
git clone --recurse-submodules https://github.com/Tareq-Ghassan/DocumentScanner-SDK.git
cd DocumentScanner-SDK

# Check submodules
git submodule status

# Should show all submodules with commit SHAs
```

## Maintenance Workflow

When updating a platform SDK:

```bash
# Work in the platform directory
cd android/
# Make changes
git add .
git commit -m "feat: add new feature"
git push
git tag -a v1.0.1 -m "Release v1.0.1"
git push origin v1.0.1

# Update main repo
cd ..
git add android
git commit -m "chore: update Android SDK to v1.0.1"
git push
```

## Troubleshooting

### Submodule not showing content

```bash
git submodule update --init --recursive
```

### Submodule pointing to wrong commit

```bash
cd submodule-directory/
git checkout main
git pull
cd ..
git add submodule-directory
git commit -m "Update submodule"
```

### Remove a submodule

```bash
git submodule deinit -f path/to/submodule
git rm -f path/to/submodule
rm -rf .git/modules/path/to/submodule
```

---

**Need Help?**
- [GitHub Submodules Documentation](https://git-scm.com/book/en/v2/Git-Tools-Submodules)
- [GitHub CLI Documentation](https://cli.github.com/manual/)
