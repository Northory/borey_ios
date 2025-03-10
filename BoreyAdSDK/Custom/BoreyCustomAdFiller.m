//
//  BoreyCustomAdFiller.m
//  BoreyAdSDK
//
//  Created by Buer on 2025/3/9.
//

#import <Foundation/Foundation.h>
#import "BoreyCustomAdFiller.h"
#import "Api.h"
#import "BoreyAdSDK/BoreyAd.h"
#import <UIKit/UIKit.h>
#import "Logs.h"
#import "ErrorHelper.h"
#import "BoreyAdSDK/BoreyAdSDK.h"
#import "BoreyAdSDK/BoreyConfig.h"

@interface BoreyCustomAdFiller()

@end

@implementation BoreyCustomAdFiller


- (void)fill:(NSString *)tagId :(long)bidFloor {
    BOOL sdkInited = [BoreyAdSDK.sharedInstance initialized];
    if(!sdkInited) {
        if (_listener) {
            [_listener onBoreyCustomAdFilled: nil : [ErrorHelper create:4001 : @"Borey SDK未初始化"]];
        }
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    
    [Api fetchAdInfo:Splash :self.customWidth :self.customHeight :tagId :bidFloor :^(BoreyModel * boreyModel, NSError * error) {
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (strongSelf.listener) {
                if (error) {
                    [Logs e: @"Custom广告加载失败：%@", error];
                    [strongSelf.listener onBoreyCustomAdFilled: nil :error];
                } else if(boreyModel && [boreyModel valid]) {
                    BoreyCustomAd * customAd = [[BoreyCustomAd alloc] initWithModelAndSize:boreyModel :strongSelf.customWidth :strongSelf.customHeight];
                    [strongSelf.listener onBoreyCustomAdFilled:customAd :error];
                } else {
                    NSString *errorMsg = @"Custom广告加载失败：数据解析失败";
                    [strongSelf.listener onBoreyCustomAdFilled: nil :[ErrorHelper create:4001 : errorMsg]];
                    [Logs e: errorMsg];
                }
            }
        });
        
    }];
}

- (instancetype)initWithAdSize:(CGFloat)width :(CGFloat)height {
    self = [super init];
    if (self) {
        self.customWidth = width;
        self.customHeight = height;
    }
    return self;
}


@end
