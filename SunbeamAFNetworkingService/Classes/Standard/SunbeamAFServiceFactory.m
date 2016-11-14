//
//  SunbeamAFServiceFactory.m
//  Pods
//
//  Created by sunbeam on 16/6/29.
//
//

#import "SunbeamAFServiceFactory.h"

@interface SunbeamAFServiceFactory()

@property (nonatomic, strong) NSMutableDictionary *serviceStorage;

@end

@implementation SunbeamAFServiceFactory

/**
 *  单例
 */
+ (SunbeamAFServiceFactory *) sharedSunbeamAFServiceFactory
{
    static SunbeamAFServiceFactory *sharedInstance = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (SunbeamAFBaseService<SAFServiceProtocol> *)getSAFServiceWithServiceIdentifier:(NSString *)serviceIdentifier
{
    if (self.serviceStorage[serviceIdentifier] == nil) {
        self.serviceStorage[serviceIdentifier] = [self.delegate getSAFService:serviceIdentifier];
    }
    return self.serviceStorage[serviceIdentifier];
}

#pragma mark - getters and setters
- (NSMutableDictionary *)serviceStorage
{
    if (_serviceStorage == nil) {
        _serviceStorage = [[NSMutableDictionary alloc] init];
    }
    return _serviceStorage;
}

@end
