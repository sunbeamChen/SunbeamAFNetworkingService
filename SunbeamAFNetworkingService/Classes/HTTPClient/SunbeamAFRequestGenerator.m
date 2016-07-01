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

@property (nonatomic, strong) AFHTTPRequestSerializer *httpJsonRequestSerializer;

@property (nonatomic, strong) AFHTTPRequestSerializer *httpFileRequestSerializer;

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

- (AFHTTPRequestSerializer *)httpFileRequestSerializer
{
    if (_httpFileRequestSerializer == nil) {
        _httpFileRequestSerializer = [AFHTTPRequestSerializer serializer];
        _httpFileRequestSerializer.timeoutInterval = [SunbeamAFServiceContext sharedSunbeamAFServiceContext].timeoutInterval = nil ? SunbeamAFRequestTimeoutInterval : [SunbeamAFServiceContext sharedSunbeamAFServiceContext].timeoutInterval;
        _httpFileRequestSerializer.cachePolicy = NSURLRequestUseProtocolCachePolicy;
    }
    return _httpFileRequestSerializer;
}

- (SunbeamAFRequest *)generateSAFRequest:(SAFRequestType)requestType serviceIdentifier:(NSString *)serviceIdentifier requestParams:(NSDictionary *)requestParams methodName:(NSString *)methodName
{
    // 获取具体服务
    SunbeamAFBaseService* service = [[SunbeamAFServiceFactory sharedSunbeamAFServiceFactory] getSAFServiceWithServiceIdentifier:serviceIdentifier];
    
    // 获取请求参数
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
    
    // 初始化url request
    NSMutableURLRequest* mutableRequest = nil;
    
    switch (requestType) {
        case SAFRequestTypeGET:
        {
            mutableRequest = [self.httpJsonRequestSerializer requestWithMethod:@"GET" URLString:urlString parameters:bodyParams error:nil];
            break;
        }
            
        case SAFRequestTypePOST:
        {
            mutableRequest = [self.httpJsonRequestSerializer requestWithMethod:@"POST" URLString:urlString parameters:bodyParams error:nil];
            break;
        }
            
        case SAFRequestTypeDownload:
        {
            mutableRequest = [self.httpFileRequestSerializer requestWithMethod:@"GET" URLString:urlString parameters:bodyParams error:nil];
            break;
        }
            
        case SAFRequestTypeUpload:
        {
            mutableRequest = [self.httpFileRequestSerializer multipartFormRequestWithMethod:@"POST" URLString:urlString parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
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
    
    return [SunbeamAFRequest getSAFRequest:requestType request:mutableRequest urlString:urlString headerParameters:headerParams urlParameters:urlParams bodyParameters:bodyParams downloadFileSavePath:downloadFileSavePath uploadFilePath:uploadFilePath];
}

@end
