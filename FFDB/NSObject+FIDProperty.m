//
//  NSObject+FIDProperty.m
//  runtimeCategory
//
//  Created by Fidetro on 2016/11/4.
//  Copyright © 2016年 Fidetro. All rights reserved.
//

#import "NSObject+FIDProperty.h"


@implementation NSObject (FIDProperty)


+ (NSArray *)propertyOfSelf{
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
        [propertyNames addObject:key];
    }
    free(ivarList);
    
    return [propertyNames copy];
}

- (NSArray *)getPublicObject
{
    
    NSMutableArray *objectArray = [NSMutableArray array];
    unsigned int outCount;
    Ivar * ivars = class_copyIvarList([self class], &outCount);
    for (int i = 0; i < outCount; i ++) {
        Ivar ivar = ivars[i];
        
        [objectArray addObject:object_getIvar(self, ivar)];
    }
    return [objectArray copy];
}

- (NSDictionary *)modelToDictionary
{
    NSArray *propertyNames = [[self class] propertyOfSelf];
    NSMutableDictionary *objectParams = [NSMutableDictionary dictionary];
    
    for (NSString *propertyName in propertyNames)
    {
        
        if ([[self sendGetMethodWithPropertyName:propertyName] class] == nil)
        {
            [objectParams setObject:@"" forKey:propertyName];
        }
        else
        {
            [objectParams setObject:[self sendGetMethodWithPropertyName:propertyName] forKey:propertyName];
        }
    }
    
    return [objectParams copy];
}

- (NSDictionary *)modelToDictionaryHaveNilProperty
{
    NSArray *propertyNames = [[self class] propertyOfSelf];
    NSMutableDictionary *objectParams = [NSMutableDictionary dictionary];
    
    for (NSString *propertyName in propertyNames)
    {
        
        if ([[self sendGetMethodWithPropertyName:propertyName] class] == nil)
        {
            continue;
        }
        
        [objectParams setObject:[self sendGetMethodWithPropertyName:propertyName] forKey:propertyName];
    }
    
    return [objectParams copy];
}

- (NSArray *)modelToArray
{
    NSArray *propertyNames = [[self class] propertyOfSelf];
    NSMutableArray *objectArray = [NSMutableArray array];
    
    for (NSString *propertyName in propertyNames)
    {
        
        if ([[self sendGetMethodWithPropertyName:propertyName] class] == nil)
        {
            [objectArray addObject:@""];
        }
        else
        {
        [objectArray addObject:[self sendGetMethodWithPropertyName:propertyName]];
        }
    }
    
    return [objectArray copy];
}

- (NSDictionary *)modelToArrayHaveNilProperty
{
    NSArray *propertyNames = [[self class] propertyOfSelf];
    NSMutableArray *objectArray = [NSMutableArray array];
    
    for (NSString *propertyName in propertyNames)
    {
        
        if ([[self sendGetMethodWithPropertyName:propertyName] class] == nil)
        {
            continue;
        }
        else
        {
            [objectArray addObject:[self sendGetMethodWithPropertyName:propertyName]];
        }
    }
    
    return [objectArray copy];
}

- (id)sendGetMethodWithPropertyName:(NSString *)propertyName{
//    SEL getSel = NSSelectorFromString(propertyName);
//    if ([self respondsToSelector:getSel]) {
//    return [self performSelector:getSel];
//    }
//    return nil;
    
    return [self valueForKey:propertyName];
    
}
- (void)setPropertyWithName:(NSString *)propertyName object:(id)object{
//    NSString *firstCharater = [propertyName substringToIndex:1].uppercaseString;
//    NSString *setPropertyName = [NSString stringWithFormat:@"set%@%@:",firstCharater,[propertyName substringFromIndex:1]];
//    SEL setSel = NSSelectorFromString(setPropertyName);
//    [self performSelector:setSel withObject:object];
    
    [self setValue:object forKey:propertyName];
    
}



@end
