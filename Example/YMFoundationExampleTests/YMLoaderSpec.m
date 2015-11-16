//
//  GlobalInjectorSpec.m
//  YMXian
//
//  Created by 琰珂 郭 on 15/10/15.
//  Copyright © 2015年 YANKE Guo. All rights reserved.
//

#import "YMFoundationTestsHelper.h"

__strong static NSString* YMTestProxyValue = nil;

@interface InjectTarget : NSObject

@property (nonatomic, strong) NSString* target1;
@property (nonatomic, strong) InjectTarget* target2;
@property (nonatomic, strong) NSString* target3;

@end

@implementation InjectTarget

- (void)buildDepencencies:(NSMutableDictionary<NSString *,NSString *> *)dependencies {
  [super buildDepencencies:dependencies];
  [dependencies addEntriesFromDictionary:@{
                                           @"target1" : @"service1",
                                           @"target2" : @"service2",
                                           @"target3" : @"service3"
                                           }];
}

@end

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

describe(@"standard usage", ^{
  it(@"should work", ^{
    id<TestProxyProtocol> proxy = (id<TestProxyProtocol>)[TestProxy proxy];
    XCTAssert([proxy respondsToSelector:@selector(doSomething:)]);
    [proxy doSomething:@"2"];
    XCTAssertEqualObjects(YMTestProxyValue, @"2");
  });
});

describe(@"nsobject ext", ^{
  it(@"should work with object", ^{
    [[YMLoader sharedLoader] registerObject:@"A" forKey:@"service1"];
    InjectTarget* target = [InjectTarget new];
    [target injectDependencies];
    expect(target.target1).equal(@"A");
  });
  
  it(@"should work with block", ^{
    [[YMLoader sharedLoader] registerFactory:^id _Nonnull(NSString * _Nonnull key) {
      return @"A";
    } forKey:@"service3"];
    
    InjectTarget* target = [InjectTarget new];
    [target injectDependencies];
    expect(target.target3).equal(@"A");
  });
});

SpecEnd