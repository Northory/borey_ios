//
//  BoreyBannerAdFiller.h
//  BoreyAdSDK
//
//  Created by Buer on 2025/1/26.
//


#import <Foundation/Foundation.h>
#import <BoreyAdSDK/BoreyBannerAd.h>
#import <UIKit/UIKit.h>


@protocol BoreyBannerAdFillListener <NSObject>

-(void) onBoreyBannerAdFilled: (nullable BoreyBannerAd *) bannerAd : (nullable NSError *) error;

@end

@interface BoreyBannerAdFiller : NSObject

@property(nonatomic, weak) id<BoreyBannerAdFillListener> listener;
@property(nonatomic, assign) CGFloat bannerWidth;
@property(nonatomic, assign) CGFloat bannerHeight;

-(instancetype) initWithAdSize:(CGFloat)width :(CGFloat)height;

-(void) fill: (NSString *) tagId : (long) bidFloor;

@end
