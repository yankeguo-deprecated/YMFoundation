//
//  NSArray+YMFoundation.h
//  Pods
//
//  Created by Yanke Guo on 16/7/28.
//
//

#import <Foundation/Foundation.h>

@interface NSArray<ObjectType> (YMFoundation)

- (ObjectType __nullable)objectPassingTest:(BOOL (^ __nonnull)(id __nonnull obj, NSUInteger idx, BOOL *__nonnull stop))predicate;

- (ObjectType __nullable)objectOrNilAtIndex:(NSUInteger)index;

@end
