//
//  SunbeamAFUtil.h
//  Pods
//
//  Created by sunbeam on 16/7/1.
//
//

#import <Foundation/Foundation.h>

@interface SunbeamAFUtil : NSObject

// url params dictionary 转换成url
+ (NSString *) urlParamsString:(NSDictionary *) urlParamsDictionary;
// 转义参数
+ (NSArray *) transformedUrlParamsArray:(NSDictionary *) urlParamsDictionary;
// 字母排序之后形成的参数字符串
+ (NSString *) paramsString:(NSArray *) urlParamsArray;

@end
