//
//  SunbeamViewController.m
//  SunbeamAFNetworkingService
//
//  Created by sunbeamChen on 06/29/2016.
//  Copyright (c) 2016 sunbeamChen. All rights reserved.
//

#import "SunbeamViewController.h"
#import <SunbeamAFNetworkingService/SunbeamAFNetworkingService.h>
#import "SLAFTestServiceFactory.h"
#import "CheckUsernameManager.h"

@interface SunbeamViewController ()

@end

@implementation SunbeamViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    [SunbeamAFServiceContext sharedSunbeamAFServiceContext].timeoutInterval = 5.0;
    [[SLAFTestServiceFactory sharedSLAFTestServiceFactory] initSLAFTestServiceFactory];
    
    [[[CheckUsernameManager alloc] initCheckUsernameManager:@"15860746397"] loadDataTask:^(NSString *identifier, id responseObject, NSError *error) {
        NSLog(@"请求响应返回，identifier：%@，responseObject：%@，error：%@", identifier, responseObject, error);
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
