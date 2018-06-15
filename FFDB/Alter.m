//
//  Alter.m
//  FFDB
//
//  Created by Fidetro on 2018/6/9.
//  Copyright © 2018年 Fidetro. All rights reserved.
//

#import "Alter.h"

@implementation Alter

- (instancetype)initWithSTMT:(NSString *)stmt
{
    self = [super init];
    if (self)
    {
        self.stmt = [NSString stringWithFormat:@" alter table %@",stmt];
    }
    return self;
}

- (instancetype)initWithTable:(Class)table
{
    self = [self initWithSTMT:[table tableName]];
    if (self)
    {
        
    }
    return self;
}

+ (Alter *(^)(id))begin
{
    return ^(id param)
    {
        if ([param isSubclassOfClass:[FFDataBaseModel class]])
        {
            return [[Alter alloc]initWithTable:param];
        }
        return [[Alter alloc]initWithSTMT:param];
    };
}

- (Add *(^)(NSString *,id))add
{
    return ^(NSString *column,id param)
    {
        if ([param isSubclassOfClass:[FFDataBaseModel class]])
        {
            return [[Add alloc]initWithSTMT:self.stmt column:column table:param];
        }
        return [[Add alloc]initWithSTMT:self.stmt column:column columnDef:param];
    };
}

@end
