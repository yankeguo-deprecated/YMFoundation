//
//  YMJSONMappingItem.h
//  ProtoJSON
//
//  Created by 琰珂 郭 on 15/9/15.
//  Copyright © 2015年 YANKE Guo. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  定义一个 YMJSON 字段的选项
 */
typedef NS_ENUM(NSInteger, JSONFieldOption) {
  /**
   *  可选的，即可以为 nil
   */
      JSONFieldOptionOptional = 0,
  /**
   *  自动填充，如果服务器返回为 nil，则自动填充为相应的类型的默认值，比如 @"", @(0)
   */
      JSONFieldOptionAutoFill = 1,
  /**
   *  字段为必选的
   */
      JSONFieldOptionRequired = 2,
  /**
   *  字段为必须选，同时可以作为该模型的索引
   */
  // JSONFieldOptionIndex    = 3
};

@interface YMJSONMappingItem: NSObject

/**
 *  属性名
 */
@property(nonatomic, strong, readonly) NSString *__nonnull propertyName;

/**
 *  Setter SEL
 */
@property(nonatomic, assign, readonly) SEL __nonnull propertySetterSelector;

/**
 *  Getter SEL
 */
@property(nonatomic, assign, readonly) SEL __nonnull propertyGetterSelector;

/**
 *  对应的 YMJSON 字段名
 */
@property(nonatomic, strong) NSString *__nonnull fieldName;

/**
 *  选项
 */
@property(nonatomic, assign) JSONFieldOption option;

/**
 *  类型
 */
@property(nonatomic, retain) Class __nonnull propertyClass;

@property(nonatomic, retain) NSString *__nonnull propertyClassName;

/**
 *  容器类内部的类型
 */
@property(nonatomic, retain) Class __nullable genericClass;

@property(nonatomic, strong) NSString *__nullable genericClassName;

/**
 *  初始化一个 Mapping
 *
 *  @param propertyName 属性名
 *
 *  @return 自己
 */
+ (instancetype __nonnull)mappingWithPropertyName:(NSString *__nonnull)propertyName;

- (id __nonnull)initWithPropertyName:(NSString *__nonnull)propertyName;

@end
