//
//  SunbeamAFServiceContext.h
//  Pods
//
//  Created by sunbeam on 16/6/29.
//
//

#import <Foundation/Foundation.h>

#import "SunbeamAFServiceFactory.h"

// 请求类型
typedef NS_ENUM(NSInteger, SAFRequestType) {
    SAFRequestTypeGET = 0,      // GET请求
    SAFRequestTypePOST = 1,     // POST请求
    SAFRequestTypeDownload = 2, // 下载请求
    SAFRequestTypeUpload = 3,   // 上传请求
};

// 请求超时默认设置
#define SunbeamAFRequestTimeoutInterval 10.0f

// 请求参数key设置
#define SunbeamAFRequestHeaderParamsKey @"saf_request_header"

#define SunbeamAFRequestUrlParamsKey @"saf_request_url"

#define SunbeamAFRequestBodyParamsKey @"saf_request_body"

#define SunbeamAFRequestDownloadFileSavePathParamsKey @"saf_request_download_file_save_path"

#define SunbeamAFRequestUploadFilePathParamsKey @"saf_request_upload_file_path"

// 上传文件时form data中key值
#define SunbeamAFRequestUploadFileFormDataFileKey @"file"

// 上传文件时认证key值
#define SunbeamAFRequestUploadFileFormDataTokenKey @"token"

@interface SunbeamAFServiceContext : NSObject

// 单例
SAF_singleton_interface(SunbeamAFServiceContext)

// SSL网络证书配置文件名称
@property (nonatomic, copy) NSString* securitySSLCer;

// 网络请求超时时间设置
@property (nonatomic, assign) NSTimeInterval timeoutInterval;

// 是否统一设置service base url and version，只有标识为YES时，unifiedUrl、unifiedVersion才有用
@property (nonatomic, assign) BOOL serviceUnified;

// 网络请求服务base url
@property (nonatomic, copy) NSString* unifiedUrl;

// 网络请求服务base version
@property (nonatomic, copy) NSString* unifiedVersion;

// 设置service factory 代理
- (void) setSAFServiceFactoryDelegate:(id<SAFServiceFactoryProtocol>) serviceFactoryDelegate;

@end
