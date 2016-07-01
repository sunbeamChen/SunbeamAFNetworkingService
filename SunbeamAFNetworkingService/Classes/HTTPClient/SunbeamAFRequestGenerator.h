//
//  SunbeamAFRequestGenerator.h
//  Pods
//
//  Created by sunbeam on 16/6/30.
//
//

#import <Foundation/Foundation.h>

#import "SunbeamAFRequest.h"

#import "SunbeamAFSingletonService.h"

@interface SunbeamAFRequestGenerator : NSObject

// 单例
SAF_singleton_interface(SunbeamAFRequestGenerator)

// 产生Sunbeam AF Request实例
- (SunbeamAFRequest *) generateSAFRequest:(SAFRequestType) requestType serviceIdentifier:(NSString *) serviceIdentifier requestParams:(NSDictionary *) requestParams methodName:(NSString *) methodName;

@end
