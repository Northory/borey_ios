//
//  NSObject+NetHelper.m
//  BoreyAdSDK
//
//  Created by Buer on 2024/12/7.
//

#import "Api.h"
#import "BoreyAdSDK.h"
#import "BoreyConfig.h"

@implementation Api

NSString *const BASE_URL = @"https://bid-adx.lanjingads.com/main?media=";

-(void) fetchAdInfo: (AdType)adType : (NSInteger *)width : (NSInteger *)height : (NSString *)tagId : (long) bidFloor : (void (BoreyModel * boreyModel, NSError *error)) callback {
    NSString *adImp = [BoreyAd getAdImp:adType];
    NSString *mediaId = BoreyAdSDK.sharedInstance.config.mediaId;
    NSString *urlStr = [BASE_URL stringByAppendingString:mediaId];
}

-(NSDictionary* ) getParams: (NSString *) adType : (NSString *) tagId : (NSInteger) width : (NSInteger) height : (long) bidFloor  {
    BoreyConfig *config = BoreyAdSDK.sharedInstance.config;
    NSInteger isTest = config.debug ? 1 : 0;
    NSDictionary * device = @{};
    NSDictionary * imp = @{
        
    };
    NSDictionary * app = @{};
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
- (void)doRequest:(NSString *)method :(NSString *)urlStr :(NSDictionary *)params :(void (^)(NSDictionary * responseDict, NSError * error))callback {
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
