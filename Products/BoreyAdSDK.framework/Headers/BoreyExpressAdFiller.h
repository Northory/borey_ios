//
//  BoreyExpressAdFiller.h
//  BoreyAdSDK
//
//  Created by Buer on 2025/1/26.
//


#import <Foundation/Foundation.h>
#import <BoreyAdSDK/BoreyExpressAd.h>
#import <UIKit/UIKit.h>


@protocol BoreyExpressAdFillListener <NSObject>

-(void) onBoreyExpressAdFilled: (nullable BoreyExpressAd *) expressAd : (nullable NSError *) error;

@end

@interface BoreyExpressAdFiller : NSObject

@property(nonatomic, strong) id<BoreyExpressAdFillListener> listener;

- (void) fill: (NSString *) tagId : (long) bidFloor: (CGFloat) width : (CGFloat) height;

@end
