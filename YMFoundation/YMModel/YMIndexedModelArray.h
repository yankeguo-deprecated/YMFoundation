//
//  YMLazyModelArray.h
//  Pods
//
//  Created by Yanke Guo on 16/7/28.
//
//

#import <Foundation/Foundation.h>

@class YMModel;
@class YMModelStore;

@interface YMIndexedModelArray<ObjectType : __kindof YMModel*> : NSObject

/**
 *  The YMModelStore attached
 */
@property(nonatomic, readonly) YMModelStore *__nonnull modelStore;

/**
 *  The YMModelStore ModelClass
 */
@property(nonatomic, readonly) Class __nonnull modelClass;

/**
 *  Count of ModelIdsArray
 */
@property(nonatomic, readonly) NSUInteger count;

/**
 *  Init with a attached ModelStore
 *
 *  @param modelStore modelStore
 *
 *  @return self
 */
- (id __nonnull)initWithModelStore:(YMModelStore *__nonnull)modelStore;

/**
 *  Replace all model ids from self.modelIds
 *
 *  @param idsArray idsArray to replace
 *
 *  @return wheather idsArray has changed, using characteristicString
 */
- (BOOL)updateIdsArray:(NSArray<NSString *> *__nonnull)idsArray;

/**
 *  Append model ids
 *
 *  @param idsArray model ids to append
 *
 *  @return wheather model ids is changed, using characteristicString
 */
- (BOOL)appendIdsArray:(NSArray<NSString *> *__nonnull)idsArray;

/**
 *  Get the model id from self.idsArray
 *
 *  @param index index
 *
 *  @return id or nil
 */
- (NSString *__nullable)modelIdAtIndex:(NSUInteger)index;

/**
 *  Find the model from self.modelStore
 *
 *  @param index index
 *
 *  @return YMModel or nil
 */
- (ObjectType __nullable)modelAtIndex:(NSUInteger)index;

- (ObjectType __nullable)objectAtIndexedSubscript:(NSUInteger)idx;

/**
 *  Join all model ids with '|', create a characteristicString for comparing
 *
 *  @return string
 */
- (NSString *__nullable)characteristicString;

@end
