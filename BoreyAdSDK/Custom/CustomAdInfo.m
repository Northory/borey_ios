//
//  CustomAdInfo.m
//  BoreyAdSDK
//
//  Created by Buer on 2025/3/9.
//

#import <Foundation/Foundation.h>
#import "CustomAdInfo.h"

@interface CustomAdInfo()


@end

@implementation CustomAdInfo

- (instancetype)initWithModel:(BoreyModel *)model {
    self = [super init];
    if (self) {
        self.model = model;
    }
    return self;
}

- (NSString *)getDesc {
    if(_model) {
        return [_model getDesc];
    }
    return @"";
}

- (NSString *) getTitle {
    if(_model) {
        return [_model getTitle];
    }
    return @"";
}

- (long)getEcpm {
    if(_model) {
        return [_model getPrice];
    }
    return 0;
}

- (NSString *)getIconUrl {
    if(_model) {
        return [_model getBrandLogo];
    }
    return @"";
}

- (NSArray<Image *> *)getImages {
    if(_model) {
        return [_model getImages];
    }
    return nil;
}

@end
