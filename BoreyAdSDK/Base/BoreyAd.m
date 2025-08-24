//
//  BoreyAd.m
//  BoreyAdSDK
//
//  Created by Buer on 2024/12/1.
//

#import <Foundation/Foundation.h>
#import "BoreyAd.h"

@implementation BoreyAd

+(NSString *) getAdImp: (AdType) adtype {
    switch (adtype) {
        case Splash:
            return @"5";
        case Express:
            return @"2";
        case Banner:
            return @"2";
        case Custom:
            return @"2";
    }
}

+ (NSString *)getAdTypeName:(AdType)adtype {
    switch (adtype) {
        case Splash:
            return @"splash";
        case Express:
            return @"express";
        case Banner:
            return @"banner";
        case Custom:
            return @"native";
    }
}

- (long)getEcpm {
    return 0;
}

- (void)doRelease {
    
}

@end
