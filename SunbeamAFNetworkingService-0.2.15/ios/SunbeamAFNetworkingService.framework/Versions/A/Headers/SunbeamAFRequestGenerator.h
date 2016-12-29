//
//  SunbeamAFRequestGenerator.h
//  Pods
//
//  Created by sunbeam on 16/6/30.
//
//

#import <Foundation/Foundation.h>
#import "SunbeamAFRequest.h"

@interface SunbeamAFRequestGenerator : NSObject

/**
 Sunbeam AF Request实例

 @param requestMethod 请求方法
 @param identifier 网络请求服务标识
 @param URI 请求资源定位符
 @param requestParams 请求参数
 @param uploadFiles 上传文件字典
 @return SunbeamAFRequest
 */
+ (SunbeamAFRequest *) generateSAFRequest:(SAF_REQUEST_METHOD) requestMethod identifier:(NSString *) identifier URI:(NSString *) URI requestParams:(NSDictionary *) requestParams uploadFiles:(NSMutableDictionary *) uploadFiles;

@end
