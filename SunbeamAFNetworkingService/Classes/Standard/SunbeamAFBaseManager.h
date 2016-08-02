//
//  SunbeamAFBaseManager.h
//  Pods
//
//  Created by sunbeam on 16/6/29.
//
//

#import <Foundation/Foundation.h>

#import "SunbeamAFResponse.h"

#import "SunbeamAFServiceContext.h"

@class SunbeamAFBaseManager;

#pragma mark - 用于获取请求的参数
@protocol SAFManagerParamsForRequest <NSObject>

- (NSDictionary *) managerParamsForRequest:(SunbeamAFBaseManager *) manager;

@end

#pragma mark - 请求参数以及请求响应合法性检查
@protocol SAFManagerParamsAndCallbackValidator <NSObject>

- (BOOL) managerParamsValidator:(SunbeamAFBaseManager *) manager;

- (BOOL) managerCallbackValidator:(SunbeamAFBaseManager *) manager;

@end

#pragma mark - 拦截器，用于请求预处理或者纪录操作请求
@protocol SAFManagerInterceptor <NSObject>

@optional
- (void) managerInterceptorBeforePerformSuccess:(SunbeamAFBaseManager *) manager;

- (void) managerInterceptorAfterPerformSuccess:(SunbeamAFBaseManager *) manager;

- (void) managerInterceptorBeforePerformFail:(SunbeamAFBaseManager *) manager;

- (void) managerInterceptorAfterPerformFail:(SunbeamAFBaseManager *) manager;

@end

#pragma mark - 请求响应处理
@protocol SAFManagerCallbackDataReformer <NSObject>

- (NSDictionary *) managerCallbackDataReformer:(SunbeamAFBaseManager *) manager;

@end

#pragma mark - 成功或者失败回调处理
@protocol SAFManagerCallbackDelegate <NSObject>

- (void) managerCallbackSuccess:(SunbeamAFBaseManager *) manager;

- (void) managerCallbackFail:(SunbeamAFBaseManager *) manager;

@end

#pragma mark - manager派生类必须继承的协议
@protocol SAFManagerProtocol <NSObject>

@required
- (NSString *) methodName;

- (NSString *) serviceIdentifier;

- (SAFRequestType) requestType;

@optional
- (void) cleanData;

@end

@interface SunbeamAFBaseManager : NSObject

@property (nonatomic, weak) id<SAFManagerParamsForRequest> paramsForRequest;

@property (nonatomic, weak) id<SAFManagerParamsAndCallbackValidator> paramsAndCallbackValidator;

@property (nonatomic, weak) id<SAFManagerInterceptor> managerInterceptor;

@property (nonatomic, weak) id<SAFManagerCallbackDataReformer> managerCallbackDataReformer;

@property (nonatomic, weak) id<SAFManagerCallbackDelegate> managerCallbackDelegate;

@property (nonatomic, weak) NSObject<SAFManagerProtocol>* child;

@property (nonatomic, strong) SunbeamAFResponse* httpResponse;

@property (nonatomic, assign, readonly) BOOL isReachable;

@property (nonatomic, assign, readonly) BOOL isLoading;

// 请求发起入口
- (NSInteger) loadRequest;

// 需要使用该数据的调用者可以继承SAPIManagerCallbackDataReformer实现格式化响应数据的操作，以满足自己的界面展示或其他需求
- (NSDictionary *) fetchHttpResponseDictWithReformer:(id<SAFManagerCallbackDataReformer>) reformer;

// 取消当前正在进行的HTTPS请求
- (void) cancelAllRequests;

- (void) cancelRequestWithRequestId:(NSInteger) requestId;

// 发生内存警告或者需要释放资源时，清空所有数据和当前正在发生的HTTP请求
- (void) cleanData;

@end
