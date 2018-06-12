//
//  Add.m
//  FFDB
//
//  Created by Fidetro on 2018/6/9.
//  Copyright © 2018年 Fidetro. All rights reserved.
//

#import "Add.h"

@implementation Add

- (instancetype)initWithSTMT:(NSString *)stmt
                      format:(NSString *)format
{
    self = [super init];
    if (self)
    {
        self.stmt = [NSString stringWithFormat:@" %@ add %@ ",stmt,format];
    }
    return self;
}

- (instancetype)initWithSTMT:(NSString *)stmt
                      column:(NSString *)column
                   columnDef:(NSString *)columnDef
{
    self = [self initWithSTMT:stmt format:[NSString stringWithFormat:@"%@ %@",column,columnDef]];
    if (self)
    {
        
    }
    return self;
}

- (instancetype)initWithSTMT:(NSString *)stmt
                      column:(NSString *)column
                       table:(Class)table
{
    self = [self initWithSTMT:stmt format:[self alterColumnsInTableSQL:column table:table]];
    if (self)
    {
        
    }
    return self;
}

- (NSString *)alterColumnsInTableSQL:(NSString *)newColumn
                               table:(Class)table
{
    NSMutableString *sql = [NSMutableString string];
    [sql appendString:newColumn];
    [sql appendString:@" "];
    NSString *type = [table columnsType][newColumn];
    if ([type length] != 0)
    {
        [sql appendString:type];
    }else
    {
        [sql appendString:@"TEXT"];
    }
    return sql;
}

@end
