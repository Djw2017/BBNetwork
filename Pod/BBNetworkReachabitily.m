//
//  BBNetworkReachabitily.m
//  BBNetwork
//
//  Created by Dongjw on 2017/6/19.
//  Copyright © 2017年 Babybus. All rights reserved.
//

#import <CoreTelephony/CTCellularData.h>
#import <ifaddrs.h>
#import <net/if.h> 
#import <UIKit/UIKit.h>

#import "AFNetworkReachabilityManager.h"
#import "BBNetworkReachabitily.h"

@implementation BBNetworkReachabitily

/**
 WWAN网络
 
 @return
 */
+ (BOOL)isWWANEnabled {
    if ([AFNetworkReachabilityManager sharedManager].isReachableViaWWAN) {
        return YES;
    }
    return NO;
}

/**
 wifi
 
 @return  wifi
 */
+ (BOOL)isWiFiEnabled {
    if ([AFNetworkReachabilityManager sharedManager].isReachableViaWiFi) {
        return YES;
    }
    return NO;
}

/**
 使用AFNetworkReachabilityManager判断网络可用
 
 @return  网络可用
 */
+ (BOOL)isInternetConnection {
    if ([AFNetworkReachabilityManager sharedManager].isReachable) {
        return YES;
    }
    return NO;
}

@end
