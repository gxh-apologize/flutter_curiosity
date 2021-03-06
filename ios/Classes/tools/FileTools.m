
#import "FileTools.h"
#import "SSZipArchive.h"
#define fileManager [NSFileManager defaultManager]
#define cachePath [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]

@implementation FileTools

// 删除沙盒指定文件或文件夹
+ (void)deleteFile:(NSString *)path{
    if ([self isDirectoryExist:path]) {
        if(![fileManager removeItemAtPath:path error:nil]){
            [fileManager removeItemAtPath:path error:nil];
        }
    }
}
// 删除沙盒指定文件夹内容
+ (void)deleteDirectory:(NSString *)path{
    if ([self isDirectoryExist:path]) {
        if ([fileManager fileExistsAtPath:path]) {
            // 获取该路径下面的文件名
            NSArray *childrenFiles = [fileManager subpathsAtPath:path];
            for (NSString *fileName in childrenFiles) {
                // 拼接路径
                
                // 将文件删除
                [fileManager removeItemAtPath: [path stringByAppendingPathComponent:fileName] error:nil];
            }
        }
    }
}
// 沙盒是否有指定路径文件夹或文件
+(BOOL)isDirectoryExist:(NSString *)path {
    return [fileManager fileExistsAtPath:path];
}
// 是否是文件夹
+ (BOOL) isDirectory:(NSString *)path{
    BOOL isDir = NO;
    [fileManager fileExistsAtPath:path isDirectory:&isDir];
    return isDir;
}

//获取目录文件或文件夹大小
+ (NSString *)getFilePathSize:(NSString *)path{
    // 获取“path”文件夹下的所有文件
    NSArray *subPathArr = [[NSFileManager defaultManager] subpathsAtPath:path];
    NSString *filePath  = nil;
    NSInteger totalSize = 0;
    for (NSString *subPath in subPathArr){
        // 1. 拼接每一个文件的全路径
        filePath =[path stringByAppendingPathComponent:subPath];
        // 2. 是否是文件夹，默认不是
        BOOL isDirectory = [FileTools isDirectory:path];
        // 3. 判断文件是否存在
        BOOL isExist = [FileTools isDirectoryExist:path];
        // 4. 以上判断目的是忽略不需要计算的文件
        if (!isExist || isDirectory || [filePath containsString:@".DS"]){
            // 过滤: 1. 文件夹不存在  2. 过滤文件夹  3. 隐藏文件
            continue;
        }
        // 5. 指定路径，获取这个路径的属性
        NSDictionary *dict = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
        /**
         attributesOfItemAtPath: 文件夹路径
         该方法只能获取文件的属性, 无法获取文件夹属性, 所以也是需要遍历文件夹的每一个文件的原因
         */
        // 6. 获取每一个文件的大小
        NSInteger size = [dict[@"NSFileSize"] integerValue];
        // 7. 计算总大小
        totalSize += size;
    }
    //8. 将文件夹大小转换为 M/KB/B
    NSString *totalStr = nil;
    if (totalSize > 1000 * 1000){
        totalStr = [NSString stringWithFormat:@"%.2fMB",totalSize / 1000.00f /1000.00f];
        
    }else if (totalSize > 1000){
        totalStr = [NSString stringWithFormat:@"%.2fKB",totalSize / 1000.00f ];
        
    }else{
        totalStr = [NSString stringWithFormat:@"%.2fB",totalSize / 1.00f];
    }
    return totalStr;
}


//获取目录下所有文件和文件夹名字
+ (NSMutableArray *) getDirectoryAllName :(NSDictionary *)arguments{
    NSString *path = [arguments objectForKey:@"path"];
    NSMutableArray * nameList=[NSMutableArray array];
    if(![FileTools isDirectoryExist:path]){
        [nameList addObject:@"path not exist"];
        return nameList;
    }
    if(![FileTools isDirectory:path]){
        [nameList addObject:@"path not exist"];
        return nameList;
    }
    NSDirectoryEnumerator *dirEnum=[fileManager enumeratorAtPath:path];
    //列举目录内容，可以遍历子目录
    NSString *name;
    while((name=[dirEnum nextObject])!=nil)
    {
        if([self isDirectoryExist:name] == YES)  [dirEnum skipDescendants];
        [nameList addObject:name];
    }
    return nameList;
}

//解压文件
+ (NSString *)unZipFile:(NSString *)filePath {
    if ([self isDirectoryExist:filePath]) {
        [SSZipArchive unzipFileAtPath:filePath toDestination:[filePath substringToIndex:filePath.length-[[[filePath componentsSeparatedByString:@"/"] lastObject] length]]];
        return @"success";
    }else{
        return @"not file";
    }
}
@end
