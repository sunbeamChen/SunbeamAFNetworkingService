//
//  SunbeamAFHTTPService.m
//  Pods
//
//  Created by sunbeam on 16/6/30.
//
//

#import "SunbeamAFHTTPService.h"

#import <AFNetworking/AFNetworking.h>

#define AFNetworking_Version @"2.0"

@interface SunbeamAFHTTPService()

@property (nonatomic, strong) NSMutableDictionary *dispatchTable;

@property (nonatomic, strong) NSNumber *recordedRequestId;

@property (nonatomic, strong) AFHTTPRequestOperationManager *operationManager;

@property (nonatomic, strong) NSOperationQueue *operationQueue;

@property (nonatomic, strong) AFSecurityPolicy* customSecurityPolicy;

//@property (nonatomic, strong) AFURLSessionManager* sessionManager;
//
//@property (nonatomic, strong) AFHTTPSessionManager* httpSessionManager;
//
//@property (nonatomic, strong) NSMutableArray *sessionTaskQueue;

/**
 *  AFNetworking 2.6.3 版本请求
 */
- (NSNumber *) afAPIRequest_get_low:(SunbeamAFRequest *) requestModel success:(SunbeamAFCallback) success fail:(SunbeamAFCallback) fail requestId:(NSNumber *) requestId;

- (NSNumber *) afAPIRequest_post_low:(SunbeamAFRequest *) requestModel success:(SunbeamAFCallback) success fail:(SunbeamAFCallback) fail requestId:(NSNumber *) requestId;

- (NSNumber *) afAPIRequest_download_low:(SunbeamAFRequest *) requestModel success:(SunbeamAFCallback) success fail:(SunbeamAFCallback) fail requestId:(NSNumber *) requestId;

- (NSNumber *) afAPIRequest_upload_low:(SunbeamAFRequest *) requestModel success:(SunbeamAFCallback) success fail:(SunbeamAFCallback) fail requestId:(NSNumber *) requestId;

/**
 *  AFNetworking 3.0 版本请求
 */
- (NSNumber *) afAPIRequest_get_high:(SunbeamAFRequest *) requestModel success:(SunbeamAFCallback) success fail:(SunbeamAFCallback) fail requestId:(NSNumber *) requestId;

- (NSNumber *) afAPIRequest_post_high:(SunbeamAFRequest *) requestModel success:(SunbeamAFCallback) success fail:(SunbeamAFCallback) fail requestId:(NSNumber *) requestId;

- (NSNumber *) afAPIRequest_download_high:(SunbeamAFRequest *) requestModel success:(SunbeamAFCallback) success fail:(SunbeamAFCallback) fail requestId:(NSNumber *) requestId;

- (NSNumber *) afAPIRequest_upload_high:(SunbeamAFRequest *) requestModel success:(SunbeamAFCallback) success fail:(SunbeamAFCallback) fail requestId:(NSNumber *) requestId;

@end

@implementation SunbeamAFHTTPService

SAF_singleton_implementation(SunbeamAFHTTPService)

- (NSNumber *)sunbeamAFRequest:(SunbeamAFRequest *)request success:(SunbeamAFCallback)success fail:(SunbeamAFCallback)fail
{
    NSNumber* requestId = [self generateRequestId];
    
    switch (request.requestType) {
        case SAFRequestTypeGET:
        {
            if ([@"2.0" isEqualToString:AFNetworking_Version]) {
                
                [self afAPIRequest_get_low:request success:success fail:fail requestId:requestId];
                
            } else {
                
                [self afAPIRequest_get_high:request success:success fail:fail requestId:requestId];
                
            }
            
            break;
        }
            
        case SAFRequestTypePOST:
        {
            if ([@"2.0" isEqualToString:AFNetworking_Version]) {
                
                [self afAPIRequest_post_low:request success:success fail:fail requestId:requestId];
                
            } else {
                
                [self afAPIRequest_post_high:request success:success fail:fail requestId:requestId];
                
            }
            
            break;
        }
            
        case SAFRequestTypeDownload:
        {
            if ([@"2.0" isEqualToString:AFNetworking_Version]) {
                
                [self afAPIRequest_download_low:request success:success fail:fail requestId:requestId];
                
            } else {
                
                [self afAPIRequest_download_high:request success:success fail:fail requestId:requestId];
                
            }
            
            break;
        }
            
        case SAFRequestTypeUpload:
        {
            if ([@"2.0" isEqualToString:AFNetworking_Version]) {
                
                [self afAPIRequest_upload_low:request success:success fail:fail requestId:requestId];
                
            } else {
                
                [self afAPIRequest_upload_high:request success:success fail:fail requestId:requestId];
                
            }
            
            break;
        }
            
        default:
            break;
    }
    
    return requestId;
}

