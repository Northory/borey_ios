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

- (NSString *)getPaid {
    if(_paid) {
        return _paid;
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

@end
