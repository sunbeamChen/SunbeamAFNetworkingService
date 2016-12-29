//
//  SunbeamAFServiceFactory.h
//  Pods
//
//  Created by sunbeam on 16/6/29.
//
//

#import <Foundation/Foundation.h>
#import "SunbeamAFBaseService.h"

@protocol SAFServiceFactoryProtocol <NSObject>

/**
 根据对应的identifier获取对应的SunbeamAFBaseService

 @param identifier 标识
 @return SunbeamAFBaseService<SAFServiceProtocol>
 */
- (SunbeamAFBaseService<SAFServiceProtocol> *) getSAFService:(NSString *) identifier;

@end

@interface SunbeamAFServiceFactory : NSObject

/**
 *  单例
 */
+ (SunbeamAFServiceFactory *) sharedSunbeamAFServiceFactory;

/**
 SAF service factory delegate
 */
@property (nonatomic, weak) id<SAFServiceFactoryProtocol> delegate;

/**
 根据对应的identifier获取对应的SunbeamAFBaseService

 @param identifier 标识
 @return SunbeamAFBaseService<SAFServiceProtocol>
 */
- (SunbeamAFBaseService<SAFServiceProtocol> *) getSAFService:(NSString *) identifier;

@end
