//
//  SunbeamAFBaseService.h
//  Pods
//
//  Created by sunbeam on 16/6/29.
//
//

#import <Foundation/Foundation.h>

@protocol SAFServiceProtocol <NSObject>

// 服务url
@property (nonatomic, copy, readonly) NSString* serviceUrl;

// 服务版本号
@property (nonatomic, copy, readonly) NSString* serviceVersion;

@end

@interface SunbeamAFBaseService : NSObject

// 服务url
@property (nonatomic, copy, readonly) NSString* serviceUrl;

// 服务版本号
@property (nonatomic, copy, readonly) NSString* serviceVersion;

// 代理
@property (nonatomic, weak) id<SAFServiceProtocol> child;

@end
