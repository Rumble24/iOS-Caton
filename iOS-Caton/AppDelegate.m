//
//  AppDelegate.m
//  iOS-Caton
//
//  Created by 王景伟 on 2019/5/24.
//  Copyright © 2019 王景伟. All rights reserved.
//

#import "AppDelegate.h"
#import "sys/utsname.h"
#import "PerformanceMonitor.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSSetUncaughtExceptionHandler(&UncaughtExceptionHandler);
    [self updateAppErrorInfo];
    
    [[PerformanceMonitor sharedInstance] start];

    return YES;
}

#pragma mark  - 如果有异常崩溃信息,提交异常
- (void)updateAppErrorInfo
{
    NSString *path =[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSString *personsArrPath = [path stringByAppendingString:@"/personsArr.plist"];
    NSDictionary * dictionary = [NSDictionary dictionaryWithContentsOfFile:personsArrPath];
//    NSLog(@"dictionary==%@",dictionary);
    //如果有异常崩溃信息,提交异常
    ////> 上传到服务器 并且 删除问价n
}
#pragma mark    收集异常，存储到本地，下次用户打开程序时上传给我们
void UncaughtExceptionHandler(NSException *exception) {
    /**
     *  获取异常崩溃信息
     */
    NSArray *callStack = [exception callStackSymbols];
    NSString *reason = [exception reason];
    NSString *name = [exception name];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSString * dateStr = [formatter stringFromDate:[NSDate date]];
    
    NSString * userID   =   @"";
    NSString * userName =   @"";
    
    NSString * iOS_Version = [[UIDevice currentDevice] systemVersion];
    NSString * PhoneSize    =   NSStringFromCGSize([[UIScreen mainScreen] bounds].size);
    
    NSString * App_Version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString * iPhoneType = @"";
    
    NSString *content = [NSString stringWithFormat:@"%@<br>\niOS_Version : %@----PhoneSize : %@<br>\n----iPhoneType: %@<br>\nApp_Version : %@<br>\nuserID : %@<br>\nuserName : %@<br>\nname:%@<br>\nreason:\n%@<br>\ncallStackSymbols:\n%@",dateStr,iOS_Version,PhoneSize,iPhoneType,App_Version,userID,userName,name,reason,[callStack componentsJoinedByString:@"\n"]];
    
#if DEBUG
    NSDictionary * dictionary   =   @{@"content":content,
                                      @"isDebug":@(1),
                                      @"packageName":@"com.thinkjoy.NetworkTaxiDriver"};
#else
    NSDictionary * dictionary   =   @{@"content":content,
                                      @"isDebug":@(0),
                                      @"packageName":@"com.thinkjoy.NetworkTaxiDriver"};
#endif
    
    NSString *path =[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSString *personsArrPath = [path stringByAppendingString:@"/personsArr.plist"];
    [dictionary writeToFile:personsArrPath atomically:YES];
    
    NSLog(@"name:%@  reason:%@",name,reason);
    
    NSLog(@"堆栈 %@",callStack);
    
    NSLog(@"\n -----------------------------------");
}





#pragma mark 获得设备型号
+ (NSString *)getiPhoneType
{
    struct utsname systemInfo;
    
    uname(&systemInfo);
    
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G";
    
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G";
    
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS";
    
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S";
    
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5";
    
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5";
    
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c";
    
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c";
    
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s";
    
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s";
    
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus";
    
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6";
    
    if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6s";
    
    if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6s Plus";
    
    if ([platform isEqualToString:@"iPhone8,4"]) return @"iPhone SE";
    
    if ([platform isEqualToString:@"iPhone9,1"]) return @"iPhone 7";
    
    if ([platform isEqualToString:@"iPhone9,2"]) return @"iPhone 7 Plus";
    
    if ([platform isEqualToString:@"iPod1,1"])   return @"iPod Touch 1G";
    
    if ([platform isEqualToString:@"iPod2,1"])   return @"iPod Touch 2G";
    
    if ([platform isEqualToString:@"iPod3,1"])   return @"iPod Touch 3G";
    
    if ([platform isEqualToString:@"iPod4,1"])   return @"iPod Touch 4G";
    
    if ([platform isEqualToString:@"iPod5,1"])   return @"iPod Touch 5G";
    
    if ([platform isEqualToString:@"iPad1,1"])   return @"iPad 1G";
    
    if ([platform isEqualToString:@"iPad2,1"])   return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,2"])   return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,3"])   return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,4"])   return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,5"])   return @"iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad2,6"])   return @"iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad2,7"])   return @"iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad3,1"])   return @"iPad 3";
    
    if ([platform isEqualToString:@"iPad3,2"])   return @"iPad 3";
    
    if ([platform isEqualToString:@"iPad3,3"])   return @"iPad 3";
    
    if ([platform isEqualToString:@"iPad3,4"])   return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad3,5"])   return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad3,6"])   return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad4,1"])   return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,2"])   return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,3"])   return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,4"])   return @"iPad Mini 2G";
    
    if ([platform isEqualToString:@"iPad4,5"])   return @"iPad Mini 2G";
    
    if ([platform isEqualToString:@"iPad4,6"])   return @"iPad Mini 2G";
    
    if ([platform isEqualToString:@"i386"])      return @"iPhone Simulator";
    
    if ([platform isEqualToString:@"x86_64"])    return @"iPhone Simulator";
    
    return platform;
}

@end
