//
//  NSObject+BoreySplashAd.h
//  BoreyAdSDK
//
//  Created by Buer on 2024/12/2.
//

#import <Foundation/Foundation.h>
#import <BoreyAdSDK/BoreyAd.h>
#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import <BoreyAdSDK/BoreyModel.h>

NS_ASSUME_NONNULL_BEGIN

@protocol BoreySplashAdListener <NSObject>

-(void) onBoreySplashAdClick;

-(void) onBoreySplashAdClosed;

-(void) onBoreySplashAdDisplayed;

-(void) onBoreySplashAdShowFailed: (NSError *) error;

@end

@interface BoreySplashAd : BoreyAd

@property(nonatomic, strong) id<BoreySplashAdListener> listener;

-(void) showInWindow: (UIWindow *) window;

-(instancetype) initWithModel: (BoreyModel *) model;

@end

NS_ASSUME_NONNULL_END
