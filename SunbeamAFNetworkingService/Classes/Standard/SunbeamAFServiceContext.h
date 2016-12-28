//
//  SunbeamAFServiceContext.h
//  Pods
//
//  Created by sunbeam on 16/6/29.
//
//

#import <Foundation/Foundation.h>
#import "SunbeamAFServiceFactory.h"

// 网络状态
typedef enum : NSUInteger {
    UNKNOWN             = -1,   // 未知
    NOT_REACHABLE       = 0,    // 不可达
    REACHABLE_VIA_WWAN  = 1,    // 蜂窝流量
    REACHABLE_VIA_WIFI  = 2,    // wifi
} SAF_NETWORK_STATUS;

// 网络状态发生变化时发送notification
#define SAF_NETWORK_STATUS_CHANGED_NOTIFICATION_NAME @"saf_network_status_changed_notification"

@interface SunbeamAFServiceContext : NSObject

/**
 *  单例
 */
+ (SunbeamAFServiceContext *) sharedSunbeamAFServiceContext;

/**
 网络请求超时时间设置
 */
@property (nonatomic, assign) NSTimeInterval timeoutInterval;

/**
 网络是否可达
 */
@property (nonatomic, assign, readonly) BOOL networkIsReachable;

/**
 当前网络状态
 */
@property (nonatomic, assign, readonly) SAF_NETWORK_STATUS networkStatus;

/**
 设置service factory代理

 @param SAFServiceFactoryDelegate 代理
 */
- (void) setSAFServiceFactoryDelegate:(id<SAFServiceFactoryProtocol>) SAFServiceFactoryDelegate;

/**
 监听网络状态改变
 
 @param networkStatusChangeBlock 网络状态改变回调
 */
- (void) startListenNetworkStatusChange:(void(^)(SAF_NETWORK_STATUS networkStatus)) networkStatusChangeBlock;

@end
