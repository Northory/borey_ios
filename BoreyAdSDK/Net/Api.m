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
#import "Logs.h"
#import <WebKit/WebKit.h>

@implementation Api

NSString *const BASE_URL = @"https://bid-adx.lanjingads.com/main?media=";

+(void) fetchAdInfo: (AdType)adType : (NSInteger)width : (NSInteger )height : (NSString *)tagId : (long) bidFloor : (void (^)(BoreyModel * responseDict, NSError * error))callback {
    
    NSString *mediaId = BoreyAdSDK.sharedInstance.config.mediaId;
    NSString *urlStr = [BASE_URL stringByAppendingString:mediaId];
    NSDictionary *params = [self getParams:adType :tagId :width :height :bidFloor];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [Logs i: @"Request Url: %@", urlStr];
        [Logs dict:@"Request Params" : params];
        
        [self doRequest:@"POST" :urlStr :params :^(NSDictionary * response, NSError * error) {
            if (response) {
                BoreyModel *boreyModel = [[BoreyModel alloc] initWithDict:response];
                [Logs i: @"解析BoreyModel: %@", boreyModel];
                callback(boreyModel, nil);
            } else {
                callback(nil, error);
            }
        }];
        
    });
    
}

+ (NSDictionary* ) getParams: (AdType) adType : (NSString *) tagId : (NSInteger) width : (NSInteger) height : (long) bidFloor   {
    
    BoreyConfig *config = BoreyAdSDK.sharedInstance.config;
    NSString *biddingId = [Constants getBiddingId];
    NSString *requestId = [RandomHelper randomStr:32];
    NSString *adImp = [BoreyAd getAdImp:adType];
    NSInteger isTest = config.debug ? 1 : 0;
    // 创建一个UIWebView来获取User-Agent
    WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectZero];
    // 获取User-Agent
    NSString *userAgent = webView.customUserAgent;
    if (!userAgent || [userAgent length] <= 0) {
        userAgent = @"Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1";
    }
    
    //广告信息
    NSDictionary * imp = @{
        @"id": requestId,
        @"tagid": tagId,
        @"deepLink": @1,
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
    
    NSString *paid = [DeviceHelper getPAID];
    NSString *idfa = [config getIdfa];
    
    if (!idfa || [idfa length] <= 0) {
        idfa = did;
    }
    
    NSString *idfaMd5 = [Md5Helper md5: idfa];
    
    //paid
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
        @"imp": @[imp],
        @"app": app,
        @"test": @(isTest),
        @"tmax": @1000,
        @"id": biddingId
    };
    
    return params;
}



//⚠️注意子线程发起请求
+ (void)doRequest:(NSString *)method :(NSString *)urlStr :(NSDictionary *)params :(void (^)(NSDictionary * responseDict, NSError * error))callback {
    NSURL *url = [NSURL URLWithString:urlStr];
    NSError *paramsParseError;
    NSData *requestBody = [NSJSONSerialization dataWithJSONObject:params options:0 error: &paramsParseError];
    if (paramsParseError) {
        [Logs e: @"Parse params error: %@", paramsParseError.userInfo];
        callback(nil, paramsParseError);
        return;
    }
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod: method];
    [request setHTTPBody: requestBody];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [Logs i: @"Req: %@", request];
    [Logs i: @"Req Body: %@", requestBody];
     //创建会话配置
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
     //创建会话
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    // 发起请求
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            [Logs i:@"请求失败： %@", error.userInfo];
            callback(nil, error);
            return;
        }
        NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        [Logs i:@"响应成功： %@", string];
        // 解析响应数据
        if([response isKindOfClass:[NSHTTPURLResponse class]]) {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
            if (httpResponse.statusCode == 200) {
                if (data) {
                    NSError *parseError = nil;
                    NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
                    if (parseError) {
                        [Logs i:@"解析响应数据失败: %@", parseError.userInfo];
                        callback(nil, parseError);
                    } else {
                        [Logs i:@"解析响应数据成功: %@", responseDict];
                        callback(responseDict, nil);
                    }
                }
            } else {
                [Logs i:@"请求失败，code: %d, msg: ", httpResponse.statusCode, httpResponse.description];
            }
        }
    }];

    // 启动任务
    [dataTask resume];
}

@end
