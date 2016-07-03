//
//  SunbeamAFServiceContext.m
//  Pods
//
//  Created by sunbeam on 16/6/29.
//
//

#import "SunbeamAFServiceContext.h"

#import "SunbeamAFServiceFactory.h"

@interface SunbeamAFServiceContext()

// 网络是否可达
@property (nonatomic, assign, readwrite) BOOL networkIsReachable;

// 当前网络状态
@property (nonatomic, assign, readwrite) SAFNetworkStatus networkStatus;

@end

@implementation SunbeamAFServiceContext

// 单例
SAF_singleton_implementation(SunbeamAFServiceContext)

- (instancetype)init
{
    if (self = [super init]) {
        // 初始化网络监听
        [self initNetworkService];
    }
    
    return self;
}

// 初始化网络服务
- (void) initNetworkService
{
    self.networkStatus = SAFNetworkStatusUnknown;
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                self.networkStatus = SAFNetworkStatusUnknown;
                break;
                
            case AFNetworkReachabilityStatusNotReachable:
                self.networkStatus = SAFNetworkStatusNotReachable;
                break;
                
            case AFNetworkReachabilityStatusReachableViaWWAN:
                self.networkStatus = SAFNetworkStatusReachableViaWWAN;
                break;
                
            case AFNetworkReachabilityStatusReachableViaWiFi:
                self.networkStatus = SAFNetworkStatusReachableViaWiFi;
                break;
                
            default:
                break;
        }
        
        @synchronized(self)
        {
            NSNotification *notificationPost = [NSNotification notificationWithName:SAF_NETWORK_STATUS_CHANGED_NOTIFICATION_NAME object:self userInfo:nil];
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotification:notificationPost];
            });
        }
    }];
}

// 设置service factory 代理
- (void) setSAFServiceFactoryDelegate:(id<SAFServiceFactoryProtocol>) serviceFactoryDelegate
{
    [SunbeamAFServiceFactory sharedSunbeamAFServiceFactory].delegate = serviceFactoryDelegate;
}

- (BOOL)networkIsReachable
{
    if (self.networkStatus == SAFNetworkStatusUnknown) {
        return YES;
    }
    
    return [[AFNetworkReachabilityManager sharedManager] isReachable];
}

@end
