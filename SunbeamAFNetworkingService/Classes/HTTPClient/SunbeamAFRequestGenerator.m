//
//  SunbeamAFRequestGenerator.m
//  Pods
//
//  Created by sunbeam on 16/6/30.
//
//

#import "SunbeamAFRequestGenerator.h"
#import <AFNetworking/AFNetworking.h>
#import "SunbeamAFServiceProperty.h"
#import "SunbeamAFServiceContext.h"
#import "SunbeamAFServiceFactory.h"
#import "SunbeamAFUtil.h"

@implementation SunbeamAFRequestGenerator

#pragma mark - request serializer
+ (AFHTTPRequestSerializer *)getHttpJsonRequestSerializer
{
    AFHTTPRequestSerializer* jsonRequestSerializer = [AFJSONRequestSerializer serializer];
    jsonRequestSerializer.timeoutInterval = [SunbeamAFServiceContext sharedSunbeamAFServiceContext].timeoutInterval = nil ? SAFRequestTimeoutInterval : [SunbeamAFServiceContext sharedSunbeamAFServiceContext].timeoutInterval;
    jsonRequestSerializer.cachePolicy = NSURLRequestUseProtocolCachePolicy;
    [jsonRequestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    return jsonRequestSerializer;
}

+ (AFHTTPRequestSerializer *)getHttpRequestSerializer
{
    AFHTTPRequestSerializer* httpRequestSerializer = [AFHTTPRequestSerializer serializer];
    httpRequestSerializer.timeoutInterval = [SunbeamAFServiceContext sharedSunbeamAFServiceContext].timeoutInterval = nil ? SAFRequestTimeoutInterval : [SunbeamAFServiceContext sharedSunbeamAFServiceContext].timeoutInterval;
    httpRequestSerializer.cachePolicy = NSURLRequestUseProtocolCachePolicy;
    
    return httpRequestSerializer;
}

+ (SunbeamAFRequest *)generateSAFRequest:(SAF_REQUEST_METHOD)requestMethod identifier:(NSString *)identifier URI:(NSString *)URI requestParams:(NSDictionary *)requestParams uploadFiles:(NSMutableDictionary *)uploadFiles downloadUrl:(NSString *)downloadUrl
{
    SunbeamAFBaseService* service = [[SunbeamAFServiceFactory sharedSunbeamAFServiceFactory] getSAFService:identifier];
    
    NSDictionary* headerParams = [requestParams objectForKey:SAFRequestHeaderParamsKey];
    NSDictionary* urlParams = [requestParams objectForKey:SAFRequestUrlParamsKey];
    NSDictionary* bodyParams = [requestParams objectForKey:SAFRequestBodyParamsKey];
    
    NSString* urlString = nil;
    if (urlParams == nil) {
        urlString = [NSString stringWithFormat:@"%@%@%@%@", service.protocol, service.domain, service.version, URI];
    } else {
        urlString = [NSString stringWithFormat:@"%@%@%@%@?%@", service.protocol, service.domain, service.version, URI, [SunbeamAFUtil urlParamsString:urlParams]];
    }
    
    NSMutableURLRequest* mutableRequest = nil;
    switch (requestMethod) {
        case GET:
        {
            mutableRequest = [[self getHttpJsonRequestSerializer] requestWithMethod:@"GET" URLString:urlString parameters:bodyParams error:nil];
            break;
        }
        case POST:
        {
            mutableRequest = [[self getHttpJsonRequestSerializer] requestWithMethod:@"POST" URLString:urlString parameters:bodyParams error:nil];
            break;
        }
        case DOWNLOAD:
        {
            mutableRequest = [[self getHttpRequestSerializer] requestWithMethod:@"GET" URLString:downloadUrl parameters:nil error:nil];
            break;
        }
        case UPLOAD:
        {
            mutableRequest = [[self getHttpRequestSerializer] multipartFormRequestWithMethod:@"POST" URLString:urlString parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                for (NSString* fileKey in [uploadFiles allKeys]) {
                    [formData appendPartWithFileURL:[NSURL fileURLWithPath:[uploadFiles objectForKey:fileKey]] name:fileKey error:nil];
                }
            } error:nil];
            break;
        }
            
        default:
            break;
    }
    
    if (headerParams != nil && [headerParams count] > 0) {
        for (NSString* key in [headerParams allKeys]) {
            [mutableRequest addValue:[headerParams objectForKey:key] forHTTPHeaderField:key];
        }
    }
    
    return [SunbeamAFRequest getSAFRequest:requestMethod request:mutableRequest urlString:urlString useSSLCertificates:service.useSSLCertificates headerParameters:headerParams urlParameters:urlParams bodyParameters:bodyParams uploadFiles:uploadFiles downloadUrl:downloadUrl];
}

@end
