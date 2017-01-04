//
//  SunbeamAFHTTPClient.m
//  Pods
//
//  Created by sunbeam on 16/6/30.
//
//

#import "SunbeamAFHTTPClient.h"
#import "SunbeamAFHTTPService.h"
#import "SunbeamAFRequestGenerator.h"
#import "SunbeamAFResponseConstructor.h"

@interface SunbeamAFHTTPClient()

@property (nonatomic, strong) NSNumber* requestId;

@property (nonatomic, strong) NSMutableDictionary* sessionTaskQueue;

@end

@implementation SunbeamAFHTTPClient

+ (SunbeamAFHTTPClient *) sharedSunbeamAFHTTPClient
{
    static SunbeamAFHTTPClient *sharedInstance = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
        NSLog(@"\n==============================================\nSunbeam AFNetworking Service version is %@\n==============================================", SUNBEAM_AFNETWORKING_SERVICE_VERSION);
    });
    
    return sharedInstance;
}

- (NSNumber *)loadDataTask:(NSString *)URI identifier:(NSString *)identifier method:(SAF_REQUEST_METHOD)method params:(NSDictionary *)params completion:(void (^)(SunbeamAFResponse *))completion
{
    SunbeamAFRequest* request = [SunbeamAFRequestGenerator generateSAFRequest:method identifier:identifier URI:URI requestParams:params uploadFiles:nil downloadUrl:nil];
    NSNumber* requestId = [self generateRequestId];
    NSLog(@"\n==========================================begin>>>https GET/POST请求序号:%@\nhttps GET/POST请求url：%@\nhttps GET/POST请求header：%@\nhttps GET/POST请求body：%@", requestId, request.urlString, request.request.allHTTPHeaderFields, [[NSString alloc] initWithData:request.request.HTTPBody encoding:NSUTF8StringEncoding]);
    self.sessionTaskQueue[requestId] = [[[SunbeamAFHTTPService alloc] init] loadDataTask:request completion:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (response) {
            NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*) response;
            NSLog(@"\n==========================================response>>>https GET/POST请求序号:%@\nhttps GET/POST请求响应status code：%@, error：%@", requestId, @(httpResponse.statusCode), error);
        } else {
            NSLog(@"\n==========================================response>>>https GET/POST请求序号:%@\nhttps GET/POST请求响应error：%@", requestId, error);
        }
        //NSLog(@"\nhttps GET/POST请求响应原始数据：%@", responseObject);
        
        NSURLSessionDataTask* dataTask = self.sessionTaskQueue[requestId];
        if (dataTask == nil) {
            return ;
        } else {
            [self.sessionTaskQueue removeObjectForKey:requestId];
        }
        SunbeamAFResponse* safResponse = [SunbeamAFResponseConstructor constructSAFResponse:requestId urlResponse:response responseObject:responseObject error:error downloadFileUrl:nil];
        completion(safResponse);
    }];
    
    return requestId;
}

- (NSNumber *)loadUploadTask:(NSString *)URI identifier:(NSString *)identifier method:(SAF_REQUEST_METHOD)method params:(NSDictionary *)params uploadFiles:(NSMutableDictionary *) uploadFiles uploadProgress:(NSProgress * __nullable __autoreleasing * __nullable)uploadProgress completion:(void (^)(SunbeamAFResponse *))completion
{
    SunbeamAFRequest* request = [SunbeamAFRequestGenerator generateSAFRequest:method identifier:identifier URI:URI requestParams:params uploadFiles:uploadFiles downloadUrl:nil];
    NSNumber* requestId = [self generateRequestId];
    self.sessionTaskQueue[requestId] = [[[SunbeamAFHTTPService alloc] init] loadUploadTask:request uploadProgress:uploadProgress completion:^(NSURLResponse *response, id responseObject, NSError *error) {
        NSURLSessionDataTask* dataTask = self.sessionTaskQueue[requestId];
        if (dataTask == nil) {
            return ;
        } else {
            [self.sessionTaskQueue removeObjectForKey:requestId];
        }
        SunbeamAFResponse* safResponse = [SunbeamAFResponseConstructor constructSAFResponse:requestId urlResponse:response responseObject:responseObject error:error downloadFileUrl:nil];
        completion(safResponse);
    }];
    
    return requestId;
}

- (NSNumber *)loadDownloadTask:(NSString *)URI identifier:(NSString *)identifier method:(SAF_REQUEST_METHOD)method params:(NSDictionary *)params downloadUrl:(NSString *) downloadUrl downloadProgress:(NSProgress * __nullable __autoreleasing * __nullable)downloadProgress completion:(void (^)(SunbeamAFResponse *))completion
{
    SunbeamAFRequest* request = [SunbeamAFRequestGenerator generateSAFRequest:method identifier:identifier URI:URI requestParams:params uploadFiles:nil downloadUrl:downloadUrl];
    NSNumber* requestId = [self generateRequestId];
    self.sessionTaskQueue[requestId] = [[[SunbeamAFHTTPService alloc] init] loadDownloadTask:request downloadProgress:downloadProgress completion:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        NSURLSessionDataTask* dataTask = self.sessionTaskQueue[requestId];
        if (dataTask == nil) {
            return ;
        } else {
            [self.sessionTaskQueue removeObjectForKey:requestId];
        }
        SunbeamAFResponse* slafResponse = [SunbeamAFResponseConstructor constructSAFResponse:requestId urlResponse:response responseObject:nil error:error downloadFileUrl:filePath];
        completion(slafResponse);
    }];
    
    return requestId;
}

- (void)cancelAllRequest
{
    for (NSNumber* requestId in [self.sessionTaskQueue allKeys]) {
        [self cancelRequest:requestId];
    }
}

- (void)cancelRequest:(NSNumber *)requestId
{
    NSURLSessionTask* sessionTask = [self.sessionTaskQueue objectForKey:requestId];
    if (sessionTask) {
        [sessionTask cancel];
        [self.sessionTaskQueue removeObjectForKey:requestId];
    }
}

#pragma mark - private methods
- (NSNumber *)generateRequestId
{
    @synchronized (self) {
        if (_requestId == nil) {
            _requestId = @(1);
        } else {
            if ([_requestId integerValue] == NSIntegerMax) {
                _requestId = @(1);
            } else {
                _requestId = @([_requestId integerValue] + 1);
            }
        }
        
        return _requestId;
    }
}

- (NSMutableDictionary *)sessionTaskQueue
{
    if (_sessionTaskQueue == nil) {
        _sessionTaskQueue = [[NSMutableDictionary alloc] init];
    }
    
    return _sessionTaskQueue;
}

@end
