# Publishing Guide for DocumentScanner SDK

This guide explains how to publish each platform SDK to its respective package manager.

## Prerequisites

Before publishing, ensure you have:
- Completed and tested the code
- Updated version numbers
- Updated CHANGELOG.md
- Created a git tag
- All tests passing
- All CI checks passing

## 🤖 Android SDK - JitPack

### Setup (One-time)

JitPack automatically publishes from GitHub releases. No additional setup required!

### Publishing Steps

1. **Update version in `build.gradle`:**
   ```gradle
   android {
       defaultConfig {
           versionName "1.0.1"  // Update this
       }
   }
   ```

2. **Commit and tag:**
   ```bash
   cd android/
   git add build.gradle
   git commit -m "chore: bump version to 1.0.1"
   git tag -a v1.0.1 -m "Release v1.0.1"
   git push origin main
   git push origin v1.0.1
   ```

3. **Create GitHub Release:**
   ```bash
   gh release create v1.0.1 --title "v1.0.1" --notes "Bug fixes and improvements"
   ```

4. **Verify on JitPack:**
   - Visit https://jitpack.io/#Tareq-Ghassan/DocScannerSDK-Android
   - The release should appear automatically
   - Click "Get it" to trigger build if needed

### Usage

Users can then add:
```gradle
dependencies {
    implementation 'com.github.Tareq-Ghassan:DocScannerSDK-Android:1.0.1'
}
```

---

## 🍎 iOS SDK - CocoaPods & SPM

### Setup (One-time)

#### CocoaPods

1. **Register with CocoaPods Trunk:**
   ```bash
   pod trunk register email@example.com 'Your Name'
   ```
   
2. **Verify email** (check inbox)

#### Swift Package Manager

No setup required - works automatically with GitHub releases!

### Publishing Steps

1. **Update version:**
   - In `DocScannerSDK.podspec`: `s.version = '1.0.1'`
   - In `Package.swift` if needed

2. **Commit and tag:**
   ```bash
   cd ios/
   git add .
   git commit -m "chore: bump version to 1.0.1"
   git tag -a v1.0.1 -m "Release v1.0.1"
   git push origin main
   git push origin v1.0.1
   ```

3. **Create GitHub Release** (for SPM)

4. **Publish to CocoaPods:**
   ```bash
   cd ios/
   pod spec lint DocScannerSDK.podspec --allow-warnings
   pod trunk push DocScannerSDK.podspec --allow-warnings
   ```

### Usage

**CocoaPods:**
```ruby
pod 'DocScannerSDK', '~> 1.0.1'
```

**SPM:**
```swift
.package(url: "https://github.com/Tareq-Ghassan/DocScannerSDK-iOS.git", from: "1.0.1")
```

---

## 🌐 Web SDK - NPM

### Setup (One-time)

1. **Create NPM account:** https://www.npmjs.com/signup

2. **Login:**
   ```bash
   npm login
   ```

3. **Verify organization** (if using @docscanner):
   ```bash
   npm org ls docscanner
   ```

### Publishing Steps

1. **Update version in `package.json`:**
   ```json
   {
     "version": "1.0.1"
   }
   ```

2. **Build and test:**
   ```bash
   cd web/
   npm run build
   npm test
   npm run lint
   ```

3. **Publish:**
   ```bash
   npm publish --access public
   ```

4. **Create git tag:**
   ```bash
   git tag -a v1.0.1 -m "Release v1.0.1"
   git push origin v1.0.1
   ```

### Automated Publishing

The GitHub Actions workflow will automatically publish on release:
```bash
gh release create v1.0.1
```

### Usage

```bash
npm install @docscanner/sdk-web
```

---

## 🎯 Flutter Plugin - pub.dev

### Setup (One-time)

1. **Ensure you're logged in:**
   ```bash
   flutter pub login
   ```

### Publishing Steps

1. **Update version in `pubspec.yaml`:**
   ```yaml
   version: 1.0.1
   ```

2. **Update CHANGELOG.md**

3. **Validate package:**
   ```bash
   cd flutter/
   flutter pub publish --dry-run
   ```

4. **Publish:**
   ```bash
   flutter pub publish
   ```

5. **Create git tag:**
   ```bash
   git tag -a v1.0.1 -m "Release v1.0.1"
   git push origin v1.0.1
   ```

### Automated Publishing

