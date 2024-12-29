#import "BoreyAdSDK.h"
#import "Helper/PreferenceHelper.h"
#import "Common/Constants.h"
#import "Helper/RandomHelper.h"
#import "Common/DeviceHelper.h"
#import "Logs.h"

@implementation BoreyAdSDK

static BoreyAdSDK *_sharedInstance = nil;
static dispatch_once_t onceToken;

+ (instancetype)sharedInstance {
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}

- (void)initWithConfigAndCompletion:(BoreyConfig *)config :(void (^)(BOOL, NSError * ))completion {
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
    if (!biddingId || biddingId.length != 32) {
        NSString *userBiddingId = [RandomHelper randomStr:32];
        [Logs i: @"biddingId: %@", biddingId];
        [PreferenceHelper.sharedInstance saveStr:PerfKeyUserBiddingId : userBiddingId];
    }

    
    _config = config;
    _initialized = YES;
    
    //biddingId生成
    if (completion) {
        completion(YES, nil);
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
