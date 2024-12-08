//
//  PreferenceHelper.m
//  BoreyAdSDK
//
//  Created by Buer on 2024/12/8.
//

#import <Foundation/Foundation.h>
#import "PreferenceHelper.h"

@implementation PreferenceHelper

static PreferenceHelper *_sharedInstance = nil;

static dispatch_once_t onceToken;

+(instancetype)sharedInstance {
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _userDefault = [NSUserDefaults standardUserDefaults];
        NSLog(@"_userDefault inited");
    }
    return self;
}

- (NSString *)getStr:(NSString *)key {
    NSLog(@"_userDefault getStr %@", key);
    return [_userDefault objectForKey:key];
}

- (void)saveStr:(NSString *)key :(NSString *)value {
    
    [_userDefault setObject:value forKey:key];
    BOOL saveRes = [_userDefault synchronize];
    if (saveRes) {
        NSLog(@"_userDefault saveStr %@, %@", key, value);
    }
}

@end
