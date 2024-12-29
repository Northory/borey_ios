//
//  NSObject+BoreySplashAdFiller.m
//  BoreyAdSDK
//
//  Created by Buer on 2024/12/1.
//

#import "BoreySplashAdFiller.h"
#import "Api.h"
#import "BoreyAdSDK/BoreyAd.h"
#import <UIKit/UIKit.h>
#import "Logs.h"
#import "ErrorHelper.h"
#import "BoreySplashAd.h"
#import "BoreyAdSDK/BoreyAdSDK.h"
#import "BoreyAdSDK/BoreyConfig.h"

@interface BoreySplashAdFiller()


@end

@implementation BoreySplashAdFiller

-(void)fill:(NSString *)tagId bidFloor:(long)bidFloor {
    
    BOOL sdkInited = [BoreyAdSDK.sharedInstance initialized];
    if(!sdkInited) {
        if (_listener) {
            [_listener onSplashAdFilled:nil :[ErrorHelper create:1001 : @"Borey SDK未初始化"]];
        }
        return;
    }
    
    UIScreen *mainScreen = [UIScreen mainScreen];
    CGRect screenBounds = mainScreen.bounds;
    NSInteger screenWidth = (NSInteger)screenBounds.size.width;
    NSInteger screenHeight = (NSInteger)screenBounds.size.height;
    __weak typeof(self) weakSelf = self;
    [Api fetchAdInfo:Splash :screenWidth :screenHeight :tagId :bidFloor :^(BoreyModel * boreyModel, NSError * error) {
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (strongSelf.listener) {
                if (error) {
                    [Logs e: @"Splash广告加载失败：%@", error];
                    [strongSelf.listener onSplashAdFilled: nil :error];
                } else if(boreyModel && [boreyModel valid]) {
                    BoreySplashAd * splashAd = [[BoreySplashAd alloc] initWithModel: boreyModel];
                    [strongSelf.listener onSplashAdFilled:splashAd :error];
                } else {
                    NSString *errorMsg = @"Splash广告加载失败：数据解析失败";
                    [strongSelf.listener onSplashAdFilled: nil :[ErrorHelper create:2001 : errorMsg]];
                    [Logs e: errorMsg];
                }
            }
        });
        
    }];
}

@end
