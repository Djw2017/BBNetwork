//
//  BBNetworkReachabitily.m
//  BBNetwork
//
//  Created by Dongjw on 2017/6/19.
//  Copyright © 2017年 Babybus. All rights reserved.
//

#import <SystemConfiguration/SystemConfiguration.h>
#include <netdb.h>

#import "BBNetworkReachabitily.h"

@implementation BBNetworkReachabitily

/**
 WWAN网络
 
 @return
 */
+ (BOOL)isWWANEnabled {
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    
    if (!didRetrieveFlags)
    {
        printf("Error. Could not recover network reachability flagsn");
        return NO;
    }
    
    BOOL isReachable = ((flags & kSCNetworkFlagsReachable) != 0);
    if (isReachable) {
        if (flags & kSCNetworkReachabilityFlagsIsWWAN) {
            NSLog(@"IsWWAN");
            return YES;
        } else {
            NSLog(@"WIFI");
            return NO;
        }
    } else {
        return NO;
    }
}

/**
 wifi
 
 @return  wifi
 */
+ (BOOL)isWiFiEnabled {
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    
    if (!didRetrieveFlags)
    {
        printf("Error. Could not recover network reachability flagsn");
        return NO;
    }
    
    BOOL isReachable = ((flags & kSCNetworkFlagsReachable) != 0);
    if (isReachable) {
        if (flags & kSCNetworkReachabilityFlagsIsWWAN) {
            NSLog(@"IsWWAN");
            return NO;
        } else {
            NSLog(@"WIFI");
            return YES;
        }
    } else {
        return NO;
    }
}

/**
 网络可用
 
 @return  网络可用
 */
+ (BOOL)isInternetConnection {
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    
    if (!didRetrieveFlags)
    {
        printf("Error. Could not recover network reachability flagsn");
        return NO;
    }
    
    BOOL isReachable = ((flags & kSCNetworkFlagsReachable) != 0);
    if (isReachable) {
        return YES;
    } else {
        return NO;
    }
}

@end
