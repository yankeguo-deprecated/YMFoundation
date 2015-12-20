//
//  YMUtilsRobustEqualsSpec.m
//  YMFoundationExample
//
//  Created by Yanke Guo on 15/12/21.
//  Copyright © 2015年 YMXian. All rights reserved.
//

SpecBegin(YMUtilsRobustEquals)

  describe(@"NSNumber", ^{
    it(@"should work", ^{
      XCTAssertTrue(NSNumberEquals(nil, nil));
      XCTAssertTrue(NSNumberEquals(@1, @1));
      XCTAssertFalse(NSNumberEquals(@1, nil));
      XCTAssertFalse(NSNumberEquals(nil, @1));
      XCTAssertFalse(NSNumberEquals(@2, @1));
    });
  });

  describe(@"NSString", ^{
    it(@"should work", ^{
      XCTAssertTrue(NSStringEquals(nil, nil));
      XCTAssertTrue(NSStringEquals(@"A", @"A"));
      XCTAssertFalse(NSStringEquals(nil, @"A"));
      XCTAssertFalse(NSStringEquals(@"A", nil));
      XCTAssertFalse(NSStringEquals(@"A", @"B"));
    });
  });

SpecEnd