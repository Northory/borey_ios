#import "BoreyAdSDK.h"
#import "Helper/PreferenceHelper.h"
#import "Common/Constants.h"
#import "Helper/RandomHelper.h"
#import "Common/DeviceHelper.h"

@implementation BoreyAdSDK

static BoreyAdSDK *_sharedInstance = nil;
static dispatch_once_t onceToken;

+ (instancetype)sharedInstance {
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}

- (void)initWithConfigAndCompletion:(BoreyConfig *)config :(void (^)(BOOL, NSError * _Nonnull))completion {
    if (_initialized) {
        return;
    }
    
    if(!config) {
        if (completion) {
            NSError * error = [ErrorHelper create:1000 : @"初始化配置异常"];
            completion(NO, error);
        }
        return;
    }
    
    if (!config.mediaId) {
        if (completion) {
            NSError * error = [ErrorHelper create:1001 : @"mediaId配置异常"];
            completion(NO, error);
        }
        return;
    }
    
    NSString *biddingId = [PreferenceHelper.sharedInstance getStr: PerfKeyUserBiddingId];
    NSLog(@"Borey-Init -> biddingId: %@", biddingId);
    if (!biddingId || biddingId.length != 32) {
        NSString *userBiddingId = [RandomHelper randomStr:32];
        NSLog(@"Borey-Init -> userBiddingId: %@", userBiddingId);
        [PreferenceHelper.sharedInstance saveStr:PerfKeyUserBiddingId : userBiddingId];
    }
    
    [DeviceHelper requestIDFA];
    
    _config = config;
    _initialized = YES;
    
    //biddingId生成
    if (completion) {
        NSError * error = [ErrorHelper create: 0 : @"初始化成功"];
        completion(YES, error);
    }
}

-(NSString *) getBiddingId {
    return [PreferenceHelper.sharedInstance getStr: PerfKeyUserBiddingId];;
}

- (instancetype) init {
    self = [super self];
    if (self) {
        
    }
    return self;
}

@end