/**
 *  AFNetworking 2.6.3 版本请求
 */
- (NSNumber *) afAPIRequest_get_low:(SunbeamAFRequest *) requestModel success:(SunbeamAFCallback) success fail:(SunbeamAFCallback) fail requestId:(NSNumber *) requestId
{
    AFHTTPRequestOperation *httpRequestOperation = [self.operationManager HTTPRequestOperationWithRequest:requestModel.request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        AFHTTPRequestOperation *storedOperation = self.dispatchTable[requestId];
        
        if (storedOperation == nil) {
            // 如果这个operation是被cancel的，那就不用处理回调了。
            return;
        } else {
            
            [self.dispatchTable removeObjectForKey:requestId];
        }
        
        int statusCode = (int)operation.response.statusCode;
        
        NSDictionary *returnValue = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        NSLog(@"GET/POST响应码为[%d]成功返回数据为:%@",statusCode,returnValue);
        
        success?success([SunbeamAFResponse getSAFResponse:[requestId integerValue] responseData:responseObject downloadFileSavePath:nil uploadFilePath:nil networkResponseError:[self getNetworkResponseError:nil]]):nil;
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        AFHTTPRequestOperation *storedOperation = self.dispatchTable[requestId];
        
        if (storedOperation == nil) {
            // 如果这个operation是被cancel的，那就不用处理回调了。
            return;
        } else {
            [self.dispatchTable removeObjectForKey:requestId];
        }
        
        NSLog(@"GET/POST失败返回数据为:[%d:%@]",(int)[error code],[error localizedDescription]);
        
        fail?fail([SunbeamAFResponse getSAFResponse:[requestId integerValue] responseData:nil downloadFileSavePath:nil uploadFilePath:nil networkResponseError:[self getNetworkResponseError:error]]):nil;
        
    }];
    
    NSLog(@"HTTPS请求url：[%@]", requestModel.urlString);
    
    NSLog(@"HTTPS请求header：[%@]", httpRequestOperation.request.allHTTPHeaderFields);
    
    NSLog(@"HTTPS请求body：[%@]", [[NSString alloc] initWithData:httpRequestOperation.request.HTTPBody encoding:NSUTF8StringEncoding]);
    
    self.dispatchTable[requestId] = httpRequestOperation;
    
    [self.operationQueue addOperation:httpRequestOperation];
    
    return requestId;
}

- (NSNumber *) afAPIRequest_post_low:(SunbeamAFRequest *) requestModel success:(SunbeamAFCallback) success fail:(SunbeamAFCallback) fail requestId:(NSNumber *) requestId
{
    return [self afAPIRequest_get_low:requestModel success:success fail:fail requestId:requestId];
}

