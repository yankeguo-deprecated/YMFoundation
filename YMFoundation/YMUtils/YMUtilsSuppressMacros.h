//
//  YMUtilsSuppressMacros.h
//
//  Created by Yanke Guo on 15/11/16.
//  Copyright (c) 2015 YMXian. All rights reserved.
//

#define SUPPRESS_START                      _Pragma("clang diagnostic push")

#define SUPPRESS_ARC_PERFORM_SELECTOR_LEAKS _Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"")

#define SUPPRESS_GNU                        _Pragma("clang diagnostic ignored \"-Wgnu\"")

#define SUPPRESS_DEPRECATED_DECLARATIONS    _Pragma("clang diagnostic ignored \"-Wdeprecated-declarations\"")

#define SUPPRESS_RECEIVER_IS_WEAK           _Pragma("clang diagnostic ignored \"-Wreceiver-is-weak\"")

#define SUPPRESS_UNDECLARED_SELECTOR        _Pragma("clang diagnostic ignored \"-Wundeclared-selector\"")

#define SUPPRESS_END                        _Pragma("clang diagnostic pop")
