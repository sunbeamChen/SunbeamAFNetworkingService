//
//  SunbeamAFHTTPClient.h
//  Pods
//
//  Created by sunbeam on 16/6/30.
//
//

#import <Foundation/Foundation.h>

#import "SunbeamAFHTTPService.h"

@interface SunbeamAFHTTPClient : NSObject

/**
 *  单例
 */
+ (SunbeamAFHTTPClient *) sharedSunbeamAFHTTPClient;

/**
 *  开启网络请求
 *
 *  @param requestType      请求类型
 *  @param params           请求参数
 *  @param servieIdentifier 具体服务标识
 *  @param methodName       方法名
 *  @param success          成功回调
 *  @param fail             失败回调
 *
 *  @return 请求id
 */
- (NSInteger) loadSAFRequestWithParams:(SAFRequestType) requestType withParams:(NSDictionary *) params serviceIdentifier:(NSString *) servieIdentifier methodName:(NSString *) methodName success:(SunbeamAFCallback) success fail:(SunbeamAFCallback) fail;

/**
 *  取消对应requestId的请求
 *
 *  @param requestId 请求id
 */
- (void) cancelRequestWithRequestId:(NSNumber *) requestId;

/**
 *  取消对应request list的请求
 *
 *  @param requestIdList 请求id list
 */
- (void) cancelRequestWithRequestIdList:(NSArray *) requestIdList;

@end
