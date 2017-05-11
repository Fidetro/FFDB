//
//  FIDDataBaseModel.m
//  FFDB
//
//  Created by Fidetro on 2017/3/22.
//  Copyright © 2017年 Fidetro. All rights reserved.
//

#import "FFDataBaseModel.h"
#import "FFDataBaseModel+Sqlite.h"

NSString *const kDatabaseHeadname = @"FID";
NSString const* kUpdateContext = @"kUpdateContext";

@interface FFDataBaseModel ()

@property(nonatomic,strong,readwrite) NSString *primaryID;
@end

@implementation FFDataBaseModel

+ (NSArray *)selectAllObject
{
    return [[self class] selectObjectPredicateWithFormat:nil];
}

+ (NSArray *)selectObjectPredicateWithFormat:(NSString *)format{
    FMDatabase *database = [self getDatabase];
    NSMutableArray *params = [NSMutableArray array];
    if ([database open])
    {
        FMResultSet *resultSet;
        resultSet = [database executeQuery:[[self class]selectObjectSqlstatementWithFormat:format]];
        while ([resultSet next])
        {
            
            id object = [[[self class]alloc]init];
            for (NSString *propertyname in [[self class] propertyOfSelf])
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

+ (BOOL)deleteAllObject
{
    return [[self class] deleteObjectPredicateWithFormat:nil];
}

- (BOOL)deleteObject
{
    return [[self class] deleteObjectPredicateWithFormat:[self deleteObjectSqlstatement]];
}

+ (BOOL)deleteObjectPredicateWithFormat:(NSString *)format
{
    return [[FFDataBaseModel getDatabase] executeUpdateWithSqlstatement:[[self class] deleteObjectSqlstatementWithFormat:format]];
}

- (BOOL)insertObject
{
    return [[FFDataBaseModel getDatabase] executeUpdateWithSqlstatement:[self insertObjectSqlstatement]];
}

+ (BOOL)updateObjectPredicateWithFormat:(NSString *)format
{
    return [[FFDataBaseModel getDatabase] executeUpdateWithSqlstatement:[NSString stringWithFormat:@"update `%@` %@",[[self class] getTableName],format]];
}

- (BOOL)updateObject
{
    NSArray *propertyNames = [[self class]propertyOfSelf];
    return [self updateObjectWithColumns:propertyNames];
}

- (BOOL)updateObjectWithColumns:(NSArray *)columns
{
    NSString *sqlstatement = [self updateObjectSqlStatementWithColumns:columns];
    return [[FFDataBaseModel getDatabase] executeUpdateWithSqlstatement:sqlstatement];
}

- (void)updateObjectWithBlock:(void(^)())update_block
{
    NSArray *propertyNames = [[self class]propertyOfSelf];
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
        [self updateObjectWithColumns:@[keyPath]];
    }
}

#pragma mark - --------------------------base method--------------------------

+ (FMDatabase *)getDatabase
{
    return [FFDBManager database];
}

+ (NSString *)getTableName
{
    return [NSString stringWithFormat:@"%@%@",kDatabaseHeadname,NSStringFromClass([self class])];
}

/**
 添加新的字段
 */
+ (void)alertColumn
{
    NSString *tablename = [NSString stringWithFormat:@"%@%@",kDatabaseHeadname,NSStringFromClass([self class])];
    FMDatabase *database = [FFDataBaseModel getDatabase];
    if ([database open])
    {
        for (NSString *propertyname in [[self class]propertyOfSelf])
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
        [[FFDataBaseModel getDatabase] executeUpdateWithSqlstatement:[self createTableSqlstatement]];
        [[self class]alertColumn];
    }
}

@end


