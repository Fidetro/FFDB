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
        if ([param isKindOfClass:[NSArray class]])
        {
            NSArray *columns = (NSArray *)param;
            NSMutableString *columnString = [NSMutableString string];
            [columnString appendString:@"("];
            for (NSInteger index = 0; index<columns.count; index++)
            {
                NSString *column = columns[index];
                if (index == 0)
                {
                    
                    [columnString appendString:column];
                }else
                {
                    [columnString appendFormat:@",%@",column];
                }
            }
            [columnString appendString:@")"];
            return [[Select alloc]initWithSTMT:[columnString copy]];
        }
        return [[Select alloc]initWithSTMT:param];
    };
}

- (From *(^)(id))from
{
    return ^(id param){
        if ([param isKindOfClass:[NSString class]])
        {
        return [[From alloc]initWithSTMT:self.stmt format:param];
        }else if ([param isSubclassOfClass:[FFDataBaseModel class]]) {
            return [[From alloc]initWithSTMT:self.stmt table:param];
        }
        return [[From alloc]initWithSTMT:self.stmt format:param];
    };
}

@end
