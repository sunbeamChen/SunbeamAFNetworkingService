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
// 网络类型
typedef NS_ENUM(NSInteger, SAFNetworkStatus) {
    SAFNetworkStatusUnknown          = -1,  // 未知
    SAFNetworkStatusNotReachable     = 0,   // 不可达
    SAFNetworkStatusReachableViaWWAN = 1,   // 蜂窝流量
    SAFNetworkStatusReachableViaWiFi = 2,   // wifi
};
// 网络请求系统错误
typedef NS_ENUM(NSInteger, SAFNetworkSystemError) {
    SAFNetworkSystemErrorDefault = -1,  // 默认发起请求
    SAFNetworkSystemErrorNetworkTimeOut = -2,  // 网络请求超时
    SAFNetworkSystemErrorBadServerResponse = -3,    // 服务器响应有误
    SAFNetworkSystemErrorNoNetwork = -4,    // 没有网络
    SAFNetworkSystemErrorRequestIsRuning = -5,  // 当前正在进行网络请求
    SAFNetworkSystemErrorRequestSuccess = 0,    // 表示网络请求成功
};
// 网络状态发生变化时发送notification
# define SAF_NETWORK_STATUS_CHANGED_NOTIFICATION_NAME @"network_status_changed_notification"
// 请求超时默认设置
#define SunbeamAFRequestTimeoutInterval 10.0f
// 单独设置request header content type是因为在requestSerializer初始化的时候需要确定是使用httpRequestSerializer还是httpJsonRequestSerializer.
#define SunbeamAFRequestHeaderContentType @"saf_request_header_content_type_string"
// 设置NSMutableURLRequest header中参数，例如版本号APIVersion
#define SunbeamAFRequestHeaderParamsKey @"saf_request_header_params_dict"
// 设置NSMutableURLRequest url链接后使用 ? 后接的参数
#define SunbeamAFRequestUrlParamsKey @"saf_request_url_dict"
// 设置NSMutableURLRequest body中请求参数
#define SunbeamAFRequestBodyParamsKey @"saf_request_body_dict"
// 设置文件下载后保存的地址
#define SunbeamAFRequestDownloadFileSavePathParamsKey @"saf_request_download_file_save_path_string"
// 设置需要上传文件的本地地址
#define SunbeamAFRequestUploadFilePathParamsKey @"saf_request_upload_file_path_string"

@interface SunbeamAFServiceContext : NSObject

/**
 *  单例
 */
+ (SunbeamAFServiceContext *) sharedSunbeamAFServiceContext;

// 上传接口中上传文件时设置的key值
@property (nonatomic, copy) NSString* uploadFileKey;
// 网络请求超时时间设置
@property (nonatomic, assign) NSTimeInterval timeoutInterval;
// 网络是否可达
@property (nonatomic, assign, readonly) BOOL networkIsReachable;
// 当前网络状态
@property (nonatomic, assign, readonly) SAFNetworkStatus networkStatus;
// 设置service factory代理
- (void) setSAFServiceFactoryDelegate:(id<SAFServiceFactoryProtocol>) serviceFactoryDelegate;

@end
