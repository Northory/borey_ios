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


@protocol BoreyExpressAdListener <NSObject>

-(void) onBoreyExpressAdClick;

-(void) onBoreyExpressAdClosed;

-(void) onBoreyExpressAdDisplayed;

-(void) onBoreyExpressAdShowFailed: (NSError *) error;

@end

@interface BoreyExpressAd : BoreyAd

@property(nonatomic, assign) CGFloat mWidth;
@property(nonatomic, assign) CGFloat mHeight;
@property(nonatomic, strong) BoreyModel *model;
@property(nonatomic, weak) id<BoreyExpressAdListener> listener;

-(UIView *) expressAdViewWithViewController: (UIViewController *) viewController;

-(instancetype) initWithModelAndSize: (BoreyModel *) model : (CGFloat) width : (CGFloat) height;

@end
