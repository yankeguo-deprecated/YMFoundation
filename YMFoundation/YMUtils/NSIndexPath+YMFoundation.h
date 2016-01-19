//
//  NSIndexPath+YMFoundation.h
//  YMFoundation
//
//  Created by Yanke Guo on 16/1/19.
//

#import <Foundation/Foundation.h>

@interface NSIndexPath (YMFoundation)

+ (NSIndexPath *__nonnull)emptyIndexPath;

- (NSIndexPath *__nonnull)indexPathByCuttingToLength:(NSUInteger)length;

- (NSIndexPath *__nonnull)indexPathByFilingToLength:(NSUInteger)length withIndex:(NSUInteger)index;

@end
