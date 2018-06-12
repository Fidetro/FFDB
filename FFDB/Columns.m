//
//  Columns.m
//  FFDB
//
//  Created by Fidetro on 2018/6/9.
//  Copyright © 2018年 Fidetro. All rights reserved.
//

#import "Columns.h"

@implementation Columns


- (instancetype)initWithSTMT:(NSString *)stmt format:(NSString *)format
{
    self = [super init];
    if (self)
    {
        self.stmt = [NSString stringWithFormat:@"%@%@ ",stmt,format];
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

- (Values *(^)(id))values
{
    return ^(id param){
        if ([param isKindOfClass:[NSNumber class]]) {
            return [[Values alloc]initWithSTMT:self.stmt count:param];
        }
        return [[Values alloc]initWithSTMT:self.stmt format:param];
        
    };
}

- (NSString *)columnsToString:(NSArray<NSString *>*)columns
{
    NSMutableString *columnsString = [NSMutableString string];
    [columnsString appendString:@"("];
    
    for (NSInteger index = 0; index<columns.count; index++)
    {
        NSString *column = columns[index];
        if (index == 0)
        {
            [columnsString appendFormat:@"%@",column];
        }else
        {
            [columnsString appendFormat:@",%@",column];
        }        
    }
    [columnsString appendString:@")"];
    return [columnsString copy];
}


@end
