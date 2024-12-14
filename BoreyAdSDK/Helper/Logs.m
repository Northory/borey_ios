//
//  LogHelper.m
//  BoreyAdSDK
//
//  Created by Buer on 2024/12/14.
//

#import <Foundation/Foundation.h>
#import "Logs.h"

NSString *const ITAG = @"BoreyI";
NSString *const ETAG = @"BoreyE";

@implementation Logs

+ (void) i:(NSString *)msg, ... {
    va_list args;
    va_start(args, msg);
    NSString *logString = [[NSString alloc] initWithFormat:msg arguments:args];
    NSLog(@"%@ -> %@", ITAG, logString);
}

+ (void)e:(NSString *)msg, ... {
    va_list args;
    va_start(args, msg);
    NSString *logString = [[NSString alloc] initWithFormat:msg arguments:args];
    NSLog(@"%@ -> %@", ETAG, logString);
}

+ (void)dict:(NSString *)label :(NSDictionary *)dict {
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&error];
    if (!jsonData) {
        [Logs i: @"打印dict失败：%@", error.localizedDescription];
        return;
    }
    NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    [Logs i: @"%@: %@", label, jsonStr];
}

@end
