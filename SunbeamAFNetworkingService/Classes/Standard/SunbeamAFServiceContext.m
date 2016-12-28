//
//  SunbeamAFServiceContext.m
//  Pods
//
//  Created by sunbeam on 16/6/29.
//
//

#import "SunbeamAFServiceContext.h"
#import "SunbeamAFServiceFactory.h"
#import <AFNetworking/AFNetworking.h>

typedef void(^NetworkStatusChangeBlock)(SAF_NETWORK_STATUS networkStatus);

@interface SunbeamAFServiceContext()

@property (nonatomic, assign, readwrite) BOOL networkIsReachable;

@property (nonatomic, assign, readwrite) SAF_NETWORK_STATUS networkStatus;

@property (nonatomic, strong) NetworkStatusChangeBlock networkStatusChangeBlock;

@end

@implementation SunbeamAFServiceContext

+ (SunbeamAFServiceContext *) sharedSunbeamAFServiceContext
{
    static SunbeamAFServiceContext *sharedInstance = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype) init
{
    if (self = [super init]) {
        self.networkStatus = UNKNOWN;
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
        __weak __typeof__(self) weakSelf = self;
        [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            __strong __typeof__(weakSelf) strongSelf = weakSelf;
            switch (status) {
                case AFNetworkReachabilityStatusUnknown:
                    strongSelf.networkStatus = UNKNOWN;
                    break;
                case AFNetworkReachabilityStatusNotReachable:
                    strongSelf.networkStatus = NOT_REACHABLE;
                    break;
                case AFNetworkReachabilityStatusReachableViaWWAN:
                    strongSelf.networkStatus = REACHABLE_VIA_WWAN;
                    break;
                case AFNetworkReachabilityStatusReachableViaWiFi:
                    strongSelf.networkStatus = REACHABLE_VIA_WIFI;
                    break;
                default:
                    break;
            }
            NSNotification *notificationPost = [NSNotification notificationWithName:SAF_NETWORK_STATUS_CHANGED_NOTIFICATION_NAME object:strongSelf userInfo:nil];
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotification:notificationPost];
            });
            if (strongSelf.networkStatusChangeBlock) {
                strongSelf.networkStatusChangeBlock(strongSelf.networkStatus);
            }
        }];
    }
    
    return self;
}

- (void) setSAFServiceFactoryDelegate:(id<SAFServiceFactoryProtocol>)SAFServiceFactoryDelegate
{
    [SunbeamAFServiceFactory sharedSunbeamAFServiceFactory].delegate = SAFServiceFactoryDelegate;
}

- (void) startListenNetworkStatusChange:(void(^)(SAF_NETWORK_STATUS networkStatus)) networkStatusChangeBlock
{
    self.networkStatusChangeBlock = networkStatusChangeBlock;
}

- (BOOL) networkIsReachable
{
    if (self.networkStatus == NOT_REACHABLE) {
        return NO;
    }
    
    return YES;
}

@end
