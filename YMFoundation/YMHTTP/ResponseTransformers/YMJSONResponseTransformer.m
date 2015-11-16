//
//  YMJSONResponseTransformer.m
//  YMXian
//
//  Created by 琰珂 郭 on 15/9/16.
//  Copyright © 2015年 YANKE Guo. All rights reserved.
//

#import "YMJSONResponseTransformer.h"

#import "YMLogger.h"
#import "NSError+YMHTTP.h"

@implementation YMJSONResponseTransformer

- (id __nullable)transformResponse:(id __nullable)response error:(NSError *__nullable *__nonnull)error request:(YMHTTPRequest *__nonnull)request {
  if (![response isKindOfClass:[NSData class]]) {
    ELog(@"Response is not NSData");
    if (error) *error = [NSError YMHTTPBadResponse];
    return nil;
  }
  NSError *jsonError = nil;
  id jsonObject = [NSJSONSerialization JSONObjectWithData:response options:kNilOptions error:&jsonError];
  if (jsonError || jsonObject == nil) {
    ELog(@"Failed to transform to json: %@", [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
    if (error) *error = [NSError YMHTTPBadResponse];
    return nil;
  }
  return jsonObject;
}

- (NSString *)description {
  return NSStringFromClass([self class]);
}

@end
