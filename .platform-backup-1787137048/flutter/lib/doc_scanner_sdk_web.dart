import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:doc_scanner_sdk/src/models/scan_result.dart';
import 'package:doc_scanner_sdk/src/models/scan_options.dart';
import 'package:doc_scanner_sdk/src/platform/doc_scanner_sdk_platform.dart';

/// Web implementation of [DocScannerSdkPlatform]
class DocScannerSdkWeb extends DocScannerSdkPlatform {
  /// Registers this class as the default instance of [DocScannerSdkPlatform]
  static void registerWith(Registrar registrar) {
    DocScannerSdkPlatform.instance = DocScannerSdkWeb();
  }

  @override
  Future<bool> requestCameraPermission() async {
    try {
      // Request camera permission using MediaDevices API
      final stream = await window.navigator.mediaDevices?.getUserMedia({
        'video': {'facingMode': 'environment'}
      });
      
      stream?.getTracks().forEach((track) => track.stop());
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> hasCameraPermission() async {
    try {
      final result = await window.navigator.permissions?.query({'name': 'camera'});
      return result?.state == 'granted';
    } catch (e) {
      return false;
    }
  }

  @override
  Future<ScanResult> scanDocument(ScanOptions options) async {
    // TODO: Implement web scanner UI
    return ScanResult.failure(errorMessage: 'Web scanner not implemented yet');
  }

  @override
  Future<ScanResult> scanBothSides(ScanOptions options) async {
    // TODO: Implement web scanner UI
    return ScanResult.failure(errorMessage: 'Web scanner not implemented yet');
  }

  @override
  Future<String> getVersion() async {
    return '1.0.0';
  }
}
