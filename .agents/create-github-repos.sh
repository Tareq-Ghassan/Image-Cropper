#!/bin/bash

# Script to create all platform GitHub repositories
# Run this after merging the PR

set -e

GITHUB_USERNAME="Tareq-Ghassan"

echo "🚀 Creating GitHub repositories for DocumentScanner SDK..."

# Array of repositories to create
declare -a repos=(
    "DocScannerSDK-Android:Android SDK for document scanning"
    "DocScannerSDK-iOS:iOS SDK for document scanning"
    "DocScannerSDK-Web:Web SDK for document scanning"  
    "DocScannerSDK-Windows:Windows SDK for document scanning"
    "DocScannerSDK-macOS:macOS SDK for document scanning"
    "DocScannerSDK-Linux:Linux SDK for document scanning"
    "DocScannerSDK-Flutter:Flutter plugin for document scanning"
)

# Create each repository
for repo_info in "${repos[@]}"; do
    IFS=':' read -r repo_name repo_desc <<< "$repo_info"
    
    echo ""
    echo "📦 Creating repository: $repo_name"
    
    gh repo create "$GITHUB_USERNAME/$repo_name" \
        --public \
        --description "$repo_desc" \
        --add-readme \
        --license mit
    
    echo "✅ Created: https://github.com/$GITHUB_USERNAME/$repo_name"
done

echo ""
echo "🎉 All repositories created successfully!"
echo ""
echo "Next steps:"
echo "1. Push code to each repository (see .agents/CREATE_REPOS.md)"
echo "2. Convert to submodules"
echo "3. Create GitHub releases"
echo "4. Publish to package managers"
