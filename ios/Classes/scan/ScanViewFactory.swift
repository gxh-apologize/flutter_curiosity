import AVFoundation
import Flutter

class ScanViewFactory: NSObject, FlutterPlatformViewFactory {
    private var scanView = "scanView"
    
    private weak var messenger: (NSObjectProtocol & FlutterBinaryMessenger)?
    
    
    init(messenger: (NSObjectProtocol & FlutterBinaryMessenger)?) {
        super.init()
        self.messenger = messenger
    }
    
    
    func createArgsCodec() -> (NSObjectProtocol & FlutterMessageCodec) {
        return FlutterStandardMessageCodec.sharedInstance()
    }
    
    func create(withFrame frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?) -> (NSObjectProtocol & FlutterPlatformView) {
        let scanView = ScanPlatformView(frame: frame, viewindentifier: viewId, arguments: args, binaryMessenger: messenger!)
        return scanView
        
    }
}
class ScanPlatformView : NSObject, FlutterPlatformView{
    private var scanView: ScanView
    
    init(frame: CGRect, viewindentifier viewId: Int64, arguments args: Any?, binaryMessenger messenger: (NSObjectProtocol & FlutterBinaryMessenger)) {
        scanView = ScanView(frame: frame, viewIdentifier: viewId, arguments: args, binaryMessenger: messenger)
        scanView.backgroundColor = UIColor.clear
        scanView.frame = frame
    }
    
    func view() -> UIView {
        return scanView
    }
}
