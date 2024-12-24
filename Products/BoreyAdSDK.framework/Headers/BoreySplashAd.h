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
#import <BoreyAdSDK/BoreyModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface BoreySplashAd : NSObject

-(void) showInWindow: (UIWindow *) window;

-(instancetype) initWithModel: (BoreyModel *) model;

@end

NS_ASSUME_NONNULL_END