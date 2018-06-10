//
//  FMDatabase+FFExtern.h
//  FFDB
//
//  Created by Fidetro on 2017/5/11.
//  Copyright © 2017年 Fidetro. All rights reserved.
//
//  https://github.com/Fidetro/FFDB

#import <FMDB/FMDB.h>
typedef void(^QueryResult)(NSArray *result);
typedef void(^UpdateResult)(BOOL result);
@interface FMDatabase (FFExtern)


/**
 use FMDatabase update,but unclose
 */
- (BOOL)executeUpdateWithSqlstatement:(NSString *)sqlstatement;

- (void)executeUpdateWithSqlstatement:(NSString *)sqlstatement
                               values:(NSArray <id>*)values
                           completion:(UpdateResult)block;

- (void)executeQueryWithSqlstatement:(NSString *)sqlstatement
                              values:(NSArray <id>*)values
                             toClass:(Class)toClass
                          completion:(QueryResult)block;

@end
