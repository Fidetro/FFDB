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
#import "NSObject+FIDProperty.h"
 NSString *const kDatabaseHeadname = @"FID";
@implementation FFDataBaseModel (Custom)

+ (NSString *)tableName
{
    return [NSString stringWithFormat:@"%@%@",kDatabaseHeadname,NSStringFromClass([self class])];
}

+ (NSArray *)memoryPropertys
{
    return nil;
}

+ (NSDictionary *)columnsType
{
    return nil;
}

+ (NSArray *)columnsOfSelf
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
        NSString *customColumn = [self customColumns][key];
        if (customColumn != nil)
        {
            key = customColumn;
        }
        [propertyNames addObject:key];
    }
    free(ivarList);
    
    return [propertyNames copy];
    
}

+ (NSDictionary *)customColumns
{
    return nil;
}

- (id)sendGetMethodWithPropertyName:(NSString *)propertyName
{
    NSArray *propertyNames = [[[self class]customColumns] allKeysForObject:propertyName];
    if (propertyNames.count == 0)
    {
        return [super sendGetMethodWithPropertyName:propertyName];;
    }
    else
    {
        NSString *customColumn = [propertyNames lastObject];
        return [super sendGetMethodWithPropertyName:customColumn];;
    }
    
}

- (void)setPropertyWithName:(NSString *)propertyName object:(id)object
{
    NSArray *propertyNames = [[[self class]customColumns] allKeysForObject:propertyName];
    if (propertyNames.count == 0)
    {
        [super setPropertyWithName:propertyName object:object];
    }
    else
    {
        NSString *customColumn = [propertyNames lastObject];
        [super setPropertyWithName:customColumn object:object];
    }
}

@end
