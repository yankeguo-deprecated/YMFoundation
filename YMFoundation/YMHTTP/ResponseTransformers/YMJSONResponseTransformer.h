//
//  YMJSONResponseTransformer.h
//  YMXian
//
//  Created by 琰珂 郭 on 15/9/16.
//  Copyright © 2015年 YANKE Guo. All rights reserved.
//
//  将 NSData 转换为 JSON NSDictionary 或者 NSArray

#import <Foundation/Foundation.h>

#import "YMHTTPResponseTransformer.h"

@interface YMJSONResponseTransformer: NSObject<YMHTTPResponseTransformer>

@end
