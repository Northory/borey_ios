#import "BoreyAdSDK.h"

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
    
    _config = config;
    _initialized = YES;
    
    //biddingId生成
    if (completion) {
        NSError * error = [ErrorHelper create: 0 : @"初始化成功"];
        completion(YES, error);
    }
}

- (instancetype) init {
    self = [super self];
    if (self) {
        
    }
    return self;
}

@end
