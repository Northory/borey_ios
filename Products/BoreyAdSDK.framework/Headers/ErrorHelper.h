//
//  NSObject+ErrorCode.h
//  BoreyAdSDK
//
//  Created by Buer on 2024/12/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ErrorHelper: NSObject

+(NSError *) create: (NSInteger) code : (NSString *) desc;

@end

NS_ASSUME_NONNULL_END
