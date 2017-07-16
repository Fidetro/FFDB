//
//  FFDataBaseModel+Custom.m
//  FFDB
//
//  Created by Fidetro on 2017/7/16.
//  Copyright © 2017年 Fidetro. All rights reserved.
//
//  https://github.com/Fidetro/FFDB

#import "FFDataBaseModel+Custom.h"
#import <objc/runtime.h>
@implementation FFDataBaseModel (Custom)

+ (NSArray *)memoryPropertys
{
    return nil;
}

+ (NSDictionary *)columnsType
{
    return nil;
}

+ (NSArray *)columsOfSelf
{
    unsigned int count = 0;
    Ivar *ivarList = class_copyIvarList(self, &count);
    NSMutableArray *propertyNames = [NSMutableArray array];
    for (int i = 0; i < count; i++)
    {
        Ivar ivar = ivarList[i];
        NSString *name = [NSString stringWithUTF8String:ivar_getName(ivar)];
        NSString *key;
        if ([[name substringToIndex:1] isEqualToString:@"_"])
        {
            key = [name substringFromIndex:1];
        }
        else
        {
            key = [name substringFromIndex:0];
        }
        if ([[self memoryPropertys]containsObject:key])
        {
            continue;
        }
        [propertyNames addObject:key];
    }
    free(ivarList);
    
    return [propertyNames copy];
    
}

@end
