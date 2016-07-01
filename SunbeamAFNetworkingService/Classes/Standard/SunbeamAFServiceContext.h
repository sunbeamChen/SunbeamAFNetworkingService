//
//  SunbeamAFServiceContext.h
//  Pods
//
//  Created by sunbeam on 16/6/29.
//
//

#import <Foundation/Foundation.h>

#import "SunbeamAFSingletonService.h"

typedef NS_ENUM(NSInteger, SAFRequestType) {
    SAFRequestTypeGET = 0,      // GET请求
    SAFRequestTypePOST = 1,     // POST请求
    SAFRequestTypeDownload = 2, // 下载请求
    SAFRequestTypeUpload = 3,   // 上传请求
};

@interface SunbeamAFServiceContext : NSObject



// SSL网络证书配置文件名称
@property (nonatomic, copy) NSString* securitySSLCer;



@end
