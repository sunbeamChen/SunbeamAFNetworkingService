//
//  SunbeamAFHTTPClient.h
//  Pods
//
//  Created by sunbeam on 16/6/30.
//
//

#import <Foundation/Foundation.h>
#import "SunbeamAFServiceProperty.h"
#import "SunbeamAFResponse.h"

#define SUNBEAM_AFNETWORKING_SERVICE_VERSION @"0.2.15"

@interface SunbeamAFHTTPClient : NSObject

/**
 session任务列表 {"requestId":NSURLSessionTask}
 */
@property (nonatomic, strong, readonly) NSMutableDictionary* sessionTaskQueue;

/**
 *  单例
 */
+ (SunbeamAFHTTPClient *) sharedSunbeamAFHTTPClient;

/**
 Get/Post
 
 @param URI 统一资源定位符
 @param identifier 标识
 @param method 方法
 @param params 参数
 @param completion 回调
 @return 请求id
 */
- (NSNumber *) loadDataTask:(NSString *) URI identifier:(NSString *) identifier method:(SAF_REQUEST_METHOD) method params:(NSDictionary *) params completion:(void (^)(SunbeamAFResponse* response)) completion;

/**
 Upload
 
 @param URI 统一资源定位符
 @param identifier 标识
 @param method 方法
 @param params 参数
 @param uploadProgress 上传进程
 @param completion 回调
 @return 请求id
 */
- (NSNumber *) loadUploadTask:(NSString *) URI identifier:(NSString *) identifier method:(SAF_REQUEST_METHOD) method params:(NSDictionary *) params uploadFiles:(NSMutableDictionary *) uploadFiles uploadProgress:(NSProgress * __nullable __autoreleasing * __nullable) uploadProgress completion:(void (^)(SunbeamAFResponse* response)) completion;

/**
 Download
 
 @param URI 统一资源定位符
 @param identifier 标识
 @param method 方法
 @param params 参数
 @param downloadProgress 下载进程
 @param completion 回调
 @return 请求id
 */
- (NSNumber *) loadDownloadTask:(NSString *) URI identifier:(NSString *) identifier method:(SAF_REQUEST_METHOD) method params:(NSDictionary *) params downloadProgress:(NSProgress * __nullable __autoreleasing * __nullable)downloadProgress completion:(void (^)(SunbeamAFResponse* response)) completion;

/**
 取消所有网络请求
 */
- (void) cancelAllRequest;

/**
 取消指定requestId的网络请求
 
 @param requestId 请求id
 */
- (void) cancelRequest:(NSNumber *) requestId;

@end
