//
//  YMUtilsSystemInfoMacros.h
//  YMFoundationDemo
//
//  Created by Yanke Guo on 15/11/16.
//  Copyright (c) 2015 YMXian. All rights reserved.
//

#define AppBundleIdentifier ([NSBundle mainBundle].infoDictionary[@"CFBundleIdentifier"])
#define AppVersionShort     ([NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"])
#define AppVersionLong      ([NSBundle mainBundle].infoDictionary[@"CFBundleVersion"])

#define SystemVersionEqualTo(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SystemVersionGreaterThan(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SystemVersionGreaterThanOrEqualTo(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SystemVersionLessThan(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SystemVersionLessThanOrEqualTo(v)        ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#define AppCacheDirectory ((NSString*)[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject])
#define AppDocumentDirectory ((NSString*)[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject])
