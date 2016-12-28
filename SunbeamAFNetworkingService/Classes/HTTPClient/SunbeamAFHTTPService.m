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

@property (nonatomic, strong) AFURLSessionManager* httpSessionManager;

@property (nonatomic, strong) AFURLSessionManager* jsonSessionManager;

@end

@implementation SunbeamAFHTTPService

- (instancetype)init
{
    if (self = [super init]) {
        _httpSessionManager = nil;
    }
    return self;
}

- (NSURLSessionDataTask *)loadDataTask:(SunbeamAFRequest *)slafRequest completion:(void (^)(NSURLResponse *, id, NSError *))completion
{
    AFURLSessionManager* sessionManager = [self getHttpSessionManager:slafRequest.useSSLCertificates];
    
    NSURLSessionDataTask* dataTask = [sessionManager dataTaskWithRequest:slafRequest.request completionHandler:completion];
    [dataTask resume];
    
    return dataTask;
}

- (NSURLSessionUploadTask *)loadUploadTask:(SunbeamAFRequest *)slafRequest uploadProgress:(NSProgress * __nullable __autoreleasing * __nullable)uploadProgress completion:(void (^)(NSURLResponse *, id, NSError *))completion
{
    AFURLSessionManager* sessionManager = [self getHttpSessionManager:slafRequest.useSSLCertificates];
    
    NSURLSessionUploadTask* uploadTask = [sessionManager uploadTaskWithStreamedRequest:slafRequest.request progress:uploadProgress completionHandler:completion];
    [uploadTask resume];
    
    return uploadTask;
}

- (NSURLSessionDownloadTask *)loadDownloadTask:(SunbeamAFRequest *)slafRequest downloadProgress:(NSProgress * __nullable __autoreleasing * __nullable)downloadProgress completion:(void (^)(NSURLResponse *, NSURL *, NSError *))completion
{
    AFURLSessionManager* sessionManager = [self getHttpSessionManager:slafRequest.useSSLCertificates];
    
    NSURLSessionDownloadTask* downloadTask = [sessionManager downloadTaskWithRequest:slafRequest.request progress:downloadProgress destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:completion];
    [downloadTask resume];
    
    return downloadTask;
}

#pragma mark - private method
- (AFURLSessionManager *)getHttpSessionManager:(BOOL) useSSLCertificates
{
    if (_httpSessionManager == nil) {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        _httpSessionManager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
        _httpSessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
        if (useSSLCertificates) {
            _httpSessionManager.securityPolicy = [self getCustomSecurityPolicy];
        } else {
            _httpSessionManager.securityPolicy = [self getDefaultSecurityPolicy];
        }
    }
    
    return _httpSessionManager;
}

- (AFSecurityPolicy *) getDefaultSecurityPolicy
{
    AFSecurityPolicy* securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    securityPolicy.allowInvalidCertificates = NO;
    securityPolicy.validatesDomainName = NO;
    
    return securityPolicy;
}

- (AFSecurityPolicy *) getCustomSecurityPolicy
{
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    securityPolicy.pinnedCertificates = [self getDefaultPinnedCertificates];
    securityPolicy.allowInvalidCertificates = NO;
    securityPolicy.validatesDomainName = YES;
    
    return securityPolicy;
}

/**
 默认cer文件从main bundle中加载

 @return cer文件数组
 */
- (NSArray *) getDefaultPinnedCertificates {
    NSArray* defaultPinnedCertificates = nil;
    NSBundle *bundle = [NSBundle mainBundle];
    NSArray *paths = [bundle pathsForResourcesOfType:@"cer" inDirectory:@"."];
    NSMutableArray *certificates = [NSMutableArray arrayWithCapacity:[paths count]];
    for (NSString *path in paths) {
        NSData *certificateData = [NSData dataWithContentsOfFile:path];
        [certificates addObject:certificateData];
    }
    defaultPinnedCertificates = [[NSArray alloc] initWithArray:certificates];
    
    return defaultPinnedCertificates;
}

@end
