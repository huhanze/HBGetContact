//
//  NSString+HHBPinyinString.m
//  HHBKit
//  
//  Created by DylanHu on 2015/9/12.
//  Copyright © 2015年 DylanHu. All rights reserved.
//

#import "NSString+HHBPinyinString.h"

@implementation NSString (HHBPinyinString)

- (NSString *)pinyinString {
    NSAssert([self isKindOfClass:[NSString class]], @"object changed must be a string");
    if (self == nil) {
        return nil;
    }
    NSMutableString *pinyin = [self mutableCopy];
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformStripDiacritics, NO);
    return pinyin;
}

@end
