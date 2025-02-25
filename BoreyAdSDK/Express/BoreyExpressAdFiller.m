//
//  BoreyExpressAdFiller.m
//  BoreyAdSDK
//
//  Created by Buer on 2025/1/26.
//

#import <Foundation/Foundation.h>
#import "BoreyExpressAdFiller.h"
#import "Api.h"
#import "BoreyAdSDK/BoreyAd.h"
#import <UIKit/UIKit.h>
#import "Logs.h"
#import "ErrorHelper.h"
#import "BoreyAdSDK/BoreyAdSDK.h"
#import "BoreyAdSDK/BoreyConfig.h"


@implementation BoreyExpressAdFiller

- (instancetype)initWithAdSize:(CGFloat)width :(CGFloat)height {
    self = [super init];
    if (self) {
        self.expressWidth = width;
        self.expressHeight = height;
    }
    return self;
}

- (void)fill:(NSString *)tagId :(long)bidFloor {
    BOOL sdkInited = [BoreyAdSDK.sharedInstance initialized];
    if(!sdkInited) {
        if (_listener) {
            [_listener onBoreyExpressAdFilled: nil : [ErrorHelper create:2001 : @"Borey SDK未初始化"]];
        }
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    
    [Api fetchAdInfo:Splash :self.expressWidth :self.expressHeight :tagId :bidFloor :^(BoreyModel * boreyModel, NSError * error) {
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (strongSelf.listener) {
                if (error) {
                    [Logs e: @"Express广告加载失败：%@", error];
                    [strongSelf.listener onBoreyExpressAdFilled: nil :error];
                } else if(boreyModel && [boreyModel valid]) {
                    BoreyExpressAd * expressAd = [[BoreyExpressAd alloc] initWithModelAndSize:boreyModel :strongSelf.expressWidth :strongSelf.expressHeight];
                    [strongSelf.listener onBoreyExpressAdFilled:expressAd :error];
                } else {
                    NSString *errorMsg = @"Express广告加载失败：数据解析失败";
                    [strongSelf.listener onBoreyExpressAdFilled: nil :[ErrorHelper create:2001 : errorMsg]];
                    [Logs e: errorMsg];
                }
            }
        });
        
    }];
}

@end
