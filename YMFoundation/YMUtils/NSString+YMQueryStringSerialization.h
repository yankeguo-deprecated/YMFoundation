//
//  NSString+CMDQueryStringSerialization.h
//  CMDQueryStringSerialization
//
//  Created by Bryan Irace on 1/26/14.
//  Copyright (c) 2014 Caleb Davenport. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (CMDQueryStringSerialization)

- (NSString *)CMDQueryStringSerialization_stringByAddingEscapes;

- (NSString *)CMDQueryStringSerialization_stringByRemovingEscapes;

@end
