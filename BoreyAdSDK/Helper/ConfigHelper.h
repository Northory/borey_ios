//
//  ConfigHelper.h
//  BoreyAdSDK
//
//  Created by Buer on 2024/12/14.
//

#import <Foundation/Foundation.h>
#import "BoreyAdSDK/BoreyAd.h"

NS_ASSUME_NONNULL_BEGIN

@interface ConfigHelper : NSObject

+ (BOOL) isAccidentalTouch: (AdType) adType : (NSString *) scene;

+ (NSDictionary *) getAdConfig: (AdType) adType : (NSString *) scene;

+ (BOOL) showInnerLog;

@end

NS_ASSUME_NONNULL_END
