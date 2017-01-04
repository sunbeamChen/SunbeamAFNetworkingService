//
//  SunbeamAFRequest.h
//  Pods
//
//  Created by sunbeam on 16/6/29.
//
//

#import <Foundation/Foundation.h>
#import "SunbeamAFServiceProperty.h"

@interface SunbeamAFRequest : NSObject

@property (nonatomic, assign) SAF_REQUEST_METHOD requestMethod;

@property (nonatomic, strong) NSMutableURLRequest* request;

@property (nonatomic, copy) NSString* urlString;

@property (nonatomic, assign) BOOL useSSLCertificates;

@property (nonatomic, strong) NSMutableDictionary* headerParameters;

@property (nonatomic, strong) NSMutableDictionary* urlParameters;

@property (nonatomic, strong) NSMutableDictionary* bodyParameters;

@property (nonatomic, strong) NSMutableDictionary* uploadFiles;

@property (nonatomic, copy) NSString* downloadUrl;

/**
 SunbeamAFRequest

 @param requestMethod 请求方法
 @param request 请求实例
 @param urlString 请求url
 @param useSSLCertificates 是否使用SSL
 @param headerParameters 请求参数header
 @param urlParameters 请求参数url
 @param bodyParameters 请求参数body
 @param uploadFiles 上传文件字典{'fileKey':'localFilePath'}
 @param downloadUrl 下载地址
 @return SunbeamAFRequest
 */
+ (SunbeamAFRequest *) getSAFRequest:(SAF_REQUEST_METHOD) requestMethod request:(NSMutableURLRequest *) request urlString:(NSString *) urlString useSSLCertificates:(BOOL) useSSLCertificates headerParameters:(NSMutableDictionary *) headerParameters urlParameters:(NSMutableDictionary *) urlParameters bodyParameters:(NSMutableDictionary *) bodyParameters uploadFiles:(NSMutableDictionary *) uploadFiles downloadUrl:(NSString *) downloadUrl;

@end
