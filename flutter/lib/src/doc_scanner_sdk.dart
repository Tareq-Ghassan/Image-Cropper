import 'dart:async';
import 'models/scan_result.dart';
import 'models/scan_options.dart';
import 'platform/doc_scanner_sdk_platform.dart';

/// Main class for DocScanner SDK
///
/// Provides methods to scan documents with a fixed crop area overlay.
/// The SDK automatically crops the captured image to the overlay bounds.
class DocScannerSdk {
  /// Returns the singleton instance of [DocScannerSdk]
  static DocScannerSdk get instance => DocScannerSdk._();

  DocScannerSdk._();

  /// Request camera permission
  ///
  /// Returns `true` if permission is granted, `false` otherwise.
  Future<bool> requestCameraPermission() async {
    return await DocScannerSdkPlatform.instance.requestCameraPermission();
  }

  /// Check if camera permission is granted
  ///
  /// Returns `true` if permission is granted, `false` otherwise.
  Future<bool> hasCameraPermission() async {
    return await DocScannerSdkPlatform.instance.hasCameraPermission();
  }

  /// Scan a single document
  ///
  /// Opens the camera with a fixed crop overlay and returns the cropped image path.
  ///
  /// [options] - Optional scan configuration
  ///
  /// Returns a [ScanResult] containing the scanned image path.
  /// Throws an exception if scanning fails or is cancelled.
  Future<ScanResult> scanDocument([ScanOptions? options]) async {
    options ??= ScanOptions();
    return await DocScannerSdkPlatform.instance.scanDocument(options);
  }

  /// Scan both front and back of a document
  ///
  /// Opens the camera twice to capture both sides of a document.
  /// Each side is cropped to the overlay bounds.
  ///
  /// [options] - Optional scan configuration
  ///
  /// Returns a [ScanResult] containing both front and back image paths.
  /// Throws an exception if scanning fails or is cancelled.
  Future<ScanResult> scanBothSides([ScanOptions? options]) async {
    options ??= ScanOptions();
    return await DocScannerSdkPlatform.instance.scanBothSides(options);
  }

  /// Get the SDK version
  Future<String> getVersion() async {
    return await DocScannerSdkPlatform.instance.getVersion();
  }
}
