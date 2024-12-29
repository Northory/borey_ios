//
//  Constants.h
//  BoreyAdSDK
//
//  Created by Buer on 2024/12/8.
//

 
#import <Foundation/Foundation.h>

extern NSString *const PerfKeyUserBiddingId;
extern NSString *const PerfKeyUserIDFA;
extern NSString *const PerfKeyUserAgent;

extern NSInteger const SplashShowError;

@interface Constants : NSObject

+(NSString*) getBiddingId;

@end
