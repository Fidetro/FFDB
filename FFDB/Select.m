//
//  Select.m
//  FFDB
//
//  Created by Fidetro on 2018/6/8.
//  Copyright © 2018年 Fidetro. All rights reserved.
//

#import "Select.h"

@implementation Select

- (instancetype)initWithSTMT:(NSString *)stmt
{
    self = [super init];
    if (self) {
        self.stmt = [NSString stringWithFormat:@"select %@ ",stmt];
    }
    return self;
}

+ (Select *(^)(id))begin
{
    return ^(id param){
        if ([param isSubclassOfClass:[NSArray class]])
        {
            NSArray *columns = (NSArray *)param;
            NSString *columnString = @"";
            for (NSInteger index = 0; index<columns.count; index++)
            {
                NSString *column = columns[index];
                if (index == 0)
                {
                    columnString = [NSString stringWithFormat:@"%@",column];
                }else
                {
                    columnString = [NSString stringWithFormat:@"%@,%@",columnString,column];
                }
            }
            
            return [[Select alloc]initWithSTMT:param];
        }
        return [[Select alloc]initWithSTMT:param];
    };
}

- (From *(^)(id))from
{
    return ^(id param){
        if ([param isSubclassOfClass:[FFDataBaseModel class]]) {
            return [[From alloc]initWithSTMT:self.stmt table:param];
        }
        return [[From alloc]initWithSTMT:self.stmt format:param];
    };
}

@end
