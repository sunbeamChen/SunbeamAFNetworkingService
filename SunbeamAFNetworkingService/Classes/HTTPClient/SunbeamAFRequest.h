//
//  SunbeamAFRequest.h
//  Pods
//
//  Created by sunbeam on 16/6/29.
//
//

#import <Foundation/Foundation.h>

#import "SunbeamAFServiceContext.h"

@interface SunbeamAFRequest : NSObject

// 请求类型
@property (nonatomic, assign, readonly) SAFRequestType requestType;

// 请求实例
@property (nonatomic, strong, readonly) NSMutableURLRequest* request;

// 请求url
@property (nonatomic, copy, readonly) NSString* urlString;

// security ssl cer file path
@property (nonatomic, copy, readonly) NSString* cerFilePath;

// header请求参数
@property (nonatomic, strong, readonly) NSMutableDictionary* headerParameters;

// url请求参数
@property (nonatomic, strong, readonly) NSMutableDictionary* urlParameters;

// body请求参数
@property (nonatomic, strong, readonly) NSMutableDictionary* bodyParameters;

// download文件保存地址
@property (nonatomic, copy, readonly) NSString* downloadFileSavePath;

// upload文件上传地址
@property (nonatomic, copy, readonly) NSString* uploadFilePath;

// 获取请求实例对象
+ (SunbeamAFRequest *) getSAFRequest:(SAFRequestType) requestType request:(NSMutableURLRequest *) request urlString:(NSString *) urlString cerFilePath:(NSString *) cerFilePath headerParameters:(NSMutableDictionary *) headerParameters urlParameters:(NSMutableDictionary *) urlParameters bodyParameters:(NSMutableDictionary *) bodyParameters downloadFileSavePath:(NSString *) downloadFileSavePath uploadFilePath:(NSString *) uploadFilePath;

@end