- (NSNumber *) afAPIRequest_download_low:(SunbeamAFRequest *) requestModel success:(SunbeamAFCallback) success fail:(SunbeamAFCallback) fail requestId:(NSNumber *) requestId
{
    AFHTTPRequestOperation *httpRequestOperation = [self.operationManager HTTPRequestOperationWithRequest:requestModel.request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        AFHTTPRequestOperation *storedOperation = self.dispatchTable[requestId];
        
        if (storedOperation == nil) {
            // 如果这个operation是被cancel的，那就不用处理回调了。
            return;
        } else {
            [self.dispatchTable removeObjectForKey:requestId];
        }
        
        int statusCode = (int)operation.response.statusCode;
        
        NSLog(@"DOWNLOAD响应码为[%d]返回数据为:%@",statusCode,responseObject);
        
        success?success([SunbeamAFResponse getSAFResponse:[requestId integerValue] responseData:responseObject downloadFileSavePath:requestModel.downloadFileSavePath uploadFilePath:nil networkResponseError:[self getNetworkResponseError:nil]]):nil;
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        AFHTTPRequestOperation *storedOperation = self.dispatchTable[requestId];
        
        if (storedOperation == nil) {
            // 如果这个operation是被cancel的，那就不用处理回调了。
            return;
        } else {
            [self.dispatchTable removeObjectForKey:requestId];
        }
        
        fail?fail([SunbeamAFResponse getSAFResponse:[requestId integerValue] responseData:nil downloadFileSavePath:requestModel.downloadFileSavePath uploadFilePath:nil networkResponseError:[self getNetworkResponseError:error]]):nil;
        
    }];
    
    httpRequestOperation.outputStream = [NSOutputStream outputStreamToFileAtPath:requestModel.downloadFileSavePath append:NO];
    
    [httpRequestOperation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        NSLog(@"下载[%lld]",totalBytesRead);
        NSLog(@"期望下载[%lld]",totalBytesExpectedToRead);
    }];
    
    self.dispatchTable[requestId] = httpRequestOperation;
    
    [self.operationQueue addOperation:httpRequestOperation];
    
    return requestId;
}

- (NSNumber *) afAPIRequest_upload_low:(SunbeamAFRequest *) requestModel success:(SunbeamAFCallback) success fail:(SunbeamAFCallback) fail requestId:(NSNumber *) requestId
{
    AFHTTPRequestOperation *httpRequestOperation = [self.operationManager HTTPRequestOperationWithRequest:requestModel.request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        AFHTTPRequestOperation *storedOperation = self.dispatchTable[requestId];
        
        if (storedOperation == nil) {
            // 如果这个operation是被cancel的，那就不用处理回调了。
            return;
        } else {
            [self.dispatchTable removeObjectForKey:requestId];
        }
        
        int statusCode = (int)operation.response.statusCode;
        
        NSLog(@"UPLOAD响应码为[%d]返回数据为:%@",statusCode,responseObject);
        
        success?success([SunbeamAFResponse getSAFResponse:[requestId integerValue] responseData:responseObject downloadFileSavePath:nil uploadFilePath:requestModel.uploadFilePath networkResponseError:[self getNetworkResponseError:nil]]):nil;
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        AFHTTPRequestOperation *storedOperation = self.dispatchTable[requestId];
        
        if (storedOperation == nil) {
            // 如果这个operation是被cancel的，那就不用处理回调了。
            return;
        } else {
            [self.dispatchTable removeObjectForKey:requestId];
        }
        
        fail?fail([SunbeamAFResponse getSAFResponse:[requestId integerValue] responseData:nil downloadFileSavePath:nil uploadFilePath:requestModel.uploadFilePath networkResponseError:[self getNetworkResponseError:error]]):nil;
    }];
    
    NSLog(@"上传文件请求header：[%@]", httpRequestOperation.request.allHTTPHeaderFields);
    
    NSLog(@"上传文件请求body：[%@]", [[NSString alloc] initWithData:httpRequestOperation.request.HTTPBody encoding:NSUTF8StringEncoding]);
    
    [httpRequestOperation setUploadProgressBlock:^(NSUInteger bytesWrite, long long totalBytesWrite, long long totalBytesExpectedToWrite) {
        NSLog(@"上传[%lld]",totalBytesWrite);
    }];
    
    self.dispatchTable[requestId] = httpRequestOperation;
    
    [self.operationQueue addOperation:httpRequestOperation];
    
    return requestId;
}

