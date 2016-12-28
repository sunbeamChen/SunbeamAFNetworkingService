//
//  SunbeamAFBaseManager.m
//  Pods
//
//  Created by sunbeam on 16/6/29.
//
//

#import "SunbeamAFBaseManager.h"
#import "SunbeamAFHTTPClient.h"
#import "SunbeamAFServiceProperty.h"
#import "SunbeamAFServiceContext.h"

#define SAF_REQUEST_ID_DEFAULT @(0)

@implementation SunbeamAFBaseManager

- (instancetype)init
{
    if (self = [super init]) {
        if ([self conformsToProtocol:@protocol(SAFManagerProtocol)]) {
            _childManager = (id<SAFManagerProtocol>) self;
        } else {
            NSLog(@"%@不符合SAFManagerProtocol", self);
        }
        _paramsForRequest = nil;
        _paramsValidator = nil;
        _managerCallbackDataFormatter = nil;
        _managerInterceptor = nil;
        _managerCallbackDataValidator = nil;
    }
    
    return self;
}

- (void)dealloc
{
    [[SunbeamAFHTTPClient sharedSunbeamAFHTTPClient] cancelAllRequest];
}

- (NSNumber *) loadDataTask:(void(^)(NSString* identifier, id responseObject, NSError* error)) completion
{
    NSError* error = [self beforeRequest];
    if (error != nil) {
        completion(self.childManager.identifier, nil, error);
        
        return SAF_REQUEST_ID_DEFAULT;
    }
    
    NSDictionary* params = nil;
    if (self.paramsForRequest && [self.paramsForRequest respondsToSelector:@selector(managerParamsForRequest)]) {
        params = [self.paramsForRequest managerParamsForRequest];
    }
    
    __weak __typeof__(self) weakSelf = self;
    if (self.childManager.method == GET || self.childManager.method == POST) {
        return [[SunbeamAFHTTPClient sharedSunbeamAFHTTPClient] loadDataTask:self.childManager.URI identifier:self.childManager.identifier method:self.childManager.method params:params completion:^(SunbeamAFResponse *response) {
            __strong __typeof__(weakSelf) strongSelf = weakSelf;
            if (response.error == nil) {
                id jsonData = [strongSelf formatResponseData:response.responseObject];
                NSLog(@"\nhttps GET/POST请求响应格式化后数据：%@\n<<<end==========================================https GET/POST请求序号:%@", jsonData, response.requestId);
                if (self.managerCallbackDataValidator && [self.managerCallbackDataValidator respondsToSelector:@selector(managerCallbackDataValidate:)]) {
                    NSError* error = [self.managerCallbackDataValidator managerCallbackDataValidate:jsonData];
                    if (error != nil) {
                        completion(strongSelf.childManager.identifier, nil, error);
                        if (strongSelf.managerInterceptor && [strongSelf.managerInterceptor respondsToSelector:@selector(managerInterceptorPerformFailed)]) {
                            [strongSelf.managerInterceptor managerInterceptorPerformFailed];
                        }
                        
                        return ;
                    }
                }
                completion(strongSelf.childManager.identifier, jsonData, nil);
                if (strongSelf.managerInterceptor && [strongSelf.managerInterceptor respondsToSelector:@selector(managerInterceptorPerformSuccess)]) {
                    [strongSelf.managerInterceptor managerInterceptorPerformSuccess];
                }
            } else {
                completion(strongSelf.childManager.identifier, nil, response.error);
                if (strongSelf.managerInterceptor && [strongSelf.managerInterceptor respondsToSelector:@selector(managerInterceptorPerformFailed)]) {
                    [strongSelf.managerInterceptor managerInterceptorPerformFailed];
                }
            }
        }];
    } else {
        completion(self.childManager.identifier, nil, [NSError errorWithDomain:SAF_ERROR_DOMAIN code:REQUEST_METHOD_NOT_SUPPORT userInfo:@{NSLocalizedDescriptionKey:@"request method not support"}]);
        
        return SAF_REQUEST_ID_DEFAULT;
    }
}

- (NSNumber *) loadUploadTask:(NSMutableDictionary *) uploadFiles uploadProgress:(NSProgress * __nullable __autoreleasing * __nullable) uploadProgress completion:(void(^)(NSString* identfier, id responseObject, NSError* error)) completion
{
    NSError* error = [self beforeRequest];
    if (error != nil) {
        completion(self.childManager.identifier, nil, error);
        
        return SAF_REQUEST_ID_DEFAULT;
    }
    
    NSDictionary* params = nil;
    if (self.paramsForRequest && [self.paramsForRequest respondsToSelector:@selector(managerParamsForRequest)]) {
        params = [self.paramsForRequest managerParamsForRequest];
    }
    
    __weak __typeof__(self) weakSelf = self;
    if (self.childManager.method == UPLOAD) {
        return [[SunbeamAFHTTPClient sharedSunbeamAFHTTPClient] loadUploadTask:self.childManager.URI identifier:self.childManager.identifier method:self.childManager.method params:params uploadFiles:uploadFiles uploadProgress:uploadProgress completion:^(SunbeamAFResponse *response) {
            __strong __typeof__(weakSelf) strongSelf = weakSelf;
            if (response.error == nil) {
                id jsonData = [strongSelf formatResponseData:response.responseObject];
                if (self.managerCallbackDataValidator && [self.managerCallbackDataValidator respondsToSelector:@selector(managerCallbackDataValidate:)]) {
                    NSError* error = [self.managerCallbackDataValidator managerCallbackDataValidate:jsonData];
                    if (error != nil) {
                        completion(strongSelf.childManager.identifier, nil, error);
                        if (strongSelf.managerInterceptor && [strongSelf.managerInterceptor respondsToSelector:@selector(managerInterceptorPerformFailed)]) {
                            [strongSelf.managerInterceptor managerInterceptorPerformFailed];
                        }
                        
                        return ;
                    }
                }
                completion(strongSelf.childManager.identifier, jsonData, nil);
                if (strongSelf.managerInterceptor && [strongSelf.managerInterceptor respondsToSelector:@selector(managerInterceptorPerformSuccess)]) {
                    [strongSelf.managerInterceptor managerInterceptorPerformSuccess];
                }
            } else {
                completion(strongSelf.childManager.identifier, nil, response.error);
                if (strongSelf.managerInterceptor && [strongSelf.managerInterceptor respondsToSelector:@selector(managerInterceptorPerformFailed)]) {
                    [strongSelf.managerInterceptor managerInterceptorPerformFailed];
                }
            }
        }];
    } else {
        completion(self.childManager.identifier, nil, [NSError errorWithDomain:SAF_ERROR_DOMAIN code:REQUEST_METHOD_NOT_SUPPORT userInfo:@{NSLocalizedDescriptionKey:@"request method not support"}]);
        
        return SAF_REQUEST_ID_DEFAULT;
    }
}

