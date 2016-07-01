//
//  SunbeamAFHTTPClient.m
//  Pods
//
//  Created by sunbeam on 16/6/30.
//
//

#import "SunbeamAFHTTPClient.h"

#import "SunbeamAFRequestGenerator.h"

@implementation SunbeamAFHTTPClient

SAF_singleton_implementation(SunbeamAFHTTPClient)

- (NSInteger) loadSAFRequestWithParams:(SAFRequestType) requestType withParams:(NSDictionary *) params serviceIdentifier:(NSString *) servieIdentifier methodName:(NSString *) methodName success:(SunbeamAFCallback) success fail:(SunbeamAFCallback) fail
{
    SunbeamAFRequest* request = [[SunbeamAFRequestGenerator sharedSunbeamAFRequestGenerator] generateSAFRequest:requestType serviceIdentifier:servieIdentifier requestParams:params methodName:methodName];
    
    return [[[SunbeamAFHTTPService sharedSunbeamAFHTTPService] sunbeamAFRequest:request success:success fail:fail] integerValue];
}

- (void) cancelRequestWithRequestId:(NSNumber *) requestId
{
    [[SunbeamAFHTTPService sharedSunbeamAFHTTPService] cancelSAFRequestWithRequestId:requestId];
}

- (void) cancelRequestWithRequestIdList:(NSArray *) requestIdList
{
    [[SunbeamAFHTTPService sharedSunbeamAFHTTPService] cancelSAFRequestWithRequestIdList:requestIdList];
}

@end
