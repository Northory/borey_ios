//
//  DeviceHelper.h
//  BoreyAdSDK
//
//  Created by Buer on 2024/12/13.
//

#import <Network/Network.h>

typedef NS_ENUM(NSInteger, NetworkType) {
    NetworkTypeUnknown = 0,
    NetworkTypeWIFI = 2,
    NetworkType2G = 4,
    NetworkType3G = 5,
    NetworkType4G = 6,
    NetworkType5G = 7
};

@interface DeviceHelper : NSObject

+ (NetworkType)getCurrentNetworkType;
+ (CGFloat) getPixelsPerInch;
+ (NSString *)getDeviceModel;
+ (NSString *)getCurrentCarrierName;
+ (NSString *)getDeviceIdentifier;
+ (NSString *)getCurrentLanguage;
+ (void)requestIDFA;
+ (NSString *)getIdfa;
+ (NSString *)getPAID;


@end
