//
//  YMStringConvertible.h
//  Pods
//
//  Created by Yanke Guo on 16/2/26.
//

#import <Foundation/Foundation.h>

@protocol YMStringConvertible

- (id __nullable)initWithString:(NSString *__nonnull)string;

- (NSString* __nonnull)toString;

@end
