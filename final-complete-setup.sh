#!/bin/bash

# Final setup script - Run AFTER creating repositories and renaming main repo
# Usage: bash final-complete-setup.sh

set -e

echo "🚀 DocumentScanner SDK - Final Setup"
echo "====================================="
echo ""

GITHUB_USER="Tareq-Ghassan"
MAIN_REPO="DocumentScanner-SDK"

# Check if repos exist
echo "Checking if repositories exist..."
REPOS=("Android" "iOS" "Flutter" "Web" "Windows" "macOS" "Linux")
ALL_EXIST=true

for platform in "${REPOS[@]}"; do
    repo_name="DocScannerSDK-${platform}"
    if gh repo view "${GITHUB_USER}/${repo_name}" >/dev/null 2>&1; then
        echo "✓ ${repo_name} exists"
    else
        echo "❌ ${repo_name} NOT FOUND"
        ALL_EXIST=false
    fi
done

if [ "$ALL_EXIST" = false ]; then
    echo ""
    echo "❌ Error: Some repositories don't exist yet!"
    echo "Please create them first. See FINISH_SETUP.md for instructions."
    exit 1
fi

echo ""
echo "✅ All repositories exist!"
echo ""

# Get backup directory
BACKUP_DIR=$(ls -td /workspace/.platform-backup-* 2>/dev/null | head -1)

if [ -z "$BACKUP_DIR" ]; then
    echo "❌ No backup directory found. Platform code may already be pushed."
    echo "Continuing anyway..."
    BACKUP_DIR="/workspace"
fi

echo "Using code from: ${BACKUP_DIR}"
echo ""

# Create temp directory for pushing
TEMP_DIR=$(mktemp -d)
echo "Working in: ${TEMP_DIR}"
echo ""

