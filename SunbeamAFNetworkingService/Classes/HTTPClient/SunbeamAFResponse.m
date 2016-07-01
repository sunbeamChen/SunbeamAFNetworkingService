//
//  SunbeamAFResponse.m
//  Pods
//
//  Created by sunbeam on 16/6/30.
//
//

#import "SunbeamAFResponse.h"

@interface SunbeamAFResponse()

// 请求id
@property (nonatomic, assign, readwrite) NSInteger requestId;

// 响应数据
@property (nonatomic, strong, readwrite) id responseData;

// 文件下载路径
@property (nonatomic, copy, readwrite) NSString* downloadFileSavePath;

// 文件上传路径
@property (nonatomic, copy, readwrite) NSString* uploadFilePath;

// 响应错误
@property (nonatomic, strong, readwrite) NSError* responseError;

// 初始化响应实例
- (instancetype) initSAFResponse:(NSInteger) requestId responseData:(id) responseData downloadFileSavePath:(NSString *) downloadFileSavePath uploadFilePath:(NSString *) uploadFilePath responseError:(NSError *) responseError;

@end

@implementation SunbeamAFResponse

- (instancetype)initSAFResponse:(NSInteger)requestId responseData:(id)responseData downloadFileSavePath:(NSString *)downloadFileSavePath uploadFilePath:(NSString *)uploadFilePath responseError:(NSError *)responseError
{
    if (self = [super init]) {
        self.requestId = requestId;
        self.responseData = responseData;
        self.downloadFileSavePath = downloadFileSavePath;
        self.uploadFilePath = uploadFilePath;
        self.responseError = responseError;
    }
    
    return self;
}

+ (SunbeamAFResponse *)getSAFResponse:(NSInteger)requestId responseData:(id)responseData downloadFileSavePath:(NSString *)downloadFileSavePath uploadFilePath:(NSString *)uploadFilePath responseError:(NSError *)responseError
{
    SunbeamAFResponse* safResponse = [[SunbeamAFResponse alloc] initSAFResponse:requestId responseData:responseData downloadFileSavePath:downloadFileSavePath uploadFilePath:uploadFilePath responseError:responseError];
    
    return safResponse;
}

@end