/**
 *  AFNetworking 3.0 版本请求
 */
- (NSNumber *) afAPIRequest_get_high:(SunbeamAFRequest *) requestModel success:(SunbeamAFCallback) success fail:(SunbeamAFCallback) fail requestId:(NSNumber *) requestId
{
    //    AFHTTPRequestOperation* httpRequestOperation_Get = [self.operationManager GET:requestModel.urlString parameters:requestModel.parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
    //
    //        AFHTTPRequestOperation *storedOperation = self.dispatchTable[requestId];
    //
    //        if (storedOperation == nil) {
    //            // 如果这个operation是被cancel的，那就不用处理回调了。
    //            return;
    //        } else {
    //
    //            [self.dispatchTable removeObjectForKey:requestId];
    //        }
    //
    //        int statusCode = (int)operation.response.statusCode;
    //
    //        NSDictionary *returnValue = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
    //
    //        NSLog(@"GET/POST响应码为[%d]成功返回数据为:%@",statusCode,returnValue);
    //
    //        success?success([SHttpResponse sHttpResponseInitWithStatus:SAPIResponseStatusSuccess withResponseData:responseObject withResponseStatusCode:statusCode withRequestId:[requestId integerValue] withFilePathDownload:nil withFilePathUpload:nil withResponseError:nil]):nil;
    //
    //    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
    //
    //        AFHTTPRequestOperation *storedOperation = self.dispatchTable[requestId];
    //
    //        if (storedOperation == nil) {
    //            // 如果这个operation是被cancel的，那就不用处理回调了。
    //            return;
    //        } else {
    //            [self.dispatchTable removeObjectForKey:requestId];
    //        }
    //
    //        NSLog(@"GET/POST失败返回数据为:[%d:%@]",(int)[error code],[error localizedDescription]);
    //
    //        fail?fail([SHttpResponse sHttpResponseInitWithStatus:SAPIResponseStatusSuccess withResponseData:nil withResponseStatusCode:-1 withRequestId:[requestId integerValue] withFilePathDownload:nil withFilePathUpload:nil withResponseError:error]):nil;
    //
    //    }];
    //
    //    self.dispatchTable[requestId] = httpRequestOperation_Get;
    //
    //    [self.operationQueue addOperation:httpRequestOperation_Get];
    
    return requestId;
}

- (NSNumber *) afAPIRequest_post_high:(SunbeamAFRequest *) requestModel success:(SunbeamAFCallback) success fail:(SunbeamAFCallback) fail requestId:(NSNumber *) requestId
{
    //    AFHTTPRequestOperation* httpRequestOperation_Post = [self.operationManager POST:requestModel.urlString parameters:requestModel.parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
    //
    //        AFHTTPRequestOperation *storedOperation = self.dispatchTable[requestId];
    //
    //        if (storedOperation == nil) {
    //            // 如果这个operation是被cancel的，那就不用处理回调了。
    //            return;
    //        } else {
    //
    //            [self.dispatchTable removeObjectForKey:requestId];
    //        }
    //
    //        int statusCode = (int)operation.response.statusCode;
    //
    //        NSDictionary *returnValue = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
    //
    //        NSLog(@"GET/POST响应码为[%d]成功返回数据为:%@",statusCode,returnValue);
    //
    //        success?success([SHttpResponse sHttpResponseInitWithStatus:SAPIResponseStatusSuccess withResponseData:responseObject withResponseStatusCode:statusCode withRequestId:[requestId integerValue] withFilePathDownload:nil withFilePathUpload:nil withResponseError:nil]):nil;
    //
    //    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
    //
    //        AFHTTPRequestOperation *storedOperation = self.dispatchTable[requestId];
    //
    //        if (storedOperation == nil) {
    //            // 如果这个operation是被cancel的，那就不用处理回调了。
    //            return;
    //        } else {
    //            [self.dispatchTable removeObjectForKey:requestId];
    //        }
    //
    //        NSLog(@"GET/POST失败返回数据为:[%d:%@]",(int)[error code],[error localizedDescription]);
    //
    //        fail?fail([SHttpResponse sHttpResponseInitWithStatus:SAPIResponseStatusSuccess withResponseData:nil withResponseStatusCode:-1 withRequestId:[requestId integerValue] withFilePathDownload:nil withFilePathUpload:nil withResponseError:error]):nil;
    //
    //    }];
    //
    //    self.dispatchTable[requestId] = httpRequestOperation_Post;
    //
    //    [self.operationQueue addOperation:httpRequestOperation_Post];
    
    return requestId;
}