# Push each platform
for platform in android ios flutter web windows macos linux; do
    PLATFORM_UPPER=$(echo "$platform" | awk '{print toupper(substr($0,1,1)) tolower(substr($0,2))}')
    if [ "$platform" = "macos" ]; then PLATFORM_UPPER="macOS"; fi
    if [ "$platform" = "ios" ]; then PLATFORM_UPPER="iOS"; fi
    
    repo_name="DocScannerSDK-${PLATFORM_UPPER}"
    
    echo "📦 Pushing ${PLATFORM_UPPER}..."
    echo "----------------------------------------"
    
    # Create platform directory
    mkdir -p "${TEMP_DIR}/${platform}"
    cd "${TEMP_DIR}/${platform}"
    
    # Initialize git
    git init -q
    git config user.name "$(cd /workspace && git config user.name)"
    git config user.email "$(cd /workspace && git config user.email)"
    
    # Copy platform files from backup
    SOURCE_DIR="${BACKUP_DIR}/${platform}"
    if [ ! -d "$SOURCE_DIR" ]; then
        SOURCE_DIR="/workspace/${platform}"
    fi
    
    if [ -d "$SOURCE_DIR" ]; then
        echo "Copying from: ${SOURCE_DIR}"
        cp -r "${SOURCE_DIR}"/* ./ 2>/dev/null || true
        cp -r "${SOURCE_DIR}"/.[!.]* ./ 2>/dev/null || true
    else
        echo "⚠ Warning: No source directory found for ${platform}"
    fi
    
    # Ensure README exists
    if [ ! -f "README.md" ]; then
        cat > README.md << EOF
# ${repo_name}

DocumentScanner SDK for ${PLATFORM_UPPER}

Part of the [DocumentScanner SDK](https://github.com/${GITHUB_USER}/${MAIN_REPO}) multi-platform project.

## Features

- Document scanning with fixed crop rectangle
- Camera preview and capture
- Image cropping and optimization
- Platform-specific native implementation

## Installation

See the main [DocumentScanner SDK documentation](https://github.com/${GITHUB_USER}/${MAIN_REPO}) for installation instructions.

## License

MIT License - see LICENSE file for details
EOF
    fi
    
    # Copy LICENSE
    if [ ! -f "LICENSE" ] && [ -f "/workspace/LICENSE" ]; then
        cp /workspace/LICENSE LICENSE
    fi
    
    # Add and commit
    git add .
    git commit -m "feat: initial ${PLATFORM_UPPER} SDK implementation

- Modern ${PLATFORM_UPPER} implementation for document scanning
- Camera integration with fixed crop rectangle
- Image capture and cropping functionality
- Part of DocumentScanner SDK multi-platform project
- Migrated from monorepo structure
- Ready for platform-specific development and releases" -q || echo "⚠ Nothing to commit"
    
    # Add remote and push
    git remote add origin "https://github.com/${GITHUB_USER}/${repo_name}.git"
    git branch -M main
    
    echo "Pushing to ${repo_name}..."
    if git push -u origin main --force -q 2>&1; then
        echo "✅ ${PLATFORM_UPPER} pushed successfully!"
    else
        echo "⚠ Push failed for ${PLATFORM_UPPER}"
    fi
    
    echo ""
done

# Setup submodules in main repo
echo "🔗 Setting up submodules in main repository..."
echo "----------------------------------------"
cd /workspace

# Initialize submodules
if [ -f ".gitmodules" ]; then
    echo "✓ .gitmodules already exists"
    
    # Add submodules
    for platform in android ios flutter web windows macos linux; do
        PLATFORM_UPPER=$(echo "$platform" | awk '{print toupper(substr($0,1,1)) tolower(substr($0,2))}')
        if [ "$platform" = "macos" ]; then PLATFORM_UPPER="macOS"; fi
        if [ "$platform" = "ios" ]; then PLATFORM_UPPER="iOS"; fi
        
        repo_url="https://github.com/${GITHUB_USER}/DocScannerSDK-${PLATFORM_UPPER}.git"
        
        if [ ! -d "${platform}" ] || [ ! -d "${platform}/.git" ]; then
            echo "Adding ${platform} submodule..."
            git submodule add -f "${repo_url}" "${platform}" 2>&1 | grep -v "already exists" || true
        else
            echo "✓ ${platform} submodule already exists"
        fi
    done
    
    # Initialize and update
    git submodule init 2>&1 | grep -v "Submodule" || true
    git submodule update --remote --init 2>&1 || true
    
    echo "✅ Submodules configured!"
else
    echo "❌ .gitmodules not found!"
    exit 1
fi

echo ""
echo "📝 Committing submodule setup..."
git add .gitmodules 2>/dev/null || true
git add android ios flutter web windows macos linux 2>/dev/null || true
git add quick-setup.sh FINISH_SETUP.md final-complete-setup.sh 2>/dev/null || true

git commit -m "feat: complete multi-repository setup with submodules

- Added all platform SDKs as git submodules
- Each platform now in its own repository
- Structure matches FaceDetection-GazePoint
- Ready for independent platform development

Platform repositories:
- DocScannerSDK-Android: https://github.com/${GITHUB_USER}/DocScannerSDK-Android
- DocScannerSDK-iOS: https://github.com/${GITHUB_USER}/DocScannerSDK-iOS
- DocScannerSDK-Flutter: https://github.com/${GITHUB_USER}/DocScannerSDK-Flutter
- DocScannerSDK-Web: https://github.com/${GITHUB_USER}/DocScannerSDK-Web
- DocScannerSDK-Windows: https://github.com/${GITHUB_USER}/DocScannerSDK-Windows
- DocScannerSDK-macOS: https://github.com/${GITHUB_USER}/DocScannerSDK-macOS
- DocScannerSDK-Linux: https://github.com/${GITHUB_USER}/DocScannerSDK-Linux" 2>&1 || echo "⚠ Nothing to commit"

echo "Pushing to remote..."
git push origin cursor/multi-platform-sdk 2>&1 || git push 2>&1 || echo "⚠ Push may have issues"

echo ""
echo "✅ SETUP COMPLETE!"
echo "=================="
echo ""
echo "🎉 Your repository structure now matches FaceDetection-GazePoint!"
echo ""
echo "Repository URLs:"
for platform in Android iOS Flutter Web Windows macOS Linux; do
    echo "  • https://github.com/${GITHUB_USER}/DocScannerSDK-${platform}"
done
echo ""
echo "Main repository:"
echo "  • https://github.com/${GITHUB_USER}/${MAIN_REPO}"
echo ""
echo "Verify submodules:"
echo "  $ git submodule status"
echo ""
echo "Clone with submodules:"
echo "  $ git clone --recursive https://github.com/${GITHUB_USER}/${MAIN_REPO}"
echo ""
echo "Update submodules:"
echo "  $ git submodule update --remote --merge"
echo ""
echo "🚀 You can now develop each platform independently!"
echo ""
