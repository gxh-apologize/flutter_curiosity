
import Foundation
class PicturePickerUtils {
    
    
    
    /// 处理原图数据
    class func resultOriginalPhotoData(_ data: Data, _ asset: PHAsset,_ isGIF: Bool, _ quality: CGFloat) -> [AnyHashable : Any]? {
        if createCache(){}
        var photo: [AnyHashable : Any] = [:]
        var filename: String? = nil
        if let value = asset.value(forKey: "filename") {
            filename = "\(UUID().uuidString)\(value)"
        }
        let fileExtension = URL(fileURLWithPath: filename ?? "").pathExtension
        var image: UIImage? = nil
        var writeData: Data? = nil
        var filePath = ""
        
        let isPNG = fileExtension.hasSuffix("PNG") || fileExtension.hasSuffix("png")
        if isGIF {
            image = UIImage.sd_tz_animatedGIF(with: data)
            writeData = data
        } else {
            image = UIImage(data: data)
            //writeData = isPNG ?? image.jpegData(compressionQuality: quality / 100)
            writeData = image!.jpegData(compressionQuality: quality / 100)
        }
        
        if isPNG || isGIF {
            filePath += "\(NSTemporaryDirectory())PicturePickerCaches/\(filename ?? "")"
        } else {
            filePath += "\(NSTemporaryDirectory())PicturePickerCaches/\(URL(fileURLWithPath: filename ?? "").deletingPathExtension().absoluteString).jpg"
        }
        do{  try writeData?.write(to: URL.init(fileURLWithPath : filePath))
        }catch{}
        photo["path"] = filePath
        photo["width"] = NSNumber(value: Float((image!.size.width)))
        photo["height"] = NSNumber(value: Float(image!.size.height))
        var size: Int? = nil
        do {
            size = Int(try FileManager.default.attributesOfItem(atPath: filePath)[FileAttributeKey.size] as? UInt64 ?? 0)
        } catch {
        }
        photo["size"] = NSNumber(value: size ?? 0)
        photo["mediaType"] = NSNumber(value: asset.mediaType.rawValue)
        
        return photo
        
    }
    
    class func resultImage(_ image: UIImage, _ asset: PHAsset, _ quality: CGFloat) -> [AnyHashable : Any]? {
        if  createCache(){ }
        var photo: [AnyHashable : Any] = [:]
        var filename: String? = nil
        if let value = asset.value(forKey: "filename") {
            filename = "\(UUID().uuidString)\(value)"
        }
        let fileExtension = URL(fileURLWithPath: filename ?? "").pathExtension
        var filePath = ""
        let isPNG = fileExtension.hasSuffix("PNG") || fileExtension.hasSuffix("png")
        
        if isPNG {
            filePath += "\(NSTemporaryDirectory())PicturePickerCaches/\(filename ?? "")"
        } else {
            filePath += "\(NSTemporaryDirectory())PicturePickerCaches/\(URL(fileURLWithPath: filename ?? "").deletingPathExtension().absoluteString).jpg"
        }
        let writeData = image.jpegData(compressionQuality: quality / 100)
        do{  try writeData?.write(to: URL.init(fileURLWithPath : filePath))
        }catch{}
        photo["path"] = filePath
        photo["width"] = NSNumber(value: Float(image.size.width))
        photo["height"] = NSNumber(value: Float(image.size.height))
        var size: Int? = nil
        do {
            size = Int(try FileManager.default.attributesOfItem(atPath: filePath)[FileAttributeKey.size] as? UInt64 ?? 0)
        } catch {
        }
        photo["size"] = NSNumber(value: size ?? 0)
        photo["mediaType"] = NSNumber(value: asset.mediaType.rawValue)
        return photo
        
    }
    
    /// 视频数据
    class func resultVideo(_ outputPath:String, _ asset:PHAsset, _ quality: CGFloat) -> [AnyHashable : Any]? {
        var video: [AnyHashable : Any] = [:]
        video["path"] = outputPath
        var size: Int? = nil
        do {
            size = Int(try FileManager.default.attributesOfItem(atPath: outputPath )[FileAttributeKey.size] as? UInt64 ?? 0)
        } catch {
        }
        video["size"] = NSNumber(value: size!)
        video["width"] = NSNumber(value: asset.pixelWidth )
        video["height"] = NSNumber(value: asset.pixelHeight )
        video["favorite"] = NSNumber(value: asset.isFavorite)
        video["duration"] = NSNumber(value: asset.duration)
        video["mediaType"] = NSNumber(value: asset.mediaType.rawValue)
        //           video["coverUri"] = resultImage(coverImage, asset, quality)!["uri"]
        
        return video
    }
    
    /// 创建缓存目录
    class func createCache() -> Bool {
        let path = "\(NSTemporaryDirectory())PicturePickerCaches"
        let fileManager = FileManager.default
        if FileUtils.isDirectory(path) {
            //先判断目录是否存在，不存在才创建
            var res = false
            do {
                try fileManager.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
                res = true
            } catch {
            }
            return res
        } else {
            return false
        }
    }
}
