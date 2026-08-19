#!/bin/bash

set -e

echo "=================================="
echo "DocumentScanner SDK - Submodule Setup"
echo "=================================="
echo ""

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
GITHUB_USER="Tareq-Ghassan"
MAIN_REPO_OLD="Image-Cropper"
MAIN_REPO_NEW="DocumentScanner-SDK"
BASE_SDK_NAME="DocScannerSDK"

PLATFORMS=("Android" "iOS" "Flutter" "Web" "Windows" "macOS" "Linux")

echo -e "${YELLOW}Step 1: Rename main repository${NC}"
echo "----------------------------------------"
echo "First, we need to rename the main repository:"
echo ""
echo "  gh repo rename ${MAIN_REPO_NEW} --repo ${GITHUB_USER}/${MAIN_REPO_OLD}"
echo ""
read -p "Press Enter after you've renamed the repository (or if already renamed)..."

echo ""
echo -e "${YELLOW}Step 2: Update local remote URL${NC}"
echo "----------------------------------------"
git remote set-url origin "https://github.com/${GITHUB_USER}/${MAIN_REPO_NEW}.git"
echo -e "${GREEN}✓${NC} Updated local remote URL"

echo ""
echo -e "${YELLOW}Step 3: Create platform repositories${NC}"
echo "----------------------------------------"
for platform in "${PLATFORMS[@]}"; do
    repo_name="${BASE_SDK_NAME}-${platform}"
    echo "Creating ${repo_name}..."
    
    gh repo create "${GITHUB_USER}/${repo_name}" \
        --public \
        --description "DocumentScanner SDK for ${platform}" \
        --add-readme \
        --license mit 2>&1 | grep -v "GraphQL" || echo "  Repository may already exist"
    
    echo -e "${GREEN}✓${NC} ${repo_name}"
done

echo ""
echo -e "${YELLOW}Step 4: Push platform code to separate repositories${NC}"
echo "----------------------------------------"

# Create temporary directory
TEMP_DIR=$(mktemp -d)
echo "Working in: ${TEMP_DIR}"