- (NSNumber *) afAPIRequest_download_high:(SunbeamAFRequest *) requestModel success:(SunbeamAFCallback) success fail:(SunbeamAFCallback) fail requestId:(NSNumber *) requestId
{
    
    return requestId;
}

- (NSNumber *) afAPIRequest_upload_high:(SunbeamAFRequest *) requestModel success:(SunbeamAFCallback) success fail:(SunbeamAFCallback) fail requestId:(NSNumber *) requestId
{
    
    return requestId;
}


//- (NSNumber *)callApiWithRequest:(NSMutableURLRequest *)request success:(SCallback)success fail:(SCallback)fail
//{
//    NSLog(@"request头部信息为：%@", [request allHTTPHeaderFields]);
//
//    NSNumber *requestId = [self generateRequestId];
//
//    NSURLSessionDataTask* dataTask = [self.sessionManager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
//
//        NSURLSessionTask* storedSessionTask = self.dispatchTable[requestId];
//
//        if (storedSessionTask == nil) {
//            // 如果这个operation是被cancel的，那就不用处理回调了。
//            return;
//        } else {
//            [self.dispatchTable removeObjectForKey:requestId];
//        }
//
//        NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse *) response;
//
//        int statusCode = [httpResponse statusCode];
//
//        NSString* responseStr = (NSString *) response;
//
//        NSLog(@"响应错误码为：[%d], 响应数据为：[%@]", statusCode, responseStr);
//
//        if (error == nil) {
//            // 成功
////            NSError* error = nil;
////
////            NSDictionary *returnValue = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:&error];
////
////            if (error) {
////                // 失败
////                NSLog(@"失败：[%d:%@]", (int)[error code],[error localizedDescription]);
////            } else {
////                NSLog(@"GET/POST成功返回数据为：%@", returnValue);
////            }
//
//            success?success([SHttpResponse sHttpResponseInitWithStatus:SAPIResponseStatusSuccess withResponseData:responseObject withResponseStatusCode:statusCode withRequestId:[requestId integerValue] withFilePathDownload:nil withFilePathUpload:nil withResponseError:nil]):nil;
//        } else {
//            // 失败
//            NSLog(@"GET/POST失败返回数据为:[%d:%@]",(int)[error code],[error localizedDescription]);
//
//            fail?fail([SHttpResponse sHttpResponseInitWithStatus:SAPIResponseStatusSuccess withResponseData:nil withResponseStatusCode:-1 withRequestId:[requestId integerValue] withFilePathDownload:nil withFilePathUpload:nil withResponseError:error]):nil;
//        }
//    }];
//
//    self.dispatchTable[requestId] = dataTask;
//
//    [self.sessionTaskQueue addObject:dataTask];
//
//    [dataTask resume];
//
//    return requestId;
//}
//
//- (NSNumber *)callApiDownloadWithRequest:(NSMutableURLRequest *)request withFilePath:(NSString *)downloadFilePath success:(SCallback)success fail:(SCallback)fail
//{
//    NSNumber *requestId = [self generateRequestId];
//
//    NSURLSessionDownloadTask* downloadTask = [self.sessionManager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
//
//    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
//        NSURL* downloadFilePathUrl = [NSURL fileURLWithPath:downloadFilePath];
//
////        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
////
////        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
//
//        return downloadFilePathUrl;
//    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
//        NSURLSessionTask* storedSessionTask = self.dispatchTable[requestId];
//
//        if (storedSessionTask == nil) {
//            // 如果这个operation是被cancel的，那就不用处理回调了。
//            return;
//        } else {
//            [self.dispatchTable removeObjectForKey:requestId];
//        }
//
//        NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse *) response;
//
//        int statusCode = [httpResponse statusCode];
//
//        if (filePath == nil) {
//            // 文件保存地址空
//            NSLog(@"文件下载错误信息:[%@]", [error localizedDescription]);
//
//            fail?fail([SHttpResponse sHttpResponseInitWithStatus:SAPIResponseStatusSuccess withResponseData:nil withResponseStatusCode:-1 withRequestId:[requestId integerValue] withFilePathDownload:downloadFilePath withFilePathUpload:nil withResponseError:error]):nil;
//        } else {
//            // 文件保存成功
//            NSLog(@"文件下载地址：[%@]", filePath);
//
//            success?success([SHttpResponse sHttpResponseInitWithStatus:SAPIResponseStatusSuccess withResponseData:nil withResponseStatusCode:statusCode withRequestId:[requestId integerValue] withFilePathDownload:downloadFilePath withFilePathUpload:nil withResponseError:nil]):nil;
//        }
//    }];
//
//    self.dispatchTable[requestId] = downloadTask;
//
//    [self.sessionTaskQueue addObject:downloadTask];
//
//    [downloadTask resume];
//
//    return requestId;
//}
//
//- (NSNumber *)callApiUploadWithRequest:(NSMutableURLRequest *)request withFilePath:(NSString *)uploadFilePath success:(SCallback)success fail:(SCallback)fail
//{
//    NSNumber *requestId = [self generateRequestId];
//
//    NSURL* uploadFilePathUrl = [NSURL fileURLWithPath:uploadFilePath];
//
//    NSURLSessionUploadTask* uploadTask = [self.sessionManager uploadTaskWithRequest:request fromFile:uploadFilePathUrl progress:^(NSProgress * _Nonnull uploadProgress) {
//
//    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
//        NSURLSessionTask* storedSessionTask = self.dispatchTable[requestId];
//
//        if (storedSessionTask == nil) {
//            // 如果这个operation是被cancel的，那就不用处理回调了。
//            return;
//        } else {
//            [self.dispatchTable removeObjectForKey:requestId];
//        }
//
//        NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse *) response;
//
//        int statusCode = [httpResponse statusCode];
//
//        if (error == nil) {
//            // 成功
//            success?success([SHttpResponse sHttpResponseInitWithStatus:SAPIResponseStatusSuccess withResponseData:responseObject withResponseStatusCode:statusCode withRequestId:[requestId integerValue] withFilePathDownload:nil withFilePathUpload:uploadFilePath withResponseError:nil]):nil;
//        } else {
//            // 失败
//            fail?fail([SHttpResponse sHttpResponseInitWithStatus:SAPIResponseStatusSuccess withResponseData:nil withResponseStatusCode:-1 withRequestId:[requestId integerValue] withFilePathDownload:nil withFilePathUpload:uploadFilePath withResponseError:error]):nil;
//        }
//    }];
//
//    self.dispatchTable[requestId] = uploadTask;
//
//    [self.sessionTaskQueue addObject:uploadTask];
//
//    [uploadTask resume];
//
//    return requestId;
//}

