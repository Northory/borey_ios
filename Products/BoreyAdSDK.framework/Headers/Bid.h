//
//  NSObject+Bid.h
//  BoreyAdSDK
//
//  Created by Buer on 2024/12/7.
//

#import <Foundation/Foundation.h>
#import <BoreyAdSDK/Image.h>

NS_ASSUME_NONNULL_BEGIN

@interface Bid : NSObject

@property(nonatomic, retain) NSArray<NSString *> *clickTrackers;
@property(nonatomic, retain) NSArray<NSString *> *impTrackers;
@property(nonatomic, retain) NSArray<NSString *> *dpTrackers;
@property(nonatomic, retain) NSArray<Image *> *images;
@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *deeplink;
@property(nonatomic, copy) NSString *desc;
@property(nonatomic, assign) long price;

- (instancetype)initWithDict:(NSDictionary *)dictionary;


@end

NS_ASSUME_NONNULL_END
