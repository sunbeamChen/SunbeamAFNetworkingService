//
//  SunbeamAFHTTPService.h
//  Pods
//
//  Created by sunbeam on 16/6/30.
//
//

#import <Foundation/Foundation.h>
#import "SunbeamAFRequest.h"

@interface SunbeamAFHTTPService : NSObject

/**
 GET/POST
 
 @param slafRequest 请求
 @param completion 回调
 @return NSURLSessionTask
 */
- (id) loadDataTask:(SunbeamAFRequest *) slafRequest completion:(void (^)(NSURLResponse* response, id responseObject,  NSError* error)) completion;

/**
 Upload
 
 @param slafRequest 请求
 @param uploadProgressBlock 上传进程
 @param completion 回调
 @return NSURLSessionTask
 */
- (id) loadUploadTask:(SunbeamAFRequest *) slafRequest uploadProgress:(NSProgress * __nullable __autoreleasing * __nullable) uploadProgress completion:(void (^)(NSURLResponse* response, id responseObject,  NSError* error)) completion;

/**
 Download
 
 @param slafRequest 请求
 @param downloadProgressBlock 下载进程
 @param completion 回调
 @return NSURLSessionTask
 */
- (id) loadDownloadTask:(SunbeamAFRequest *) slafRequest downloadProgress:(NSProgress * __nullable __autoreleasing * __nullable)downloadProgress completion:(void (^)(NSURLResponse* response, NSURL* filePath, NSError* error)) completion;

@end
