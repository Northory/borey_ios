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


@interface BoreySplashAdFiller()


@end

@implementation BoreySplashAdFiller

-(void)fill:(NSString *)tagId bidFloor:(long)bidFloor {
    //设备信息
    UIScreen *mainScreen = [UIScreen mainScreen];
    CGRect screenBounds = mainScreen.bounds;
    NSInteger screenWidth = (NSInteger)screenBounds.size.width;
    NSInteger screenHeight = (NSInteger)screenBounds.size.height;
    [Api fetchAdInfo:Splash :screenWidth :screenHeight :@"25" :10 :^(BoreyModel * boreyModel, NSError * error) {
        
    }];
}

@end
