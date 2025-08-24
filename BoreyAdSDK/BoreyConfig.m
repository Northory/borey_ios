//
//  NSObject+BoreyConfig.m
//  BoreyAdSDK
//
//  Created by Buer on 2024/12/7.
//

#import "BoreyConfig.h"

@implementation BoreyConfig 

- (NSString *) getIdfa {
    if(_idfa) {
        return _idfa;
    } else {
        return @"";
    }
}

- (NSString *)getMediaId {
    if (_mediaId) {
        return _mediaId;
    } else {
        return @"";
    }
}

-(NSDictionary *) getSplashParams {
    if (_params) {
        NSDictionary * splashConfig = _params[@"splash"];
        if (splashConfig) {
            return splashConfig;
        }
    }
    return @{};
}

- (NSDictionary *)getParams {
    return _params;
}

@end
