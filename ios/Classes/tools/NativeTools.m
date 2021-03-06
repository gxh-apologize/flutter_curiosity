#import "NativeTools.h"

@implementation NativeTools

//Log
+ (void)log:(id)info{
    NSLog(@"Curiosity--- %@", info);
}

//跳转到AppStore
+ (void)goToMarket:(NSString *)props
{
    NSString* url=@"itms-apps://itunes.apple.com/us/app/id";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[url stringByAppendingString:props]]];
}

+ (void)callPhone:(NSString *)phoneNumber :(NSNumber*)directDial {
    
    if ([directDial intValue]==1) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"tel:://" stringByAppendingString:phoneNumber]]];
    }else{
        UIWebView * callWebview = [[UIWebView alloc] init];
        [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[@"tel:" stringByAppendingString:phoneNumber] ]]];
        [[UIApplication sharedApplication].keyWindow addSubview:callWebview];
    }
    
}
+ (NSMutableDictionary *)getAppInfo
{
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    NSDictionary *app = [[NSBundle mainBundle] infoDictionary];
    CGRect statusBar = [[UIApplication sharedApplication] statusBarFrame];
    [info setObject:@(statusBar.size.height) forKey:@"statusBarHeight"];
    [info setObject:@(statusBar.size.width) forKey:@"statusBarWidth"];
    
    [info setObject:NSHomeDirectory() forKey:@"homeDirectory"];
    [info setObject:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] forKey:@"documentDirectory"];
    [info setObject:[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject] forKey:@"libraryDirectory"];
    [info setObject:[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject] forKey:@"cachesDirectory"];
    [info setObject:NSTemporaryDirectory() forKey:@"temporaryDirectory"];
    
    [info setObject:[app objectForKey:@"CFBundleShortVersionString"] forKey:@"versionName"];
    [info setObject:@"Apple" forKey:@"phoneBrand"];
    [info setObject:[NSNumber numberWithInt:[[app objectForKey:@"CFBundleVersion"] intValue]] forKey:@"versionCode"];
    
    [info setObject:[app objectForKey:@"CFBundleIdentifier"] forKey:@"packageName"];
    [info setObject:[app objectForKey:@"CFBundleName"] forKey:@"appName"];
    [info setObject:[app objectForKey:@"DTSDKBuild"] forKey:@"sdkBuild"];
    [info setObject:[app objectForKey:@"DTPlatformName"] forKey:@"platformName"];
    [info setObject:[app objectForKey:@"MinimumOSVersion"] forKey:@"pinimumOSVersion"];
    [info setObject:[app objectForKey:@"DTPlatformVersion"] forKey:@"platformVersion"];
    UIDevice *device = [UIDevice currentDevice];
    [info setObject:device.systemName forKey:@"systemName"];
    [info setObject:device.systemVersion forKey:@"systemVersion"];
    
    return  info;
}

/**
 *  分享
 *  多图分享，items里面直接放图片
 *  分享链接
 *  NSString *text = @"mq分享";
 *  UIImage *image = [UIImage imageNamed:@"imageName"];
 *  NSURL *url = [NSURL URLWithString:@"https:www.baidu.com"];
 *  NSArray *items = @[urlToShare,textToShare,imageToShare];
 */
+ (void)systemShare:(FlutterMethodCall*)call result:(FlutterResult)result{
    NSString * title=[call.arguments valueForKey:@"title"];
    NSString * content=[call.arguments valueForKey:@"content"];
    NSString * type=[call.arguments valueForKey:@"type"];
    NSArray * imagesPath=[call.arguments valueForKey:@"imagesPath"];
    NSMutableArray *items=[NSMutableArray array];
    if([type isEqual: @"images"]){
        if(imagesPath!=nil){
            for(NSString *value in imagesPath){
                UIImage *image = [UIImage imageNamed:value];
                [items addObject:image];
            }
        }else{
            result(@"imagesPath is null");
        }
    }else{
        if(content!=nil){
            if([type isEqual: @"text"])[items addObject:content];
            if([type isEqual: @"url"])[items addObject:[NSURL URLWithString:content]];
            if([type isEqual: @"image"])[items addObject:[UIImage imageNamed:content]];
        }else{
            result(@"content is null");
            return;
        }
    }
    
    if (0 == items.count) {
        result([@"not find " stringByAppendingString:type]);
        return;
    }
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:items applicationActivities:nil];
    if (@available(iOS 11.0, *)) {
        //UIActivityTypeMarkupAsPDF是在iOS 11.0 之后才有的
        activityVC.excludedActivityTypes = @[UIActivityTypeMessage, UIActivityTypeMail, UIActivityTypeOpenInIBooks, UIActivityTypeMarkupAsPDF];
    }else if (@available(iOS 9.0, *)){
        //UIActivityTypeOpenInIBooks是在iOS 9.0 之后才有的
        activityVC.excludedActivityTypes = @[UIActivityTypeMessage, UIActivityTypeMail, UIActivityTypeOpenInIBooks];
    }else{
        activityVC.excludedActivityTypes = @[UIActivityTypeMessage, UIActivityTypeMail];
    }
    activityVC.completionWithItemsHandler = ^(UIActivityType  _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {
        if (completed) {
            result(@"success");
        }else{
            result(@"cancel");
        }
    };
    //这儿一定要做iPhone与iPad的判断，因为这儿只有iPhone可以present，iPad需pop，所以这儿actVC.popoverPresentationController.sourceView = self.view;在iPad下必须有，不然iPad会crash，self.view你可以换成任何view，你可以理解为弹出的窗需要找个依托。
    UIViewController *vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        activityVC.popoverPresentationController.sourceView = vc.view;
        [vc presentViewController:activityVC animated:YES completion:nil];
    }else{
        [vc presentViewController:activityVC animated:YES completion:nil];
    }
}
@end
