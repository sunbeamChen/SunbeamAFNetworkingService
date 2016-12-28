//
//  CheckUsernameManager.m
//  SLAFTest
//
//  Created by sunbeam on 2016/12/23.
//  Copyright © 2016年 aerolite. All rights reserved.
//

#import "CheckUsernameManager.h"

@interface CheckUsernameManager() <SAFManagerProtocol, SAFManagerParamsForRequest, SAFManagerParamsValidator, SAFManagerInterceptor, SAFManagerCallbackDataFormatter, SAFManagerCallbackDataValidator>

@property (nonatomic, copy) NSString* username;

@end

@implementation CheckUsernameManager

- (instancetype)init
{
    if (self = [super init]) {
        self.childManager = self;
        self.paramsForRequest = self;
        self.paramsValidator = self;
        self.managerInterceptor = self;
        self.managerCallbackDataFormatter = self;
        self.managerCallbackDataValidator = self;
    }
    
    return self;
}

- (instancetype)initCheckUsernameManager:(NSString *)username
{
    if (self = [self init]) {
        self.username = username;
    }
    
    return self;
}

// 统一资源标识符
- (NSString *) URI
{
    return @"/check/reg";
}

// 当前请求标识
- (NSString *) identifier
{
    return @"sherlock_private_api_service_checkUsernameRegistOrNot";
}

// 当前请求方法
- (SAF_REQUEST_METHOD) method
{
    return POST;
}

// 请求参数
- (NSDictionary *) managerParamsForRequest
{
    return @{@"saf_request_header_params_dict":@{@"APIVER":@"1.0"},@"saf_request_body_dict":@{@"mobile":self.username}};
}

// 请求参数合法性检查
- (NSError *) managerParamsValidate
{
    return nil;
}

// 请求成功
- (void) managerInterceptorPerformSuccess
{
    NSLog(@"请求成功");
}

// 请求失败
- (void) managerInterceptorPerformFailed
{
    NSLog(@"请求失败");
}

@end
