//
//  BBNetworkReachabitily.h
//  BBNetwork
//
//  Created by Dongjw on 2017/6/19.
//  Copyright © 2017年 Babybus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BBNetworkReachabitily : NSObject

/**
 使用ifaddrs 判断wifi状态

 @return  wifi
 */
+ (BOOL)isWiFiEnabled;

/**
 使用AFNetworkReachabilityManager判断网络可用
 
 @return  网络可用
 */
+ (BOOL)isInternetConnection;

@end