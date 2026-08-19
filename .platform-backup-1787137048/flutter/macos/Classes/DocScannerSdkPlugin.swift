import Cocoa
import FlutterMacOS
import AVFoundation

public class DocScannerSdkPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "doc_scanner_sdk", binaryMessenger: registrar.messenger)
    let instance = DocScannerSdkPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "requestCameraPermission":
      requestCameraPermission(result: result)
    case "hasCameraPermission":
      result(hasCameraPermission())
    case "scanDocument", "scanBothSides":
      result(FlutterError(code: "NOT_IMPLEMENTED",
                         message: "macOS scanner UI not implemented yet",
                         details: nil))
    case "getVersion":
      result("1.0.0")
    default:
      result(FlutterMethodNotImplemented)
    }
  }
  
  private func requestCameraPermission(result: @escaping FlutterResult) {
    AVCaptureDevice.requestAccess(for: .video) { granted in
      DispatchQueue.main.async {
        result(granted)
      }
    }
  }
  
  private func hasCameraPermission() -> Bool {
    return AVCaptureDevice.authorizationStatus(for: .video) == .authorized
  }
}
