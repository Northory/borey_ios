//
//  LogHelper.h
//  BoreyAdSDK
//
//  Created by Buer on 2024/12/14.
//
#import <Foundation/Foundation.h>

extern NSString *const ITAG;
extern NSString *const ETAG;

@interface Logs : NSObject

+ (void) i: (NSString *) msg, ...;
+ (void) e: (NSString *) msg, ...;
+ (void) dict: (NSString *) label : (NSDictionary *) dict;

@end
