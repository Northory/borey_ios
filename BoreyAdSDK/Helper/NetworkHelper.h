//
//  NetworkHelper.h
//  BoreyAdSDK
//
//  Created by Buer on 2024/12/14.
//

#import <Foundation/Foundation.h>

@interface NetworkHelper : NSObject

/**
 * 获取当前网络类型
 * @return 网络类型数字值
 * 0: 未知
 * 1: Ethernet
 * 2: WiFi
 * 3: Unknown Generation
 * 4: 2G
 * 5: 3G
 * 6: 4G
 * 7: 5G
 */
+ (NSInteger)getNetworkType;

@end
