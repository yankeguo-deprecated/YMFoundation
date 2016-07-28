//
//  YMModel.m
//  Pods
//
//  Created by Yanke Guo on 16/7/28.
//
//

#import "YMModel.h"

@implementation YMModel

+ (void)buildDescriptor:(YMJSONDescriptor *)descriptor {
  [descriptor addRequired:@"id"];
}

@end
