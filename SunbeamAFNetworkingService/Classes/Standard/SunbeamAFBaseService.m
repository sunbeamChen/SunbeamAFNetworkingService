//
//  SunbeamAFBaseService.m
//  Pods
//
//  Created by sunbeam on 16/6/29.
//
//

#import "SunbeamAFBaseService.h"

#import "SunbeamAFServiceContext.h"

@implementation SunbeamAFBaseService

- (instancetype)init
{
    if (self = [super init]) {
        if ([self conformsToProtocol:@protocol(SAFServiceProtocol)]) {
            self.child = (id<SAFServiceProtocol>) self;
        }
    }
    
    return self;
}

- (NSString *)serviceUrl
{
    return [SunbeamAFServiceContext sharedSunbeamAFServiceContext].serviceUnified ? [SunbeamAFServiceContext sharedSunbeamAFServiceContext].unifiedUrl : self.child.serviceUrl;
}

- (NSString *)serviceVersion
{
    return [SunbeamAFServiceContext sharedSunbeamAFServiceContext].serviceUnified ? [SunbeamAFServiceContext sharedSunbeamAFServiceContext].unifiedVersion : self.child.serviceVersion;
}

@end
