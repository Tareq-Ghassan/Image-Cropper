import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import '../models/scan_result.dart';
import '../models/scan_options.dart';
import 'doc_scanner_sdk_method_channel.dart';

/// Platform interface for DocScanner SDK
abstract class DocScannerSdkPlatform extends PlatformInterface {
  DocScannerSdkPlatform() : super(token: _token);

  static final Object _token = Object();
  static DocScannerSdkPlatform _instance = MethodChannelDocScannerSdk();

  /// The default instance of [DocScannerSdkPlatform] to use
  static DocScannerSdkPlatform get instance => _instance;

  /// Platform-specific plugins should set this with their own platform-specific
  /// class that extends [DocScannerSdkPlatform] when they register themselves.
  static set instance(DocScannerSdkPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// Request camera permission
  Future<bool> requestCameraPermission() {
    throw UnimplementedError('requestCameraPermission() has not been implemented.');
  }

  /// Check if camera permission is granted
  Future<bool> hasCameraPermission() {
    throw UnimplementedError('hasCameraPermission() has not been implemented.');
  }

  /// Scan a single document
  Future<ScanResult> scanDocument(ScanOptions options) {
    throw UnimplementedError('scanDocument() has not been implemented.');
  }

  /// Scan both front and back of a document
  Future<ScanResult> scanBothSides(ScanOptions options) {
    throw UnimplementedError('scanBothSides() has not been implemented.');
  }

  /// Get SDK version
  Future<String> getVersion() {
    throw UnimplementedError('getVersion() has not been implemented.');
  }
}
