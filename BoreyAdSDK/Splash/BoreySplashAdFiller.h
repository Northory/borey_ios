//
//  NSObject+BoreySplashAdFiller.h
//  BoreyAdSDK
//
//  Created by Buer on 2024/12/1.
//

#import <Foundation/Foundation.h>
#import <BoreyAdSDK/BoreySplashAd.h>

NS_ASSUME_NONNULL_BEGIN

@protocol BoreySplashAdFillListener <NSObject>

-(void) onSplashAdFilled: (BoreySplashAd *) splashAd : (NSError *) error;

@end

@interface BoreySplashAdFiller : NSObject

@property(nonatomic, strong) id<BoreySplashAdFillListener> listener;

- (void) fill: (NSString *) tagId bidFloor: (long) bidFloor;

@end

NS_ASSUME_NONNULL_END
