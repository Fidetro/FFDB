//
//  STMT.m
//  FFDB
//
//  Created by Fidetro on 2018/6/6.
//  Copyright © 2018年 Fidetro. All rights reserved.
//

#import "STMT.h"

@implementation STMT

- (void(^)(NSArray <id>*,FMDatabase *,UpdateResult))endUpdate
{
    return ^(NSArray <id> *values,FMDatabase *db,UpdateResult block)
    {
        [self excuteUpdate:values database:db completion:block];
    };
}

- (void(^)(NSArray <id>*,Class,FMDatabase *,QueryResult))endQuery
{
    return ^(NSArray <id> *values,Class toClass,FMDatabase *db,QueryResult block)
    {
        [self excuteQuery:values toClass:toClass database:db completion:block];
    };
}

- (void)excuteUpdate:(NSArray <id>*)values
            database:(FMDatabase *)db
          completion:(UpdateResult)block
{
    if (db == nil)
    {
        [[FFDBManager database]executeUpdateWithSqlstatement:self.stmt values:values completion:block];
    }else
    {
        [db executeUpdateWithSqlstatement:self.stmt values:values completion:block];
    }
}

- (void)excuteQuery:(NSArray <id>*)values
            toClass:(Class)toClass
           database:(FMDatabase *)db
         completion:(QueryResult)block
{
    if (db == nil)
    {
        [[FFDBManager database]executeQueryWithSqlstatement:self.stmt values:values toClass:toClass completion:block];
    }else
    {
        [db executeQueryWithSqlstatement:self.stmt values:values toClass:toClass completion:block];
    }
}



@end
