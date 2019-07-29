import Flutter
import UIKit
import Photos

public class SwiftCameraContentSaverPlugin: NSObject, FlutterPlugin {
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "camera_content_saver", binaryMessenger: registrar.messenger())
        let instance = SwiftCameraContentSaverPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if call.method == "saveImage" {
            self.saveImage(result: result, call: call)
        } else if call.method == "saveVideo" {
            self.saveVideo(result: result, call: call)
        } else {
            result(FlutterMethodNotImplemented)
        }
    }
    
    func saveImage(result: @escaping FlutterResult, call: FlutterMethodCall) {
        let args = call.arguments as? Dictionary<String, Any>
        let path = args!["path"] as! String
        
        let status = PHPhotoLibrary.authorizationStatus()
        if status == .notDetermined {
            PHPhotoLibrary.requestAuthorization({status in
                if status == .authorized{
                    self.performSavingImage(path: path, flutterResult: result)
                } else {
                    result("permission denied");
                }
            })
            
        } else if status == .authorized {
            self.performSavingImage(path: path, flutterResult: result)
        } else {
            result("please grant photos access");
        }
    }
    
    func performSavingImage(path: String, flutterResult: @escaping FlutterResult){
        
        let url = URL(fileURLWithPath: path)
        
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAssetFromImage(atFileURL: url)
        }) { (success, error) in
            if success {
                flutterResult("image saved")
            } else {
                flutterResult("failed to save image")
            }
        }
    }
    
    func saveVideo(result: @escaping FlutterResult, call: FlutterMethodCall) {
        let args = call.arguments as? Dictionary<String, Any>
        let path = args!["path"] as! String
        
        let status = PHPhotoLibrary.authorizationStatus()
        if status == .notDetermined {
            PHPhotoLibrary.requestAuthorization({status in
                if status == .authorized{
                    self.performSavingVideo( flutterResult: result, path: path)
                } else {
                    result("permission denied");
                }
            })
        } else if status == .authorized {
            self.performSavingVideo( flutterResult: result, path: path)
        } else {
            result("please grant photos access");
        }
    }
    
    func performSavingVideo(flutterResult: @escaping FlutterResult, path: String){
        
        let url = URL(fileURLWithPath: path)
        
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: url)
        }) { (success, error) in
            if success {
                flutterResult("video saved")
            } else {
                flutterResult("failed to save video")
            }
        }
    }
}
