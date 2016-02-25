//
//  YMDictionaryConvertible.h
//  YMFoundation
//
//  Created by Yanke Guo on 16/2/26.
//

#import <Foundation/Foundation.h>

@protocol YMDictionaryConvertible

/**
 *  Initialize a instance from NSDictionary
 *
 *  @param dict dictionary
 *
 *  @return new instance
 */
- (id __nullable)initWithDictionary:(NSDictionary *__nonnull)dict;

/**
 *  Convert current instance to NSDictionary
 *
 *  @return new dictionary
 */
- (NSDictionary *__nonnull)toDictionary;

@end
