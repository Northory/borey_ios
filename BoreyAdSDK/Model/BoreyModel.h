//
//  NSObject+BoreyModel.h
//  BoreyAdSDK
//
//  Created by Buer on 2024/12/7.
//

#import <Foundation/Foundation.h>
#import "SeatBid.h"
#import "Bid.h"

NS_ASSUME_NONNULL_BEGIN

@interface BoreyModel : NSObject

@property(nonatomic, retain) SeatBid *seatBids;

-(instancetype)initWithDict: (NSDictionary *) dict;

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
