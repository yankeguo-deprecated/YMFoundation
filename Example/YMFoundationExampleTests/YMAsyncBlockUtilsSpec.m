//
//  YMAsyncBlockUtilsSpec.m
//  YMFoundationExample
//
//  Created by Yanke Guo on 15/12/19.
//  Copyright © 2015年 YMXian. All rights reserved.
//

SpecBegin(YMAsyncBlockUtils)

describe(@"YMAsyncCreateOnceBlock", ^{
  it(@"should work", ^{
    __block NSInteger performedCount = 0;
    YMAsyncVoidBlock testBlock = ^{
      performedCount += 1;
    };
    YMAsyncBOOLBlock boolBlock = YMAsyncCreateOnceBlock(testBlock);
    XCTAssertTrue(boolBlock());
    XCTAssertEqual(performedCount, 1);
    XCTAssertFalse(boolBlock());
    XCTAssertEqual(performedCount, 1);
    XCTAssertFalse(boolBlock());
    XCTAssertEqual(performedCount, 1);
  });
});

describe(@"YMAsyncCreateAllBlock", ^{
  it(@"should work", ^{
    __block NSInteger performedCount = 0;
    YMAsyncVoidBlock testBlock = ^{
      performedCount += 1;
    };
    YMAsyncCompareBlock outBlock = YMAsyncCreateAllBlock(3, testBlock);
    XCTAssertEqual(outBlock(), NSOrderedDescending);
    XCTAssertEqual(performedCount, 0);
    XCTAssertEqual(outBlock(), NSOrderedDescending);
    XCTAssertEqual(performedCount, 0);
    XCTAssertEqual(outBlock(), NSOrderedSame);
    XCTAssertEqual(performedCount, 1);
    XCTAssertEqual(outBlock(), NSOrderedAscending);
    XCTAssertEqual(performedCount, 1);
  });
});

SpecEnd