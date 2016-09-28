//
//  YMModelArray.h
//  Pods
//
//  Created by Yanke Guo on 16/7/28.
//
//

#import <YMFoundation/YMModel.h>
#import <YMFoundation/YMModelStore.h>
#import <YMFoundation/YMAsync.h>

#import "YRAdapter.h"

@interface YMModelArray<ObjectType : YMModel *> : NSObject

///////////////////////  Resource   ////////////////////////

/**
 * Adapter encapsule statusPair and queue, you can assign another adapter to share queue and statusPair among multiple YMModel or YMModelArray
 */
@property(nonatomic, strong) YRAdapter *__nonnull adapter;

@property(nonatomic, readonly) YMAsyncQueue *__nonnull queue; // Lazy Init

@property(nonatomic, strong) YRStatusPair *__nonnull statusPair;

@property(nonatomic, assign) YRStatus *__nonnull status;

- (void)appendStatus:(YRStatus *__nonnull)status;

////////////////////////////////////////////////////////////

/**
 *  The YMModelStore attached, !!! You should OVERRIDE this property for advanced init !!!
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

@property(nonatomic, readonly, getter=isEmpty) BOOL empty;

@property(nonatomic, readonly) NSArray<NSString *> *__nonnull allIds;

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
 * Remove all model ids
 *
 * @return wheather model ids is changed
 */
- (BOOL)removeAllIds;

/**
 *  Remove an id
 *  @param id
 *
 *  @return  wheather model ids is changed
 */
- (BOOL)removeId:(NSString *__nonnull)id;

/**
 *  Get the model id from self.idsArray
 *
 *  @param index index
 *
 *  @return id or nil
 */
- (NSString *__nullable)modelIdAtIndex:(NSUInteger)index;

- (ObjectType __nullable)firstModel;

- (ObjectType __nullable)lastModel;

- (NSString *__nullable)firstModelId;

- (NSString *__nullable)lastModelId;

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
 *  Convertible to a NSArray
 *
 *  @return NSArray
 */
- (NSArray<ObjectType> *__nullable)toArray;

/**
 *  Join all model ids with '|', create a characteristicString for comparing
 *
 *  @return string
 */
- (NSString *__nullable)characteristicString;

#pragma mark - For Subclass

/**
 *  Advanced Initializor, in this case, you should OVERRIDE -modelStore
 *
 *  @return self
 */
- (id __nonnull)init;

@end
