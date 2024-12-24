//
//  NSObject+BoreyModel.h
//  BoreyAdSDK
//
//  Created by Buer on 2024/12/7.
//

#import <Foundation/Foundation.h>
#import <BoreyAdSDK/SeatBid.h>
#import <BoreyAdSDK/Bid.h>

NS_ASSUME_NONNULL_BEGIN

@interface BoreyModel : NSObject

@property(nonatomic, retain) SeatBid *seatBids;
@property(nonatomic, assign) NSInteger code;
//自定义的错误信息
@property(nonatomic, strong) NSString * errorMsg;

-(instancetype)initWithDict: (NSDictionary *) dict;

-(BOOL) valid;

-(NSString *) getImg;

-(long) getPrice;

-(NSString *) getDeeplink;

-(NSString *) getTitle;

-(NSArray<NSString *> *) getImpTrackers;

-(NSArray<NSString *> *) getDpTrackers;

-(NSArray<NSString *> *) getClickTrackers;

-(Bid *) getBid;


@end

NS_ASSUME_NONNULL_END
