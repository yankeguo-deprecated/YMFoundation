//
// Created by Yanke Guo on 16/3/7.
//

#import "YMLoggerConsoleOutput.h"
#import "YMLogger.h"

#import <asl.h>

@interface YMLoggerConsoleOutput ()

@property(nonatomic, weak) YMLogger *__nullable logger;

@end

@implementation YMLoggerConsoleOutput

- (void)didAddToLogger:(YMLogger *__nonnull)logger {
  self.logger = logger;
}

- (void)didRemoveFromLogger:(YMLogger *__nonnull)logger {
}

- (void)logger:(YMLogger *__nonnull)logger didOutputLine:(NSString *__nonnull)line {
  fprintf(stderr, "%s\n", [line UTF8String]);
}

- (NSArray<NSString *> *__nonnull)allLogEntries {
  return [self allLogEntriesForBundleName:self.logger.bundleName];
}

- (NSArray<NSString *> *__nonnull)allLogEntriesForBundleName:(NSString *__nonnull)bundleName {
  NSMutableArray *logs = [NSMutableArray array];

  if (bundleName.length == 0) {
    return logs;
  }

  aslmsg q, m;
  int i;
  const char *key, *val;

  NSString *queryTerm = bundleName;

  q = asl_new(ASL_TYPE_QUERY);
  asl_set_query(q, ASL_KEY_SENDER, [queryTerm UTF8String], ASL_QUERY_OP_EQUAL);

  aslresponse r = asl_search(NULL, q);

  while (NULL != (m = asl_next(r))) {
    NSMutableDictionary *tmpDict = [NSMutableDictionary dictionary];

    for (i = 0; (NULL != (key = asl_key(m, i))); i++) {
      NSString *keyString = [NSString stringWithUTF8String:(char *) key];

      val = asl_get(m, key);

      NSString *string = [NSString stringWithUTF8String:val];
      [tmpDict setObject:string forKey:keyString];
    }

    NSString *message = [tmpDict objectForKey:@"Message"];
    if (message) {
      [logs addObject:message];
    }
  }

  asl_free(r);

  return logs;
}

@end