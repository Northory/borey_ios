//
//  BoreyAdSDK.h
//  BoreyAdSDK
//
//  Created by Buer on 2024/12/1.
//

#import <Foundation/Foundation.h>

//! Project version number for BoreyAdSDK.
FOUNDATION_EXPORT double BoreyAdSDKVersionNumber;

//! Project version string for BoreyAdSDK.
FOUNDATION_EXPORT const unsigned char BoreyAdSDKVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <BoreyAdSDK/PublicHeader.h>
#import <BoreyAdSDK/BoreySplashAd.h>
#import <BoreyAdSDK/BoreySplashAdFiller.h>
#import <BoreyAdSDK/BoreyConfig.h>
#import <BoreyAdSDK/ErrorHelper.h>
#import <BoreyAdSDK/BoreyAd.h>
#import <BoreyAdSDK/BoreyModel.h>
#import <BoreyAdSDK/BoreyExpressAd.h>
#import <BoreyAdSDK/BoreyExpressAdFiller.h>
#import <BoreyAdSDK/BoreyBannerAd.h>
#import <BoreyAdSDK/BoreyBannerAdFiller.h>



NS_ASSUME_NONNULL_BEGIN

@interface BoreyAdSDK : NSObject

@property(atomic, assign, readonly) BOOL initialized;
@property(nonatomic, retain, readonly) BoreyConfig* config;

+(instancetype) sharedInstance;

-(void) initWithConfigAndCompletion: (BoreyConfig *) config : (void (^)(BOOL, NSError *)) completion;

@end

NS_ASSUME_NONNULL_END
