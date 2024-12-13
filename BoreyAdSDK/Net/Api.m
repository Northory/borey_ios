//
//  NSObject+NetHelper.m
//  BoreyAdSDK
//
//  Created by Buer on 2024/12/7.
//

#import "Api.h"
#import "BoreyAdSDK.h"
#import "BoreyConfig.h"
#import "PreferenceHelper.h"
#import "Constants.h"
#import "RandomHelper.h"
#import <UIKit/UIKit.h>
#import "DeviceHelper.h"
#import "Md5Helper.h"

@implementation Api

NSString *const BASE_URL = @"https://bid-adx.lanjingads.com/main?media=";

+(void) fetchAdInfo: (AdType)adType : (NSInteger)width : (NSInteger )height : (NSString *)tagId : (long) bidFloor : (void (BoreyModel * boreyModel, NSError *error)) callback {
    
    NSString *mediaId = BoreyAdSDK.sharedInstance.config.mediaId;
    NSString *urlStr = [BASE_URL stringByAppendingString:mediaId];
    NSURL *url = [NSURL URLWithString:urlStr];
    //获取user agent
    NSURLRequest *requestObjForUserAgent = [NSURLRequest requestWithURL: url];
    NSString *userAgent = [requestObjForUserAgent valueForHTTPHeaderField:@"User-Agent"];
    NSDictionary *params = [self getParams:adType :tagId :width :height :bidFloor :userAgent];
    [self doRequest:@"POST" :urlStr :params :^(NSDictionary * response, NSError * error) {
        if (response) {
            BoreyModel *boreyModel = [BoreyModel initWithDict: response];
        } else {
            
        }
    }];
    
}

+ (NSDictionary* ) getParams: (AdType) adType : (NSString *) tagId : (NSInteger) width : (NSInteger) height : (long) bidFloor : (NSString *) userAgent  {
    
    BoreyConfig *config = BoreyAdSDK.sharedInstance.config;
    NSString *biddingId = [Constants getBiddingId];
    NSString *requestId = [RandomHelper randomStr:32];
    NSString *adImp = [BoreyAd getAdImp:adType];
    NSInteger isTest = config.debug ? 1 : 0;
    
    //广告信息
    NSDictionary * imp = @{
        @"id": requestId,
        @"tagid": tagId,
        @"deeplink": @1,
        @"impType": adImp,
        @"secure": @1,
        @"width": @(width),
        @"height": @(height),
        @"bidfloor": @(bidFloor),
    };
    
    //设备信息
    UIScreen *mainScreen = [UIScreen mainScreen];
    CGRect screenBounds = mainScreen.bounds;
    CGFloat screenWidth = screenBounds.size.width;
    CGFloat screenHeight = screenBounds.size.height;
    //运营商信息
    NSString *carrier = [DeviceHelper getCurrentCarrierName];
    CGFloat screenScale = [UIScreen mainScreen].scale;
    NSString *model = [DeviceHelper getDeviceModel];
    CGFloat ppi = [DeviceHelper getPixelsPerInch];
    NSString *osv = [[UIDevice currentDevice] systemVersion];
    NSString *did = [DeviceHelper getDeviceIdentifier];
    NSString *didMd5 = [Md5Helper md5: did];
    NSString *lang = [DeviceHelper getCurrentLanguage];
    NSString *idfa = [DeviceHelper getIdfa];
    NSString *idfaMd5 = [Md5Helper md5: idfa];
    NSString *paid = [DeviceHelper getPAID];
    NSDictionary * device = @{
        @"ua": userAgent,
        @"w": @(screenWidth),
        @"h": @(screenHeight),
        @"devicetype":@(4),
        @"carrier": carrier,
        @"pxratio": @(screenScale),
        @"model": model,
        @"os":@"ios",
        @"osv":osv,
        @"ppi":@(ppi),
        @"js": @(1),
        @"did": did,
        @"didmd5": didMd5,
        @"region": @"CN",
        @"lang": lang,
        @"idfa": idfa,
        @"idfa_md5": idfaMd5,
        @"paid": paid
    };
    
    //app信息
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *appName = [bundle objectForInfoDictionaryKey:@"CFBundleName"];
    NSString *bundleIdentifier = [bundle bundleIdentifier];
    NSString *appVersion = [bundle objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    NSDictionary * app = @{
        @"name" : appName,
        @"bundle" : bundleIdentifier,
        @"ver" : appVersion
    };
    
    NSDictionary * params = @{
        @"device": device,
        @"imp": imp,
        @"app": app,
        @"test": @(isTest),
        @"tmax": @1000,
    };
    
    return params;
}



//⚠️注意子线程发起请求
+ (void)doRequest:(NSString *)method :(NSString *)urlStr :(NSDictionary *)params :(void (^)(NSDictionary * responseDict, NSError * error))callback {
    NSURL *url = [NSURL URLWithString:urlStr];
    NSData *requestBody = [NSJSONSerialization dataWithJSONObject:params options:0 error:nil];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = method;
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    request.HTTPBody = requestBody;
    // 创建会话配置
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    // 创建会话
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    // 发起请求
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"请求失败: %@", error);
            callback(nil, error);
            return;
        }

        // 解析响应数据
        if (data) {
            NSError *parseError = nil;
            NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
            if (parseError) {
                NSLog(@"解析响应数据失败: %@", parseError);
                callback(nil, parseError);
            } else {
                callback(responseDict, nil);
                NSLog(@"响应数据: %@", responseDict);
            }
        }
    }];

    // 启动任务
    [dataTask resume];
}

@end
