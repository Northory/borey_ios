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

@interface BoreySplashAdFiller()


@end

@implementation BoreySplashAdFiller

-(void)fill:(NSString *)tagId bidFloor:(long)bidFloor {
    UIScreen *mainScreen = [UIScreen mainScreen];
    CGRect screenBounds = mainScreen.bounds;
    NSInteger screenWidth = (NSInteger)screenBounds.size.width;
    NSInteger screenHeight = (NSInteger)screenBounds.size.height;
    __weak typeof(self) weakSelf = self;
    [Api fetchAdInfo:Splash :screenWidth :screenHeight :tagId :bidFloor :^(BoreyModel * boreyModel, NSError * error) {
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [Logs i:@"callback success... %@", strongSelf.listener];
            if (strongSelf.listener) {
                if (error) {
                    [Logs i: @"Splash广告加载失败：%@", error.userInfo];
                } else if(boreyModel && [boreyModel valid]) {
                    
                    BoreySplashAd * splashAd = [[BoreySplashAd alloc] initWithModel: boreyModel];

                    [strongSelf.listener onSplashAdFilled:splashAd :error];
                } else {
                    NSString *errorMsg = @"Splash广告加载失败：数据解析失败";
                    [strongSelf.listener onSplashAdFilled: nil :[ErrorHelper create:2001 : errorMsg]];
                    [Logs i: errorMsg];
                }
            }
        });
        
    }];
}

@end
