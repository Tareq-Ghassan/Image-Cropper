# Complete Setup Guide - DocumentScanner SDK

This guide will help you set up the repository structure exactly like `FaceDetection-GazePoint` with proper submodules.

## Why Submodules?

Each platform (Android, iOS, Flutter, Web, Windows, macOS, Linux) gets its own GitHub repository. The main repository becomes an "umbrella" that includes all platforms as git submodules. This allows:

- Independent development per platform
- Separate versioning and releases
- Platform-specific issues and PRs
- Individual package publishing
- Cleaner git history per platform

---

## 🚀 Automatic Setup (Recommended)

I've created an automated script that does everything for you:

```bash
cd /workspace
./setup-submodules.sh
```

### What the script does:

1. ✅ **Renames main repository** (requires your confirmation)
2. ✅ **Creates 7 platform repositories** (Android, iOS, Flutter, Web, Windows, macOS, Linux)
3. ✅ **Pushes each platform's code** to its own repository
4. ✅ **Creates `.gitmodules`** with all submodule configurations
5. ✅ **Adds submodules** to the main repository
6. ✅ **Commits and pushes** everything

### Prerequisites:

- GitHub CLI (`gh`) must be authenticated
- You need repository creation permissions
- Git must be configured with your name and email

### Running the script:

```bash
chmod +x setup-submodules.sh
./setup-submodules.sh
```

The script will pause and ask you to rename the repository first. You can do this by running:

```bash
gh repo rename DocumentScanner-SDK --repo Tareq-Ghassan/Image-Cropper
```

---

## 🛠️ Manual Setup (Alternative)

If the automatic script doesn't work, follow these manual steps:

### Step 1: Rename Main Repository

```bash
gh repo rename DocumentScanner-SDK --repo Tareq-Ghassan/Image-Cropper

# Or via GitHub web interface:
# Go to: https://github.com/Tareq-Ghassan/Image-Cropper/settings
# Change "Image-Cropper" to "DocumentScanner-SDK"
```

### Step 2: Create Platform Repositories

```bash
gh repo create Tareq-Ghassan/DocScannerSDK-Android --public --description "DocumentScanner SDK for Android"
gh repo create Tareq-Ghassan/DocScannerSDK-iOS --public --description "DocumentScanner SDK for iOS"
gh repo create Tareq-Ghassan/DocScannerSDK-Flutter --public --description "DocumentScanner SDK for Flutter"
gh repo create Tareq-Ghassan/DocScannerSDK-Web --public --description "DocumentScanner SDK for Web"
gh repo create Tareq-Ghassan/DocScannerSDK-Windows --public --description "DocumentScanner SDK for Windows"
gh repo create Tareq-Ghassan/DocScannerSDK-macOS --public --description "DocumentScanner SDK for macOS"
gh repo create Tareq-Ghassan/DocScannerSDK-Linux --public --description "DocumentScanner SDK for Linux"
```

### Step 3: Push Each Platform

For each platform, create a temporary directory, copy the code, and push:

#### Android:
```bash
cd /tmp && mkdir -p android-sdk && cd android-sdk
git init
cp -r /workspace/android/* ./
git add .
git commit -m "Initial commit: Android SDK"
git remote add origin https://github.com/Tareq-Ghassan/DocScannerSDK-Android.git
git branch -M main
git push -u origin main
```

#### iOS:
```bash
cd /tmp && mkdir -p ios-sdk && cd ios-sdk
git init
cp -r /workspace/ios/* ./
git add .
git commit -m "Initial commit: iOS SDK"
git remote add origin https://github.com/Tareq-Ghassan/DocScannerSDK-iOS.git
git branch -M main
git push -u origin main
```

#### Flutter:
```bash
cd /tmp && mkdir -p flutter-sdk && cd flutter-sdk
git init
cp -r /workspace/flutter/* ./
git add .
git commit -m "Initial commit: Flutter SDK"
git remote add origin https://github.com/Tareq-Ghassan/DocScannerSDK-Flutter.git
git branch -M main
git push -u origin main
```

#### Web:
```bash
cd /tmp && mkdir -p web-sdk && cd web-sdk
git init
cp -r /workspace/web/* ./
git add .
git commit -m "Initial commit: Web SDK"
git remote add origin https://github.com/Tareq-Ghassan/DocScannerSDK-Web.git
git branch -M main
git push -u origin main
```

#### Windows:
```bash
cd /tmp && mkdir -p windows-sdk && cd windows-sdk
git init
cp -r /workspace/windows/* ./
git add .
git commit -m "Initial commit: Windows SDK"
git remote add origin https://github.com/Tareq-Ghassan/DocScannerSDK-Windows.git
git branch -M main
git push -u origin main
```

#### macOS:
```bash
cd /tmp && mkdir -p macos-sdk && cd macos-sdk
git init
cp -r /workspace/macos/* ./
git add .
git commit -m "Initial commit: macOS SDK"
git remote add origin https://github.com/Tareq-Ghassan/DocScannerSDK-macOS.git
git branch -M main
git push -u origin main
```

#### Linux:
```bash
cd /tmp && mkdir -p linux-sdk && cd linux-sdk
git init
cp -r /workspace/linux/* ./
git add .
git commit -m "Initial commit: Linux SDK"
git remote add origin https://github.com/Tareq-Ghassan/DocScannerSDK-Linux.git
git branch -M main
git push -u origin main
```

