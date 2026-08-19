/// Result of a document scan operation
class ScanResult {
  /// Path to the front image file
  final String? frontImagePath;

  /// Path to the back image file (null if only front was scanned)
  final String? backImagePath;

  /// Timestamp of the scan
  final DateTime timestamp;

  /// Whether the scan was successful
  final bool isSuccess;

  /// Error message if scan failed
  final String? errorMessage;

  const ScanResult({
    this.frontImagePath,
    this.backImagePath,
    required this.timestamp,
    required this.isSuccess,
    this.errorMessage,
  });

  /// Create a successful scan result with front image only
  factory ScanResult.success({
    required String frontImagePath,
    String? backImagePath,
  }) {
    return ScanResult(
      frontImagePath: frontImagePath,
      backImagePath: backImagePath,
      timestamp: DateTime.now(),
      isSuccess: true,
    );
  }

  /// Create a failed scan result
  factory ScanResult.failure({required String errorMessage}) {
    return ScanResult(
      timestamp: DateTime.now(),
      isSuccess: false,
      errorMessage: errorMessage,
    );
  }

  /// Create from platform map
  factory ScanResult.fromMap(Map<String, dynamic> map) {
    return ScanResult(
      frontImagePath: map['frontImagePath'] as String?,
      backImagePath: map['backImagePath'] as String?,
      timestamp: DateTime.fromMillisecondsSinceEpoch(
        map['timestamp'] as int? ?? DateTime.now().millisecondsSinceEpoch,
      ),
      isSuccess: map['isSuccess'] as bool? ?? false,
      errorMessage: map['errorMessage'] as String?,
    );
  }

  /// Convert to platform map
  Map<String, dynamic> toMap() {
    return {
      'frontImagePath': frontImagePath,
      'backImagePath': backImagePath,
      'timestamp': timestamp.millisecondsSinceEpoch,
      'isSuccess': isSuccess,
      'errorMessage': errorMessage,
    };
  }

  @override
  String toString() {
    return 'ScanResult(frontImagePath: $frontImagePath, backImagePath: $backImagePath, '
        'isSuccess: $isSuccess, errorMessage: $errorMessage)';
  }
}
