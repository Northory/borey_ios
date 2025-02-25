//
//  NSObject+Bid.m
//  BoreyAdSDK
//
//  Created by Buer on 2024/12/7.
//

#import "Bid.h"
#import "Image.h"

@implementation Bid

- (instancetype)initWithDict:(NSDictionary *)dictionary {
    self = [super init];
    if (self && dictionary) {
        _desc = dictionary[@"desc"];
        _deeplink = dictionary[@"deeplink"];
        _title = dictionary[@"title"];
        _ldp = dictionary[@"ldp"];
        _ulk_scheme = dictionary[@"ulk_scheme"];
        _universal_link = dictionary[@"universal_link"];
        _desc = dictionary[@"desc"];
        _brandLogo = dictionary[@"brand_logo"];
        _universal_link = dictionary[@"universal_link"];
        NSNumber *priceNumber = dictionary[@"price"];
        _price = [priceNumber longValue];
        
        NSArray *imgArr = dictionary[@"image"];
        NSMutableArray *imgs = [NSMutableArray new];
        _images = imgs;
        if (imgArr) {
            for (NSDictionary *imgDict in imgArr) {
                Image *img = [Image new];
                img.url = imgDict[@"url"];
                NSNumber *widthNumber = imgDict[@"width"];
                NSNumber *heightNumber = imgDict[@"height"];
                img.width = [widthNumber integerValue];
                img.height = [heightNumber integerValue];
                [imgs addObject: img];
            }
        }
        
        NSMutableArray *clickTrackers = [NSMutableArray new];
        NSMutableArray *impTrackers = [NSMutableArray new];
        NSMutableArray *dpTrackers = [NSMutableArray new];
        _impTrackers = impTrackers;
        _clickTrackers = clickTrackers;
        _dpTrackers = dpTrackers;
        
        NSArray *clickArr = dictionary[@"clicktrackers"];
        NSArray *impArr = dictionary[@"imptrackers"];
        NSArray *dpArr = dictionary[@"dp_tracking"];
        
        if (clickArr) {
            for (NSString * clickUrl in clickArr) {
                [clickTrackers addObject:clickUrl];
            }
        }
        if (impArr) {
            for (NSString * impUrl in impArr) {
                [impTrackers addObject:impUrl];
            }
        }
        if (dpArr) {
            for (NSString * dpUrl in dpTrackers) {
                [dpTrackers addObject:dpUrl];
            }
        }
    }
    return self;
}

@end
