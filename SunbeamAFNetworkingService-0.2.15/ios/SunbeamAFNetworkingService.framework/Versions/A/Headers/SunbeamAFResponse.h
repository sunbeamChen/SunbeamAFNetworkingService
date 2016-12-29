//
//  SunbeamAFResponse.h
//  Pods
//
//  Created by sunbeam on 16/6/30.
//
//

#import <Foundation/Foundation.h>

@interface SunbeamAFResponse : NSObject

@property (nonatomic, strong) NSNumber* requestId;

@property (nonatomic, strong) id responseObject;

@property (nonatomic, strong) NSURL* downloadFileUrl;

@property (nonatomic, strong) NSError* error;

/**
 SunbeamAFResponse

 @param requestId 请求id
 @param responseObject 请求响应数据
 @param downloadFileUrl 下载文件本地地址
 @param error 错误描述
 @return SunbeamAFResponse
 */
+ (SunbeamAFResponse *) getSAFResponse:(NSNumber *) requestId responseObject:(id) responseObject downloadFileUrl:(NSURL *) downloadFileUrl error:(NSError *) error;

@end
