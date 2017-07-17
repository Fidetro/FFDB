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
    FMDatabase *database = [self FFDatabase];
    NSMutableArray *params = [NSMutableArray array];
    if ([database open])
    {
        FMResultSet *resultSet;
        resultSet = [database executeQuery:[[self class]selectFromClassSQLStatementWithFormat:format]];
        while ([resultSet next])
        {
            
            id object = [[[self class]alloc]init];
            for (NSString *propertyname in [[self class] columsOfSelf])
            {
                NSString *objStr = [[resultSet stringForColumn:propertyname]length] == 0 ? @"" :[resultSet stringForColumn:propertyname];
                [object setPropertyWithName:propertyname object:objStr];
            }
            [object setPropertyWithName:@"primaryID" object:[resultSet stringForColumn:@"primaryID"]];
            [params addObject:object];
        }
        
    }
    
    [database close];
    
    return [params copy];
}

+ (BOOL)deleteFromClassAllObject
{
    return [[self class] deleteFromClassPredicateWithFormat:nil];
}

- (BOOL)deleteObject
{
    return [[self class] deleteFromClassPredicateWithFormat:[self deleteObjectSqlstatement]];
}

+ (BOOL)deleteFromClassPredicateWithFormat:(NSString *)format
{
    return [[FFDataBaseModel FFDatabase] executeUpdateWithSqlstatement:[[self class] deleteFromSQLStatementWithFormat:format]];
}

- (BOOL)insertObject
{
    NSArray *propertyNames = [[self class]columsOfSelf];
    return [[FFDataBaseModel FFDatabase] executeUpdateWithSqlstatement:[self insertFromClassSQLStatementWithColumns:propertyNames]];
}

- (BOOL)insertObjectWithColumns:(NSArray *)columns
{
    return [[FFDataBaseModel FFDatabase] executeUpdateWithSqlstatement:[self insertFromClassSQLStatementWithColumns:columns]];
}

+ (BOOL)updateFromClassPredicateWithFormat:(NSString *)format
{
    return [[FFDataBaseModel FFDatabase] executeUpdateWithSqlstatement:[NSString stringWithFormat:@"update `%@` %@",[[self class] tableName],format]];
}

- (BOOL)updateObject
{
    NSArray *propertyNames = [[self class]columsOfSelf];
    return [self updateObjectSetColumns:propertyNames];
}

- (BOOL)updateObjectSetColumns:(NSArray *)columns
{
    NSString *sqlstatement = [self updateFromClassSQLStatementWithColumns:columns];
    return [[FFDataBaseModel FFDatabase] executeUpdateWithSqlstatement:sqlstatement];
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

+ (FMDatabase *)FFDatabase
{
    return [FFDBManager database];
}



/**
 添加新的字段
 */
+ (void)alertColumn
{
    NSString *tablename = [NSString stringWithFormat:@"%@%@",kDatabaseHeadname,NSStringFromClass([self class])];
    FMDatabase *database = [FFDataBaseModel FFDatabase];
    if ([database open])
    {
        for (NSString *propertyname in [[self class]columsOfSelf])
        {
            if (![database columnExists:propertyname inTableWithName:tablename])
            {
                [database executeUpdateWithSqlstatement:[NSString stringWithFormat:@"alter table `%@` add %@ text",tablename,propertyname]];
            }
        }
    }
    [database close];
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
        [[FFDataBaseModel FFDatabase] executeUpdateWithSqlstatement:[self createTableSqlstatement]];
        [[self class]alertColumn];
    }
}

@end


