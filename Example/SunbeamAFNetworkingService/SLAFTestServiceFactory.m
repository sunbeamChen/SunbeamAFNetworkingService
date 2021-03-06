//
//  SLAFTestServiceFactory.m
//  SLAFTest
//
//  Created by sunbeam on 2016/12/26.
//  Copyright © 2016年 aerolite. All rights reserved.
//

#import "SLAFTestServiceFactory.h"
#import <SunbeamAFNetworkingService/SunbeamAFNetworkingService.h>
#import "CheckUsernameService.h"

@interface SLAFTestServiceFactory() <SAFServiceFactoryProtocol>

@end

@implementation SLAFTestServiceFactory

/**
 *  单例
 */
+ (SLAFTestServiceFactory *) sharedSLAFTestServiceFactory
{
    static SLAFTestServiceFactory *sharedInstance = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (void) initSLAFTestServiceFactory
{
    [[SunbeamAFServiceContext sharedSunbeamAFServiceContext] setSAFServiceFactoryDelegate:self];
}

// 根据对应的service identifier获取对应的SLAFBaseService
- (SunbeamAFBaseService<SAFServiceProtocol> *) getSAFService:(NSString *) identifier
{
    if ([@"sherlock_private_api_service_checkUsernameRegistOrNot" isEqualToString:identifier]) {
        return [[CheckUsernameService alloc] init];
    }
    
    return nil;
}

@end
