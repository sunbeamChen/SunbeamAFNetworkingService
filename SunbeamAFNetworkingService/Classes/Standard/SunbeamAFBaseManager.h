//
//  SunbeamAFBaseManager.h
//  Pods
//
//  Created by sunbeam on 16/6/29.
//
//

#import <Foundation/Foundation.h>
#import "SunbeamAFServiceProperty.h"

#pragma mark - manager派生类必须继承的协议
@protocol SAFManagerProtocol <NSObject>

@required
- (NSString *) URI;

- (NSString *) identifier;

- (SAF_REQUEST_METHOD) method;

@optional
- (void) cleanData;

@end

#pragma mark - 用于获取请求的参数
@protocol SAFManagerParamsForRequest <NSObject>

@required
- (NSDictionary *) managerParamsForRequest;

@end

#pragma mark - 请求参数以及请求响应合法性检查
@protocol SAFManagerParamsValidator <NSObject>

@optional
- (NSError *) managerParamsValidate;

@end

#pragma mark - 拦截器，用于请求预处理或者纪录操作请求
@protocol SAFManagerInterceptor <NSObject>

@optional
- (void) managerInterceptorPerformSuccess;

- (void) managerInterceptorPerformFailed;

@end

#pragma mark - 请求响应处理
@protocol SAFManagerCallbackDataFormatter <NSObject>

- (id) managerCallbackDataFormat:(id) responseObject;

@end

#pragma mark - 响应结果格式化后合法性检查
@protocol SAFManagerCallbackDataValidator <NSObject>

@optional
- (NSError *) managerCallbackDataValidate:(id) formatData;

@end

@interface SunbeamAFBaseManager : NSObject

@property (nonatomic, weak) NSObject<SAFManagerProtocol>* childManager;

@property (nonatomic, weak) id<SAFManagerParamsForRequest> paramsForRequest;

@property (nonatomic, weak) id<SAFManagerParamsValidator> paramsValidator;

@property (nonatomic, weak) id<SAFManagerInterceptor> managerInterceptor;

@property (nonatomic, weak) id<SAFManagerCallbackDataFormatter> managerCallbackDataFormatter;

@property (nonatomic, weak) id<SAFManagerCallbackDataValidator> managerCallbackDataValidator;

/**
 数据请求入口

 @param completion 回调
 @return 请求id
 */
- (NSNumber *) loadDataTask:(void(^)(NSString* identifier, id responseObject, NSError* error)) completion;

/**
 上传请求入口

 @param uploadFiles 上传文件字典
 @param uploadProgress 上传进程
 @param completion 回调
 @return 请求id
 */
- (NSNumber *) loadUploadTask:(NSMutableDictionary *) uploadFiles uploadProgress:(NSProgress * __nullable __autoreleasing * __nullable) uploadProgress completion:(void(^)(NSString* identfier, id responseObject, NSError* error)) completion;

/**
 下载请求入口

 @param downloadProgress 下载进程
 @param completion 回调
 @return 请求id
 */
- (NSNumber *) loadDownloadTask:(NSProgress * __nullable __autoreleasing * __nullable) downloadProgress completion:(void(^)(NSString* identfier, NSURL* downloadFileurl, NSError* error)) completion;

@end
