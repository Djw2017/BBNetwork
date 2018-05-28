//
//  BBBaseRequestProtocol.h
//  bbframework
//
//  Created by Dongjw on 2018/1/26.
//  Copyright © 2018年 Babybus. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, BBRequestMethod) {
    BBRequestMethodGET = 0,
    BBRequestMethodPOST,
    BBRequestMethodHEAD,
    BBRequestMethodPUT,
    BBRequestMethodDELETE,
    BBRequestMethodPATCH,
};

@class BBBaseRequest;

@protocol BBBaseRequestProtocol <NSObject>

@required
- (NSString *)requestUrl;

@optional
/**
 指定返回json数据格式
 
 @[@{@"id": [NSNumber class],
     @"imageId": @[[NSString class]],
     @"time": [NSNumber class],
     @"status": [NSNumber class],
     @"question": @{
                     @"id": [NSNumber class],
                     @"content": [NSString class],
                     @"contentType": [NSNumber class]
                   }
   }
 ];

 @return 嵌套的数据格式
 */
- (id)jsonValidator;

/**
 明确获取返回数据的格式为NSData或NSString
 
 @return [NSData class]
 */
- (Class)responseOCDataType;

/**
 请求超时时间，默认为10秒

 @return 请求超时时间
 */
- (NSTimeInterval)requestTimeoutInterval;

/**
 请求方式。默认Post请求

 @return @see BBRequestMethod
 */
- (BBRequestMethod)requestMethod;

/**
 请求携带参数

 @return 请求Body
 */
- (NSDictionary *)requestParameters;

/**
 实现此方法自动转为下载

 @return 下载至本地路径
 */
- (NSURL *)resumableDownloadPath;

#pragma mark - aop
/**
 请求前
 
 @param request 请求
 */
- (void)requestBefore;

///  Called on background thread after request succeded but before switching to main thread. Note if
///  cache is loaded, this method WILL be called on the main thread, just like `requestCompleteFilter`.
- (void)requestCompletePreprocessor;

///  Called on background thread after request failed but before switching to main thread. See also
///  `requestCompletePreprocessor`.
- (void)requestFailedPreprocessor:(NSInteger)errorCode;

NS_ASSUME_NONNULL_END

@end
