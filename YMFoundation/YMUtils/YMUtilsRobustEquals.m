//
//  YMUtilsRobustEquals.m
//  YMFoundation
//
//  Created by Yanke Guo on 15/12/21.
//

#import "YMUtilsRobustEquals.h"

BOOL NSStringEquals(NSString *string1, NSString *string2) {
  if (string1 == nil && string2 == nil) {
    return YES;
  }
  return string1 != nil && string2 != nil && [string1 isEqualToString:string2];
}

BOOL NSStringNotEquals(NSString *string1, NSString *string2) {
  return !NSStringEquals(string1, string2);
}

BOOL NSNumberEquals(NSNumber *number1, NSNumber *number2) {
  if (number1 == nil && number2 == nil) {
    return YES;
  }
  return number1 != nil && number2 != nil && [number1 isEqualToNumber:number2];
}

BOOL NSNumberNotEquals(NSNumber *number1, NSNumber *number2) {
  return !NSNumberEquals(number1, number2);
}
