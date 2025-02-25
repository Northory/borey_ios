//
//  BoreyBannerAdFiller.m
//  BoreyAdSDK
//
//  Created by Buer on 2025/1/26.
//

#import <Foundation/Foundation.h>
#import "BoreyBannerAdFiller.h"
#import "Api.h"
#import "BoreyAdSDK/BoreyAd.h"
#import <UIKit/UIKit.h>
#import "Logs.h"
#import "ErrorHelper.h"
#import "BoreyAdSDK/BoreyAdSDK.h"
#import "BoreyAdSDK/BoreyConfig.h"


@implementation BoreyBannerAdFiller

- (instancetype)initWithAdSize:(CGFloat)width :(CGFloat)height {
    self = [super init];
    if (self) {
        self.bannerWidth = width;
        self.bannerHeight = height;
    }
    return self;
}

- (void)fill:(NSString *)tagId :(long)bidFloor {
    BOOL sdkInited = [BoreyAdSDK.sharedInstance initialized];
    if(!sdkInited) {
        if (_listener) {
            [_listener onBoreyBannerAdFilled: nil : [ErrorHelper create:2001 : @"Borey SDK未初始化"]];
        }
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    
    [Api fetchAdInfo:Splash :self.bannerWidth :self.bannerHeight :tagId :bidFloor :^(BoreyModel * boreyModel, NSError * error) {
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (strongSelf.listener) {
                if (error) {
                    [Logs e: @"Banner广告加载失败：%@", error];
                    [strongSelf.listener onBoreyBannerAdFilled: nil :error];
                } else if(boreyModel && [boreyModel valid]) {
                    [Logs i: @"Banner广告加载成功"];
                    BoreyBannerAd * bannerAd = [[BoreyBannerAd alloc] initWithModelAndSize:boreyModel :strongSelf.bannerWidth :strongSelf.bannerHeight];
                    [strongSelf.listener onBoreyBannerAdFilled:bannerAd :error];
                } else {
                    NSString *errorMsg = @"Banner广告加载失败：数据解析失败";
                    [strongSelf.listener onBoreyBannerAdFilled: nil :[ErrorHelper create:2001 : errorMsg]];
                    [Logs e: errorMsg];
                }
            }
        });
        
    }];
}

@end
