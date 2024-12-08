//
//  NSObject+ErrorCode.m
//  BoreyAdSDK
//
//  Created by Buer on 2024/12/7.
//

#import "ErrorHelper.h"

@implementation ErrorHelper

+ (NSError *) create:(NSInteger)code :(NSString *)desc {
    NSDictionary *info = @{NSLocalizedDescriptionKey : desc};
    NSError *error = [NSError errorWithDomain:@"BoreyDomain" code:code userInfo:info];
    return error;
}


@end
