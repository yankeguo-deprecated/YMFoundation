//
//  YMHTTPRequest.m
//  YMXian
//
//  Created by 琰珂 郭 on 15/9/12.
//  Copyright © 2015年 YANKE Guo. All rights reserved.
//

#import "YMHTTPRequest.h"

#import <objc/runtime.h>
#import <UIKit/UIKit.h>

#import "YMLogger.h"
#import "NSError+YMHTTP.h"
#import "YMUtilsSuppressMacros.h"
#import "CMDQueryStringSerialization.h"

static YMHTTPRequest *YMHTTPRequestDefault = nil;

@interface YMHTTPRequest () {
  BOOL _isFrozen;

  NSMutableDictionary *_params;

  NSMutableArray<id<YMHTTPResponseTransformer>> *_transformers;

  NSMutableArray<YMHTTPRequestCompleteCallback> *_completeCallbacks;
  NSMutableArray<YMHTTPRequestSuccessCallback> *_successCallbacks;
  NSMutableArray<YMHTTPRequestFailureCallback> *_failureCallbacks;

  NSMutableURLRequest *_URLRequest;
}

@end

@implementation YMHTTPRequest

#pragma mark - Factory

+ (instancetype)defaultRequest {
  static dispatch_once_t _dispatch_key;
  dispatch_once(&_dispatch_key, ^{
    YMHTTPRequestDefault = [[YMHTTPRequest alloc] init];
  });
  return YMHTTPRequestDefault;
}

+ (instancetype __nonnull)buildGET:(NSString *)url {
  return [[self alloc] initWithMethod:YMHTTPMethodGet url:url];
}

+ (instancetype)buildPOST:(NSString *)url {
  return [[self alloc] initWithMethod:YMHTTPMethodPost url:url];
}

#pragma mark - Setters / Getters

- (NSDictionary *)params {
  return _params;
}

- (NSURLRequest *)URLRequest {
  return _URLRequest;
}

- (NSArray<id<YMHTTPResponseTransformer>> *)responseTransformers {
  return _transformers;
}

- (NSArray<YMHTTPRequestCompleteCallback> *)completeCallbacks {
  return _completeCallbacks;
}

- (NSArray<YMHTTPRequestSuccessCallback> *)successCallbacks {
  return _successCallbacks;
}

- (NSArray<YMHTTPRequestFailureCallback> *)failureCallbacks {
  return _failureCallbacks;
}

- (void)freeze {
  _isFrozen = YES;
}

#pragma mark - Inits

- (id)init {
  NSAssert(YMHTTPRequestDefault == nil, @"Call initWithMethod:url: instead");
  if (self = [super init]) {
  }
  return self;
}

- (instancetype)initWithMethod:(YMHTTPMethod)method url:(NSString *)url {
  if (self = [super init]) {
    //  Set method
    _method = method;
    //  Set url
    _URLString = url;
    //  Not yet freezed
    _isFrozen = NO;
    //  Default params
    _params = [[[[self class] defaultRequest] params] mutableCopy];
    //  Default validators
    _transformers = [[[[self class] defaultRequest] responseTransformers] mutableCopy];
    //  Default callbacks
    _completeCallbacks = [[[[self class] defaultRequest] completeCallbacks] mutableCopy];
    _successCallbacks = [[[[self class] defaultRequest] successCallbacks] mutableCopy];
    _failureCallbacks = [[[[self class] defaultRequest] failureCallbacks] mutableCopy];
  }
  return self;
}

#pragma mark - Request

- (YMHTTPRequest *)setParam:(id<NSCoding>)object forKey:(NSString *)key {
  NSParameterAssert(!_isFrozen);
  //  Prepare _params
  if (_params == nil) {
    _params = [NSMutableDictionary new];
  }
  if (object == nil) {
    [_params removeObjectForKey:key];
  } else {
    [_params setObject:object forKey:key];
  }
  return self;
}

- (YMHTTPRequest *)addParams:(NSDictionary *)dict {
  NSParameterAssert(!_isFrozen);

  if (_params == nil) {
    _params = [NSMutableDictionary new];
  }

  [_params addEntriesFromDictionary:dict];

  return self;
}

#pragma mark - Response

- (YMHTTPRequest *__nonnull)removeAllResposeTransformers {
  NSParameterAssert(!_isFrozen);

  [_transformers removeAllObjects];

  return self;
}

- (YMHTTPRequest *)addResponseTransformer:(id<YMHTTPResponseTransformer>)transformer {
  NSParameterAssert(!_isFrozen);

  if (_transformers == nil) {
    _transformers = [NSMutableArray new];
  }

  [_transformers addObject:transformer];
  return self;
}

