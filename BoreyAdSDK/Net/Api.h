//
//  NSObject+NetHelper.h
//  BoreyAdSDK
//
//  Created by Buer on 2024/12/7.
//

#import <Foundation/Foundation.h>
#import "BoreyAd.h"
#import "BoreyModel.h"


typedef NS_ENUM(NSInteger, ReportType) {
    Imp = 1,
    Click,
    Dp
};

NS_ASSUME_NONNULL_BEGIN

@interface Api : NSObject

+(void) fetchAdInfo: (AdType)adType : (NSInteger )width : (NSInteger )height : (NSString *)tagId : (long) bidFloor : (void (^)(BoreyModel *, NSError *)) callback ;

+(void) doRequest:(NSString *) method : (NSString *) urlStr : (nullable NSDictionary *) params : (void (^)(NSDictionary *, NSError *)) callback;

+(void) report: (NSArray<NSString *> *) urls :  (long) price : (ReportType) reportType : (AdType) adType;

@end

NS_ASSUME_NONNULL_END