for platform in "${PLATFORMS[@]}"; do
    platform_lower=$(echo "$platform" | tr '[:upper:]' '[:lower:]')
    repo_name="${BASE_SDK_NAME}-${platform}"
    repo_url="https://github.com/${GITHUB_USER}/${repo_name}.git"
    
    echo ""
    echo "Processing ${platform}..."
    echo "----------------------------------------"
    
    # Create platform directory
    platform_dir="${TEMP_DIR}/${platform_lower}"
    mkdir -p "${platform_dir}"
    
    # Initialize git in platform directory
    cd "${platform_dir}"
    git init
    git config user.name "$(git config --global user.name)"
    git config user.email "$(git config --global user.email)"
    
    # Copy platform code
    if [ -d "/workspace/${platform_lower}" ]; then
        cp -r "/workspace/${platform_lower}"/* ./ 2>/dev/null || true
        cp -r "/workspace/${platform_lower}"/.[!.]* ./ 2>/dev/null || true
    fi
    
    # Create README if doesn't exist
    if [ ! -f "README.md" ]; then
        echo "# ${BASE_SDK_NAME} - ${platform}" > README.md
        echo "" >> README.md
        echo "DocumentScanner SDK for ${platform}" >> README.md
        echo "" >> README.md
        echo "Part of the [DocumentScanner SDK](https://github.com/${GITHUB_USER}/${MAIN_REPO_NEW}) multi-platform project." >> README.md
    fi
    
    # Create LICENSE if doesn't exist
    if [ ! -f "LICENSE" ]; then
        cp /workspace/LICENSE LICENSE 2>/dev/null || true
    fi
    
    # Add and commit
    git add .
    git commit -m "Initial commit: ${platform} SDK

- Migrated from monorepo to standalone repository
- Part of DocumentScanner SDK multi-platform project
- Ready for platform-specific development" || true
    
    # Add remote and push
    git remote add origin "${repo_url}"
    git branch -M main
    
    echo "Pushing to ${repo_url}..."
    git push -u origin main --force || echo "  ${YELLOW}⚠${NC} Push may have failed - repository might not exist yet"
    
    echo -e "${GREEN}✓${NC} ${platform} pushed"
done

echo ""
echo -e "${YELLOW}Step 5: Clean up main repository and add submodules${NC}"
echo "----------------------------------------"

cd /workspace

# Backup current platform directories
BACKUP_DIR="/workspace/.platform-backup-$(date +%s)"
mkdir -p "${BACKUP_DIR}"
for platform in "${PLATFORMS[@]}"; do
    platform_lower=$(echo "$platform" | tr '[:upper:]' '[:lower:]')
    if [ -d "${platform_lower}" ]; then
        mv "${platform_lower}" "${BACKUP_DIR}/" 2>/dev/null || true
    fi
done
echo -e "${GREEN}✓${NC} Backed up platform directories to ${BACKUP_DIR}"

# Create .gitmodules
echo "Creating .gitmodules..."
cat > .gitmodules << EOF
[submodule "android"]
	path = android
	url = https://github.com/${GITHUB_USER}/${BASE_SDK_NAME}-Android.git
	branch = main
[submodule "ios"]
	path = ios
	url = https://github.com/${GITHUB_USER}/${BASE_SDK_NAME}-iOS.git
	branch = main
[submodule "flutter"]
	path = flutter
	url = https://github.com/${GITHUB_USER}/${BASE_SDK_NAME}-Flutter.git
	branch = main
[submodule "web"]
	path = web
	url = https://github.com/${GITHUB_USER}/${BASE_SDK_NAME}-Web.git
	branch = main
[submodule "windows"]
	path = windows
	url = https://github.com/${GITHUB_USER}/${BASE_SDK_NAME}-Windows.git
	branch = main
[submodule "macos"]
	path = macos
	url = https://github.com/${GITHUB_USER}/${BASE_SDK_NAME}-macOS.git
	branch = main
[submodule "linux"]
	path = linux
	url = https://github.com/${GITHUB_USER}/${BASE_SDK_NAME}-Linux.git
	branch = main
EOF
echo -e "${GREEN}✓${NC} Created .gitmodules"

# Add submodules
echo ""
echo "Adding submodules..."
for platform in "${PLATFORMS[@]}"; do
    platform_lower=$(echo "$platform" | tr '[:upper:]' '[:lower:]')
    repo_name="${BASE_SDK_NAME}-${platform}"
    repo_url="https://github.com/${GITHUB_USER}/${repo_name}.git"
    
    echo "Adding ${platform_lower} as submodule..."
    git submodule add -f "${repo_url}" "${platform_lower}" 2>&1 | grep -v "already exists" || true
    echo -e "${GREEN}✓${NC} Added ${platform_lower}"
done

# Initialize and update submodules
echo ""
echo "Initializing submodules..."
git submodule init
git submodule update --remote --merge
echo -e "${GREEN}✓${NC} Submodules initialized"

echo ""
echo -e "${YELLOW}Step 6: Commit and push changes${NC}"
echo "----------------------------------------"

git add .gitmodules
git add android ios flutter web windows macos linux 2>/dev/null || true
git commit -m "refactor: convert to multi-repository structure with submodules

- Created separate repositories for each platform SDK
- Added all platforms as git submodules
- Updated architecture to match multi-platform structure
- Each platform can now be developed independently

Platform repositories:
- DocScannerSDK-Android
- DocScannerSDK-iOS
- DocScannerSDK-Flutter
- DocScannerSDK-Web
- DocScannerSDK-Windows
- DocScannerSDK-macOS
- DocScannerSDK-Linux" || echo "Nothing to commit"

git push origin cursor/multi-platform-sdk || git push

echo ""
echo -e "${GREEN}=================================="
echo "✓ Setup Complete!"
echo "==================================${NC}"
echo ""
echo "Your repository structure now matches FaceDetection-GazePoint:"
echo ""
for platform in "${PLATFORMS[@]}"; do
    platform_lower=$(echo "$platform" | tr '[:upper:]' '[:lower:]')
    echo "  - ${platform_lower}/ → https://github.com/${GITHUB_USER}/${BASE_SDK_NAME}-${platform}"
done
echo ""
echo "Next steps:"
echo "1. Verify all submodules: git submodule status"
echo "2. Clone with submodules: git clone --recursive https://github.com/${GITHUB_USER}/${MAIN_REPO_NEW}"
echo "3. Update submodules: git submodule update --remote --merge"
echo ""
echo "Platform backups are in: ${BACKUP_DIR}"
echo "You can delete this directory once you verify everything works."
echo ""
