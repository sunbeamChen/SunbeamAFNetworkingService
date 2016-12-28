//
//  SunbeamAFServiceFactory.m
//  Pods
//
//  Created by sunbeam on 16/6/29.
//
//

#import "SunbeamAFServiceFactory.h"

@interface SunbeamAFServiceFactory()

@property (nonatomic, strong) NSMutableDictionary *SAFServiceStorage;

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

- (SunbeamAFBaseService<SAFServiceProtocol> *)getSAFService:(NSString *)identifier
{
    if (self.SAFServiceStorage[identifier] == nil) {
        
        NSAssert(self.delegate != nil, @"SAFServiceFactory delegate should not be nil");
        
        NSAssert([self.delegate respondsToSelector:@selector(getSAFService:)], @"SAFServiceFactory delegate selector [getSAFService:] should not be nil");
        
        self.SAFServiceStorage[identifier] = [self.delegate getSAFService:identifier];
    }
    
    return self.SAFServiceStorage[identifier];
}

#pragma mark - getters and setters
- (NSMutableDictionary *)SAFServiceStorage
{
    if (_SAFServiceStorage == nil) {
        _SAFServiceStorage = [[NSMutableDictionary alloc] init];
    }
    
    return _SAFServiceStorage;
}

@end
