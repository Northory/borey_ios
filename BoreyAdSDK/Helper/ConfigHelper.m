//
//  ConfigHelper.m
//  BoreyAdSDK
//
//  Created by Buer on 2024/12/14.
//

#import "ConfigHelper.h"
#import "BoreyAdSDK/BoreyAd.h"
#import "BoreyAdSDK/BoreyAdSDK.h"
#import "BoreyAdSDK/BoreyConfig.h"
#import "RandomHelper.h"

@implementation ConfigHelper

+ (BOOL)isAccidentalTouch:(AdType)adType : (NSString *) scene {
    NSDictionary *adConfig = [self getAdConfig:adType :scene];
    if (adConfig) {
        NSNumber *accidentalTouchRate = [adConfig objectForKey:@"accidental_touch_rate"];
        if (accidentalTouchRate && [accidentalTouchRate isKindOfClass:[NSNumber class]]) {
            CGFloat rate = [accidentalTouchRate floatValue];
            return [RandomHelper isHit:rate];
        }
    }
    return NO;
}

+ (NSDictionary *) getAdConfig: (AdType) adType : (NSString *) scene {
    NSString *typeName = [BoreyAd getAdTypeName:adType];
    BoreyConfig *config = BoreyAdSDK.sharedInstance.config;
    if (config) {
        NSDictionary *params = [config getParams];
        if (params) {
            NSDictionary *adConfig = [params objectForKey:typeName];
            if (adConfig && [adConfig isKindOfClass:[NSDictionary class]]) {
                NSDictionary *sceneConfig = [adConfig objectForKey:scene];
                if (sceneConfig && [sceneConfig isKindOfClass:[NSDictionary class]]) {
                    return sceneConfig;
                }
            }
        }
    }
    return @{};
}

@end
