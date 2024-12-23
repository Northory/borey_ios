//
//  NSObject+BoreyModel.m
//  BoreyAdSDK
//
//  Created by Buer on 2024/12/7.
//

#import "BoreyModel.h"
#import "SeatBid.h"
#import "Bid.h"
#import "Image.h"
#

@implementation BoreyModel

- (instancetype)initWithDict:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        //解析数据
        _seatBids = [SeatBid new];
        if (dict) {
            NSMutableArray * bids = [NSMutableArray new];
            _seatBids.bids = bids;
            NSArray * seatbid = dict[@"seatbid"];
            _code = [dict[@"code"] integerValue];
            if (_code == 0 && seatbid) {
                for (NSDictionary * bidsObj in seatbid) {
                    if (bidsObj) {
                        NSArray * bidDicts = bidsObj[@"bid"];
                        if (bidDicts) {
                            for (NSDictionary * bidDict in bidDicts) {
                                Bid * bid = [[Bid alloc] initWithDict: bidDict];
                                [bids addObject:bid];
                            }
                        }
                    }
                }
            } else {
                _errorMsg = [NSString stringWithFormat:@"解析数据失败 -> code: %ld, 也有可能seatbid为空", _code];
            }
        }
    }
    return self;
}

- (BOOL) valid {
    return _code == 0;
}

-(Bid *) getBid {
    if (_seatBids && _seatBids.bids && _seatBids.bids.count > 0) {
        return _seatBids.bids[0];
    }
    return nil;
}

- (long) getPrice {
    Bid * bid = [self getBid];
    if(bid) {
        return bid.price;
    }
    return 0;
}

- (NSString *)getImg {
    Bid * bid = [self getBid];
    if(bid && bid.images && bid.images.count > 0) {
        NSString * url = bid.images[0].url;
        if (url) {
            return url;
        }
    }
    return @"";
}

- (NSString *)getTitle {
    Bid * bid = [self getBid];
    if (bid && bid.title){
        return bid.title;
    }
    return @"";
}

-(NSString *)getDeeplink {
    Bid * bid = [self getBid];
    if (bid && bid.deepLink){
        return bid.deepLink;
    }
    return @"";
}

-(NSArray<NSString *> *)getDpTrackers {
    Bid * bid = [self getBid];
    if (bid && bid.dpTrackers){
        return bid.dpTrackers;
    }
    return nil;
}

-(NSArray<NSString *> *)getImpTrackers {
    Bid * bid = [self getBid];
    if (bid && bid.impTrackers){
        return bid.impTrackers;
    }
    return nil;
}


- (NSArray<NSString *> *)getClickTrackers {
    Bid * bid = [self getBid];
    if (bid && bid.clickTrackers){
        return bid.clickTrackers;
    }
    return nil;
}

@end
