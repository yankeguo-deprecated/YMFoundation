//
//  GlobalInjectorSpec.m
//  YMXian
//
//  Created by 琰珂 郭 on 15/10/15.
//  Copyright © 2015年 YANKE Guo. All rights reserved.
//

#import "YMFoundationTestsHelper.h"

__strong static NSString* YMTestProxyValue = nil;

@protocol TestProxyProtocol <NSObject>

- (void)doSomething:(NSString* __nonnull)key;

@end

@interface TestProxyTarget : NSObject

@end

@implementation TestProxyTarget

- (void)doSomething:(NSString* __nonnull)key {
  YMTestProxyValue = [key copy];
}

@end

@interface TestProxy : YMLoaderProxy

@end

@implementation TestProxy

- (void)build {
  [self use:@"test" forSelector:@selector(doSomething:)];
}

@end

SpecBegin(YMLoader)

beforeAll(^{
  [[YMLoader sharedLoader] registerObject:[TestProxyTarget new] forKey:@"test"];
});

it(@"should work", ^{
  id<TestProxyProtocol> proxy = [TestProxy proxy];
  XCTAssert([proxy respondsToSelector:@selector(doSomething:)]);
  [proxy doSomething:@"2"];
  XCTAssertEqualObjects(YMTestProxyValue, @"2");
});

SpecEnd