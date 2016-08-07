//
//  SunbeamAFRequestGenerator.m
//  Pods
//
//  Created by sunbeam on 16/6/30.
//
//

#import "SunbeamAFRequestGenerator.h"

#import "SunbeamAFServiceFactory.h"

#import <AFNetworking/AFNetworking.h>

#import "SunbeamAFUtil.h"

@interface SunbeamAFRequestGenerator()

@property (nonatomic, strong) AFHTTPRequestSerializer* httpJsonRequestSerializer;

@property (nonatomic, strong) AFHTTPRequestSerializer* httpRequestSerializer;

@end

@implementation SunbeamAFRequestGenerator

SAF_singleton_implementation(SunbeamAFRequestGenerator)

#pragma mark - request serializer
- (AFHTTPRequestSerializer *)httpJsonRequestSerializer
{
    if (_httpJsonRequestSerializer == nil) {
        _httpJsonRequestSerializer = [AFJSONRequestSerializer serializer];
        _httpJsonRequestSerializer.timeoutInterval = [SunbeamAFServiceContext sharedSunbeamAFServiceContext].timeoutInterval = nil ? SunbeamAFRequestTimeoutInterval : [SunbeamAFServiceContext sharedSunbeamAFServiceContext].timeoutInterval;
        _httpJsonRequestSerializer.cachePolicy = NSURLRequestUseProtocolCachePolicy;
    }
    return _httpJsonRequestSerializer;
}

- (AFHTTPRequestSerializer *)httpRequestSerializer
{
    if (_httpRequestSerializer == nil) {
        _httpRequestSerializer = [AFHTTPRequestSerializer serializer];
        _httpRequestSerializer.timeoutInterval = [SunbeamAFServiceContext sharedSunbeamAFServiceContext].timeoutInterval = nil ? SunbeamAFRequestTimeoutInterval : [SunbeamAFServiceContext sharedSunbeamAFServiceContext].timeoutInterval;
        _httpRequestSerializer.cachePolicy = NSURLRequestUseProtocolCachePolicy;
    }
    return _httpRequestSerializer;
}

- (SunbeamAFRequest *)generateSAFRequest:(SAFRequestType)requestType serviceIdentifier:(NSString *)serviceIdentifier requestParams:(NSDictionary *)requestParams methodName:(NSString *)methodName
{
    // 获取具体服务
    SunbeamAFBaseService* service = [[SunbeamAFServiceFactory sharedSunbeamAFServiceFactory] getSAFServiceWithServiceIdentifier:serviceIdentifier];
    
    // 获取请求参数
    NSString* contentType = [requestParams objectForKey:SunbeamAFRequestHeaderContentType];
    
    NSDictionary* headerParams = [requestParams objectForKey:SunbeamAFRequestHeaderParamsKey];
    
    NSDictionary* urlParams = [requestParams objectForKey:SunbeamAFRequestUrlParamsKey];
    
    NSDictionary* bodyParams = [requestParams objectForKey:SunbeamAFRequestBodyParamsKey];
    
    NSString* downloadFileSavePath = [requestParams objectForKey:SunbeamAFRequestDownloadFileSavePathParamsKey];
    
    NSString* uploadFilePath = [requestParams objectForKey:SunbeamAFRequestUploadFilePathParamsKey];
    
    // 初始化url string
    NSString* urlString = nil;
    
    if (urlParams == nil) {
        urlString = [NSString stringWithFormat:@"%@%@%@", service.serviceUrl, service.serviceVersion, methodName];
    } else {
        urlString = [NSString stringWithFormat:@"%@%@%@?%@", service.serviceUrl, service.serviceVersion, methodName, [SunbeamAFUtil urlParamsString:urlParams]];
    }
    
    AFHTTPRequestSerializer* requestSerializer = nil;
    
    if (contentType != nil) {
        requestSerializer = self.httpRequestSerializer;
        [requestSerializer setValue:contentType forHTTPHeaderField:@"Content-Type"];
    } else {
        requestSerializer = self.httpJsonRequestSerializer;
        [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    }
    
    // 初始化url request
    NSMutableURLRequest* mutableRequest = nil;
    
    switch (requestType) {
        case SAFRequestTypeGET:
        {
            mutableRequest = [requestSerializer requestWithMethod:@"GET" URLString:urlString parameters:bodyParams error:nil];
            break;
        }
            
        case SAFRequestTypePOST:
        {
            mutableRequest = [requestSerializer requestWithMethod:@"POST" URLString:urlString parameters:bodyParams error:nil];
            break;
        }
            
        case SAFRequestTypeDownload:
        {
            mutableRequest = [requestSerializer requestWithMethod:@"GET" URLString:urlString parameters:bodyParams error:nil];
            break;
        }
            
        case SAFRequestTypeUpload:
        {
            mutableRequest = [requestSerializer multipartFormRequestWithMethod:@"POST" URLString:urlString parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                [formData appendPartWithFileURL:[NSURL fileURLWithPath:uploadFilePath] name:SunbeamAFRequestUploadFileFormDataFileKey error:nil];
                
                [formData appendPartWithFormData:[[bodyParams objectForKey:SunbeamAFRequestUploadFileFormDataTokenKey] dataUsingEncoding:NSUTF8StringEncoding] name:SunbeamAFRequestUploadFileFormDataTokenKey];
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
    
    return [SunbeamAFRequest getSAFRequest:requestType request:mutableRequest urlString:urlString headerParameters:[headerParams mutableCopy] urlParameters:[urlParams mutableCopy] bodyParameters:[bodyParams mutableCopy] downloadFileSavePath:downloadFileSavePath uploadFilePath:uploadFilePath];
}

@end
