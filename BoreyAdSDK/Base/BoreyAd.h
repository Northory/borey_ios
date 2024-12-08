//
//  BoreyAd.h
//  BoreyAdSDK
//
//  Created by Buer on 2024/12/1.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, AdType) {
    Splash = 0,
    Express
};


@interface BoreyAd : NSObject

+(NSString *) getAdImp: (AdType) adtype;

@end
