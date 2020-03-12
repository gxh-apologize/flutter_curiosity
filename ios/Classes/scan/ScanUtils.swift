import Foundation
import AVFoundation
import Flutter
class ScanUtils {
    //本地图片识别
    class func scanImagePath(path: String, result: FlutterResult) {
        //加载文件
        let fh = FileHandle(forReadingAtPath: path )
        let data = fh?.readDataToEndOfFile()
        result(getCode(data: data!))
    }
    //图片urls识别
    class func scanImageUrl(url: String, result: FlutterResult) {
        let nsUrl = URL(string: url )
        var data: Data? = nil
        do {
            if let nsUrl = nsUrl {
                data = try NSURLConnection.sendSynchronousRequest(URLRequest(url: nsUrl), returning: nil)
            }
        } catch {
        }
        result(getCode(data: data!))
    }
    //内存图片识别
    class func scanImageMemory(uint8list: FlutterStandardTypedData, result: FlutterResult) {
//       let uint8list = call.arguments.value(forKey: "") as? FlutterStandardTypedData
        result(getCode(data: uint8list.data))
    }
    //获取二维码数据
    class func getCode(data: Data) -> [AnyHashable : Any] {
       
        let detectImage = CIImage(data: data)
            let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: [
                CIDetectorAccuracy: CIDetectorAccuracyHigh
            ])
            var feature: [CIFeature]? = nil
            if let detectImage = detectImage {
                feature = detector?.features(in: detectImage, options: nil)
            }
            if feature?.count != 0 {
                for index in 0..<(feature?.count ?? 0) {
                    let qrCode = feature?[index] as? CIQRCodeFeature
                    let resultStr = qrCode?.messageString
                    if resultStr != nil {
                        var dict: [AnyHashable : Any] = [:]
                        dict["code"] = resultStr
                        dict["type"] = AVMetadataObject.ObjectType.qr
                        return dict
                    }
                }
            }
         return [:]
    }
    
    //二维码数据转换
    class func scanDataToMap(data: AVMetadataMachineReadableCodeObject) -> [AnyHashable : Any] {
        var result: [AnyHashable : Any] = [:]
        result["code"] = data.stringValue
        result["type"] = data.type
        return result
    }
    
}
