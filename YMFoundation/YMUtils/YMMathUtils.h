//
//  YMMathUtils.h
//  YMFoundation
//
//  Created by Yanke Guo on 15/12/21.
//

#import <Foundation/Foundation.h>

#pragma mark - Bitmask

/**
 *  Enumerate each bit in a bitmask
 *
 *  @param value input bitmask
 *  @param block block called when a bit is found
 */
extern void BitmaskEnumerateBits(NSUInteger value, void(^__nonnull block)(NSUInteger bitValue));

/**
 *  Generate a NSArray of NSNumber from each bit in a bitmask
 *
 *  @param value input bitmask
 *
 *  @return NSArray
 */
extern NSArray<NSNumber *> *__nonnull NSArrayOfNumbersFromBitmask(NSUInteger value);