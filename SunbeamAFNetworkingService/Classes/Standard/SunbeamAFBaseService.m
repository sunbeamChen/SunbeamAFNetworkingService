//
//  SunbeamAFBaseService.m
//  Pods
//
//  Created by sunbeam on 16/6/29.
//
//

#import "SunbeamAFBaseService.h"

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

- (NSString *)protocol
{
    return self.child.protocol;
}

- (NSString *)domain
{
    return self.child.domain;
}

- (NSString *)version
{
    return self.child.version;
}

- (BOOL)useSSLCertificates
{
    return self.child.useSSLCertificates;
}

@end
