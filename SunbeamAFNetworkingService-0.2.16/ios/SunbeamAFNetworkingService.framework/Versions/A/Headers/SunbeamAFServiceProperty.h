//
//  SunbeamAFServiceProperty.h
//  Pods
//
//  Created by sunbeam on 2016/12/27.
//
//

#ifndef SunbeamAFServiceProperty_h
#define SunbeamAFServiceProperty_h

// 请求类型
typedef enum : NSUInteger {
    GET         = 0, // GET请求
    POST        = 1, // POST请求
    UPLOAD      = 2, // 上传请求
    DOWNLOAD    = 3, // 下载请求
} SAF_REQUEST_METHOD;

// error domain
#define SAF_ERROR_DOMAIN @"saf_error_domain"

// 网络请求系统错误
typedef enum : NSUInteger {
    NETWORK_TIMEOUT_ERROR       = -1,   // 网络请求超时 "network request is timeout"
    BAD_SERVER_RESPONSE_ERROR   = -2,   // 服务器响应有误 "server response is error"
    NETWORK_NOT_REACHABLE_ERROR = -3,   // 网络不可达 "network is not reachable"
    REQUEST_RUNING_ERROR        = -4,   // 当前正在进行网络请求 "network request is busy"
    REQUEST_METHOD_NOT_SUPPORT  = -5,   // 当前请求方法不支持 "request method not support"
} SAF_NETWORK_SYSTEM_ERROR;

// 请求超时默认设置
#define SAFRequestTimeoutInterval 10.0f

// 设置NSMutableURLRequest header中参数，例如版本号APIVersion,系统默认的 "Content-Type"
#define SAFRequestHeaderParamsKey @"saf_request_header_params_dict"

// 设置NSMutableURLRequest url链接后使用 ? 后接的参数
#define SAFRequestUrlParamsKey @"saf_request_url_dict"

// 设置NSMutableURLRequest body中请求参数
#define SAFRequestBodyParamsKey @"saf_request_body_dict"

#endif /* SunbeamAFServiceProperty_h */
