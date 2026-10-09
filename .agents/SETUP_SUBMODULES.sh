#!/bin/bash
# Script to convert platform directories to Git submodules
set -e

echo "🚀 Setting up DocScanner SDK platform submodules..."

# GitHub username
GITHUB_USER="Tareq-Ghassan"

# Check if repos exist first
echo ""
echo "⚠️  Create these 4 GitHub repositories first:"
echo "  - https://github.com/${GITHUB_USER}/DocScannerSDK-Web"
echo "  - https://github.com/${GITHUB_USER}/DocScannerSDK-Windows"
echo "  - https://github.com/${GITHUB_USER}/DocScannerSDK-macOS"
echo "  - https://github.com/${GITHUB_USER}/DocScannerSDK-Linux"
echo ""
read -p "Have you created all 4 repositories? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "❌ Please create the repositories first"
    exit 1
fi

# Process each platform
for platform in web windows macos linux; do
    case $platform in
        web) repo="DocScannerSDK-Web" ;;
        windows) repo="DocScannerSDK-Windows" ;;
        macos) repo="DocScannerSDK-macOS" ;;
        linux) repo="DocScannerSDK-Linux" ;;
    esac
    
    echo "Processing $platform..."
    cd "$platform"
    git init
    git add .
    git commit -m "feat: initial $platform SDK implementation"
    git remote add origin "https://github.com/${GITHUB_USER}/${repo}.git"
    git branch -M main
    git push -u origin main
    cd ..
    
    rm -rf "$platform"
    git submodule add "https://github.com/${GITHUB_USER}/${repo}.git" "$platform"
done

git add .gitmodules web windows macos linux
git commit -m "feat: convert platform SDKs to Git submodules"
git push

echo "✅ Done!"
