//
//  NetworkHelper.m
//  BoreyAdSDK
//
//  Created by Buer on 2024/12/14.
//

#import "NetworkHelper.h"
#import <SystemConfiguration/CaptiveNetwork.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import <Network/Network.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <CoreFoundation/CoreFoundation.h>
#import <netinet/in.h>

@implementation NetworkHelper

+ (NSInteger)getCellularNetworkType {
    
    if (@available(iOS 12.0, *)) {
        // 获取网络类型信息
        CTTelephonyNetworkInfo *networkInfo = [[CTTelephonyNetworkInfo alloc] init];
        NSString *currentRadioAccessTechnology = nil;
        
        NSDictionary *serviceCurrentRadioAccessTechnology = networkInfo.serviceCurrentRadioAccessTechnology;
        if (serviceCurrentRadioAccessTechnology.count > 0) {
            currentRadioAccessTechnology = [serviceCurrentRadioAccessTechnology.allValues firstObject];
        }
        
        if (!currentRadioAccessTechnology) {
            return 3; // Unknown Generation
        }
         if ([currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyGPRS] ||
             [currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyEdge]) { // Edge常量可能不存在，使用字符串
             return 4; // 2G
         } else if ([currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyWCDMA] ||
                    [currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyHSDPA] ||
                    [currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyHSUPA] ||
                    [currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyCDMA1x] ||
                    [currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyCDMAEVDORev0] ||
                    [currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyCDMAEVDORevA] ||
                    [currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyCDMAEVDORevB] ||
                    [currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyeHRPD]) { // eHRPD常量可能不存在，使用字符串
             return 5; // 3G
         } else if ([currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyLTE]) {
             return 6; // 4G
         } else if (@available(iOS 14.1, *)) {
             if ([currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyNRNSA] ||
                 [currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyNR]) {
                 return 7; // 5G
             }
         }
    }
    
    return 3; // Unknown Generation

}

+ (NSInteger)getNetworkType {
    // 1. 创建网络可达性引用（以苹果官网为例）
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, (const struct sockaddr *)&zeroAddress);
    
    if (reachability == NULL) {
        return 0; // 未知
    }
    
    // 2. 获取网络状态标志
    SCNetworkReachabilityFlags flags;
    BOOL success = SCNetworkReachabilityGetFlags(reachability, &flags);
    CFRelease(reachability); // 释放引用
    
    if (!success) {
        return 0; // 未知
    }
    
         // 3. 判断网络类型
     BOOL isReachable = (flags & kSCNetworkReachabilityFlagsReachable) != 0;
     BOOL needsConnection = (flags & kSCNetworkReachabilityFlagsConnectionRequired) != 0;
     BOOL isWWAN = (flags & kSCNetworkReachabilityFlagsIsWWAN) != 0;
     
     if (!isReachable || needsConnection) {
         return 0; // 未知/无网络
     } else if (isWWAN) {
         // isWWAN为YES表示蜂窝网络（WWAN = Wireless Wide Area Network）
         return [self getCellularNetworkType];
     } else {
         // isWWAN为NO表示WiFi或其他本地网络
         return 2; // WiFi
     }
}

@end
