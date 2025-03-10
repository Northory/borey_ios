//
//  BoreyCustomAd.h
//  BoreyAdSDK
//
//  Created by Buer on 2025/3/9.
//

#import <BoreyAdSDK/BoreyAd.h>
#import <BoreyAdSDK/BoreyModel.h>
#import <UIKit/UIKit.h>
#import <BoreyAdSDK/CustomAdInfo.h>

@protocol BoreyCustomAdListener <NSObject>

-(void) onBoreyCustomAdClick;

-(void) onBoreyCustomAdDislike;

-(void) onBoreyCustomAdDisplayed;

@end

@interface BoreyCustomAd : BoreyAd

@property(nonatomic, strong) id<BoreyCustomAdListener> listener;
@property(nonatomic, assign) CGFloat mWidth;
@property(nonatomic, assign) CGFloat mHeight;
@property(nonatomic, strong) CustomAdInfo *info;

-(instancetype) initWithModelAndSize: (BoreyModel *) model : (CGFloat) width : (CGFloat) height;

- (void) registerViews: (UIView *) adView : (NSArray<UIView *> *) clickableViews : (NSArray<UIView *> *) closeViews;

-(CustomAdInfo *) getCustomInfo;

@end
