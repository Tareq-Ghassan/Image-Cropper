import { ScanOptions, ScanResult } from '../types';

/**
 * Main class for DocScanner SDK on Web
 */
export class DocScanner {
  private static instance: DocScanner;
  private videoElement: HTMLVideoElement | null = null;
  private stream: MediaStream | null = null;
  private canvas: HTMLCanvasElement | null = null;

  private constructor() {}

  /**
   * Get singleton instance
   */
  public static getInstance(): DocScanner {
    if (!DocScanner.instance) {
      DocScanner.instance = new DocScanner();
    }
    return DocScanner.instance;
  }

  /**
   * Request camera permission
   */
  public async requestCameraPermission(): Promise<boolean> {
    try {
      const stream = await navigator.mediaDevices.getUserMedia({ 
        video: { facingMode: 'environment' } 
      });
      
      stream.getTracks().forEach(track => track.stop());
      return true;
    } catch (error) {
      console.error('Camera permission denied:', error);
      return false;
    }
  }

  /**
   * Check if camera permission is granted
   */
  public async hasCameraPermission(): Promise<boolean> {
    try {
      const result = await navigator.permissions.query({ name: 'camera' as PermissionName });
      return result.state === 'granted';
    } catch {
      return false;
    }
  }

  /**
   * Scan a single document
   */
  public async scanDocument(options: ScanOptions = {}): Promise<ScanResult> {
    try {
      // TODO: Implement camera UI and capture
      throw new Error('Not implemented yet');
    } catch (error) {
      return {
        timestamp: Date.now(),
        isSuccess: false,
        errorMessage: error instanceof Error ? error.message : 'Unknown error'
      };
    }
  }

  /**
   * Scan both sides of a document
   */
  public async scanBothSides(options: ScanOptions = {}): Promise<ScanResult> {
    try {
      // TODO: Implement both sides scanning
      throw new Error('Not implemented yet');
    } catch (error) {
      return {
        timestamp: Date.now(),
        isSuccess: false,
        errorMessage: error instanceof Error ? error.message : 'Unknown error'
      };
    }
  }

  /**
   * Get SDK version
   */
  public getVersion(): string {
    return '1.0.0';
  }

  /**
   * Start camera stream
   */
  private async startCamera(options: ScanOptions): Promise<void> {
    this.stream = await navigator.mediaDevices.getUserMedia({
      video: {
        facingMode: 'environment',
        width: { ideal: 1920 },
        height: { ideal: 1080 }
      }
    });

    if (this.videoElement) {
      this.videoElement.srcObject = this.stream;
      await this.videoElement.play();
    }
  }

  /**
   * Stop camera stream
   */
  private stopCamera(): void {
    if (this.stream) {
      this.stream.getTracks().forEach(track => track.stop());
      this.stream = null;
    }
  }

  /**
   * Crop image to overlay bounds
   */
  private cropImage(
    sourceCanvas: HTMLCanvasElement,
    options: ScanOptions
  ): Blob | null {
    // TODO: Implement cropping logic
    return null;
  }
}
