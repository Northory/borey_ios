//
//  BoreyExpressAd.h
//  BoreyAdSDK
//
//  Created by Buer on 2025/1/26.
//

#import <Foundation/Foundation.h>
#import <BoreyAdSDK/BoreyAd.h>
#import <BoreyAdSDK/BoreyModel.h>
#import <UIKit/UIKit.h>


@protocol BoreyBannerAdListener <NSObject>

-(void) onBoreyBannerAdClick;

-(void) onBoreyBannerAdClosed;

-(void) onBoreyBannerAdDisplayed;

-(void) onBoreyBannerAdShowFailed: (NSError *) error;

@end

@interface BoreyBannerAd : BoreyAd

@property(nonatomic, assign) CGFloat mWidth;
@property(nonatomic, assign) CGFloat mHeight;
@property(nonatomic, strong) BoreyModel *model;
@property(nonatomic, weak) id<BoreyBannerAdListener> listener;

-(UIView *) bannerAdViewWithViewController: (UIViewController *) viewController;

-(instancetype) initWithModelAndSize: (BoreyModel *) model : (CGFloat) width : (CGFloat) height;

@end
