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
    }
}

+ (NSString *)getAdTypeName:(AdType)adtype {
    switch (adtype) {
        case Splash:
            return @"Splash";
        case Express:
            return @"Express";
    }
}

- (long)getEcpm {
    return 0;
}

- (void)doRelease {
    
}

@end
