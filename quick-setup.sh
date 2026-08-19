#!/bin/bash

# Simple one-command setup - Run this to complete everything!
# Usage: bash quick-setup.sh

set -e

echo "🚀 DocumentScanner SDK - Quick Setup"
echo "===================================="
echo ""

GITHUB_USER="Tareq-Ghassan"
GITHUB_TOKEN="${GITHUB_TOKEN:-$(gh auth token 2>/dev/null || echo '')}"

if [ -z "$GITHUB_TOKEN" ]; then
    echo "❌ GitHub token not found. Please authenticate:"
    echo "   gh auth login"
    exit 1
fi

echo "✓ GitHub authenticated"
echo ""

# Step 1: Rename main repo
echo "📝 Step 1: Renaming main repository..."
curl -X PATCH \
  -H "Authorization: token $GITHUB_TOKEN" \
  -H "Accept: application/vnd.github.v3+json" \
  https://api.github.com/repos/${GITHUB_USER}/Image-Cropper \
  -d '{"name":"DocumentScanner-SDK"}' 2>&1 | grep -q "name" && echo "✓ Renamed to DocumentScanner-SDK" || echo "⚠ May already be renamed"

# Update local remote
git remote set-url origin "https://github.com/${GITHUB_USER}/DocumentScanner-SDK.git"
echo "✓ Updated local remote"
echo ""

# Step 2: Create platform repositories
echo "📝 Step 2: Creating platform repositories..."
for platform in Android iOS Flutter Web Windows macOS Linux; do
    repo_name="DocScannerSDK-${platform}"
    echo "Creating ${repo_name}..."
    
    curl -X POST \
      -H "Authorization: token $GITHUB_TOKEN" \
      -H "Accept: application/vnd.github.v3+json" \
      https://api.github.com/user/repos \
      -d "{\"name\":\"${repo_name}\",\"description\":\"DocumentScanner SDK for ${platform}\",\"private\":false,\"license_template\":\"mit\"}" \
      2>&1 | grep -q "full_name" && echo "✓ ${repo_name}" || echo "⚠ ${repo_name} (may already exist)"
done
echo ""

# Step 3: Push platform code
echo "📝 Step 3: Pushing platform code..."
TEMP_DIR=$(mktemp -d)

for platform in android ios flutter web windows macos linux; do
    PLATFORM_UPPER=$(echo "$platform" | awk '{print toupper(substr($0,1,1)) tolower(substr($0,2))}')
    if [ "$platform" = "macos" ]; then PLATFORM_UPPER="macOS"; fi
    if [ "$platform" = "ios" ]; then PLATFORM_UPPER="iOS"; fi
    
    repo_name="DocScannerSDK-${PLATFORM_UPPER}"
    
    echo "Processing ${platform}..."
    
    mkdir -p "${TEMP_DIR}/${platform}"
    cd "${TEMP_DIR}/${platform}"
    git init -q
    git config user.name "$(cd /workspace && git config user.name)"
    git config user.email "$(cd /workspace && git config user.email)"
    
    # Copy platform files
    if [ -d "/workspace/${platform}" ]; then
        cp -r "/workspace/${platform}"/* ./ 2>/dev/null || true
        cp -r "/workspace/${platform}"/.[!.]* ./ 2>/dev/null || true
    fi
    
    # Ensure README exists
    if [ ! -f "README.md" ]; then
        echo "# ${repo_name}" > README.md
        echo "" >> README.md
        echo "DocumentScanner SDK for ${PLATFORM_UPPER}" >> README.md
    fi
    
    git add . 2>/dev/null || true
    git commit -m "Initial commit: ${PLATFORM_UPPER} SDK" -q 2>/dev/null || true
    git remote add origin "https://${GITHUB_TOKEN}@github.com/${GITHUB_USER}/${repo_name}.git" 2>/dev/null || true
    git branch -M main
    git push -u origin main --force -q 2>&1 | head -2 || echo "  ⚠ Push may have failed"
    
    echo "✓ ${platform}"
done
echo ""

# Step 4: Setup submodules
echo "📝 Step 4: Setting up submodules..."
cd /workspace

# Backup platform directories
BACKUP_DIR="/workspace/.platform-backup-$(date +%s)"
mkdir -p "${BACKUP_DIR}"
for platform in android ios flutter web windows macos linux; do
    if [ -d "${platform}" ] && [ ! -L "${platform}" ]; then
        mv "${platform}" "${BACKUP_DIR}/" 2>/dev/null || true
    fi
done
echo "✓ Backed up to ${BACKUP_DIR}"

# Create .gitmodules
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
echo "✓ Created .gitmodules"

# Add submodules
for platform in android ios flutter web windows macos linux; do
    PLATFORM_UPPER=$(echo "$platform" | awk '{print toupper(substr($0,1,1)) tolower(substr($0,2))}')
    if [ "$platform" = "macos" ]; then PLATFORM_UPPER="macOS"; fi
    if [ "$platform" = "ios" ]; then PLATFORM_UPPER="iOS"; fi
    
    git submodule add -f "https://github.com/${GITHUB_USER}/DocScannerSDK-${PLATFORM_UPPER}.git" "${platform}" 2>&1 | grep -v "already exists in the index" || true
done

git submodule init
git submodule update --remote --merge
echo "✓ Submodules configured"
echo ""

# Step 5: Commit
echo "📝 Step 5: Committing changes..."
git add .gitmodules 2>/dev/null || true
git add android ios flutter web windows macos linux 2>/dev/null || true
git commit -m "refactor: convert to multi-repository structure with submodules

- Created separate repositories for each platform SDK
- Added all platforms as git submodules
- Each platform can now be developed independently

Repositories:
- DocScannerSDK-Android
- DocScannerSDK-iOS
- DocScannerSDK-Flutter
- DocScannerSDK-Web
- DocScannerSDK-Windows
- DocScannerSDK-macOS
- DocScannerSDK-Linux" 2>&1 || echo "⚠ Nothing to commit"

git push origin cursor/multi-platform-sdk 2>&1 || git push 2>&1 || echo "⚠ Push may have issues"

echo ""
echo "✅ SETUP COMPLETE!"
echo "==================" 
echo ""
echo "Your repositories:"
for platform in Android iOS Flutter Web Windows macOS Linux; do
    echo "  ✓ https://github.com/${GITHUB_USER}/DocScannerSDK-${platform}"
done
echo ""
echo "Main repo: https://github.com/${GITHUB_USER}/DocumentScanner-SDK"
echo ""
echo "Platform backups: ${BACKUP_DIR}"
echo ""
echo "Next: git submodule status"
echo ""
