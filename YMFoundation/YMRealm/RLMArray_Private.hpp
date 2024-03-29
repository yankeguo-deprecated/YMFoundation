////////////////////////////////////////////////////////////////////////////
//
// Copyright 2014 Realm Inc.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
////////////////////////////////////////////////////////////////////////////

#import "RLMArray_Private.h"
#import <YMFoundation/RLMResults.h>

#import <memory>
#import <vector>

namespace realm {
    class LinkView;
    class Results;
    class TableView;
    struct SortOrder;

    namespace util {
        template<typename T> class bind_ptr;
    }
    typedef util::bind_ptr<LinkView> LinkViewRef;
}

@class RLMObjectBase;
@class RLMObjectSchema;
class RLMObservationInfo;

@protocol RLMFastEnumerable
@property (nonatomic, readonly) RLMRealm *realm;
@property (nonatomic, readonly) RLMObjectSchema *objectSchema;
@property (nonatomic, readonly) NSUInteger count;

- (NSUInteger)indexInSource:(NSUInteger)index;
- (realm::TableView)tableView;
@end

@interface RLMArray () {
  @protected
    NSString *_objectClassName;
  @public
    // The name of the property which this RLMArray represents
    NSString *_key;
    __weak RLMObjectBase *_parentObject;
}
@end


//
// LinkView backed RLMArray subclass
//
@interface RLMArrayLinkView : RLMArray <RLMFastEnumerable>
@property (nonatomic, unsafe_unretained) RLMObjectSchema *objectSchema;

+ (RLMArrayLinkView *)arrayWithObjectClassName:(NSString *)objectClassName
                                          view:(realm::LinkViewRef)view
                                         realm:(RLMRealm *)realm
                                           key:(NSString *)key
                                  parentSchema:(RLMObjectSchema *)parentSchema;

// deletes all objects in the RLMArray from their containing realms
- (void)deleteObjectsFromRealm;
@end

void RLMValidateArrayObservationKey(NSString *keyPath, RLMArray *array);

// Initialize the observation info for an array if needed
void RLMEnsureArrayObservationInfo(std::unique_ptr<RLMObservationInfo>& info, NSString *keyPath, RLMArray *array, id observed);


//
// RLMResults private methods
//
@interface RLMResults () <RLMFastEnumerable>
+ (instancetype)resultsWithObjectSchema:(RLMObjectSchema *)objectSchema
                                   results:(realm::Results)results;

- (void)deleteObjectsFromRealm;
@end

// An object which encapulates the shared logic for fast-enumerating RLMArray
// and RLMResults, and has a buffer to store strong references to the current
// set of enumerated items
@interface RLMFastEnumerator : NSObject
- (instancetype)initWithCollection:(id<RLMFastEnumerable>)collection objectSchema:(RLMObjectSchema *)objectSchema;

// Detach this enumerator from the source collection. Must be called before the
// source collection is changed.
- (void)detach;

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state
                                    count:(NSUInteger)len;
@end