- (YMHTTPRequest *)removeResponseTransformerByClass:(Class)transformerClass {
  NSParameterAssert(!_isFrozen);

  NSIndexSet *indexes = [_transformers indexesOfObjectsPassingTest:^BOOL(id<YMHTTPResponseTransformer> _Nonnull obj,
                                                                         NSUInteger idx,
                                                                         BOOL *_Nonnull stop) {
    return [obj isKindOfClass:transformerClass];
  }];
  [_transformers removeObjectsAtIndexes:indexes];
  return self;
}

- (YMHTTPRequest *)onSuccess:(YMHTTPRequestSuccessCallback)success {
  NSParameterAssert(!_isFrozen);
  if (_successCallbacks == nil) {
    _successCallbacks = [NSMutableArray new];
  }
  [_successCallbacks addObject:[success copy]];
  return self;
}

- (YMHTTPRequest *)onFailure:(YMHTTPRequestFailureCallback)failure {
  NSParameterAssert(!_isFrozen);
  if (_failureCallbacks == nil) {
    _failureCallbacks = [NSMutableArray new];
  }
  [_failureCallbacks addObject:[failure copy]];
  return self;
}

- (YMHTTPRequest *)onComplete:(YMHTTPRequestCompleteCallback)complete {
  NSParameterAssert(!_isFrozen);
  if (_completeCallbacks == nil) {
    _completeCallbacks = [NSMutableArray new];
  }
  [_completeCallbacks addObject:[complete copy]];
  return self;
}

- (void)invokeSuccessWithResponseObject:(id)responseObject {
  [self.completeCallbacks enumerateObjectsUsingBlock:^(YMHTTPRequestCompleteCallback _Nonnull obj,
                                                       NSUInteger idx,
                                                       BOOL *_Nonnull stop) {
    obj(nil, responseObject, self);
  }];
  [self.successCallbacks enumerateObjectsUsingBlock:^(YMHTTPRequestSuccessCallback _Nonnull obj,
                                                      NSUInteger idx,
                                                      BOOL *_Nonnull stop) {
    obj(responseObject, self);
  }];
}

- (void)invokeFailureWithError:(NSError *)error {
  [self.completeCallbacks enumerateObjectsUsingBlock:^(YMHTTPRequestCompleteCallback _Nonnull obj,
                                                       NSUInteger idx,
                                                       BOOL *_Nonnull stop) {
    obj(error, nil, self);
  }];
  [self.failureCallbacks enumerateObjectsUsingBlock:^(YMHTTPRequestFailureCallback _Nonnull obj,
                                                      NSUInteger idx,
                                                      BOOL *_Nonnull stop) {
    obj(error, self);
  }];
}

/**
 *  执行全部的 Transformer
 *
 *  错误和返回值不能全部为空，也不能全部存在
 *
 *  @param input 输入
 *  @param error 错误输出
 *
 *  @return 结果输出
 */
- (id)applyAllTransformersWithResponse:(id)input error:(NSError *_Nonnull *)error {
  if (*error) {
    return nil;
  }
  id finalObject = input;
  for (id<YMHTTPResponseTransformer> transformer in _transformers) {
    finalObject = [transformer transformResponse:finalObject error:error request:self];
    if (finalObject == nil && *error == nil) {
      *error = [NSError YMHTTPBadResponse];
    }
    if (*error) {
      ELog(@"Failed passing transformer: %@", transformer);
      return nil;
    }
  }
  return finalObject;
}

/**
 *  转换原生错误为 YMError
 *
 *  @param error 原生错误
 *
 *  @return YMError
 */
- (NSError *__nonnull)applyTransformWithError:(NSError *__nonnull)error {
  if ([error.domain isEqualToString:NSURLErrorDomain]) {
    if (error.code == NSURLErrorCancelled) {
      return [NSError YMHTTPCancelled];
    }
    return [NSError YMHTTPBadNetwork];
  } else {
    return [NSError YMHTTPBadResponse];
  }
}

- (NSURLSessionDataTaskCompleteBlock)NSURLCompleteBlock {
  //  这个 Block Retain 了 self，以防止在请求过程中 self 被回收
  return ^(NSData *_Nullable data, NSURLResponse *_Nullable response, NSError *_Nullable error) {
    dispatch_async(dispatch_get_main_queue(), ^{
      NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
      //  Process incoming error
      if (error) {
        [self invokeFailureWithError:[self applyTransformWithError:error]];
        return;
      }
      //  Process response
      if (httpResponse.statusCode >= 500) {
        [self invokeFailureWithError:[NSError YMHTTPBadResponse]];
      } else {
        NSError *finalError = nil;
        id finalObject = [self applyAllTransformersWithResponse:data error:&finalError];
        if (finalError) {
          [self invokeFailureWithError:finalError];
        } else {
          [self invokeSuccessWithResponseObject:finalObject];
        }
      }
    });
  };
}

