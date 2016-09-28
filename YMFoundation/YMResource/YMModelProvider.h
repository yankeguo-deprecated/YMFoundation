//
//  YMModelProvider.h
//  Pods
//
//  Created by Yanke Guo on 16/7/28.
//
//

#import <Foundation/Foundation.h>

@protocol YMModelProvider<NSObject>

- (id __nullable)modelForId:(NSString *__nonnull)id;

@end
