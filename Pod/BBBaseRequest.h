//
//  BBBaseRequest.h
//  bbframework
//
//  Created by Dongjw on 2018/1/26.
//  Copyright © 2018年 Babybus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BBBaseRequestProtocol.h"

@class BBBaseRequest;

NS_ASSUME_NONNULL_BEGIN

@protocol BaseRequestDelegate <NSObject>

@optional

/**
 是否允许请求，请求前判断，默认允许
 
 @return 允许请求
 */
- (BOOL)requestAllow:(__kindof BBBaseRequest *)request;

/**
 请求完成
 
 @param request 请求
 */
- (void)requestFinished:(__kindof BBBaseRequest *)request;

/**
 请求失败
 
 @param request 请求
 */
- (void)requestFailed:(__kindof BBBaseRequest *)request;

@end

@interface BBBaseRequest : NSObject

/// 请求地址
@property (nonatomic, copy, readonly) NSString *reuqestUrl;

/// 响应数据
@property (nonatomic, strong, readonly, nullable) id responseObject;

@property (nonatomic, strong, readonly, nullable) NSError *error;

/// 请求超时时间，默认为10秒
@property (nonatomic, assign, readonly) NSTimeInterval requestTimeoutInterval;

/// 请求下载地址
@property (nonatomic, strong, readonly) NSURL *resumableDownloadPath;

#pragma mark - Request Configuration
/// 请求标识. Default value is 0.
@property (nonatomic) NSInteger tag;

@property (nonatomic, weak, nullable) id<BaseRequestDelegate> delegate;

/**
 开始请求
 */
- (void)start;

/**
 停止请求
 */
- (void)stop;

/**
 添加请求
 */
- (BBBaseRequest *)addChainRequest:(BBBaseRequest *)chainRequest;

@end

NS_ASSUME_NONNULL_END
