//
//  SunbeamAFResponse.m
//  Pods
//
//  Created by sunbeam on 16/6/30.
//
//

#import "SunbeamAFResponse.h"

@interface SunbeamAFResponse()

- (instancetype) initSAFResponse:(NSNumber *) requestId responseObject:(id) responseObject downloadFileUrl:(NSURL *) downloadFileUrl error:(NSError *) error;

@end

@implementation SunbeamAFResponse

- (instancetype)initSAFResponse:(NSNumber *) requestId responseObject:(id) responseObject downloadFileUrl:(NSURL *) downloadFileUrl error:(NSError *) error
{
    if (self = [super init]) {
        self.requestId = requestId;
        self.responseObject = responseObject;
        self.downloadFileUrl = downloadFileUrl;
        self.error = error;
    }
    
    return self;
}

+ (SunbeamAFResponse *)getSAFResponse:(NSNumber *) requestId responseObject:(id) responseObject downloadFileUrl:(NSURL *) downloadFileUrl error:(NSError *) error;
{
    return [[SunbeamAFResponse alloc] initSAFResponse:requestId responseObject:responseObject downloadFileUrl:downloadFileUrl error:error];
}

@end
