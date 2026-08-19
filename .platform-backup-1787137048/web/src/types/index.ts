export interface ScanOptions {
  borderColor?: string;
  borderWidth?: number;
  borderRadius?: number;
  overlayMargin?: number;
  overlayHeight?: number;
  enableFlash?: boolean;
  enableAutoFocus?: boolean;
  imageQuality?: number;
}

export interface ScanResult {
  frontImagePath?: string;
  backImagePath?: string;
  frontImageBlob?: Blob;
  backImageBlob?: Blob;
  timestamp: number;
  isSuccess: boolean;
  errorMessage?: string;
}

export interface CameraConstraints {
  video: MediaTrackConstraints;
}
