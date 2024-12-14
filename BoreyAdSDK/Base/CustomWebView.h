//
//  CustomWebView.h
//  BoreyAdSDK
//
//  Created by Buer on 2024/12/14.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>
#import "BoreyModel.h"

@interface CustomWebView : WKWebView <WKNavigationDelegate, WKScriptMessageHandler>

@property(nonatomic, strong) BoreyModel * model;

- (instancetype) create: (CGRect) frame : (BoreyModel *) model;

- (void) callWebMethod: (NSString *) method : (NSDictionary *) params;

@end
