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
@property(nonatomic, copy) NSString* paid;

- (NSString *) getMediaId;
- (NSString *) getIdfa;
- (NSString *) getPaid;

@end

NS_ASSUME_NONNULL_END