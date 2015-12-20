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
