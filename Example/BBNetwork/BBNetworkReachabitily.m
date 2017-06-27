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
 wifi
 
 @return  wifi
 */
+ (BOOL)isWiFiEnabled {
    NSCountedSet * cset = [NSCountedSet new];
    
    struct ifaddrs *interfaces;
    
    if( ! getifaddrs(&interfaces) ) {
        for( struct ifaddrs *interface = interfaces; interface; interface = interface->ifa_next)
        {
            if ( (interface->ifa_flags & IFF_UP) == IFF_UP ) {
                [cset addObject:[NSString stringWithUTF8String:interface->ifa_name]];
            }
        }
    }
    
    return [cset countForObject:@"awdl0"] > 1 ? YES : NO;
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

//- (NSString *)getWifiName
//{
//    NSString *wifiName = nil;
//
//    CFArrayRef wifiInterfaces = CNCopySupportedInterfaces();
//
//    if (!wifiInterfaces) {
//        return nil;
//    }
//
//    NSArray *interfaces = (__bridge NSArray *)wifiInterfaces;
//
//    for (NSString *interfaceName in interfaces) {
//        CFDictionaryRef dictRef = CNCopyCurrentNetworkInfo((__bridge CFStringRef)(interfaceName));
//
//        if (dictRef) {
//            NSDictionary *networkInfo = (__bridge NSDictionary *)dictRef;
//            BBLog(@"network info -> %@", networkInfo);
//            wifiName = [networkInfo objectForKey:(__bridge NSString *)kCNNetworkInfoKeySSID];
//
//            CFRelease(dictRef);
//        }
//    }
//
//    CFRelease(wifiInterfaces);
//    return wifiName;
//}

@end
