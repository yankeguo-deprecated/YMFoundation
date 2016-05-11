//
// Created by Yanke Guo on 16/5/11.
//

#import <Foundation/Foundation.h>

@interface NSDecimalNumber (YMFoundation)

/**
 *  如果自己是 NaN,则返回 0,以防出问题
 */
- (instancetype __nonnull)sanitize;

@end