//
//  SunbeamAFServiceContext.m
//  Pods
//
//  Created by sunbeam on 16/6/29.
//
//

#import "SunbeamAFServiceContext.h"

#import "SunbeamAFServiceFactory.h"

@implementation SunbeamAFServiceContext

// 单例
SAF_singleton_implementation(SunbeamAFServiceContext)

// 设置service factory 代理
- (void) setSAFServiceFactoryDelegate:(id<SAFServiceFactoryProtocol>) serviceFactoryDelegate
{
    [SunbeamAFServiceFactory sharedSunbeamAFServiceFactory].delegate = serviceFactoryDelegate;
}

@end
