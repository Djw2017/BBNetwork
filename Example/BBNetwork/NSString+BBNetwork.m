//
//  NSString+BBNetwork.m
//  bbframework
//
//  Created by Dongjw on 2018/2/2.
//  Copyright © 2018年 Babybus. All rights reserved.
//

#import "NSString+BBNetwork.h"

@implementation NSString (BBNetwork)

/**
 判断字符串是否可用，为nil或者空字符则不可用
 
 @return 可用
 */
- (BOOL)isValidate {
    if (![self isEqualToString:@""] && self) {
        return YES;
    }
    return NO;
}

@end
