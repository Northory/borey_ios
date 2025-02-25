//
//  BoreyBannerAd.m
//  BoreyAdSDK
//
//  Created by Buer on 2025/1/26.
//

#import <Foundation/Foundation.h>
#import "BoreyBannerAd.h"
#import <UIKit/UIKit.h>
#import "CustomWebView.h"
#import "Logs.h"
#import "Constants.h"
#import "ErrorHelper.h"
#import "Api.h"

@interface BoreyBannerAd () <CustomWebViewDelegate>

@property(nonatomic, strong) CustomWebView * webview;


@end

@implementation BoreyBannerAd

- (UIView *)bannerAdViewWithViewController:(UIViewController *)viewController {
    
    CGRect rect = CGRectMake(0,0,_mWidth,_mHeight);
    
    _webview = [[CustomWebView alloc] create: rect :nil];
    _webview.webViewDelegate = self;
    
    // 获取HTML文件的路径
    NSBundle *bundle = [NSBundle bundleWithPath:[[NSBundle bundleForClass:[self class]] pathForResource:@"BoreyAdSDK" ofType:@"bundle"]];
    NSString *htmlPath = [bundle pathForResource:@"banner/index" ofType:@"html"];

    // 检查文件是否存在
    if (!htmlPath) {
        [Logs i: @"Banner onAdFailed: 广告样式缺失"];
        if (_listener) {
            [_listener onBoreyBannerAdShowFailed: [ErrorHelper create: BannerShowError :@"广告样式缺失"]];
        }
        return nil;
    }
    
    NSURL *url = [NSURL fileURLWithPath:htmlPath];
    _webview.backgroundColor = [UIColor clearColor];
    [_webview setOpaque:NO];
    [_webview loadRequest:[NSURLRequest requestWithURL:url]];
    
    return _webview;
}

- (instancetype)initWithModelAndSize:(BoreyModel *)model :(CGFloat)width :(CGFloat)height {
    self = [super init];
    if (self) {
        self.model = model;
        self.mWidth = width;
        self.mHeight = height;
    }
    return self;
}

- (void) onClickAd {
    [Logs i: @"Banner onClick"];
    
    if (_model) {
        long price = [_model getPrice];
        NSArray<NSString *> *dpTrackers = [_model getDpTrackers];
        NSArray<NSString *> *clickTrackers = [_model getClickTrackers];
        [Api report: clickTrackers : price : Click : Banner];
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
                [strongSelf clickAd];
                if (success) {
                    [Logs i: @"跳转成功"];
                    [Api report: dpTrackers : price : Dp : Banner];
                }
            }];
        } else {
            [self clickAd];
            [Logs i: @"无法跳转"];
        }
    } else {
        [self clickAd];
    }
}

- (void)onPageFinished {
    if (_webview && _model) {
        NSDictionary *initData = @{
            @"brand_logo": [_model getBrandLogo],
            @"title":[_model getTitle],
            @"expect_height_dp": @(_mHeight),
            @"desc": [_model getDesc],
        };
        [_webview callWebMethod: @"init" : initData];
    }
}

- (void)webViewWillAddToSuperView {

}

- (void)webViewWillMoveToWindow {
    [Logs i: @"Banner onAdDisplayed"];
    if (_model) {
        [Api report: [_model getImpTrackers] : [_model getPrice] : Imp : Banner];
    }
    if (_listener) {
        [_listener onBoreyBannerAdDisplayed];
    }
}

- (void)onClickCloseBtn {
    [Logs i: @"Banner onClickCloseBtn"];
    if (_listener) {
        [_listener onBoreyBannerAdClosed];
    }
    [self doRelease];
}

- (void)onLoadHtmlError:(NSError *)error {
    [Logs i: @"Banner onLoadHtmlError"];
    if (_listener) {
        [_listener onBoreyBannerAdShowFailed: error];
    }
    [self doRelease];
}

- (void)clickAd {
    [Logs i: @"Banner clickAd"];
    if (_listener) {
        [_listener onBoreyBannerAdClick];
    }
}


- (void)doRelease {
    if (_listener) {
        _listener = nil;
    }
    if (_webview) {
        [_webview removeFromSuperview];
    }
}

- (long)getEcpm {
    if (_model) {
        return [_model getPrice];
    }
    return 0;
}

@end
