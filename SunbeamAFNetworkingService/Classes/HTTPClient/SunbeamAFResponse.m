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

// 响应错误码
@property (nonatomic, assign, readwrite) NSInteger networkResponseError;

// 初始化响应实例
- (instancetype) initSAFResponse:(NSInteger) requestId responseData:(id) responseData downloadFileSavePath:(NSString *) downloadFileSavePath uploadFilePath:(NSString *) uploadFilePath networkResponseError:(NSInteger) networkResponseError;

@end

@implementation SunbeamAFResponse

- (instancetype)initSAFResponse:(NSInteger)requestId responseData:(id)responseData downloadFileSavePath:(NSString *)downloadFileSavePath uploadFilePath:(NSString *)uploadFilePath networkResponseError:(NSInteger)networkResponseError
{
    if (self = [super init]) {
        self.requestId = requestId;
        self.responseData = responseData;
        self.downloadFileSavePath = downloadFileSavePath;
        self.uploadFilePath = uploadFilePath;
        self.networkResponseError = networkResponseError;
    }
    
    return self;
}

+ (SunbeamAFResponse *)getSAFResponse:(NSInteger)requestId responseData:(id)responseData downloadFileSavePath:(NSString *)downloadFileSavePath uploadFilePath:(NSString *)uploadFilePath networkResponseError:(NSInteger) networkResponseError
{
    SunbeamAFResponse* safResponse = [[SunbeamAFResponse alloc] initSAFResponse:requestId responseData:responseData downloadFileSavePath:downloadFileSavePath uploadFilePath:uploadFilePath networkResponseError:networkResponseError];
    
    return safResponse;
}

@end
