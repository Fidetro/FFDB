//
//  Create.m
//  FFDB
//
//  Created by Fidetro on 2018/6/9.
//  Copyright © 2018年 Fidetro. All rights reserved.
//

#import "Create.h"

@implementation Create

- (instancetype)initWithSTMT:(NSString *)stmt
{
    self = [super init];
    if (self) {
        if ([stmt length] == 0)
        {
            self.stmt = [NSString stringWithFormat:@"create "];
        }else
        {
            self.stmt = [NSString stringWithFormat:@"create %@ ",stmt];
        }
    }
    return self;
}

- (instancetype)initWithTable:(Class)table
{
    NSString *stmt = [NSString stringWithFormat:@"table if  not exists %@ %@",[table tableName],[self createTableSQL:table]];
    self = [self initWithSTMT:stmt];
    if (self)
    {
        
    }
    return self;
}

+ (Create *(^)(id))begin
{
    return ^(id param)
    {
        if ([param isSubclassOfClass:[FFDataBaseModel class]])
        {
            return [[Create alloc]initWithTable:param];
        }
        return [[Create alloc]initWithSTMT:param];
    };
}

- (NSString *)createTableSQL:(Class)table
{
    NSMutableString *sql = [NSMutableString string];
    NSString *primaryKeyColumn = [table primaryKeyColumn];
    if ([primaryKeyColumn length] != 0)
    {
        NSString *type = [table columnsType][primaryKeyColumn];
        if ([type length] == 0) {
           type = @"integer PRIMARY KEY AUTOINCREMENT";
        }
        NSString *customAutoColumn = [table customColumns][primaryKeyColumn];
        if ([customAutoColumn length] != 0)
        {
            [sql appendFormat:@"%@ %@",customAutoColumn,type];
        }else
        {
            [sql appendFormat:@"%@ %@",primaryKeyColumn,type];
        }
    }
    
    for (NSInteger index = 0;index<[table columnsOfSelf].count;index++)
    {
        NSString *column = [table columnsOfSelf][index];
        NSString *name = [table customColumns][column];
        if ([name length] != 0)
        {
            [sql appendString:name];
        }else
        {
            [sql appendString:column];
        }
        [sql appendString:@" "];
        NSString *type = [table columnsType][column];
        if ([type length] != 0)
        {
            [sql appendString:type];
        }else
        {
            [sql appendString:@"TEXT"];
        }
        if (index != [table columnsOfSelf].count-1) {
            [sql appendString:@","];
        }
    }
    return sql;
}

@end
