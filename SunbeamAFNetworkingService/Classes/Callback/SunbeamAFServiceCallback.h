//
//  SunbeamAFServiceCallback.h
//  Pods
//
//  Created by sunbeam on 16/6/29.
//
//

#import <Foundation/Foundation.h>

#import "SunbeamAFSingletonService.h"

#import "SunbeamAFRequest.h"

#import "SunbeamAFResponse.h"

@protocol SAFServiceCallback <NSObject>

/**
 *  SAF 成功回调
 *
 *  @param serviceIdentifier 具体服务标识
 *  @param sunbeamAFRequest  request
 *  @param sunbeamAFResponse response
 */
- (void) didSAFServiceCallbackSuccess:(NSString *) serviceIdentifier sunbeamAFRequest:(SunbeamAFRequest *) sunbeamAFRequest sunbeamAFResponse:(SunbeamAFResponse *) sunbeamAFResponse;

/**
 *  SAF 失败回调
 *
 *  @param serviceIdentifier 具体服务标识
 *  @param sunbeamAFRequest  request
 *  @param sunbeamAFResponse response
 */
- (void) didSAFServiceCallbackFail:(NSString *) serviceIdentifier sunbeamAFRequest:(SunbeamAFRequest *) sunbeamAFRequest sunbeamAFResponse:(SunbeamAFResponse *) sunbeamAFResponse;

@end

@interface SunbeamAFServiceCallback : NSObject

SAF_singleton_interface(SunbeamAFServiceCallback)

// 代理
@property (nonatomic, weak) id<SAFServiceCallback> delegate;

/**
 *  SAF 成功回调
 *
 *  @param serviceIdentifier 具体服务标识
 *  @param sunbeamAFRequest  request
 *  @param sunbeamAFResponse response
 */
- (void) sunbeamAFServiceCallbackSuccess:(NSString *) serviceIdentifier sunbeamAFRequest:(SunbeamAFRequest *) sunbeamAFRequest sunbeamAFResponse:(SunbeamAFResponse *) sunbeamAFResponse;

/**
 *  SAF 失败回调
 *
 *  @param serviceIdentifier 具体服务标识
 *  @param sunbeamAFRequest  request
 *  @param sunbeamAFResponse response
 */
- (void) sunbeamAFServiceCallbackFail:(NSString *) serviceIdentifier sunbeamAFRequest:(SunbeamAFRequest *) sunbeamAFRequest sunbeamAFResponse:(SunbeamAFResponse *) sunbeamAFResponse;

@end
