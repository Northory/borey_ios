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

@end
