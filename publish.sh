#!/bin/bash

# Publish all SDKs to their respective package managers
# This script should be run from the root of each platform repository

set -e

PLATFORM=$1
VERSION=$2

if [ -z "$PLATFORM" ] || [ -z "$VERSION" ]; then
    echo "Usage: ./publish.sh <platform> <version>"
    echo "Platforms: android, ios, web, flutter, macos, windows"
    exit 1
fi

echo "📦 Publishing $PLATFORM SDK version $VERSION..."

case $PLATFORM in
    android)
        echo "✅ Android: Publishing to JitPack via GitHub Release"
        git tag -a "v$VERSION" -m "Release v$VERSION"
        git push origin "v$VERSION"
        gh release create "v$VERSION" --title "v$VERSION" --generate-notes
        echo "✅ Published! Users can use: implementation 'com.github.Tareq-Ghassan:DocScannerSDK-Android:$VERSION'"
        ;;
    
    ios)
        echo "🍎 iOS: Publishing to CocoaPods and SPM..."
        pod spec lint DocScannerSDK.podspec --allow-warnings
        pod trunk push DocScannerSDK.podspec --allow-warnings
        git tag -a "v$VERSION" -m "Release v$VERSION"
        git push origin "v$VERSION"
        gh release create "v$VERSION" --title "v$VERSION" --generate-notes
        echo "✅ Published! Users can use: pod 'DocScannerSDK', '~> $VERSION'"
        ;;
    
    web)
        echo "🌐 Web: Publishing to NPM..."
        npm run build
        npm test
        npm publish --access public
        git tag -a "v$VERSION" -m "Release v$VERSION"
        git push origin "v$VERSION"
        echo "✅ Published! Users can use: npm install @docscanner/sdk-web@$VERSION"
        ;;
    
    flutter)
        echo "🎯 Flutter: Publishing to pub.dev..."
        flutter pub publish --force
        git tag -a "v$VERSION" -m "Release v$VERSION"
        git push origin "v$VERSION"
        echo "✅ Published! Users can use: doc_scanner_sdk: ^$VERSION"
        ;;
    
    macos)
        echo "🖥️ macOS: Publishing to CocoaPods and SPM..."
        pod spec lint DocScannerSDK.podspec --allow-warnings
        pod trunk push DocScannerSDK.podspec --allow-warnings
        git tag -a "v$VERSION" -m "Release v$VERSION"
        git push origin "v$VERSION"
        gh release create "v$VERSION" --title "v$VERSION" --generate-notes
        echo "✅ Published! Users can use: pod 'DocScannerSDK-macOS', '~> $VERSION'"
        ;;
    
    windows)
        echo "🪟 Windows: Publishing to NuGet..."
        dotnet build -c Release
        dotnet pack -c Release
        dotnet nuget push "bin/Release/DocScanner.SDK.Windows.$VERSION.nupkg" --source https://api.nuget.org/v3/index.json
        git tag -a "v$VERSION" -m "Release v$VERSION"
        git push origin "v$VERSION"
        echo "✅ Published! Users can use: dotnet add package DocScanner.SDK.Windows --version $VERSION"
        ;;
    
    *)
        echo "❌ Unknown platform: $PLATFORM"
        echo "Available platforms: android, ios, web, flutter, macos, windows"
        exit 1
        ;;
esac

echo "🎉 Successfully published $PLATFORM SDK version $VERSION!"
