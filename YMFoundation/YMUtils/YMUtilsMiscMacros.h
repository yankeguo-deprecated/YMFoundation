//
//  YMUtilsMiscMacros.h
//  YMXian
//
//  Created by Yanke Guo on 16/7/25.
//
//

#import <Foundation/Foundation.h>

/**
 *  Reverse If
 */
#define unless(X) if(!(X))

/**
 *  Shortcut for [NSString stringWithFormat:...]
 */
#define S(FORMAT, ...) ([NSString stringWithFormat:FORMAT, ##__VA_ARGS__])

/**
 *  Shortcut for define a complete block with a NSError and value with TYPE
 */
#define YMCompleteBlockDefine(NAME, TYPE) typedef void(^NAME)(NSError *__nullable, TYPE __nullable);
#define YMCompleteBlockDefineP(NAME, TYPE) typedef void(^NAME)(NSError *__nullable, TYPE);

#define YMCompleteBlockQuickDefine(NAME) YMCompleteBlockDefine(NAME##CompleteBlock, NAME*)
#define YMCompleteBlockQuickDefineP(NAME) YMCompleteBlockDefineP(NAME##CompleteBlock, NAME)

#define YMCompleteBlockArrayDefine(NAME) YMCompleteBlockDefine(NAME##ArrayCompleteBlock, NSArray<NAME *>*)
