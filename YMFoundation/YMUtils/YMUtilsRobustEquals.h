//
//  YMUtilsRobustEquals.h
//  YMFoundation
//
//  Created by Yanke Guo on 15/12/21.
//

#import <Foundation/Foundation.h>

#pragma mark - NSString

extern BOOL NSStringEquals(NSString *__nullable string1, NSString *__nullable string2);

extern BOOL NSStringNotEquals(NSString *__nullable string1, NSString *__nullable string2);

#pragma mark - NSNumber

extern BOOL NSNumberEquals(NSNumber *__nullable number1, NSNumber *__nullable number2);

extern BOOL NSNumberNotEquals(NSNumber *__nullable number1, NSNumber *__nullable number2);

#pragma mark - NSDate

extern BOOL NSDateEquals(NSDate *__nullable date1, NSDate *__nullable date2);

extern BOOL NSDateEqualsToSecond(NSDate *__nullable date1, NSDate *__nullable date2);

extern BOOL NSDateNotEquals(NSDate *__nullable date1, NSDate *__nullable date2);

extern BOOL NSDateNotEqualsToSecond(NSDate *__nullable date1, NSDate *__nullable date2);
