//
//  NSObject+RandomHelper.h
//  BoreyAdSDK
//
//  Created by Buer on 2024/12/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RandomHelper : NSObject

+ (NSString *)randomStr: (NSInteger) length;

/**
 * 获取随机UUID格式字符串
 * @return 返回标准UUID格式的字符串，如：550e8400-e29b-41d4-a716-446655440000
 */
+ (NSString *)randomUUID;

+ (BOOL) isHit: (CGFloat) rate;

@end

NS_ASSUME_NONNULL_END
