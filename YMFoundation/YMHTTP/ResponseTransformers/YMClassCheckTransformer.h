//
//  YMClassCheckTransformer.h
//  YMXian
//
//  Created by 琰珂 郭 on 15/10/14.
//  Copyright © 2015年 YANKE Guo. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "YMHTTPResponseTransformer.h"

@interface YMClassCheckTransformer: NSObject<YMHTTPResponseTransformer>

@property(nonatomic, retain) Class __nonnull cls;

+ (instancetype __nonnull)validatorWithClass:(Class __nonnull)cls;

- (instancetype __nonnull)initWithClass:(Class __nonnull)cls;

@end
