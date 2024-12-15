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
    [configuration.userContentController addScriptMessageHandler:webView name:@"NativeBridge"];
    _model = model;
    webView.navigationDelegate = webView;
    return webView;
}

- (void)callWebMethod:(NSString *)method :(NSDictionary *)params {
    if (!params) {
        params = @{};
    }
    NSMutableDictionary *mutableParams = [params mutableCopy];
    [mutableParams setObject:@"ios" forKey:@"platform"];
    NSDictionary *data = @{
        @"method": method,
        @"params": mutableParams
    };
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data options:0 error:&error];

    if (error) {
        [Logs i:@"Send data to web error: %@", error.userInfo];
        return;
    }
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    [Logs i:@"nativeToWeb: %@", jsonString];
    [self evaluateJavaScript:[NSString stringWithFormat:@"nativeToWeb(%@)", jsonString] completionHandler:^(id result, NSError * error) {
        [Logs i: @"nativeToWeb result: %@, %@", result, error];
    }];
    
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    if ([message.name isEqualToString: @"NativeBridge"]) {
        [self performSelectorOnMainThread:@selector(webToNative:) withObject:message.body waitUntilDone:NO];
    }
}

- (void) webToNative: (NSString *) data {
    [Logs i: @"webToNative: %@", data];
    if (!_webViewDelegate) {
        [Logs i: @"webToNative: 没有注册监听器"];
        return;
    }
    NSError *error;
    NSData *jsonData = [data dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
    if(error) {
        [Logs i: @"解析web数据失败: %@", error.userInfo];
        return;
    }
    NSString *method = [dictionary objectForKey: @"method"];
    NSDictionary *params = [dictionary objectForKey: @"params"];
    if ([method isEqualToString: @"click_close_btn"]) {
        [_webViewDelegate onClickCloseBtn];
    } else if ([method isEqualToString: @"click_ad"]) {
        [_webViewDelegate onClickAd];
    } else if ([method isEqualToString: @"time_reached"]) {
        [_webViewDelegate onTimeReached];
    }
}

//网页加载完成
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [Logs i: @"网页加载完成"];
    if (_webViewDelegate) {
        [_webViewDelegate onPageFinished];
    }
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    [Logs i: @"网页加载失败"];
    if (_webViewDelegate) {
        [_webViewDelegate onLoadHtmlError:error];
    }
}


@end
