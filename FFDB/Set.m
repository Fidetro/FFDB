//
//  Set.m
//  FFDB
//
//  Created by Fidetro on 2018/6/9.
//  Copyright © 2018年 Fidetro. All rights reserved.
//

#import "Set.h"
#import "Where.h"
@implementation Set

- (instancetype)initWithSTMT:(NSString *)stmt format:(NSString *)format
{
    self = [super init];
    if (self)
    {
        self.stmt = [NSString stringWithFormat:@"%@set %@ ",stmt,format];
    }
    return self;
}

- (instancetype)initWithSTMT:(NSString *)stmt columns:(NSArray<NSString *>*)columns
{
    self = [self initWithSTMT:stmt format:[self columnsToString:columns]];
    if (self)
    {
        
    }
    return self;
}

- (Where *(^)(NSString *))where
{
    return ^(NSString *stmt){
        return [[Where alloc]initWithSTMT:self.stmt format:stmt];
    };
}


- (NSString *)columnsToString:(NSArray<NSString *>*)columns
{
    NSMutableString *columnsString = [NSMutableString string];
    for (NSInteger index = 0; index<columns.count; index++)
    {
        NSString *column = columns[index];
        if (index == 0)
        {
            [columnsString appendFormat:@"%@=?",column];
        }else
        {
            [columnsString appendFormat:@",%@=?",column];
        }
    }
    return [columnsString copy];
}

@end
