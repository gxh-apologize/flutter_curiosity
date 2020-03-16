import Foundation


let fileManager = FileManager.default
let cachePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).last

class FileUtils {
    // 删除沙盒指定文件或文件夹
    class func deleteFile(_ path: String) {
        if isDirectoryExist(path) {
            //移除文件
            try! fileManager.removeItem(atPath: path)
        }
    }
    // 删除沙盒指定文件夹内容
    class func deleteDirectory(_ path: String) {
        if isDirectoryExist(path) {
            // 获取该路径下面的文件名
            let childrenFiles = fileManager.subpaths(atPath: path )
            for fileName in childrenFiles ?? [] {
                deleteFile(URL(fileURLWithPath: path ).appendingPathComponent(fileName).absoluteString)
            }
        }
    }
    
    // 沙盒是否有指定路径文件夹或文件
    class func isDirectoryExist(_ path: String?) -> Bool {
        return fileManager.fileExists(atPath: path ?? "")
    }
    
    // 是否是文件夹
    class func isDirectory(_ path: String) -> Bool {
        
        var isDir: ObjCBool = ObjCBool(false)
        fileManager.fileExists(atPath: path , isDirectory: &isDir)
        return isDir.boolValue
    }
    
    /** 计算文件夹或者文件的大小 */
    class func getFilePathSize(_ path: String)-> String
    {
        if path.count == 0 {
            return "0MB" as String
        }
        if !fileManager.fileExists(atPath: path){
            return "0MB" as String
        }
        var fileSize:Float = 0.0
        do {
            let files = try fileManager.contentsOfDirectory(atPath: path)
            for file in files {
                fileSize = fileSize + fileSizeAtPath(path + "/\(file)")
            }
        }catch{
            fileSize = fileSize + fileSizeAtPath(path)
        }
        var resultSize = ""
        if fileSize >= 1024.0*1024.0{
            resultSize = NSString(format: "%.2fMB", fileSize/(1024.0 * 1024.0)) as String
        }else if fileSize >= 1024.0{
            resultSize = NSString(format: "%.fkb", fileSize/(1024.0 )) as String
        }else{
            resultSize = NSString(format: "%llub", fileSize) as String
        }
        return resultSize
    }
    
    /**  计算单个文件或文件夹的大小 */
    class func fileSizeAtPath(_ filePath:String) -> Float {
        var fileSize:Float = 0.0
        if fileManager.fileExists(atPath: filePath) {
            do {
                let attributes = try fileManager.attributesOfItem(atPath: filePath)
                
                if attributes.count != 0 {
                    
                    fileSize = attributes[FileAttributeKey.size]! as! Float
                }
            }catch{
                
            }
        }
        return fileSize;
    }
    
    //获取目录下所有文件和文件夹名字
    class func getDirectoryAllName(_ path: String) -> [AnyHashable] {
        var nameList: [String] = []
        if !isDirectoryExist(path) {
            nameList.append("path not exist")
            return nameList
        }
        if !isDirectory(path) {
            nameList.append("path not exist")
            return nameList
        }
        do {
            nameList = try fileManager.contentsOfDirectory(atPath:path)
        } catch{
            nameList.append("error")
        }
        return nameList
    }
    
    //解压文件
    class func unZipFile(_ filePath: String) -> String {
        if self.isDirectoryExist(filePath) {
            SSZipArchive.unzipFile(atPath: filePath, toDestination: (filePath as NSString).substring(to: (filePath.count ) - ((filePath.components(separatedBy: "/").last)?.count ?? 0)))
            return "Success"
        } else {
            return "NotFile"
        }
    }
    class func createFolder(_ folderName: NSString,folderPath: NSString) -> NSString {
        let path = "\(folderPath)/\(folderName)"
        // 不存在的路径才会创建
        if (!isDirectoryExist(path)) {
            //withIntermediateDirectories为ture表示路径中间如果有不存在的文件夹都会创建
            try! fileManager.createDirectory(atPath: path,withIntermediateDirectories: true, attributes: nil)
        }
        return path as NSString
    }
}
