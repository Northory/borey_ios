//
//  CustomWebView.h
//  BoreyAdSDK
//
//  Created by Buer on 2024/12/14.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>
#import "BoreyModel.h"

@protocol CustomWebViewDelegate <NSObject>

@optional
-(void) onClickCloseBtn;

@optional
-(void) onClickAd;

@optional
-(void) onTimeReached;

@optional
-(void) onPageFinished;

@optional
-(void) onLoadHtmlError: (NSError *) error;

@end

@interface CustomWebView : WKWebView <WKNavigationDelegate, WKScriptMessageHandler>

@property(nonatomic, strong) BoreyModel * model;

@property(nonatomic, strong) id<CustomWebViewDelegate> webViewDelegate;

- (instancetype) create: (CGRect) frame : (BoreyModel *) model;

- (void) callWebMethod: (NSString *) method : (NSDictionary *) params;

@end

