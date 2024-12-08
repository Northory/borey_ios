//
//  NSObject+BoreyConfig.h
//  BoreyAdSDK
//
//  Created by Buer on 2024/12/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BoreyConfig : NSObject

@property(nonatomic, copy) NSString* mediaId;
@property(nonatomic, assign) BOOL debug;

@end

NS_ASSUME_NONNULL_END
