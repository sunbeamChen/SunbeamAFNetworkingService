//
//  SunbeamAFBaseService.h
//  Pods
//
//  Created by sunbeam on 16/6/29.
//
//

#import <Foundation/Foundation.h>

@protocol SAFServiceProtocol <NSObject>

@property (nonatomic, copy, readonly) NSString* protocol;

@property (nonatomic, copy, readonly) NSString* domain;

@property (nonatomic, copy, readonly) NSString* version;

@property (nonatomic, assign, readonly) BOOL useSSLCertificates;

@end

@interface SunbeamAFBaseService : NSObject

// child delegate
@property (nonatomic, weak) id<SAFServiceProtocol> child;

// protocol（https://）
@property (nonatomic, copy, readonly) NSString* protocol;

// domain (www.baidu.com)
@property (nonatomic, copy, readonly) NSString* domain;

// protocol version（默认该version是在url链接中,header中version通过header params添加,eg:v1）
@property (nonatomic, copy, readonly) NSString* version;

// use ssl cer or not
@property (nonatomic, assign, readonly) BOOL useSSLCertificates;

@end
