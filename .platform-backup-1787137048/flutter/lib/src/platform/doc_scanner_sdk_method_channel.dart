import 'package:flutter/services.dart';
import '../models/scan_result.dart';
import '../models/scan_options.dart';
import 'doc_scanner_sdk_platform.dart';

/// Method channel implementation of [DocScannerSdkPlatform]
class MethodChannelDocScannerSdk extends DocScannerSdkPlatform {
  static const MethodChannel _channel = MethodChannel('doc_scanner_sdk');

  @override
  Future<bool> requestCameraPermission() async {
    try {
      final result = await _channel.invokeMethod<bool>('requestCameraPermission');
      return result ?? false;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> hasCameraPermission() async {
    try {
      final result = await _channel.invokeMethod<bool>('hasCameraPermission');
      return result ?? false;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<ScanResult> scanDocument(ScanOptions options) async {
    try {
      final result = await _channel.invokeMethod<Map<Object?, Object?>>(
        'scanDocument',
        options.toMap(),
      );
      
      if (result == null) {
        return ScanResult.failure(errorMessage: 'Failed to scan document');
      }
      
      return ScanResult.fromMap(Map<String, dynamic>.from(result));
    } catch (e) {
      return ScanResult.failure(errorMessage: e.toString());
    }
  }

  @override
  Future<ScanResult> scanBothSides(ScanOptions options) async {
    try {
      final result = await _channel.invokeMethod<Map<Object?, Object?>>(
        'scanBothSides',
        options.toMap(),
      );
      
      if (result == null) {
        return ScanResult.failure(errorMessage: 'Failed to scan document');
      }
      
      return ScanResult.fromMap(Map<String, dynamic>.from(result));
    } catch (e) {
      return ScanResult.failure(errorMessage: e.toString());
    }
  }

  @override
  Future<String> getVersion() async {
    try {
      final version = await _channel.invokeMethod<String>('getVersion');
      return version ?? '1.0.0';
    } catch (e) {
      return '1.0.0';
    }
  }
}
