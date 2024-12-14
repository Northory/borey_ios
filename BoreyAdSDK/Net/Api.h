//
//  NSObject+NetHelper.h
//  BoreyAdSDK
//
//  Created by Buer on 2024/12/7.
//

#import <Foundation/Foundation.h>
#import "BoreyAd.h"
#import "BoreyModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface Api : NSObject

+(void) fetchAdInfo: (AdType)adType : (NSInteger )width : (NSInteger )height : (NSString *)tagId : (long) bidFloor : (void (^)(BoreyModel *, NSError *)) callback ;

+(void) doRequest:(NSString *) method : (NSString *) urlStr : (NSDictionary *) params : (void (^)(NSDictionary *, NSError *)) callback;

@end

NS_ASSUME_NONNULL_END
