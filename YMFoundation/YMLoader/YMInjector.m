//
// Created by Yanke Guo on 16/7/29.
// Copyright (c) 2016 YANKE Guo. All rights reserved.
//

#import "YMInjector.h"

#import <YMFoundation/YMUtils.h>
#import <objc/runtime.h>

NSString *YMExtractTypeStringFromProperty(objc_property_t property) {
  const char *attr = property_getAttributes(property);
  NSString *attributes = [NSString stringWithCString:attr encoding:NSUTF8StringEncoding];
  NSRange typeRangeStart = [attributes rangeOfString:@"T@\""];  // start of type string
  if (typeRangeStart.location != NSNotFound) {
    NSString *typeStringWithQuote = [attributes substringFromIndex:typeRangeStart.location + typeRangeStart.length];
    NSRange typeRangeEnd = [typeStringWithQuote rangeOfString:@"\""]; // end of type string
    if (typeRangeEnd.location != NSNotFound) {
      NSString *typeString = [typeStringWithQuote substringToIndex:typeRangeEnd.location];
      return typeString;
    }
  }
  return nil;
}

NSString *YMExtractNameFromProperty(objc_property_t property) {
  const char *name = property_getName(property);
  return [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
}

@implementation NSObject (YMCoreInitHelper)

- (void)didInjected {}

@end

@implementation YMInjector {
  NSMutableDictionary<NSString *, NSObject *> *_cache;
}

- (id)init {
  if (self = [super init]) {
    _cache = [[NSMutableDictionary alloc] init];
  }
  return self;
}

- (void)executeAutoCreateOn:(NSObject *)target {
  Class cls = target.class;

  //  Enumerate superclass
  do {
    //  Enumerate all properties
    unsigned int properties_count = 0;
    objc_property_t *properties = class_copyPropertyList(cls, &properties_count);
    for (unsigned int i = 0; i < properties_count; i++) {
      objc_property_t objc_property = properties[i];
      NSString *value = YMExtractTypeStringFromProperty(objc_property);
      NSString *name = YMExtractNameFromProperty(objc_property);
      //  If protocol AutoCreate is adopted
      if ([value ym_containsString:S(@"<%@>", NSStringFromProtocol(@protocol(AutoCreate)))]) {
        //  Get class
        NSString *className = [value substringToIndex:[value rangeOfString:@"<"].location];
        Class cls = NSClassFromString(className);
        NSParameterAssert(cls != NULL);
        //  Create object
        NSObject *object = [[cls alloc] init];
        NSParameterAssert(object != nil);
        //  Cache object
        [self registerObject:object forKey:className];
        //  Perform setter
        NSString *setterName = S(@"set%@%@:", [[name substringToIndex:1] uppercaseString], [name substringFromIndex:1]);
        SEL setterSel = NSSelectorFromString(setterName);
        SUPPRESS_START
        SUPPRESS_ARC_PERFORM_SELECTOR_LEAKS
        [target performSelector:setterSel withObject:object];
        SUPPRESS_END
      }
      if ([value ym_containsString:S(@"<%@>", NSStringFromProtocol(@protocol(Propagate)))]) {
        //  Get object
        SEL getterSel = NSSelectorFromString(name);
        //  Perform getter
        SUPPRESS_START
        SUPPRESS_ARC_PERFORM_SELECTOR_LEAKS
        NSObject *object = [target performSelector:getterSel];
        SUPPRESS_END
        //  Propagate
        NSParameterAssert(object != nil);
        [self executeAutoCreateOn:object];
      }
    }
    free(properties);
    //  Enumerate to superclass
    cls = class_getSuperclass(cls);
  } while (cls != nil);
}

- (void)executeAutoInjectOn:(NSObject *)target {
  Class cls = target.class;

  //  Enumerate all super class
  do {
    //  Enumerate all properties
    unsigned int properties_count = 0;
    objc_property_t *properties = class_copyPropertyList(cls, &properties_count);
    for (unsigned int i = 0; i < properties_count; i++) {
      objc_property_t objc_property = properties[i];
      NSString *value = YMExtractTypeStringFromProperty(objc_property);
      NSString *name = YMExtractNameFromProperty(objc_property);
      //  If protocol AutoInject is adopted
      if ([value ym_containsString:S(@"<%@>", NSStringFromProtocol(@protocol(AutoInject)))]) {
        //  Get class
        NSString *className = [value substringToIndex:[value rangeOfString:@"<"].location];
        //  Find object
        NSObject *object = [self objectForKey:className];
        NSParameterAssert(object != nil);
        //  Perform setter
        NSString *setterName = S(@"set%@%@:", [[name substringToIndex:1] uppercaseString], [name substringFromIndex:1]);
        SEL setterSel = NSSelectorFromString(setterName);
        SUPPRESS_START
        SUPPRESS_ARC_PERFORM_SELECTOR_LEAKS
        [target performSelector:setterSel withObject:object];
        SUPPRESS_END
      }
      if ([value ym_containsString:S(@"<%@>", NSStringFromProtocol(@protocol(Propagate)))]) {
        //  Get object
        SEL getterSel = NSSelectorFromString(name);
        //  Perform getter
        SUPPRESS_START
        SUPPRESS_ARC_PERFORM_SELECTOR_LEAKS
        NSObject *object = [target performSelector:getterSel];
        SUPPRESS_END
        //  Propagate
        NSParameterAssert(object != nil);
        [self executeAutoInjectOn:object];
      }
    }
    free(properties);
    //  Enumerate to superclass
    cls = class_getSuperclass(cls);
  } while (cls != Nil);

  [target didInjected];
}

- (void)registerObject:(NSObject *__nonnull)object forKey:(NSString *__nonnull)key {
  _cache[key] = object;
}

- (NSObject *__nullable)objectForKey:(NSString *__nonnull)key {
  return _cache[key];
}

- (void)removeObjectForKey:(NSString *__nonnull)key {
  [_cache removeObjectForKey:key];
}

- (void)dispose {
  [_cache removeAllObjects];
}

@end
