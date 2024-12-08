//
//  PreferenceHelper.h
//  BoreyAdSDK
//
//  Created by Buer on 2024/12/8.
//

#import <Foundation/Foundation.h>

@interface PreferenceHelper : NSObject

@property(nonatomic, retain) NSUserDefaults *userDefault;

+(instancetype) sharedInstance;

-(NSString *) getStr: (NSString *) key;

-(void)saveStr: (NSString *) key : (NSString *) value;


@end
