//
//  SunbeamAFHTTPService.h
//  Pods
//
//  Created by sunbeam on 16/6/30.
//
//

#import <Foundation/Foundation.h>
#import "SunbeamAFRequest.h"
#import "SunbeamAFResponse.h"
#import "SunbeamAFServiceContext.h"

typedef void(^SunbeamAFCallback)(SunbeamAFResponse* response);

@interface SunbeamAFHTTPService : NSObject

/**
 *  单例
 */
+ (SunbeamAFHTTPService *) sharedSunbeamAFHTTPService;

/**
 *  AFNetworking请求
 *
 *  @param request 请求实体
 *  @param success 成功回调
 *  @param fail    失败回调
 *
 *  @return 请求id
 */
- (NSNumber *) sunbeamAFRequest:(SunbeamAFRequest *) request success:(SunbeamAFCallback) success fail:(SunbeamAFCallback) fail;

/**
 *  取消指定requestId的请求
 *
 *  @param requestId 请求id
 */
- (void) cancelSAFRequestWithRequestId:(NSNumber *) requestId;

/**
 *  取消置顶request id list的请求
 *
 *  @param requestIdList 请求id list
 */
- (void) cancelSAFRequestWithRequestIdList:(NSArray *) requestIdList;

@end
