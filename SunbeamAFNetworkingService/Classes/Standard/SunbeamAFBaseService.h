//
//  SunbeamAFBaseService.h
//  Pods
//
//  Created by sunbeam on 16/6/29.
//
//

#import <Foundation/Foundation.h>

@protocol SAFServiceProtocol <NSObject>
// protocol（https:// or http://）
@property (nonatomic, copy, readonly) NSString* protocol;
// domain
@property (nonatomic, copy, readonly) NSString* domain;
// protocol version
@property (nonatomic, copy, readonly) NSString* version;
// cer file path
@property (nonatomic, copy, readonly) NSString* cerFilePath;

@end

@interface SunbeamAFBaseService : NSObject

// child delegate
@property (nonatomic, weak) id<SAFServiceProtocol> child;
// protocol（https:// or http://）
@property (nonatomic, copy, readonly) NSString* protocol;
// domain
@property (nonatomic, copy, readonly) NSString* domain;
// protocol version（默认该version是在url链接中,header中version通过header params添加）
@property (nonatomic, copy, readonly) NSString* version;
// cer file path
@property (nonatomic, copy, readonly) NSString* cerFilePath;

@end
