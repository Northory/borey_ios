//
//  Md5Helper.m
//  BoreyAdSDK
//
//  Created by Buer on 2024/12/13.
//

#import <Foundation/Foundation.h>
#import "Md5Helper.h"
#import <CommonCrypto/CommonDigest.h>

@implementation Md5Helper

+ (NSString *)md5:(NSString *)str {
    const char *cStr = [str UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), digest);
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }
    
    return output;
}

@end
