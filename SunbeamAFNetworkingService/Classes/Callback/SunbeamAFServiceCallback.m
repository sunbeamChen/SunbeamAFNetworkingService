//
//  SunbeamAFServiceCallback.m
//  Pods
//
//  Created by sunbeam on 16/6/29.
//
//

#import "SunbeamAFServiceCallback.h"

@implementation SunbeamAFServiceCallback

SAF_singleton_implementation(SunbeamAFServiceCallback)

/**
 *  SAF 成功回调
 *
 *  @param serviceIdentifier 具体服务标识
 *  @param sunbeamAFRequest  request
 *  @param sunbeamAFResponse response
 */
- (void) sunbeamAFServiceCallbackSuccess:(NSString *) serviceIdentifier sunbeamAFRequest:(SunbeamAFRequest *) sunbeamAFRequest sunbeamAFResponse:(SunbeamAFResponse *) sunbeamAFResponse
{
    [self.delegate didSAFServiceCallbackSuccess:serviceIdentifier sunbeamAFRequest:sunbeamAFRequest sunbeamAFResponse:sunbeamAFResponse];
}

/**
 *  SAF 失败回调
 *
 *  @param serviceIdentifier 具体服务标识
 *  @param sunbeamAFRequest  request
 *  @param sunbeamAFResponse response
 */
- (void) sunbeamAFServiceCallbackFail:(NSString *) serviceIdentifier sunbeamAFRequest:(SunbeamAFRequest *) sunbeamAFRequest sunbeamAFResponse:(SunbeamAFResponse *) sunbeamAFResponse
{
    [self.delegate didSAFServiceCallbackFail:serviceIdentifier sunbeamAFRequest:sunbeamAFRequest sunbeamAFResponse:sunbeamAFResponse];
}

@end
