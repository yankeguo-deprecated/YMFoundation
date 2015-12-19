//
//  YMRouterTests.m
//  YMXian
//
//  Created by 琰珂 郭 on 15/9/19.
//  Copyright © 2015年 YANKE Guo. All rights reserved.
//

typedef NS_ENUM(NSInteger, YMRouterTestResult) {
  YMRouterTestResultNone,
  YMRouterTestResultA,
  YMRouterTestResultB,
  YMRouterTestResultC,
};

SpecBegin(YMRouter)

__block YMRouter * _router;
__block YMRouterTestResult _result;
__block NSDictionary<NSString*, NSString*>* _params;

beforeEach(^{
  _router = [[YMRouter alloc] initWithScheme:@"test"];
  
  [_router on:@"/static/test" action:^(NSDictionary<NSString *,NSString *> * _Nonnull params) {
    _params = params;
    _result = YMRouterTestResultA;
  }];
  
  [_router on:@"/dynamic/:value" action:^(NSDictionary<NSString *,NSString *> * _Nonnull params) {
    _result = YMRouterTestResultB;
    _params = params;
  }];
  
  [_router alias:@"/dynamic/a" to:@"/dynamic/value"];
  
  [_router on:@"/perf/:value1/what/:value2" action:^(NSDictionary<NSString *,NSString *> * _Nonnull params) {
    _result = YMRouterTestResultC;
    _params = params;
  }];
});

describe(@"static route", ^{
  
  it(@"should work", ^{
    BOOL success = [_router routePath:@"/static/test"];
    XCTAssert(success);
    XCTAssert(_result == YMRouterTestResultA);
  });
  
});

describe(@"paramed route", ^{
  
  it(@"should work", ^{
    BOOL success = [_router routePath:@"/dynamic/what"];
    XCTAssert(success);
    XCTAssert(_result == YMRouterTestResultB);
    XCTAssert([_params[@"value"] isEqualToString:@"what"]);  
  });
  
  it(@"should work with override", ^{
    BOOL success = [_router routePath:@"/dynamic/what" params:@{@"value":@"foo"}];
    XCTAssert(success);
    XCTAssert(_result == YMRouterTestResultB);
    XCTAssert([_params[@"value"] isEqualToString:@"foo"]);
  });
  
});

describe(@"alias", ^{
  
  it(@"should work", ^{
    BOOL success = [_router routePath:@"/dynamic/a"];
    XCTAssert(success);
    XCTAssert(_result == YMRouterTestResultB);
    XCTAssert([_params[@"value"] isEqualToString:@"value"]);
  });
  
  it(@"should work with override", ^{
    BOOL success = [_router routePath:@"/dynamic/a"params:@{@"value":@"what"}];
    XCTAssert(success);
    XCTAssert(_result == YMRouterTestResultB);
    XCTAssert([_params[@"value"] isEqualToString:@"what"]);  
  });
  
});

describe(@"performance", ^{
  
  it(@"should be ok", ^{
    [self measureBlock:^{
      for (int i = 0; i < 10000; i ++) {
        BOOL success = [_router routePath:@"/perf/111/what/bbb"];
        XCTAssert(success);
        XCTAssert(_result == YMRouterTestResultC);
        XCTAssert([_params[@"value1"] isEqualToString:@"111"]);
        XCTAssert([_params[@"value2"] isEqualToString:@"bbb"]);
      }
    }];
  });
  
});

SpecEnd