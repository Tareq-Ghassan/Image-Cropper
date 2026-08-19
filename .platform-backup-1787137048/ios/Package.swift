// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "DocScannerSDK",
    platforms: [
        .iOS(.v16),
        .macOS(.v13)
    ],
    products: [
        .library(
            name: "DocScannerSDK",
            targets: ["DocScannerSDK"]),
    ],
    targets: [
        .target(
            name: "DocScannerSDK",
            dependencies: [],
            path: "Sources/DocScannerSDK"
        ),
        .testTarget(
            name: "DocScannerSDKTests",
            dependencies: ["DocScannerSDK"],
            path: "Tests/DocScannerSDKTests"
        ),
    ]
)
