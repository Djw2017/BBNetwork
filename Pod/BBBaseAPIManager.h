//
//  BaseAPIManager.h
//  bbframework
//
//  Created by Dongjw on 2018/1/31.
//  Copyright © 2018年 Babybus. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NSString+BBNetwork.h"

@interface BBBaseAPIManager : NSObject

/**
 开始请求
 */
- (void)startRequest;

/**
 停止请求
 */
- (void)stopRequest;


@end
