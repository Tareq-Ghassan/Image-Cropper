/// Configuration options for document scanning
class ScanOptions {
  /// Border color for the crop overlay (hex color string, e.g., "#FFFFFF")
  final String borderColor;

  /// Border width in dp/pixels
  final double borderWidth;

  /// Border corner radius in dp/pixels
  final double borderRadius;

  /// Overlay margin from screen edges (left and right) in dp/pixels
  final double overlayMargin;

  /// Overlay height in dp/pixels
  final double overlayHeight;

  /// Enable flash for camera
  final bool enableFlash;

  /// Enable auto-focus
  final bool enableAutoFocus;

  /// Image quality (0-100)
  final int imageQuality;

  const ScanOptions({
    this.borderColor = '#FFFFFF',
    this.borderWidth = 2.0,
    this.borderRadius = 10.0,
    this.overlayMargin = 50.0,
    this.overlayHeight = 210.0,
    this.enableFlash = false,
    this.enableAutoFocus = true,
    this.imageQuality = 100,
  });

  /// Create from platform map
  factory ScanOptions.fromMap(Map<String, dynamic> map) {
    return ScanOptions(
      borderColor: map['borderColor'] as String? ?? '#FFFFFF',
      borderWidth: (map['borderWidth'] as num?)?.toDouble() ?? 2.0,
      borderRadius: (map['borderRadius'] as num?)?.toDouble() ?? 10.0,
      overlayMargin: (map['overlayMargin'] as num?)?.toDouble() ?? 50.0,
      overlayHeight: (map['overlayHeight'] as num?)?.toDouble() ?? 210.0,
      enableFlash: map['enableFlash'] as bool? ?? false,
      enableAutoFocus: map['enableAutoFocus'] as bool? ?? true,
      imageQuality: map['imageQuality'] as int? ?? 100,
    );
  }

  /// Convert to platform map
  Map<String, dynamic> toMap() {
    return {
      'borderColor': borderColor,
      'borderWidth': borderWidth,
      'borderRadius': borderRadius,
      'overlayMargin': overlayMargin,
      'overlayHeight': overlayHeight,
      'enableFlash': enableFlash,
      'enableAutoFocus': enableAutoFocus,
      'imageQuality': imageQuality,
    };
  }

  @override
  String toString() {
    return 'ScanOptions(borderColor: $borderColor, borderWidth: $borderWidth, '
        'borderRadius: $borderRadius, overlayMargin: $overlayMargin, '
        'overlayHeight: $overlayHeight, enableFlash: $enableFlash, '
        'enableAutoFocus: $enableAutoFocus, imageQuality: $imageQuality)';
  }
}
