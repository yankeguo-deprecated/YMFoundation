//
//  JSONTests.m
//  YMXian
//
//  Created by 琰珂 郭 on 15/9/18.
//  Copyright © 2015年 YANKE Guo. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "YMFoundationTestsHelper.h"

@interface SampleModel : YMJSON

@property (nonatomic, strong) NSString * id;

@property (nonatomic, strong) NSArray<SampleModel*>* children;

@property (nonatomic, strong) NSArray<NSString*>* strings;

@property (nonatomic, strong) NSArray<NSString*>* strings2;

@end

@implementation SampleModel

+ (void)buildDescriptor:(YMJSONDescriptor *)descriptor {
  [descriptor addRequired:@"id"];
  [descriptor add:@"children" genericClass:[SampleModel class]];
  [descriptor add:@"strings" genericClass:[NSString class]];
  
  [descriptor add:@"strings2" build:^(YMJSONMappingItem * _Nonnull mapping) {
    mapping.fieldName = @"strings_2";
    mapping.genericClass = [NSString class];
  }];
}

@end

SpecBegin(JSON)

describe(@"required properties", ^{
  
  it(@"should work", ^{
    NSDictionary* dict = @{};
    SampleModel* smodel = [[SampleModel alloc] initWithDictionary:dict];
    XCTAssert(smodel == nil);
    NSDictionary* dict2 = @{@"id":@(10)};
    SampleModel* smodel2 = [[SampleModel alloc] initWithDictionary:dict2];
    XCTAssert([smodel2 isKindOfClass:[SampleModel class]]);
    XCTAssert([smodel2.id isKindOfClass:[NSString class]]);  
  });
  
});

describe(@"custom field name", ^{
  
  it(@"should work", ^{
    NSDictionary* dict = @{
                           @"id":@(1),
                           @"strings_2":@[@(1), @(2)]
                           };
    SampleModel* smodel = [[SampleModel alloc] initWithDictionary:dict];
    XCTAssert([smodel isKindOfClass:[SampleModel class]]);
    XCTAssert(smodel.children == nil);
    XCTAssert(smodel.strings2.count == 2);
    XCTAssert([smodel.strings2.firstObject isKindOfClass:[NSString class]]);  
  });
  
});

describe(@"properties with generic", ^{
  
  it(@"should work", ^{
    NSDictionary* dict = @{
                           @"id":@(1),
                           @"strings":@[@(1), @(2)]
                           };
    SampleModel* smodel = [[SampleModel alloc] initWithDictionary:dict];
    XCTAssert([smodel isKindOfClass:[SampleModel class]]);
    XCTAssert(smodel.children == nil);
    XCTAssert(smodel.strings.count == 2);
    XCTAssert([smodel.strings.firstObject isKindOfClass:[NSString class]]);  
  });
  
  it(@"should work with nested", ^{
    NSDictionary* dict = @{
                           @"id":@(1),
                           @"children":@[
                               @{
                                 @"id": @(2)
                                 },
                               @{
                                 @"id": @(3)
                                 }
                               ]
                           };
    SampleModel* smodel = [[SampleModel alloc] initWithDictionary:dict];
    XCTAssert([smodel isKindOfClass:[SampleModel class]]);
    XCTAssert(smodel.strings == nil);
    XCTAssert(smodel.children.count == 2);
    XCTAssert([smodel.children.firstObject isKindOfClass:[SampleModel class]]);
    XCTAssert([smodel.children.firstObject.id isKindOfClass:[NSString class]]);  
  });
  
});

describe(@"performance", ^{
  
  it(@"should look good", ^{
    [self measureBlock:^{
      NSDictionary* dict = @{
                             @"id":@(1),
                             @"children":@[
                                 @{
                                   @"id": @(2)
                                   },
                                 @{
                                   @"id": @(3)
                                   }
                                 ]
                             };
      for (int i = 0 ; i < 10000; i ++) {
        SampleModel* smodel = [[SampleModel alloc] initWithDictionary:dict];
        XCTAssert([smodel isKindOfClass:[SampleModel class]]);
      }
    }];  
  });
});

SpecEnd