- (void) cancelSAFRequestWithRequestId:(NSNumber *) requestId
{
    NSOperation *requestOperation = self.dispatchTable[requestId];
    [requestOperation cancel];
    [self.dispatchTable removeObjectForKey:requestId];
}

- (void) cancelSAFRequestWithRequestIdList:(NSArray *) requestIdList
{
    for (NSNumber *requestId in requestIdList) {
        [self cancelSAFRequestWithRequestId:requestId];
    }
}

#pragma mark - private methods
- (NSNumber *)generateRequestId
{
    if (_recordedRequestId == nil) {
        _recordedRequestId = @(1);
    } else {
        if ([_recordedRequestId integerValue] == NSIntegerMax) {
            _recordedRequestId = @(1);
        } else {
            _recordedRequestId = @([_recordedRequestId integerValue] + 1);
        }
    }
    
    return _recordedRequestId;
}

#pragma mark - getters and setters
- (NSMutableDictionary *)dispatchTable
{
    if (_dispatchTable == nil) {
        _dispatchTable = [[NSMutableDictionary alloc] init];
    }
    
    return _dispatchTable;
}

- (AFSecurityPolicy *)customSecurityPolicy
{
    /**** SSL Pinning ****/
    NSString *cerPath = nil;
    
    cerPath = [[NSBundle mainBundle] pathForResource:[SunbeamAFServiceContext sharedSunbeamAFServiceContext].securitySSLCer ofType:@"cer"];
    
    NSData *certData = [NSData dataWithContentsOfFile:cerPath];
    
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    
    securityPolicy.pinnedCertificates = @[certData];
    
    [securityPolicy setAllowInvalidCertificates:NO];
    
    securityPolicy.validatesDomainName = YES;
    
    /**** SSL Pinning ****/
    
    return securityPolicy;
}

