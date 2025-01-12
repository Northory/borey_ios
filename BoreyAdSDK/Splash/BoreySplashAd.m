//
//  NSObject+BoreySplashAd.m
//  BoreyAdSDK
//
//  Created by Buer on 2024/12/2.
//

#import "BoreySplashAd.h"
#import "CustomWebView.h"
#import "BoreyModel.h"
#import "Logs.h"
#import "Constants.h"
#import "ErrorHelper.h"
#import "Api.h"
#import <UIKit/UIKit.h>

@interface BoreySplashAd () <CustomWebViewDelegate>

@property(nonatomic, strong) CustomWebView * webview;
@property(nonatomic, strong) BoreyModel * model;

-(instancetype) initWithModel: (BoreyModel *) model;

@end

@implementation BoreySplashAd

- (instancetype)initWithModel:(BoreyModel *)model {
    self = [super init];
    if (self) {
        self.model = model;
    }
    return self;
}

- (void)showInWindow:(UIWindow *)window {
    
    if (_webview) {
        [Logs i: @"广告已展示过"];
        if (_listener) {
            [_listener onAdFailed: [ErrorHelper create: SplashShowError :@"广告已展示过"]];
        }
        return;
    }
    
    _webview = [[CustomWebView alloc] create:window.bounds :nil];
    _webview.webViewDelegate = self;
    // 获取HTML文件的路径
    NSBundle *bundle = [NSBundle bundleWithPath:[[NSBundle bundleForClass:[self class]] pathForResource:@"BoreyAdSDK" ofType:@"bundle"]];
    NSString *htmlPath = [bundle pathForResource:@"index" ofType:@"html"];

    // 检查文件是否存在
    if (!htmlPath) {
        [Logs i: @"Splash onAdFailed: 广告样式缺失"];
        if (_listener) {
            [_listener onAdFailed: [ErrorHelper create: SplashShowError :@"广告样式缺失"]];
        }
        return;
    }
    
    NSURL *url = [NSURL fileURLWithPath:htmlPath];
    _webview.backgroundColor = [UIColor clearColor];
    [_webview setOpaque:NO];
    [_webview loadRequest:[NSURLRequest requestWithURL:url]];

    // 将webView添加到视图中
    [window addSubview:_webview];
    [Logs i: @"Splash onAdDisplayed"];
    if (_model) {
        [Api report: [_model getImpTrackers] : [_model getPrice] : Imp : Splash];
    }
    if (_listener) {
        [_listener onAdDisplayed];
    }
}

- (void)onPageFinished {
    if (_webview && _model) {
        CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
        NSDictionary *initData = @{
            @"img_url": [_model getImg],
            @"time_out_second": @5,
            @"status_bar_height": @(statusBarHeight)
        };
        [_webview callWebMethod: @"init" : initData];
    }
}

- (void)onClickAd {
    [Logs i: @"Splash onClick"];
    
    if (_model) {
        long price = [_model getPrice];
        NSArray<NSString *> *dpTrackers = [_model getDpTrackers];
        NSArray<NSString *> *clickTrackers = [_model getClickTrackers];
        [Api report: clickTrackers : price : Click : Splash];
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
                    [Api report: dpTrackers : price : Dp : Splash];
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

- (void) clickAd {
    if (_listener) {
        [_listener onClick];
        [_listener onAdClosed];
    }
    [self doRelease];
}

- (void)onTimeReached {
    [Logs i: @"Splash onTimeReached"];
    if (_listener) {
        [_listener onAdClosed];
    }
    [self doRelease];
}

- (void)onClickCloseBtn {
    [Logs i: @"Splash onClickCloseBtn"];
    if (_listener) {
        [_listener onAdClosed];
    }
    [self doRelease];
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