- (NSNumber *) loadDownloadTask:(NSProgress * __nullable __autoreleasing * __nullable) downloadProgress completion:(void(^)(NSString* identfier, NSURL* downloadFileurl, NSError* error)) completion
{
    NSError* error = [self beforeRequest];
    if (error != nil) {
        completion(self.childManager.identifier, nil, error);
        
        return SAF_REQUEST_ID_DEFAULT;
    }
    
    NSDictionary* params = nil;
    if (self.paramsForRequest && [self.paramsForRequest respondsToSelector:@selector(managerParamsForRequest)]) {
        params = [self.paramsForRequest managerParamsForRequest];
    }

    __weak __typeof__(self) weakSelf = self;
    if (self.childManager.method == DOWNLOAD) {
        return [[SunbeamAFHTTPClient sharedSunbeamAFHTTPClient] loadDownloadTask:self.childManager.URI identifier:self.childManager.identifier method:self.childManager.method params:params downloadProgress:downloadProgress completion:^(SunbeamAFResponse *response) {
            __strong __typeof__(weakSelf) strongSelf = weakSelf;
            if (response.error == nil) {
                completion(strongSelf.childManager.identifier, response.downloadFileUrl, nil);
                if (strongSelf.managerInterceptor && [strongSelf.managerInterceptor respondsToSelector:@selector(managerInterceptorPerformSuccess)]) {
                    [strongSelf.managerInterceptor managerInterceptorPerformSuccess];
                }
            } else {
                completion(strongSelf.childManager.identifier, nil, response.error);
                if (strongSelf.managerInterceptor && [strongSelf.managerInterceptor respondsToSelector:@selector(managerInterceptorPerformFailed)]) {
                    [strongSelf.managerInterceptor managerInterceptorPerformFailed];
                }
            }
        }];
    } else {
        completion(self.childManager.identifier, nil, [NSError errorWithDomain:SAF_ERROR_DOMAIN code:REQUEST_METHOD_NOT_SUPPORT userInfo:@{NSLocalizedDescriptionKey:@"request method not support"}]);
        
        return SAF_REQUEST_ID_DEFAULT;
    }
}

#pragma mark - private method
/**
 检测网络参数等
 
 @return NSError
 */
- (NSError *) beforeRequest
{
    // 判断网络是否正常
    if (![[SunbeamAFServiceContext sharedSunbeamAFServiceContext] networkIsReachable])
    {
        return [NSError errorWithDomain:SAF_ERROR_DOMAIN code:NETWORK_NOT_REACHABLE_ERROR userInfo:@{NSLocalizedDescriptionKey:@"network is not reachable"}];
    }
    
    // 判断当前是否有网络请求正在执行(取决于是否支持多个请求同时执行)
    if ([[SunbeamAFHTTPClient sharedSunbeamAFHTTPClient].sessionTaskQueue count] > 0)
    {
        //TODO:该处采取的策略是阻止新的请求，另外一种策略是取消旧的请求，执行新的请求(待实际测试判断)
        
        return [NSError errorWithDomain:SAF_ERROR_DOMAIN code:REQUEST_RUNING_ERROR userInfo:@{NSLocalizedDescriptionKey:@"network request is busy"}];
    }
    
    // 判断网络请求参数是否合法，错误会返回NSError（由外部判断后返回）
    if (self.paramsValidator && [self.paramsValidator respondsToSelector:@selector(managerParamsValidate)]) {
        return [self.paramsValidator managerParamsValidate];
    }
    
    return nil;
}

/**
 格式化响应数据
 
 @param formatter 格式化方法
 @return json
 */
- (id) formatResponseData:(id) responseObject
{
    // 如果formatter不为空，则默认外部进行格式化处理
    if (self.managerCallbackDataFormatter && [self.managerCallbackDataFormatter respondsToSelector:@selector(managerCallbackDataFormat:)]) {
        return [self.managerCallbackDataFormatter managerCallbackDataFormat:responseObject];
    }
    
    if (responseObject == nil || [responseObject length] == 0) {
        return nil;
    }
    
    NSError* error = nil;
    id returnDictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:&error];
    if (error) {
        NSLog(@"\n网络请求数据NSJSONReadingAllowFragments格式化失败：%@", error);
        return nil;
    }
    
    return returnDictionary;
}

@end