GitHub Actions will publish on release (requires `PUB_CREDENTIALS` secret).

### Usage

```yaml
dependencies:
  doc_scanner_sdk: ^1.0.1
```

---

## 🖥️ macOS SDK - CocoaPods & SPM

Same as iOS SDK (see above).

---

## 🪟 Windows SDK - NuGet

### Setup (One-time)

1. **Create NuGet account:** https://www.nuget.org/

2. **Generate API key:**
   - Go to https://www.nuget.org/account/apikeys
   - Create new API key

3. **Set API key:**
   ```bash
   dotnet nuget setapikey YOUR_API_KEY
   ```

### Publishing Steps

1. **Update version in `.csproj`:**
   ```xml
   <PropertyGroup>
       <Version>1.0.1</Version>
   </PropertyGroup>
   ```

2. **Build:**
   ```bash
   cd windows/
   dotnet build -c Release
   ```

3. **Pack:**
   ```bash
   dotnet pack -c Release
   ```

4. **Publish:**
   ```bash
   dotnet nuget push bin/Release/DocScanner.SDK.Windows.1.0.1.nupkg --source https://api.nuget.org/v3/index.json
   ```

### Usage

```bash
dotnet add package DocScanner.SDK.Windows
```

---

## 🐧 Linux SDK - CMake Install

### Publishing

Linux SDK is distributed as source code:

1. **Tag release:**
   ```bash
   git tag -a v1.0.1 -m "Release v1.0.1"
   git push origin v1.0.1
   ```

2. **Create GitHub Release** with source tarball

### Usage

```bash
git clone https://github.com/Tareq-Ghassan/DocScannerSDK-Linux.git
cd DocScannerSDK-Linux
mkdir build && cd build
cmake ..
make
sudo make install
```

---

## 📋 Version Synchronization

You don't need to keep all platform versions in sync. Each platform can have its own version number:

Example:
- Android: v2.1.0
- iOS: v2.0.5
- Web: v1.8.0
- Flutter: v3.0.0

The **Flutter plugin version** should be bumped when:
- Any platform SDK is updated
- Dart API changes
- Breaking changes

---

## 🔐 Required Secrets

For automated publishing via GitHub Actions, add these secrets to your repositories:

### Android
- None required (JitPack is automatic)

### iOS
- `COCOAPODS_TRUNK_TOKEN` - Get from `~/.netrc` after `pod trunk register`

### Web
- `NPM_TOKEN` - Get from https://www.npmjs.com/settings/tokens

### Flutter
- `PUB_CREDENTIALS` - Content of `~/.pub-cache/credentials.json`

### Windows
- `NUGET_API_KEY` - From https://www.nuget.org/account/apikeys

---

## 🚀 Automated Release Workflow

1. **Update code and version numbers**

2. **Run locally:**
   ```bash
   # Android
   ./gradlew build
   
   # iOS
   swift build
   
   # Web
   npm run build && npm test
   
   # Flutter
   flutter test && flutter pub publish --dry-run
   ```

3. **Commit and push:**
   ```bash
   git add .
   git commit -m "chore: release v1.0.1"
   git push
   ```

4. **Create GitHub Release:**
   ```bash
   gh release create v1.0.1 \
     --title "Release v1.0.1" \
     --notes "$(cat CHANGELOG.md | sed -n '/## \[1.0.1\]/,/## \[/p' | sed '1d;$d')"
   ```

5. **GitHub Actions will automatically:**
   - Build all SDKs
   - Run tests
   - Publish to package managers
   - Update documentation

---

## 🐛 Troubleshooting

### JitPack Build Failed

- Check build logs at https://jitpack.io/com/github/Tareq-Ghassan/DocScannerSDK-Android/
- Ensure `jitpack.yml` is present
- Verify Gradle builds locally

### CocoaPods Rejected

- Run `pod spec lint --verbose` for detailed errors
- Check Podspec syntax
- Verify source files exist

### NPM Publish Failed

- Check if version already exists
- Verify package name is available
- Ensure you're logged in: `npm whoami`

### pub.dev Rejected

- Run `dart pub publish --dry-run`
- Check `pubspec.yaml` format
- Verify all dependencies are published

---

## 📞 Support

If you encounter issues:
1. Check CI logs on GitHub Actions
2. Open an issue on the main repo
3. Consult platform-specific documentation

---

**Last Updated:** August 19, 2026
