//
//  YMMathUtilsSpec.m
//  YMFoundationExample
//
//  Created by Yanke Guo on 15/12/21.
//  Copyright © 2015年 YMXian. All rights reserved.
//

typedef NS_OPTIONS(NSUInteger, BitmaskTestType) {
  BitmaskTestType1 = 1 << 0,
  BitmaskTestType2 = 1 << 1,
  BitmaskTestType3 = 1 << 3,
  BitmaskTestType4 = 1 << 5,
};

SpecBegin(YMMathUtils)

  describe(@"bitmask enumerate", ^{
    it(@"should work", ^{
      BitmaskTestType testInput = BitmaskTestType1 | BitmaskTestType3 | BitmaskTestType4;
      __block NSInteger time = 0;
      BitmaskEnumerateBits(testInput, ^(NSUInteger bitValue) {
        if (time == 0) {
          XCTAssertEqual(bitValue, BitmaskTestType1);
        } else if (time == 1) {
          XCTAssertEqual(bitValue, BitmaskTestType3);
        } else if (time == 2) {
          XCTAssertEqual(bitValue, BitmaskTestType4);
        } else {
          XCTAssertFalse(YES);
        }
        time += 1;
      });
      XCTAssertEqual(time, 3);
    });

    it(@"should work 1", ^{
      BitmaskTestType testInput = BitmaskTestType1;
      __block NSInteger time = 0;
      BitmaskEnumerateBits(testInput, ^(NSUInteger bitValue) {
        XCTAssertEqual(bitValue, BitmaskTestType1);
        time += 1;
      });
      XCTAssertEqual(time, 1);
    });

    it(@"should work 2", ^{
      BitmaskTestType testInput = BitmaskTestType4;
      __block NSInteger time = 0;
      BitmaskEnumerateBits(testInput, ^(NSUInteger bitValue) {
        XCTAssertEqual(bitValue, BitmaskTestType4);
        time += 1;
      });
      XCTAssertEqual(time, 1);
    });
  });

  describe(@"array from bitmask", ^{
    it(@"should work", ^{
      BitmaskTestType testInput = BitmaskTestType1 | BitmaskTestType3 | BitmaskTestType4;
      NSArray<NSNumber *> *array = NSArrayOfNumbersFromBitmask(testInput);
      XCTAssertEqualObjects(@(BitmaskTestType1), array[0]);
      XCTAssertEqualObjects(@(BitmaskTestType3), array[1]);
      XCTAssertEqualObjects(@(BitmaskTestType4), array[2]);
    });
  });

  describe(@"NSDecimalNumber fix", ^{
    it(@"should work with sanitize", ^{
      XCTAssertEqualObjects([[[NSDecimalNumber one] sanitize] stringValue], @"1");
      XCTAssertEqualObjects([[[NSDecimalNumber notANumber] sanitize] stringValue], @"0");
      XCTAssertEqualObjects([[[NSDecimalNumber decimalNumberWithString:@""] sanitize] stringValue], @"0");
    });
  });

SpecEnd