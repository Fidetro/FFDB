//
//  Values.m
//  FFDB
//
//  Created by Fidetro on 2018/6/9.
//  Copyright © 2018年 Fidetro. All rights reserved.
//

#import "Values.h"

@implementation Values

- (instancetype)initWithSTMT:(NSString *)stmt format:(NSString *)format
{
    self = [super init];
    if (self)
    {
        self.stmt = [NSString stringWithFormat:@"%@values %@ ",stmt,format];
    }
    return self;
}


- (instancetype)initWithSTMT:(NSString *)stmt count:(NSNumber *)count
{
    NSMutableString *valuesString = [NSMutableString string];
    [valuesString appendString:@"("];
    for (NSInteger index = 0; index<[count integerValue]; index++)
    {
        if (index == 0)
        {
            [valuesString appendString:@"?"];
        }else
        {
            [valuesString appendString:@",?"];
        }
    }
    [valuesString appendString:@")"];
    self = [self initWithSTMT:stmt format:valuesString];
    if (self)
    {
        
    }
    return self;
}


@end
