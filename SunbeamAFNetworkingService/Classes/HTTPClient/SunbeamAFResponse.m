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
@property (nonatomic, assign, readwrite) NSInteger errorcode;

// 响应错误信息
@property (nonatomic, copy, readwrite) NSString* message;

// 初始化响应实例
- (instancetype) initSAFResponse:(NSInteger) requestId responseData:(id) responseData downloadFileSavePath:(NSString *) downloadFileSavePath uploadFilePath:(NSString *) uploadFilePath errorcode:(NSInteger) errorcode message:(NSString *) message;

@end

@implementation SunbeamAFResponse

- (instancetype)initSAFResponse:(NSInteger)requestId responseData:(id)responseData downloadFileSavePath:(NSString *)downloadFileSavePath uploadFilePath:(NSString *)uploadFilePath errorcode:(NSInteger) errorcode message:(NSString *) message
{
    if (self = [super init]) {
        self.requestId = requestId;
        self.responseData = responseData;
        self.downloadFileSavePath = downloadFileSavePath;
        self.uploadFilePath = uploadFilePath;
        self.errorcode = errorcode;
        self.message = message;
    }
    
    return self;
}

+ (SunbeamAFResponse *)getSAFResponse:(NSInteger)requestId responseData:(id)responseData downloadFileSavePath:(NSString *)downloadFileSavePath uploadFilePath:(NSString *)uploadFilePath errorcode:(NSInteger) errorcode message:(NSString *) message
{
    SunbeamAFResponse* safResponse = [[SunbeamAFResponse alloc] initSAFResponse:requestId responseData:responseData downloadFileSavePath:downloadFileSavePath uploadFilePath:uploadFilePath errorcode:errorcode message:message];
    
    return safResponse;
}

@end
