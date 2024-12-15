//
//  NSObject+BoreySplashAd.m
//  BoreyAdSDK
//
//  Created by Buer on 2024/12/2.
//

#import "BoreySplashAd.h"
#import "CustomWebView.h"
#import "BoreyModel.h"

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
        return;
    }
    
    _webview = [[CustomWebView alloc] create:window.bounds :nil];
    _webview.webViewDelegate = self;
    // 获取HTML文件的路径
    NSBundle *bundle = [NSBundle bundleWithPath:[[NSBundle bundleForClass:[self class]] pathForResource:@"BoreySplash" ofType:@"bundle"]];
    NSString *htmlPath = [bundle pathForResource:@"index" ofType:@"html"];

    // 检查文件是否存在
    if (!htmlPath) {
        NSLog(@"HTML file does not exist");
        return;
    }
    
    NSURL *url = [NSURL fileURLWithPath:htmlPath];
    [_webview loadRequest:[NSURLRequest requestWithURL:url]];

    // 将webView添加到视图中
    [window addSubview:_webview];
}

- (void)onPageFinished {
    if (_webview) {
        NSDictionary *initData = @{
            @"img_url": @"https://qh-material.taobao.com/product/image/jsafstfskandanf4yrqah3rrtw5sycy3.jpg?x-oss-process=image/resize,w_1080,h_1920,limit_0,m_fill&",
            @"time_out_second": @5
        };
        [_webview callWebMethod: @"init" : initData];
    }
}

- (void)onClickAd {
    NSLog(@"Splash onClickAd");
}

- (void)onTimeReached {
    NSLog(@"Splash onTimeReached");
    if(_webview) {
        [_webview removeFromSuperview];
    }
}

- (void)onClickCloseBtn {
    NSLog(@"Splash onClickCloseBtn");
    if (_webview) {
        [_webview removeFromSuperview];
    }
}

@end
