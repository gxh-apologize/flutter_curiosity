import Flutter
import UIKit

public class SwiftCuriosityPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "Curiosity", binaryMessenger: (registrar.messenger()))
        
        let viewController = UIApplication.shared.delegate?.window?!.rootViewController
        let instance = SwiftCuriosityPlugin(_viewController:viewController!)
        registrar.addMethodCallDelegate(instance, channel: channel)
        registrar.register(ScanViewFactory(messenger: registrar.messenger()), withId: "scanView")
        
    }
    
    private var viewController: UIViewController
    private var call: FlutterMethodCall
    
    public func handle(_call: FlutterMethodCall, result: @escaping FlutterResult) {
        let arguments=call.arguments as! [AnyHashable : Any]
        call = _call
        gallery(arguments:arguments,result: result)
        scan(arguments:arguments,result: result)
        utils(arguments:arguments,result: result)
    }
    
    
    public  init(_viewController: UIViewController) {
        super.init()
        viewController = _viewController
    }
    
    func gallery(arguments: [AnyHashable : Any], result: FlutterResult) {
        if ("openPicker" == call.method) {
            PicturePicker.openPicker(arguments: arguments, viewController: viewController, result: result)
        } else if ("openCamera" == call.method) {
            PicturePicker.openCamera(arguments: arguments, viewController: viewController, result: result)
        } else if ("deleteCacheDirFile" == call.method) {
            PicturePicker.deleteCacheDirFile()
        }
    }
    func scan(arguments: [AnyHashable : Any],result: FlutterResult) {
        
        if ("scanImagePath" == call.method) {
            ScanUtils.scanImagePath(path: arguments["path"] as! String, result: result)
        } else if ("scanImageUrl" == call.method) {
            ScanUtils.scanImageUrl(url: arguments["url"] as! String, result: result)
        }else if ("scanImageMemory" == call.method) {
            ScanUtils.scanImageMemory(uint8list:arguments["uint8list"] as! FlutterStandardTypedData, result: result)
        }
    }
    func utils(arguments: [AnyHashable : Any],result: FlutterResult) {
        if ("clearAllCookie" == call.method) {
            NativeUtils.clearAllCookie()
            result("success")
        } else if ("getAllCookie" == call.method) {
            result(NativeUtils.getAllCookie())
        } else if ("getFilePathSize" == call.method) {
            
            result(FileUtils.getFilePathSize(path: arguments["filePath"] as! String))
        } else if ("deleteDirectory" == call.method) {
            FileUtils.deleteDirectory(path: arguments["directoryPath"] as! String)
            result("success")
        } else if ("deleteFile" == call.method) {
            FileUtils.deleteFile(path: arguments["filePath"]as! String)
            result("success")
        } else if ("unZipFile" == call.method) {
            FileUtils.unZipFile(filePath: (arguments["filePath"]as? String)!)
            result("success")
        } else if ("goToMarket" == call.method) {
            NativeUtils.goToMarket(id: arguments["packageName"] as! String )
            result("success")
        }  else if ("getAppInfo" == call.method) {
            result(NativeUtils.getAppInfo())
        } else if ("getDirectoryAllName" == call.method) {
            result(FileUtils.getDirectoryAllName(path : arguments["path"] as! String))
        } else if ("exitApp" == call.method) {
            exit(0)
        }
        
    }
    
    
}
