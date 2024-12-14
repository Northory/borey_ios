//
//  CustomWebView.m
//  BoreyAdSDK
//
//  Created by Buer on 2024/12/14.
//

#import <Foundation/Foundation.h>
#import "CustomWebView.h"
#import "Logs.h"

@implementation CustomWebView


- (instancetype)create:(CGRect)frame :(BoreyModel *)model {
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    CustomWebView *webView = [super initWithFrame:frame configuration:configuration];
    _model = model;
    webView.navigationDelegate = webView;
    [configuration.userContentController addScriptMessageHandler:webView name:@"NativeBridge"];
    return webView;
}

- (void)callWebMethod:(NSString *)method :(NSDictionary *)params {
    NSDictionary *safeParams = params;
    if (!safeParams) {
        safeParams = @{};
    }
    NSDictionary *data = @{
        @"method": method,
        @"params": safeParams
    };
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data options:0 error:&error];

    if (error) {
        [Logs i:@"Send data to web error: %@", error.userInfo];
        return;
    }
    [Logs i: @"nativeToWeb: %@", jsonData];
    [self evaluateJavaScript:[NSString stringWithFormat:@"nativeToWeb(%@)", jsonData] completionHandler:^(id result, NSError * error) {
        [Logs i: @"nativeToWeb result: %@, %@", result, error];
    }];
    
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    [Logs i: @"webToNative: %@", message];
    
}

//网页加载完成
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    
}


@end
