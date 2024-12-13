//
//  DeviceHelper.m
//  BoreyAdSDK
//
//  Created by Buer on 2024/12/13.
//

#import <Foundation/Foundation.h>
#import "DeviceHelper.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import <sys/utsname.h>
#import <UIKit/UIKit.h>
#import <AppTrackingTransparency/AppTrackingTransparency.h>
#import <AdSupport/AdSupport.h>
#import "PreferenceHelper.h"
#import "Constants.h"
#import <mach/mach_time.h>
#import <sys/sysctl.h>
#import "Md5Helper.h"

@implementation DeviceHelper

+ (NetworkType)getCurrentNetworkType {
    return NetworkTypeUnknown;
}

+ (NSString *)getCurrentCarrierName {
    CTTelephonyNetworkInfo *networkInfo = [[CTTelephonyNetworkInfo alloc] init];
    // Use serviceSubscriberCellularProviders instead of subscriberCellularProvider
    NSDictionary<NSString *, CTCarrier *> *providers = networkInfo.serviceSubscriberCellularProviders;
    if (providers.count > 0) {
        CTCarrier *carrier = [providers.allValues firstObject];
        if (carrier != nil) {
            return [carrier carrierName];
        }
    }
    return @"unknown";
}

+ (NSString *)getDeviceModel {
    struct utsname systemInfo;
    uname(&systemInfo);
    return [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
}

+ (CGFloat) getPixelsPerInch {
    CGFloat screenScale = [UIScreen mainScreen].scale;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    CGFloat physicalWidth = screenWidth * screenScale;
    CGFloat physicalHeight = screenHeight * screenScale;
    
    CGFloat diagonalInches = sqrt(pow(physicalWidth, 2) + pow(physicalHeight, 2)) / 25.4; // 转换为英寸
    CGFloat pixelsPerInch = (physicalWidth + physicalHeight) / (2 * diagonalInches);
    return pixelsPerInch;
}

+ (NSString *)getDeviceIdentifier {
    UIDevice *device = [UIDevice currentDevice];
    return device.identifierForVendor.UUIDString;
}

+ (NSString *)getCurrentLanguage {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *languages = [defaults objectForKey:@"AppleLanguages"];
    NSString *currentLanguage = [languages objectAtIndex:0];
    return currentLanguage;
}

+ (void) requestIDFA {
    if (@available(iOS 14, *)) {
        [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
            if (status == ATTrackingManagerAuthorizationStatusAuthorized) {
                // User agrees to tracking
                NSString *idfa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
                [PreferenceHelper.sharedInstance saveStr:idfa :PerfKeyUserIDFA];
            }
        }];
    } else {
        // In versions earlier than iOS 14, you can directly get the IDFA
        NSString *idfa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
        [PreferenceHelper.sharedInstance saveStr:idfa :PerfKeyUserIDFA];
    }
}

+(NSString *)getIdfa {
    NSString *idfa = [PreferenceHelper.sharedInstance getStr:PerfKeyUserIDFA];
    if (idfa) {
        return idfa;
    } else {
        return @"";
    }
}

+ (NSString *)getPAID {
    // 获取设备初始化时间
    NSTimeInterval deviceInitTime = [[NSProcessInfo processInfo] systemUptime];
    
    // 获取系统更新时间
    struct timeval bootTime;
    size_t size = sizeof(bootTime);
    int mib[2] = {CTL_KERN, KERN_BOOTTIME};
    sysctl(mib, 2, &bootTime, &size, NULL, 0);
    NSTimeInterval systemUpdateTime = bootTime.tv_sec;
    
    // 获取系统启动时间
    NSTimeInterval systemStartTime = [[NSProcessInfo processInfo] systemUptime];
    
    // 将时间戳转换为字符串
    NSString *deviceInitTimeString = [NSString stringWithFormat:@"%.0f", deviceInitTime];
    NSString *systemUpdateTimeString = [NSString stringWithFormat:@"%.0f", systemUpdateTime];
    NSString *systemStartTimeString = [NSString stringWithFormat:@"%.0f", systemStartTime];
    NSString *deviceInitMd5 = [Md5Helper md5:deviceInitTimeString];
    NSString *systemUpdateTimeMd5 = [Md5Helper md5:systemUpdateTimeString];
    NSString *systemStartTimeMd5 = [Md5Helper md5:systemStartTimeString];
    
    return [NSString stringWithFormat:@"%@-%@-%@", deviceInitMd5, systemUpdateTimeMd5, systemStartTimeMd5];
}

@end
