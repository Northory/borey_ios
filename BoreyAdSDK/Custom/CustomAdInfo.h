//
//  CustomAdInfo.h
//  BoreyAdSDK
//
//  Created by Buer on 2025/3/9.
//

#import <Foundation/Foundation.h>
#import <BoreyAdSDK/BoreyAd.h>
#import <BoreyAdSDK/BoreyModel.h>
#import <BoreyAdSDK/Image.h>

@interface CustomAdInfo : NSObject

@property(nonatomic, strong) BoreyModel * model;

-(NSString *) getTitle;
-(NSString *) getDesc;
-(NSString *) getIconUrl;
-(NSArray<Image *> *) getImages;
-(long) getEcpm;
-(instancetype) initWithModel: (BoreyModel *) model;

@end
