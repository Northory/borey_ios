//
//  Constants.m
//  BoreyAdSDK
//
//  Created by Buer on 2024/12/8.
//

#import <Foundation/Foundation.h>
#import "Constants.h"
#import "PreferenceHelper.h"
#import "RandomHelper.h"

NSString *const PerfKeyUserBiddingId = @"perf_key_user_bidding_id";
NSString *const PerfKeyUserIDFA = @"perf_key_user_idfa";
NSString *const PerfKeyUserAgent = @"perf_key_user_agent";

NSInteger const SplashShowError = 2001;
NSInteger const ExpressShowError = 3001;
NSInteger const BannerShowError = 4001;

@implementation Constants

+ (NSString *) getBiddingId {
    NSString *biddingId = [PreferenceHelper.sharedInstance getStr:PerfKeyUserBiddingId];
    if (!biddingId || biddingId.length != 32) {
        biddingId = [RandomHelper randomStr:32];
        [PreferenceHelper.sharedInstance saveStr:PerfKeyUserBiddingId :biddingId];
    }
    return biddingId;
}

@end