- (void)buildRequest {
  NSURL *url = nil;

  if (self.method == YMHTTPMethodGet) {
    //  Append Parameters to Query
    NSURLComponents *components = [[NSURLComponents alloc] initWithString:_URLString];
    if (_params.count) {
      if (components.query.length) {
        components.query =
            [components.query stringByAppendingFormat:@"&%@", [CMDQueryStringSerialization queryStringWithDictionary:_params]];
      } else {
        components.query = [CMDQueryStringSerialization queryStringWithDictionary:_params];
      }
    }
    url = components.URL;
  } else {
    url = [NSURL URLWithString:_URLString];
  }

  //  Create
  _URLRequest = [[NSMutableURLRequest alloc] initWithURL:url];

  //  HTTPMethod
  _URLRequest.HTTPMethod = (self.method == YMHTTPMethodGet ? @"GET" : @"POST");

  //  Accept
  [_URLRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];

  //  Accept-Language HTTP Header; see http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.4
  NSMutableArray *acceptLanguagesComponents = [NSMutableArray array];
  [[NSLocale preferredLanguages] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    float q = 1.0f - (idx * 0.1f);
    [acceptLanguagesComponents addObject:[NSString stringWithFormat:@"%@;q=%0.1g", obj, q]];
    *stop = q <= 0.5f;
  }];
  [_URLRequest setValue:[acceptLanguagesComponents componentsJoinedByString:@", "] forHTTPHeaderField:@"Accept-Language"];

  //  User-Agent
  NSString *userAgent = nil;
  SUPPRESS_START
  SUPPRESS_GNU
#if TARGET_OS_IOS
  // User-Agent Header; see http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.43
  userAgent =
      [NSString stringWithFormat:@"%@/%@ (%@; iOS %@; Scale/%0.2f)", [[NSBundle mainBundle] infoDictionary][(__bridge NSString *) kCFBundleExecutableKey] ?: [[NSBundle mainBundle] infoDictionary][(__bridge NSString *) kCFBundleIdentifierKey], [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"] ?: [[NSBundle mainBundle] infoDictionary][(__bridge NSString *) kCFBundleVersionKey], [[UIDevice currentDevice] model], [[UIDevice currentDevice] systemVersion], [[UIScreen mainScreen] scale]];
#elif TARGET_OS_WATCH
  // User-Agent Header; see http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.43
  userAgent = [NSString stringWithFormat:@"%@/%@ (%@; watchOS %@; Scale/%0.2f)", [[NSBundle mainBundle] infoDictionary][(__bridge NSString *)kCFBundleExecutableKey] ?: [[NSBundle mainBundle] infoDictionary][(__bridge NSString *)kCFBundleIdentifierKey], [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"] ?: [[NSBundle mainBundle] infoDictionary][(__bridge NSString *)kCFBundleVersionKey], [[WKInterfaceDevice currentDevice] model], [[WKInterfaceDevice currentDevice] systemVersion], [[WKInterfaceDevice currentDevice] screenScale]];
#endif
  SUPPRESS_END
  if (userAgent) {
    if (![userAgent canBeConvertedToEncoding:NSASCIIStringEncoding]) {
      NSMutableString *mutableUserAgent = [userAgent mutableCopy];
      if (CFStringTransform((__bridge CFMutableStringRef) (mutableUserAgent),
                            NULL,
                            (__bridge CFStringRef) @"Any-Latin; Latin-ASCII; [:^ASCII:] Remove",
                            false)) {
        userAgent = mutableUserAgent;
      }
    }
    [_URLRequest setValue:userAgent forHTTPHeaderField:@"User-Agent"];
  }

  if (self.method == YMHTTPMethodPost) {
    //  Content-Type
    [_URLRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    //  Set Body
    _URLRequest.HTTPBody =
        [[CMDQueryStringSerialization queryStringWithDictionary:_params] dataUsingEncoding:NSUTF8StringEncoding];
  }

  [self freeze];
}

- (void)execOn:(NSURLSession *)session {
  if (_URLRequest == nil) {
    [self buildRequest];
  }
  _dataTask = [session dataTaskWithRequest:_URLRequest completionHandler:[self NSURLCompleteBlock]];
  [_dataTask resume];
}

@end
