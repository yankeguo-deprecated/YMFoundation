//
//  YMUtilsSystemInfo.h
//  YMFoundationDemo
//
//  Created by Yanke Guo on 15/12/8.
//  Copyright © 2015年 YMXian. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - Macros

#pragma mark - App

#define AppBundleIdentifier ([NSBundle mainBundle].infoDictionary[@"CFBundleIdentifier"])
#define AppVersionShort     ([NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"])
#define AppVersionLong      ([NSBundle mainBundle].infoDictionary[@"CFBundleVersion"])

#pragma mark - System Version

#define SystemVersionEqualTo(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SystemVersionGreaterThan(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SystemVersionGreaterThanOrEqualTo(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SystemVersionLessThan(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SystemVersionLessThanOrEqualTo(v)        ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#pragma mark - Paths

#define AppCacheDirectory ((NSString*)[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject])
#define AppDocumentDirectory ((NSString*)[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject])

#pragma mark - Screen

#define ScreenWidth   CGRectGetWidth([UIScreen mainScreen].bounds)
#define ScreenHeight  CGRectGetHeight([UIScreen mainScreen].bounds)

#define ScreenScale     ([UIScreen mainScreen].scale)
#define ScreenPixelSize (1.f/SCREEN_SCALE)

#pragma mark - Functions

uint64_t YMGetDeviceUptimeInMilliseconds();