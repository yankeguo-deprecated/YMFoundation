//
//  YMRouter.m
//  YMXian
//
//  Created by 琰珂 郭 on 15/9/16.
//  Copyright © 2015年 YANKE Guo. All rights reserved.
//

#import "YMRouter.h"

#import "YMLogger.h"
#import "CMDQueryStringSerialization.h"

/**
 *  RouteEntryComponent
 */

@interface YMRouteEntryComponent: NSObject

@property(nonatomic, assign) BOOL isWildcard;

@property(nonatomic, copy) NSString *value;

@end

@implementation YMRouteEntryComponent
@end

/**
 *  YMRouteEntry
 */

@interface YMRouteEntry: NSObject

@property(nonatomic, strong) NSMutableArray<YMRouteEntryComponent *> *components;

@property(nonatomic, copy) YMRouterAction action;

@end

@implementation YMRouteEntry

static NSCharacterSet *YMRouteEntryComponentWildcardMarkSet = nil;

+ (void)initialize {
  [super initialize];

  if (self == [YMRouteEntry class]) {
    YMRouteEntryComponentWildcardMarkSet = [NSCharacterSet characterSetWithCharactersInString:@":"];
  }
}

- (id)initWithPattern:(NSString *__nonnull)pattern {
  if (self = [super init]) {
    _components = [NSMutableArray new];

    [[pattern pathComponents] enumerateObjectsUsingBlock:^(NSString *_Nonnull obj,
                                                           NSUInteger idx,
                                                           BOOL *_Nonnull stop) {
      //  Bypass "//"
      if (obj.length) {
        YMRouteEntryComponent *comp = [YMRouteEntryComponent new];
        if ([obj hasPrefix:@":"]) {
          comp.isWildcard = YES;
          comp.value = [obj stringByTrimmingCharactersInSet:YMRouteEntryComponentWildcardMarkSet];
        } else {
          comp.isWildcard = NO;
          comp.value = obj;
        }
        [_components addObject:comp];
      }
    }];

    NSParameterAssert(_components.count != 0);
  }
  return self;
}

- (NSDictionary<NSString *, NSString *> *__nullable)match:(NSArray<NSString *> *__nonnull)components {
  if (_components.count != components.count) {
    return nil;
  }

  NSMutableDictionary *dict = [NSMutableDictionary new];

  __block BOOL failed = NO;

  [_components enumerateObjectsUsingBlock:^(YMRouteEntryComponent *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
    NSString *src = [components objectAtIndex:idx];
    if (obj.isWildcard) {
      dict[obj.value] = src;
    } else {
      if (![obj.value isEqualToString:src]) {
        *stop = failed = YES;
      }
    }
  }];

  if (failed) {
    return nil;
  } else {
    return dict;
  }
  return nil;
}

@end

/**
 *  YMRouter
 */

@interface YMRouter ()

@property(nonatomic, strong) NSMutableDictionary<NSString *, NSString *> *alias;

@property(nonatomic, strong) NSMutableArray<YMRouteEntry *> *routes;

@property(nonatomic, strong) NSMutableDictionary<NSString *, id<YMAbstractRouter>> *subRouters;

@end

@implementation YMRouter

+ (instancetype)routerWithScheme:(NSString *)scheme {
  return [[[self class] alloc] initWithScheme:scheme];
}

- (id)init {
  NSAssert(NO, @"call initWithScheme instead");
  return nil;
}

- (instancetype)initWithScheme:(NSString *)scheme {
  if (self = [super init]) {
    _scheme = scheme;
    _routes = [NSMutableArray new];
    _alias = [NSMutableDictionary new];
    _subRouters = [NSMutableDictionary new];
  }
  return self;
}

- (void)registerRouter:(id<YMAbstractRouter>)router forScheme:(NSString *)scheme {
  [_subRouters setObject:router forKey:scheme];
}

- (NSURL *)fixedURL:(NSURL *)url {
  /**
   *  Try to padding what://value1/value2 to what:///value1/value2
   */
  NSURL *finalUrl = url;
  NSString *falsePrefix = [NSString stringWithFormat:@"%@://", _scheme];
  NSString *rightPrefix = [NSString stringWithFormat:@"%@:///", _scheme];
  if (![finalUrl.absoluteString hasPrefix:rightPrefix]) {
    NSString *urlString = [finalUrl.absoluteString stringByReplacingOccurrencesOfString:falsePrefix
                                                                             withString:rightPrefix];
    finalUrl = [NSURL URLWithString:urlString];
  }
  return finalUrl;
}

- (BOOL)routeUrl:(NSURL *)url {
  if (url.scheme == nil) {
    ELog(@"URL Scheme is nil");
    return NO;
  }
  if ([url.scheme isEqualToString:_scheme]) {
    //  为子Router保留可能性
    if ([self __selfRouteUrl:[self fixedURL:url]]) {
      return YES;
    }
  }
  id<YMAbstractRouter> router = [_subRouters objectForKey:url.scheme];
  if (router == nil) {
    ELog(@"Cannot find sub-router for %@", url.scheme);
    return NO;
  }
  return [router routeUrl:url];
}

- (BOOL)routeUrlString:(NSString *)url {
  if (url.length == 0) {
    return NO;
  }
  NSURL *URL = [NSURL URLWithString:url];
  return [self routeUrl:URL];
}

- (BOOL)routePath:(NSString *)fullPath {
  NSURLComponents *urlComponents = [[NSURLComponents alloc] initWithString:fullPath];
  [urlComponents setScheme:_scheme];
  return [self routeUrl:urlComponents.URL];
}

- (BOOL)routePath:(NSString *)path params:(NSDictionary *)params {
  NSURLComponents *urlComponents = [[NSURLComponents alloc] initWithString:path];
  urlComponents.query = [CMDQueryStringSerialization queryStringWithDictionary:params];
  return [self routePath:urlComponents.URL.absoluteString];
}

- (BOOL)routePath:(NSString *__nonnull)path
      buildParams:(void (^ __nonnull)(NSMutableDictionary<NSString *, NSString *> *__nonnull params))buildBlock {
  NSMutableDictionary *params = [NSMutableDictionary new];
  buildBlock(params);
  return [self routePath:path params:params];
}

- (BOOL)__selfRouteUrl:(NSURL *)url {
  NSString *path = url.path;
  //  Resolve Alias
  NSString *aliasPath = _alias[path];
  if (aliasPath != nil) {
    path = aliasPath;
  }
  //  Check path components
  NSArray<NSString *> *compos = [path pathComponents];
  if (compos.count == 0) {
    return NO;
  }
  //  Match entries
  for (YMRouteEntry *entry in _routes) {
    NSDictionary *matchParams = [entry match:compos];
    if (matchParams) {
      NSDictionary *queryParams = [CMDQueryStringSerialization dictionaryWithQueryString:url.query];
      if (queryParams.count == 0) {
        entry.action(matchParams);
        return YES;
      } else {
        NSMutableDictionary *md = [NSMutableDictionary dictionaryWithDictionary:matchParams];
        [md addEntriesFromDictionary:queryParams];
        entry.action(md);
        return YES;
      }
    }
  }
  return NO;
}

- (void)on:(NSString *__nonnull)path action:(YMRouterAction __nonnull)action {
  YMRouteEntry *entry = [[YMRouteEntry alloc] initWithPattern:path];
  entry.action = action;
  [_routes addObject:entry];
}

- (void)alias:(NSString *__nonnull)path to:(NSString *__nonnull)srcPath {
  NSParameterAssert(![path isEqualToString:srcPath]);
  [_alias setObject:srcPath forKey:path];
}

@end
