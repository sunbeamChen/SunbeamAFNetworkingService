//
//  SunbeamAFResponse.h
//  Pods
//
//  Created by sunbeam on 16/6/30.
//
//

#import <Foundation/Foundation.h>

@interface SunbeamAFResponse : NSObject

// 请求id
@property (nonatomic, assign, readonly) NSInteger requestId;
// 响应数据
@property (nonatomic, strong, readonly) id responseData;
// 文件下载路径
@property (nonatomic, copy, readonly) NSString* downloadFileSavePath;
// 文件上传路径
@property (nonatomic, copy, readonly) NSString* uploadFilePath;
// 响应错误码
@property (nonatomic, assign, readonly) NSInteger errorcode;
// 响应错误信息
@property (nonatomic, copy, readonly) NSString* message;
// 获取响应实例
+ (SunbeamAFResponse *) getSAFResponse:(NSInteger) requestId responseData:(id) responseData downloadFileSavePath:(NSString *) downloadFileSavePath uploadFilePath:(NSString *) uploadFilePath errorcode:(NSInteger) errorcode message:(NSString *) message;

@end
