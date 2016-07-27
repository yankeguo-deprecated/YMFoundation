//
//  YMUtilsMiscMacros.h
//  YMXian
//
//  Created by Yanke Guo on 16/7/25.
//
//

#import <Foundation/Foundation.h>

/*
 *  Shortcut for [NSString stringWithFormat:...]
 */
#define S(FORMAT, ...) ([NSString stringWithFormat:FORMAT, ##__VA_ARGS__])
