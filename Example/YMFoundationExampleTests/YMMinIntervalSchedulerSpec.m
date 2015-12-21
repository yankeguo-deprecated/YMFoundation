//
//  YMMinIntervalSchedulerSpec.m
//  YMFoundationExample
//
//  Created by Yanke Guo on 15/12/21.
//  Copyright © 2015年 YMXian. All rights reserved.
//

SpecBegin(YMMinIntervalScheduler)

  it(@"should work", ^{
    YMMinIntervalScheduler *scheduler = [[YMMinIntervalScheduler alloc] initWithInterval:3];
    __block NSUInteger count = 0;
    __block BOOL ret = NO;
    ret = [scheduler schedule:^{
      count += 1;
    }];
    XCTAssertEqual(count, 1);
    XCTAssertTrue(ret);

    [scheduler updateLastScheduled];

    ret = [scheduler schedule:^{
      count += 1;
    }];
    XCTAssertEqual(count, 1);
    XCTAssertFalse(ret);

    [scheduler updateLastScheduled];

    waitUntil(^(DoneCallback done) {
      dispatch_main_after(2, ^{
        ret = [scheduler schedule:^{
          count += 1;
        }];
        XCTAssertEqual(count, 1);
        XCTAssertFalse(ret);
        dispatch_main_after(2, ^{
          ret = [scheduler schedule:^{
            count += 1;
          }];
          XCTAssertEqual(count, 2);
          XCTAssertTrue(ret);
          done();
        });
      });
    });
  });

SpecEnd