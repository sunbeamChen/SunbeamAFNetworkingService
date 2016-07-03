//
//  SunbeamAFBaseManager.m
//  Pods
//
//  Created by sunbeam on 16/6/29.
//
//

#import "SunbeamAFBaseManager.h"

#import "SunbeamAFHTTPClient.h"

#define SAF_REQUEST_ID_DEFAULT 0

@interface SunbeamAFBaseManager()

@property (nonatomic, strong) NSMutableArray *requestIdList;

@end

@implementation SunbeamAFBaseManager

- (instancetype)init
{
    if (self = [super init]) {
        _paramsForRequest = nil;
        _paramsAndCallbackValidator = nil;
        _managerInterceptor = nil;
        _managerCallbackDataReformer = nil;
        _managerCallbackDelegate = nil;
        _httpResponse = nil;
        
        if ([self conformsToProtocol:@protocol(SAFManagerProtocol)]) {
            _child = (id<SAFManagerProtocol>)self;
        }
    }
    
    return self;
}

- (void)dealloc
{
    [self cancelAllRequests];
    self.requestIdList = nil;
    self.httpResponse = nil;
}

#pragma mark - public methods
- (void)cancelAllRequests
{
    [[SunbeamAFHTTPClient sharedSunbeamAFHTTPClient] cancelRequestWithRequestIdList:self.requestIdList];
    
    [self.requestIdList removeAllObjects];
}

- (void)cancelRequestWithRequestId:(NSInteger)requestId
{
    [self removeRequestIdWithRequestId:requestId];
    
    [[SunbeamAFHTTPClient sharedSunbeamAFHTTPClient] cancelRequestWithRequestId:@(requestId)];
}

- (NSDictionary *) fetchHttpResponseDictWithReformer:(id<SAFManagerCallbackDataReformer>) reformer
{
    if (self.httpResponse.responseData == nil || [self.httpResponse.responseData length] == 0) {
        return nil;
    }
    
    if ([reformer respondsToSelector:@selector(managerCallbackDataReformer:)]) {
        return [reformer managerCallbackDataReformer:self];
    }
    
    NSError* error = nil;
    NSDictionary* returnDictionary = [NSJSONSerialization JSONObjectWithData:self.httpResponse.responseData options:NSJSONReadingAllowFragments error:&error];
    
    if (error) {
        return nil;
    }
    
    return returnDictionary;
}

#pragma mark - calling api
- (NSInteger)loadRequest
{
    /**
     *  首先判断网络是否正常
     */
    if (![self isReachable])
    {
        self.httpResponse = [SunbeamAFResponse getSAFResponse:SAF_REQUEST_ID_DEFAULT responseData:nil downloadFileSavePath:nil uploadFilePath:nil networkResponseError:SAFNetworkSystemErrorNoNetwork];
        
        [self failedOnCallingAPI:self.httpResponse];
        
        return SAF_REQUEST_ID_DEFAULT;
    }
    /**
     *  判断当前是否有网络请求正在执行
     */
    if ([self isLoading])
    {
        // 该处采取的策略是阻止新的请求，另外一种策略是取消旧的请求，执行新的请求(待实际测试判断)
        self.httpResponse = [SunbeamAFResponse getSAFResponse:SAF_REQUEST_ID_DEFAULT responseData:nil downloadFileSavePath:nil uploadFilePath:nil networkResponseError:SAFNetworkSystemErrorRequestIsRuning];
        
        [self failedOnCallingAPI:self.httpResponse];
        
        return SAF_REQUEST_ID_DEFAULT;
    }
    /**
     *  判断网络请求参数是否合法
     */
    if (![self.paramsAndCallbackValidator managerParamsValidator:self])
    {
        // 参数检查有问题，设置apiSuccessError,返回到此处进行处理
        [self failedOnCallingAPI:self.httpResponse];
        
        return SAF_REQUEST_ID_DEFAULT;
    }
    /**
     *  获取请求params
     */
    NSDictionary *params = [self.paramsForRequest managerParamsForRequest:self];
    
    /**
     *  执行网络请求操作
     */
    return [self loadDataWithParams:params];
}

- (NSInteger)loadDataWithParams:(NSDictionary *)params
{
    NSInteger requestId = SAF_REQUEST_ID_DEFAULT;
    
    // 先检查一下是否有缓存,如果有做缓存，则直接从缓存中取
    // 实际网络请求
    requestId = [[SunbeamAFHTTPClient sharedSunbeamAFHTTPClient] loadSAFRequestWithParams:self.child.requestType withParams:params serviceIdentifier:self.child.serviceIdentifier methodName:self.child.methodName success:^(SunbeamAFResponse *response) {
        [self successedOnCallingAPI:response];
    } fail:^(SunbeamAFResponse *response) {
        [self failedOnCallingAPI:response];
    }];
    
    [self.requestIdList addObject:@(requestId)];
    
    return requestId;
}

#pragma mark - api callbacks
- (void)successedOnCallingAPI:(SunbeamAFResponse*) httpResponse
{
    self.httpResponse = httpResponse;
    
    [self removeRequestIdWithRequestId:httpResponse.requestId];
    
    if (![self.paramsAndCallbackValidator managerCallbackValidator:self])
    {
        [self failedOnCallingAPI:httpResponse];
        return;
    }
    
    //此处可以添加缓存策略,缓存返回数据供下次请求使用
    [self.managerInterceptor managerInterceptorBeforePerformSuccess:self];
    [self.managerCallbackDelegate managerCallbackSuccess:self];
    [self.managerInterceptor managerInterceptorAfterPerformSuccess:self];
}

- (void)failedOnCallingAPI:(SunbeamAFResponse*) httpResponse
{
    self.httpResponse = httpResponse;
    
    if (httpResponse != nil)
    {
        [self removeRequestIdWithRequestId:httpResponse.requestId];
    }
    
    [self.managerInterceptor managerInterceptorBeforePerformFail:self];
    [self.managerCallbackDelegate managerCallbackFail:self];
    [self.managerInterceptor managerInterceptorAfterPerformFail:self];
}

#pragma mark - method for child
- (void)cleanData
{
    if ([self.child respondsToSelector:@selector(cleanData)]) {
        [self.child cleanData];
    }
}

#pragma mark - private methods
- (void)removeRequestIdWithRequestId:(NSInteger)requestId
{
    NSNumber *requestIDToRemove = nil;
    for (NSNumber *storedRequestId in self.requestIdList) {
        if ([storedRequestId integerValue] == requestId) {
            requestIDToRemove = storedRequestId;
        }
    }
    if (requestIDToRemove) {
        [self.requestIdList removeObject:requestIDToRemove];
    }
}

#pragma mark - getter/setter
- (NSMutableArray *)requestIdList
{
    if (_requestIdList == nil) {
        _requestIdList = [[NSMutableArray alloc] init];
    }
    return _requestIdList;
}

- (BOOL)isReachable
{
    return [[SunbeamAFServiceContext sharedSunbeamAFServiceContext] networkIsReachable];
}

- (BOOL)isLoading
{
    return [self.requestIdList count] > 0;
}

@end
