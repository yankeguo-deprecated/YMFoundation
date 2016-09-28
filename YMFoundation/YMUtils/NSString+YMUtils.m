//
//  NSString+YMUtils.m
//  Pods
//
//  Created by Yanke Guo on 16/8/1.
//
//

#import "NSString+YMUtils.h"

@implementation NSString (YMUtils)

- (BOOL)present {
  return self.length > 0 && [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length != 0;
}

- (BOOL)ym_containsString:(NSString*__nonnull)string {
  if (string.length == 0) return YES;
  if ([self respondsToSelector:@selector(containsString:)]) {
    return [self containsString:string];
  }
  return [self rangeOfString:string].location != NSNotFound;
}

@end
