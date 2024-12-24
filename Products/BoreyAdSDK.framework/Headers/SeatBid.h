//
//  NSObject+SeatBid.h
//  BoreyAdSDK
//
//  Created by Buer on 2024/12/7.
//

#import <Foundation/Foundation.h>
#import <BoreyAdSDK/Bid.h>

NS_ASSUME_NONNULL_BEGIN

@interface SeatBid : NSObject

@property(nonatomic, retain)NSArray<Bid *> *bids;

@end

NS_ASSUME_NONNULL_END
