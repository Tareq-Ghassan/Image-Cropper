import Foundation
import AVFoundation
import Vision
import UIKit

/// Main class for DocScanner SDK on iOS
@available(iOS 16.0, *)
public class DocScanner {
    
    /// Shared singleton instance
    public static let shared = DocScanner()
    
    private init() {}
    
    /// Request camera permission
    /// - Returns: True if permission granted, false otherwise
    public func requestCameraPermission() async -> Bool {
        await withCheckedContinuation { continuation in
            AVCaptureDevice.requestAccess(for: .video) { granted in
                continuation.resume(returning: granted)
            }
        }
    }
    
    /// Check if camera permission is granted
    /// - Returns: True if granted, false otherwise
    public func hasCameraPermission() -> Bool {
        AVCaptureDevice.authorizationStatus(for: .video) == .authorized
    }
    
    /// Scan a single document with camera overlay
    /// - Parameter options: Scan configuration options
    /// - Returns: ScanResult containing the cropped image path
    public func scanDocument(options: ScanOptions = ScanOptions()) async throws -> ScanResult {
        // TODO: Implement document scanning with camera
        throw NSError(domain: "DocScannerSDK", code: -1, 
                     userInfo: [NSLocalizedDescriptionKey: "Not implemented yet"])
    }
    
    /// Scan both sides of a document
    /// - Parameter options: Scan configuration options
    /// - Returns: ScanResult containing both front and back image paths
    public func scanBothSides(options: ScanOptions = ScanOptions()) async throws -> ScanResult {
        // TODO: Implement both sides scanning
        throw NSError(domain: "DocScannerSDK", code: -1,
                     userInfo: [NSLocalizedDescriptionKey: "Not implemented yet"])
    }
    
    /// Get SDK version
    /// - Returns: Version string
    public func getVersion() -> String {
        return "1.0.0"
    }
}

/// Configuration options for document scanning
public struct ScanOptions {
    public let borderColor: UIColor
    public let borderWidth: CGFloat
    public let borderRadius: CGFloat
    public let overlayMargin: CGFloat
    public let overlayHeight: CGFloat
    public let enableFlash: Bool
    public let enableAutoFocus: Bool
    public let imageQuality: CGFloat
    
    public init(
        borderColor: UIColor = .white,
        borderWidth: CGFloat = 2.0,
        borderRadius: CGFloat = 10.0,
        overlayMargin: CGFloat = 50.0,
        overlayHeight: CGFloat = 210.0,
        enableFlash: Bool = false,
        enableAutoFocus: Bool = true,
        imageQuality: CGFloat = 1.0
    ) {
        self.borderColor = borderColor
        self.borderWidth = borderWidth
        self.borderRadius = borderRadius
        self.overlayMargin = overlayMargin
        self.overlayHeight = overlayHeight
        self.enableFlash = enableFlash
        self.enableAutoFocus = enableAutoFocus
        self.imageQuality = imageQuality
    }
}

/// Result of a document scan operation
public struct ScanResult {
    public let frontImagePath: String?
    public let backImagePath: String?
    public let timestamp: Date
    public let isSuccess: Bool
    public let errorMessage: String?
    
    public init(
        frontImagePath: String? = nil,
        backImagePath: String? = nil,
        timestamp: Date = Date(),
        isSuccess: Bool = false,
        errorMessage: String? = nil
    ) {
        self.frontImagePath = frontImagePath
        self.backImagePath = backImagePath
        self.timestamp = timestamp
        self.isSuccess = isSuccess
        self.errorMessage = errorMessage
    }
    
    public static func success(frontPath: String, backPath: String? = nil) -> ScanResult {
        return ScanResult(
            frontImagePath: frontPath,
            backImagePath: backPath,
            timestamp: Date(),
            isSuccess: true
        )
    }
    
    public static func failure(error: String) -> ScanResult {
        return ScanResult(
            timestamp: Date(),
            isSuccess: false,
            errorMessage: error
        )
    }
}
