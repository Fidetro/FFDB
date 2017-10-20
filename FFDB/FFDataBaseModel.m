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
    NSArray *propertyNames = [[self class]columnsOfSelf];
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
    NSArray *propertyNames = [[self class]columnsOfSelf];
    return [FFDBManager updateObject:self columns:propertyNames];
}

- (BOOL)upsert
{
    if ([self.primaryID length] == 0)
    {
        return [self insertObject];
    }
    else
    {
        return [self updateObject];
    }
}


- (BOOL)upsertWithColumns:(NSArray *)columns
{
    if (columns.count == 0)
    {
        return [self upsert];
    }
    else
    {
       long long int totalCount = [FFDBManager selectCountfromClasses:@[[self class]] SQLStatementWithFormat:[NSString stringWithFormat:@" where %@",[self stringWithWhereValueOfColumns:columns]]];
        if (totalCount == 0)
        {
            [self insertObject];
        }
        else
        {
            [self updateObject];
        }
        return YES;
    }
 
}

- (BOOL)updateObjectSetColumns:(NSArray *)columns
{
    return [FFDBManager updateObject:self columns:columns];
}

- (void)updateObjectWithBlock:(void(^)())update_block
{
    NSArray *propertyNames = [[self class]columnsOfSelf];
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
        [FFDBManager createTableFromClass:self];
        [FFDBManager alterFromClass:self columns:nil];
    }
}

@end


