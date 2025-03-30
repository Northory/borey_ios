//
//  BoreyCustomAd.m
//  BoreyAdSDK
//
//  Created by Buer on 2025/3/9.
//

#import <Foundation/Foundation.h>
#import "BoreyCustomAd.h"
#import <BoreyAdSDK/BoreyAd.h>
#import <BoreyAdSDK/BoreyModel.h>
#import "Logs.h"
#import "Constants.h"
#import "ErrorHelper.h"
#import "Api.h"
#import <BoreyAdSDK/CustomAdInfo.h>

@interface BoreyCustomAd()

@property(nonatomic, strong) BoreyModel * model;
@property(nonatomic, assign) BOOL hasShown;

@end

@implementation BoreyCustomAd

- (CustomAdInfo *)getCustomInfo {
    return _info;
}

- (instancetype)initWithModelAndSize:(BoreyModel *)model :(CGFloat)width :(CGFloat)height {
    self = [super init];
    if (self) {
        self.model = model;
        self.mWidth = width;
        self.mHeight = height;
        self.info = [[CustomAdInfo alloc] initWithModel:model];
        self.hasShown = NO;
    }
    return self;
}


- (void)registerViews:(UIView *)adView :(NSArray<UIView *> *)clickableViews :(NSArray<UIView *> *)closeViews {
    
    if (!adView || !clickableViews || !closeViews || _hasShown) {
        return;
    }
    
    if (_listener) {
        [_listener onBoreyCustomAdDisplayed];
    }
    if (_model) {
        [Api report: [_model getImpTrackers] : [_model getPrice] : Imp : Custom];
    }
    
    for(UIView * view in clickableViews) {
        view.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onViewClick:)];
        tapGesture.numberOfTapsRequired = 1; // 单击
        tapGesture.numberOfTouchesRequired = 1; // 单指
        [view addGestureRecognizer:tapGesture];
    }
    
    for(UIView * view in closeViews) {
        view.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onDislike:)];
        tapGesture.numberOfTapsRequired = 1; // 单击
        tapGesture.numberOfTouchesRequired = 1; // 单指
        [view addGestureRecognizer:tapGesture];
    }
    
    _hasShown = YES;
}

-(void) onDislike:(UITapGestureRecognizer *)gesture {
    [Logs i:@"Custom onDislike"];
    if (_listener) {
        [_listener onBoreyCustomAdDislike];
    }
}

- (void) onViewClick:(UITapGestureRecognizer *)gesture {
    [Logs i:@"Custom onViewClick"];
    if (_listener) {
        [_listener onBoreyCustomAdClick];
    }
    if (_model) {
        long price = [_model getPrice];
        NSArray<NSString *> *dpTrackers = [_model getDpTrackers];
        NSArray<NSString *> *clickTrackers = [_model getClickTrackers];
        [Api report: clickTrackers : price : Click : Custom];
        NSString *ulk = [_model getUlk];
        NSString *deeplink = [_model getDeeplink];
        NSString *ldp = [_model getldp];
        NSString *universalLink = [_model getUniversalLink];
        NSURL *finalUrl;
        NSURL *ulkURL;
        NSURL *dpURL;
        NSURL *ldpURL;
        NSURL *universalURL;
        if (ulk && ![ulk isEqualToString: @""]) {
            ulkURL = [NSURL URLWithString: ulk];
        }
        if (deeplink && ![deeplink isEqualToString: @""]) {
            dpURL = [NSURL URLWithString: deeplink];
        }
        if (ldp && ![ldp isEqualToString: @""]) {
            ldpURL = [NSURL URLWithString: ldp];
        }
        if (universalLink && ![universalLink isEqualToString: @""]) {
            universalURL = [NSURL URLWithString: universalLink];
        }
        if ([[UIApplication sharedApplication] canOpenURL:universalURL]) {
            finalUrl = universalURL;
        } else if ([[UIApplication sharedApplication] canOpenURL:ulkURL]) {
            finalUrl = ulkURL;
        } else if ([[UIApplication sharedApplication] canOpenURL:dpURL]) {
            finalUrl = dpURL;
        } else if ([[UIApplication sharedApplication] canOpenURL:ldpURL]) {
            finalUrl = ldpURL;
        }
        [Logs i: @"ulk: %@", ulk];
        [Logs i: @"universalLink: %@", universalLink];
        [Logs i: @"deeplink: %@", deeplink];
        [Logs i: @"ldp: %@", ldp];
        if (finalUrl) {
            __weak typeof(self) weakSelf = self;
            [[UIApplication sharedApplication] openURL:finalUrl options:@{} completionHandler:^(BOOL success) {
                __strong typeof(weakSelf) strongSelf = weakSelf;
                if (success) {
                    [Logs i: @"跳转成功"];
                    [Api report: dpTrackers : price : Dp : Custom];
                }
            }];
        } else {
            [Logs i: @"无法跳转"];
        }
    }
}

- (BOOL)isViewVisibleOnScreen:(UIView *)view
{
    if (!view || view.hidden || view.superview == nil)
    { return NO; }
    CGRect screenBounds = UIScreen.mainScreen.bounds;
    CGRect viewFrameInWindow = [view convertRect:view.bounds toView:nil];
    return !CGRectIsEmpty(viewFrameInWindow) && CGRectIntersectsRect(screenBounds, viewFrameInWindow);
}
@end
