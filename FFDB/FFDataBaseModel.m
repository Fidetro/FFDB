//
//  FIDDataBaseModel.m
//  FFDB
//
//  Created by Fidetro on 2017/3/22.
//  Copyright © 2017年 Fidetro. All rights reserved.
//
//  https://github.com/Fidetro/FFDB

#import "FFDataBaseModel.h"
#import "FFDataBaseModel+Sqlite.h"
#import "FFDataBaseModel+Custom.h"
#import "NSObject+FIDProperty.h"

NSString const* kUpdateContext = @"kUpdateContext";

@interface FFDataBaseModel ()

@property(nonatomic,strong,readwrite) NSString *primaryID;
@end

@implementation FFDataBaseModel

+ (NSArray <__kindof FFDataBaseModel *>*)selectFromClassAllObject
{
    return [[self class] selectFromClassPredicateWithFormat:nil];
}

+ (NSArray <__kindof FFDataBaseModel *>*)selectFromClassPredicateWithFormat:(NSString *)format
{
    
    return [FFDBManager selectColumns:nil fromClass:[self class] SQLStatementWithFormat:format];
    
}

+ (BOOL)deleteFromClassAllObject
{
    return [[self class]deleteFromClassPredicateWithFormat:nil];
}

- (BOOL)deleteObject
{
    return [[self class]deleteFromClassPredicateWithFormat:[self deleteObjectSqlstatement]];
}

+ (BOOL)deleteFromClassPredicateWithFormat:(NSString *)format
{
    return [FFDBManager deleteFromClass:[self class] SQLStatementWithFormat:format];
}

- (BOOL)insertObject
{
    NSArray *propertyNames = [[self class]columsOfSelf];
    return [FFDBManager insertObject:self columns:propertyNames];
}

- (BOOL)insertObjectWithColumns:(NSArray *)columns
{
    return [FFDBManager insertObject:self columns:columns];
}

+ (BOOL)updateFromClassPredicateWithFormat:(NSString *)format
{
    
    return [FFDBManager updateFromClass:[self class] SQLStatementWithFormat:format];
}

- (BOOL)updateObject
{
    NSArray *propertyNames = [[self class]columsOfSelf];
    return [FFDBManager updateObject:self columns:propertyNames];
}

- (BOOL)updateObjectSetColumns:(NSArray *)columns
{
    return [FFDBManager updateObject:self columns:columns];
}

- (void)updateObjectWithBlock:(void(^)())update_block
{
    NSArray *propertyNames = [[self class]columsOfSelf];
    if (update_block)
    {
        for (NSString *propertyName in propertyNames)
        {
            [self addObserver:self forKeyPath:propertyName options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:&kUpdateContext];
        }
        update_block();
        for (NSString *propertyName in propertyNames)
        {
            [self removeObserver:self forKeyPath:propertyName];
        }
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if (context == &kUpdateContext)
    {
        [self updateObjectSetColumns:@[keyPath]];
    }
}

#pragma mark - --------------------------base method--------------------------




/**
 添加新的字段
 */
+ (void)alertColumn
{
    [FFDBManager alertFromClass:self columns:nil];
    
}



+ (void)initialize
{
    if ([NSStringFromClass([self class])isEqualToString:@"FFDataBaseModel"])
    {
        return;
    }
    else if ([NSStringFromClass([self class])rangeOfString:@"NSKVONotifying"].location != NSNotFound)
    {
        return;
    }
    else
    {
        [[FFDBManager database] executeUpdateWithSqlstatement:[self createTableSqlstatement]];
        [[self class]alertColumn];
    }
}

@end


