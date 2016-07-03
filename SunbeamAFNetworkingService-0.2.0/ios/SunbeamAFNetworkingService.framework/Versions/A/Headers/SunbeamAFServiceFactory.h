//
//  SunbeamAFServiceFactory.h
//  Pods
//
//  Created by sunbeam on 16/6/29.
//
//

#import <Foundation/Foundation.h>

#import "SunbeamAFBaseService.h"

#import "SUnbeamAFSingletonService.h"

@protocol SAFServiceFactoryProtocol <NSObject>

// 根据对应的serviceIdentifier获取对应的SunbeamAFBaseService
- (SunbeamAFBaseService<SAFServiceProtocol> *) getSAFService:(NSString *) serviceIdentifier;

@end

@interface SunbeamAFServiceFactory : NSObject

SAF_singleton_interface(SunbeamAFServiceFactory)

// service factory 工厂代理
@property (nonatomic, weak) id<SAFServiceFactoryProtocol> delegate;

// 根据对应的serviceIdentifier获取对应的SunbeamAFBaseService
- (SunbeamAFBaseService<SAFServiceProtocol> *) getSAFServiceWithServiceIdentifier:(NSString *) serviceIdentifier;

@end
