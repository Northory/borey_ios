//
//  BoreyCustomAdFiller.h
//  BoreyAdSDK
//
//  Created by Buer on 2025/3/9.
//

#import <Foundation/Foundation.h>
#import <BoreyAdSDK/BoreyModel.h>
#import <BoreyAdSDK/BoreyCustomAd.h>

@protocol BoreyCustomAdFillListener <NSObject>

-(void) onBoreyCustomAdFilled: (nullable BoreyCustomAd *) customAd : (nullable NSError *) error;

@end

@interface BoreyCustomAdFiller : NSObject

@property(nonatomic, weak) id<BoreyCustomAdFillListener> listener;
@property(nonatomic, assign) CGFloat customWidth;
@property(nonatomic, assign) CGFloat customHeight;

-(instancetype) initWithAdSize:(CGFloat)width :(CGFloat)height;

-(void) fill: (NSString *) tagId : (long) bidFloor;



@end

