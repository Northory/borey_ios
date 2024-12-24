//
//  NSObject+Image.h
//  BoreyAdSDK
//
//  Created by Buer on 2024/12/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Image : NSObject

@property(nonatomic, copy) NSString *url;
@property(nonatomic, assign) NSInteger width;
@property(nonatomic, assign) NSInteger height;

@end

NS_ASSUME_NONNULL_END
