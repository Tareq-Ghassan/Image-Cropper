import Flutter
import UIKit
import AVFoundation

public class DocScannerSdkPlugin: NSObject, FlutterPlugin {
    private var viewController: UIViewController?
    private var pendingResult: FlutterResult?
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "doc_scanner_sdk", binaryMessenger: registrar.messenger())
        let instance = DocScannerSdkPlugin()
        
        if let app = UIApplication.shared.delegate, let window = app.window {
            instance.viewController = window?.rootViewController
        }
        
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "requestCameraPermission":
            requestCameraPermission(result: result)
            
        case "hasCameraPermission":
            result(hasCameraPermission())
            
        case "scanDocument":
            scanDocument(arguments: call.arguments, bothSides: false, result: result)
            
        case "scanBothSides":
            scanDocument(arguments: call.arguments, bothSides: true, result: result)
            
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
    
    private func scanDocument(arguments: Any?, bothSides: Bool, result: @escaping FlutterResult) {
        guard let viewController = viewController else {
            result(FlutterError(code: "NO_VIEW_CONTROLLER",
                              message: "View controller not available",
                              details: nil))
            return
        }
        
        pendingResult = result
        
        // TODO: Present scanner view controller
        // For now, return mock data
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.pendingResult?([
                "frontImagePath": "/path/to/front.jpg",
                "backImagePath": bothSides ? "/path/to/back.jpg" : nil,
                "timestamp": Int64(Date().timeIntervalSince1970 * 1000),
                "isSuccess": true
            ] as [String: Any])
            self?.pendingResult = nil
        }
    }
}
