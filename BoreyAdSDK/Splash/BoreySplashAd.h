//
//  NSObject+BoreySplashAd.h
//  BoreyAdSDK
//
//  Created by Buer on 2024/12/2.
//

#import <Foundation/Foundation.h>
#import <BoreyAdSDK/BoreyAd.h>
#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BoreySplashAd : BoreyAd

@property(nonatomic, strong) WKWebView * webview;

-(void) showInWindow: (UIWindow *) window;

@end

NS_ASSUME_NONNULL_END
