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
#import "NetworkHelper.h"


@implementation Api

NSString *const BASE_URL = @"http://bid-adx.lanjingads.com/main?media=";

+(void) fetchAdInfo: (AdType)adType : (NSInteger)width : (NSInteger )height : (NSString *)tagId : (long) bidFloor : (void (^)(BoreyModel * responseDict, NSError * error))callback {
    
    BoreyConfig *config = BoreyAdSDK.sharedInstance.config;
    NSString *mediaId;
    if (config && config.mediaId) {
        mediaId = config.mediaId;
    }
    if(!mediaId) {
        callback(nil, [ErrorHelper create:1001 :@"media id 配置异常"]);
        return;
    }

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


+ (void) report: (NSArray<NSString *> *) urls :  (long) price : (ReportType) reportType : (AdType) adType {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (NSString *url in urls) {
            NSString *encodePrice = [NSString stringWithFormat:@"%ld", price];
            NSString *desc = [self getReportDesc: reportType];
            NSString *adName = [BoreyAd getAdTypeName:adType];
            NSString *realUrl = [url stringByReplacingOccurrencesOfString:@"${AUCTION_PRICE}" withString: encodePrice];
            [self doRequest:@"GET" :realUrl : nil :^(NSDictionary * response, NSError * error) {
                if (error) {
                    [Logs e: @"%@ 的 %@ 上报失败: %@", adName, desc, realUrl];
                } else {
                    [Logs i: @"%@ 的 %@ 上报成功: %@", adName, desc, realUrl];
                }
            }];
        }
    });
}

+ (NSString *) getReportDesc: (ReportType) reportType {
    switch (reportType) {
        case Imp:
            return @"Imp";
        case Click:
            return @"Click";
        case Dp:
            return @"Dp";
    }
    return @"Unknown";
}

+ (NSDictionary* ) getParams: (AdType) adType : (NSString *) tagId : (NSInteger) width : (NSInteger) height : (long) bidFloor   {
    
    BoreyConfig *config = BoreyAdSDK.sharedInstance.config;
    NSString *biddingId = [RandomHelper randomUUID];
    NSString *requestId = [RandomHelper randomUUID];
    NSString *adImp = [BoreyAd getAdImp:adType];
    // 创建一个UIWebView来获取User-Agent
    WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectZero];
    // 获取User-Agent
    NSString *userAgent = [PreferenceHelper.sharedInstance getStr:PerfKeyUserAgent];
    
    
    if (!userAgent || [userAgent length] <= 0) {
        userAgent = webView.configuration.applicationNameForUserAgent;
    }
    
    [Logs i: @"userAgent: %@", userAgent];
    
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
        idfa = @"00000000-0000-0000-0000-000000000000";
    }
    
    NSString *idfaMd5 = [Md5Helper md5: idfa];
    NSString *sysU = [DeviceHelper getSysU];
    NSString *sysTime = [DeviceHelper bootTimeInSec];
    NSInteger netType = [NetworkHelper getNetworkType];
    
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
        @"paid": paid,
        @"update_mark": sysU,
        @"boot_mark": sysTime,
        @"connectiontype": @(netType)
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
        @"test": @0,
        @"tmax": @1000,
        @"id": biddingId
    };
    
    return params;
}



//⚠️注意子线程发起请求
+ (void)doRequest:(NSString *)method :(NSString *)urlStr :(NSDictionary *)params :(void (^)(NSDictionary * responseDict, NSError * error))callback {
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    if (params) {
        NSError *paramsParseError;
        NSData *requestBody = [NSJSONSerialization dataWithJSONObject:params options:0 error: &paramsParseError];
        if (paramsParseError) {
            [Logs e: @"Parse params error: %@", paramsParseError.userInfo];
            callback(nil, paramsParseError);
            return;
        }
        [request setHTTPBody: requestBody];
    }
    [request setHTTPMethod: method];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
     //创建会话配置
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
     //创建会话
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    // 发起请求
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            [Logs e:@"请求失败： %@", error.userInfo];
            callback(nil, error);
            return;
        }

        // 解析响应数据
        if([response isKindOfClass:[NSHTTPURLResponse class]]) {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
            if (httpResponse.statusCode == 200) {
                if (data) {
                    if (data.length > 0) {
                        NSError *parseError = nil;
                        NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
                        if (parseError) {
                            NSString *errorStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                            [Logs e:@"解析响应数据失败: %@, 原始错误数据： %@", parseError.userInfo, errorStr];
                            callback(nil, parseError);
                        } else {
                            [Logs dict:@"响应数据" :responseDict];
                            callback(responseDict, nil);
                        }
                    } else {
                        [Logs i:@"响应成功，且无返回数据"];
                        callback(nil, nil);
                    }
                } else {
                    [Logs e:@"请求失败，code: %d, msg: ", httpResponse.statusCode, httpResponse.description];
                    callback(nil, [ErrorHelper create:httpResponse.statusCode : @"网络错误, 响应数据为空"]);
                }
            } else {
                [Logs e:@"请求失败，code: %d, msg: ", httpResponse.statusCode, httpResponse.description];
                callback(nil, [ErrorHelper create:httpResponse.statusCode : @"请求失败, 网络错误"]);
            }
        } else {
            callback(nil, [ErrorHelper create: -1 : @"请求失败, 网络错误"]);
        }
    }];

    // 启动任务
    [dataTask resume];
}

@end