### Step 4: Remove Platform Directories from Main Repo

```bash
cd /workspace
git rm -rf android ios flutter web windows macos linux
git commit -m "Remove platform directories (will be added as submodules)"
```

### Step 5: Create .gitmodules

```bash
cd /workspace
cat > .gitmodules << 'EOF'
[submodule "android"]
	path = android
	url = https://github.com/Tareq-Ghassan/DocScannerSDK-Android.git
	branch = main
[submodule "ios"]
	path = ios
	url = https://github.com/Tareq-Ghassan/DocScannerSDK-iOS.git
	branch = main
[submodule "flutter"]
	path = flutter
	url = https://github.com/Tareq-Ghassan/DocScannerSDK-Flutter.git
	branch = main
[submodule "web"]
	path = web
	url = https://github.com/Tareq-Ghassan/DocScannerSDK-Web.git
	branch = main
[submodule "windows"]
	path = windows
	url = https://github.com/Tareq-Ghassan/DocScannerSDK-Windows.git
	branch = main
[submodule "macos"]
	path = macos
	url = https://github.com/Tareq-Ghassan/DocScannerSDK-macOS.git
	branch = main
[submodule "linux"]
	path = linux
	url = https://github.com/Tareq-Ghassan/DocScannerSDK-Linux.git
	branch = main
EOF
```

### Step 6: Add Submodules

```bash
cd /workspace
git submodule add https://github.com/Tareq-Ghassan/DocScannerSDK-Android.git android
git submodule add https://github.com/Tareq-Ghassan/DocScannerSDK-iOS.git ios
git submodule add https://github.com/Tareq-Ghassan/DocScannerSDK-Flutter.git flutter
git submodule add https://github.com/Tareq-Ghassan/DocScannerSDK-Web.git web
git submodule add https://github.com/Tareq-Ghassan/DocScannerSDK-Windows.git windows
git submodule add https://github.com/Tareq-Ghassan/DocScannerSDK-macOS.git macos
git submodule add https://github.com/Tareq-Ghassan/DocScannerSDK-Linux.git linux
```

### Step 7: Commit and Push

```bash
cd /workspace
git add .gitmodules
git add android ios flutter web windows macos linux
git commit -m "Add all platform SDKs as submodules"
git push
```

---

## ✅ Verification

After setup, verify everything is correct:

```bash
# Check submodule status
git submodule status

# Expected output:
# <commit-hash> android (heads/main)
# <commit-hash> ios (heads/main)
# <commit-hash> flutter (heads/main)
# <commit-hash> web (heads/main)
# <commit-hash> windows (heads/main)
# <commit-hash> macos (heads/main)
# <commit-hash> linux (heads/main)
```

```bash
# Test cloning with submodules
cd /tmp
git clone --recursive https://github.com/Tareq-Ghassan/DocumentScanner-SDK
cd DocumentScanner-SDK
ls -la  # Should show all platform directories
```

---

## 📚 Working with Submodules

### Clone the full project:
```bash
git clone --recursive https://github.com/Tareq-Ghassan/DocumentScanner-SDK
```

### Update all submodules to latest:
```bash
git submodule update --remote --merge
```

### Make changes to a submodule:
```bash
cd android
# Make your changes
git add .
git commit -m "Update Android SDK"
git push origin main

# Then update the main repo to reference the new commit
cd ..
git add android
git commit -m "Update Android submodule reference"
git push
```

### Initialize submodules after cloning (if you forgot --recursive):
```bash
git submodule init
git submodule update
```

---

## 🎯 Final Structure

```
DocumentScanner-SDK/                    # Main umbrella repository
├── .gitmodules                         # Submodule configuration
├── android/                            # → DocScannerSDK-Android repo
├── ios/                                # → DocScannerSDK-iOS repo
├── flutter/                            # → DocScannerSDK-Flutter repo
├── web/                                # → DocScannerSDK-Web repo
├── windows/                            # → DocScannerSDK-Windows repo
├── macos/                              # → DocScannerSDK-macOS repo
├── linux/                              # → DocScannerSDK-Linux repo
├── README.md                           # Main documentation
├── PUBLISHING.md                       # Publishing guide
└── .github/workflows/                  # CI/CD workflows
```

This matches exactly the structure of `FaceDetection-GazePoint`! 🎉

---

## 🐛 Troubleshooting

### "Resource not accessible by integration"
Your GitHub token doesn't have repository creation permissions. Either:
- Create repositories manually via GitHub web interface
- Or update your token with `repo` scope: https://github.com/settings/tokens

### "fatal: 'android' already exists"
Remove the existing directory first:
```bash
git rm -rf android
rm -rf android
git submodule add https://github.com/Tareq-Ghassan/DocScannerSDK-Android.git android
```

### Submodule shows as modified but no changes
```bash
git submodule update --remote
```

---

## 🚀 After Setup

Once the submodule structure is complete:

1. ✅ Update the main README to reflect the new structure
2. ✅ Create GitHub issues for tracking (see `.agents/GITHUB_ISSUES.md`)
3. ✅ Test the CI/CD workflows
4. ✅ Publish packages from each platform repository
5. ✅ Run `pana` check on Flutter: `./check-pana-score.sh`

---

Need help? Check the reference repository:
https://github.com/Tareq-Ghassan/FaceDetection-GazePoint
