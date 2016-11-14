//
//  SunbeamAFRequest.m
//  Pods
//
//  Created by sunbeam on 16/6/29.
//
//

#import "SunbeamAFRequest.h"

@interface SunbeamAFRequest()

// 请求类型
@property (nonatomic, assign, readwrite) SAFRequestType requestType;

// 请求实例
@property (nonatomic, strong, readwrite) NSMutableURLRequest* request;

// 请求url
@property (nonatomic, copy, readwrite) NSString* urlString;

// security ssl cer file path
@property (nonatomic, copy, readwrite) NSString* cerFilePath;

// header请求参数
@property (nonatomic, strong, readwrite) NSMutableDictionary* headerParameters;

// url请求参数
@property (nonatomic, strong, readwrite) NSMutableDictionary* urlParameters;

// body请求参数
@property (nonatomic, strong, readwrite) NSMutableDictionary* bodyParameters;

// download文件保存地址
@property (nonatomic, copy, readwrite) NSString* downloadFileSavePath;

// upload文件上传地址
@property (nonatomic, copy, readwrite) NSString* uploadFilePath;

// 初始化请求实例对象
- (instancetype) initSAFRequest:(SAFRequestType) requestType request:(NSMutableURLRequest *) request urlString:(NSString *) urlString cerFilePath:(NSString *) cerFilePath headerParameters:(NSMutableDictionary *) headerParameters urlParameters:(NSMutableDictionary *) urlParameters bodyParameters:(NSMutableDictionary *) bodyParameters downloadFileSavePath:(NSString *) downloadFileSavePath uploadFilePath:(NSString *) uploadFilePath;

@end

@implementation SunbeamAFRequest

- (instancetype)initSAFRequest:(SAFRequestType)requestType request:(NSMutableURLRequest *)request urlString:(NSString *)urlString cerFilePath:(NSString *) cerFilePath headerParameters:(NSMutableDictionary *)headerParameters urlParameters:(NSMutableDictionary *)urlParameters bodyParameters:(NSMutableDictionary *)bodyParameters downloadFileSavePath:(NSString *)downloadFileSavePath uploadFilePath:(NSString *)uploadFilePath
{
    if (self = [super init]) {
        self.requestType = requestType;
        self.request = request;
        self.urlString = urlString;
        self.cerFilePath = cerFilePath;
        self.headerParameters = headerParameters;
        self.urlParameters = urlParameters;
        self.bodyParameters = bodyParameters;
        self.downloadFileSavePath = downloadFileSavePath;
        self.uploadFilePath = uploadFilePath;
    }
    
    return self;
}

+ (SunbeamAFRequest *)getSAFRequest:(SAFRequestType)requestType request:(NSMutableURLRequest *)request urlString:(NSString *)urlString cerFilePath:(NSString *) cerFilePath headerParameters:(NSMutableDictionary *)headerParameters urlParameters:(NSMutableDictionary *)urlParameters bodyParameters:(NSMutableDictionary *)bodyParameters downloadFileSavePath:(NSString *)downloadFileSavePath uploadFilePath:(NSString *)uploadFilePath
{
    SunbeamAFRequest* safRequest = [[SunbeamAFRequest alloc] initSAFRequest:requestType request:request urlString:urlString cerFilePath:cerFilePath headerParameters:headerParameters urlParameters:urlParameters bodyParameters:bodyParameters downloadFileSavePath:downloadFileSavePath uploadFilePath:uploadFilePath];
    
    return safRequest;
}

@end
