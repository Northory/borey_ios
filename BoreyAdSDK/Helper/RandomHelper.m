//
//  NSObject+RandomHelper.m
//  BoreyAdSDK
//
//  Created by Buer on 2024/12/8.
//

#import "RandomHelper.h"
#import <stdlib.h>
#import "Logs.h"

@implementation RandomHelper

NSString const* charSet = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";

+ (NSString *)randomStr:(NSInteger)length {
    NSMutableString *randomString = [NSMutableString stringWithCapacity:length];
    NSUInteger charSetLength = [charSet length];
    for (NSUInteger i = 0; i < length; i++) {
        NSUInteger randomIndex = arc4random_uniform((u_int32_t)charSetLength);
        unichar randomChar = [charSet characterAtIndex:randomIndex];
        [randomString appendFormat:@"%C", randomChar];
    }
    return [randomString copy];
}

+ (NSString *)randomUUID {
    CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
    NSString *uuidString = (__bridge_transfer NSString *)CFUUIDCreateString(kCFAllocatorDefault, uuid);
    CFRelease(uuid);
    return uuidString;
}

+ (BOOL)isHit:(CGFloat)rate {
    float randomFloat = (float)arc4random() / UINT32_MAX;
    BOOL res = randomFloat < rate;
    [Logs i:@"Hit Strategy: %d", res];
    return res;
}

@end
