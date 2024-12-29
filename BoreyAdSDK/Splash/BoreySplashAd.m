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
    [_webview loadRequest:[NSURLRequest requestWithURL:url]];

    // 将webView添加到视图中
    [window addSubview:_webview];
    [Logs i: @"Splash onAdDisplayed"];
    if (_model) {
        [Api report: [_model getImpTrackers] : [_model getPrice]];
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
    if (_webview) {
        [_webview removeFromSuperview];
    }
    [Logs i: @"Splash onClick"];
    if (_model) {
        long price = [_model getPrice];
        NSArray<NSString *> *dpTrackers = [_model getDpTrackers];
        NSArray<NSString *> *clickTrackers = [_model getClickTrackers];
        [Api report: clickTrackers : price];
        NSString *deeplink = [_model getDeeplink];
        [Logs i: @"deeplink: %@", deeplink];
        NSURL *url = [NSURL URLWithString:deeplink];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [Logs i: @"可以跳转"];
            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
                if (success) {
                    [Logs i: @"跳转成功"];
                    [Api report: dpTrackers : price];
                }
            }];
        } else {
            [Logs i: @"无法跳转"];
        }
    }
    if (_listener) {
        [_listener onClick];
    }
}

- (void)onTimeReached {
    if(_webview) {
        [_webview removeFromSuperview];
    }
    [Logs i: @"Splash onAdClosed"];
    if (_listener) {
        [_listener onAdClosed];
    }
}

- (void)onClickCloseBtn {
    if (_webview) {
        [_webview removeFromSuperview];
    }
    [Logs i: @"Splash onAdClosed"];
    if (_listener) {
        [_listener onAdClosed];
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
