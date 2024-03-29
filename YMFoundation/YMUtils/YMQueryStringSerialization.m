//
//  CMDQueryStringSerialization.m
//  CMDQueryStringSerialization
//
//  Created by Caleb Davenport on 1/21/14.
//  Copyright (c) 2014 Caleb Davenport. All rights reserved.
//

#import "YMQueryStringSerialization.h"
#import "YMQueryStringReader.h"
#import "YMQueryStringValueTransformer.h"

@implementation CMDQueryStringSerialization

+ (NSDictionary *)dictionaryWithQueryString:(NSString *)string {
  CMDQueryStringReader *reader = [[CMDQueryStringReader alloc] initWithString:string];
  return [reader dictionaryValue];
}


+ (NSString *)queryStringWithDictionary:(NSDictionary *)dictionary {
  CMDQueryStringWritingOptions options = (
      CMDQueryStringWritingOptionArrayRepeatKeysWithBrackets |
          CMDQueryStringWritingOptionDateAsUnixTimestamp |
          CMDQueryStringWritingOptionAddPercentEscapes
  );
  return [self queryStringWithDictionary:dictionary options:options];
}


+ (NSString *)queryStringWithDictionary:(NSDictionary *)dictionary options:(CMDQueryStringWritingOptions)options {
  return [dictionary CMDQueryStringValueTransformer_queryStringWithKey:nil options:options];
}

@end
