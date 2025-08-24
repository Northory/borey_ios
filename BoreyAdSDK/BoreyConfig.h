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
@property(nonatomic, copy) NSString* idfa;
@property(nonatomic, copy) NSDictionary *params;

- (NSString *) getMediaId;
- (NSString *) getIdfa;
- (NSDictionary *) getSplashParams;
- (NSDictionary *) getParams;

@end

NS_ASSUME_NONNULL_END