- (AFHTTPRequestOperationManager *)operationManager
{
    if (_operationManager == nil) {
        _operationManager = [AFHTTPRequestOperationManager manager];
        
        //_operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
        _operationManager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        //        AFSecurityPolicy* securityPolicyForZAPI = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        //
        //        securityPolicyForZAPI.allowInvalidCertificates = YES;
        //
        //        securityPolicyForZAPI.validatesDomainName = NO;
        //
        //        _operationManager.securityPolicy = securityPolicyForZAPI;
        
        _operationManager.securityPolicy = self.customSecurityPolicy;
    }
    
    return _operationManager;
}

- (NSOperationQueue *)operationQueue
{
    if (_operationQueue == nil) {
        _operationQueue = [self.operationManager operationQueue];
    }
    return _operationQueue;
}

- (NSInteger) getNetworkResponseError:(NSError *) error
{
    if (error) {
        NSInteger result = SAFNetworkSystemErrorNoNetwork;
        //待改进，目前处理是：除了超时、服务器响应异常以外，所有错误都当成是无网络
        if (error.code == NSURLErrorTimedOut) {
            result = SAFNetworkSystemErrorNetworkTimeOut;
        } else if (error.code == NSURLErrorBadServerResponse) {
            result = SAFNetworkSystemErrorBadServerResponse;
        }
        return result;
    } else {
        return SAFNetworkSystemErrorRequestSuccess;
    }
}

//- (AFURLSessionManager *)sessionManager
//{
//    if (_sessionManager == nil) {
//        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
//
//        _sessionManager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:configuration];
//
//        _sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
//
//        //_sessionManager.securityPolicy = self.customSecurityPolicy;
//
//        _sessionManager.securityPolicy.allowInvalidCertificates = YES;
//
//        _sessionManager.securityPolicy.validatesDomainName = NO;
//    }
//
//    return _sessionManager;
//}
//
//- (AFHTTPSessionManager *)httpSessionManager
//{
//    if (_httpSessionManager == nil) {
//        _httpSessionManager = [AFHTTPSessionManager manager];
//
//        _httpSessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
//
//        _httpSessionManager.securityPolicy.allowInvalidCertificates = YES;
//
//        _httpSessionManager.securityPolicy.validatesDomainName = NO;
//        
//        [_httpSessionManager.requestSerializer setValue:@"1.0" forHTTPHeaderField:@"APIVER"];
//    }
//    
//    return _httpSessionManager;
//}

//- (NSMutableArray *)sessionTaskQueue
//{
//    if (_sessionTaskQueue == nil) {
//        _sessionTaskQueue = [[NSMutableArray alloc] init];
//        
//    }
//    
//    return _sessionTaskQueue;
//}

@end
