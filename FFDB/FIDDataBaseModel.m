//
//  FIDDataBaseModel.m
//  FFDB
//
//  Created by Fidetro on 2017/3/22.
//  Copyright © 2017年 Fidetro. All rights reserved.
//

#import "FIDDataBaseModel.h"
NSString *const kDatabaseHeadname = @"FID";
NSString const* kUpdateContext = @"kUpdateContext";

@interface FIDDataBaseModel ()
/** id **/
@property(nonatomic,strong,readwrite) NSString *primaryID;
@end

@implementation FIDDataBaseModel



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
        if ([format length] != 0)
        {
            resultSet = [database executeQuery:[NSString stringWithFormat:@"select *from `%@` %@",[[self class] getTableName],format]];
        }else
        {
            resultSet = [database executeQuery:[NSString stringWithFormat:@"select *from `%@`",[[self class] getTableName]]];
        }
        
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

- (BOOL)deleteObject{
    return [[self class] deleteObjectPredicateWithFormat:[NSString stringWithFormat:@"where primaryID = '%@'",self.primaryID]];
}

+ (BOOL)deleteObjectPredicateWithFormat:(NSString *)format
{
    if ([format length] != 0)
    {
        return [FIDDataBaseModel executeUpdateWithSqlstatement:[NSString stringWithFormat:@"delete from `%@` %@",[[self class] getTableName],format]];
    }else{
        return [FIDDataBaseModel executeUpdateWithSqlstatement:[NSString stringWithFormat:@"delete from `%@`",[[self class] getTableName]]];
    }
    
}

- (BOOL)insertObject
{
    NSString *keys = [NSString string];
    NSString *values = [NSString string];
    NSArray *propertyNames = [[self class]propertyOfSelf];
    for (NSInteger index = 0; index < [propertyNames count]; index++) {
        NSString *propertyname = propertyNames[index];
        if (index == 0)
        {
            keys = [NSString stringWithFormat:@"%@'%@'",keys,propertyname];
            values = [NSString stringWithFormat:@"%@'%@'",values,[self getIvarWithName:propertyname]];
            continue;
        }
        keys = [NSString stringWithFormat:@"%@,'%@'",keys,propertyname];
        values = [NSString stringWithFormat:@"%@,'%@'",values,[self getIvarWithName:propertyname]];
    }
    return [FIDDataBaseModel executeUpdateWithSqlstatement:[NSString stringWithFormat:@"insert into `%@` (%@) values(%@) ",[[self class] getTableName],keys,values]];
}

+ (BOOL)updateObjectPredicateWithFormat:(NSString *)format
{
    return [FIDDataBaseModel executeUpdateWithSqlstatement:[NSString stringWithFormat:@"update `%@` %@",[[self class] getTableName],format]];
}

- (BOOL)updateObject
{
    NSString *values = [NSString string];
    NSArray *propertyNames = [[self class]propertyOfSelf];
    for (NSInteger index = 0; index < [propertyNames count]; index++) {
        NSString *propertyname = propertyNames[index];
        if (index == 0)
        {
            values = [NSString stringWithFormat:@"%@%@='%@'",values,propertyname,[self getIvarWithName:propertyname]];
        }
        else
        {
        values = [NSString stringWithFormat:@"%@,%@='%@'",values,propertyname,[self getIvarWithName:propertyname]];
        }
    }
    
    return [FIDDataBaseModel executeUpdateWithSqlstatement:[NSString stringWithFormat:@"update `%@` set  %@ where primaryID = '%@'",[[self class] getTableName],values,self.primaryID]];
}

- (BOOL)updateObjectWithColumns:(NSArray *)columns
{
    NSString *values = [NSString string];
    for (NSInteger index = 0; index < columns.count; index++)
    {
        NSString *column = columns[index];
        if (index == 0)
        {
            values = [NSString stringWithFormat:@"%@%@='%@'",values,column,[self getIvarWithName:column]];
        }
        else
        {
            values = [NSString stringWithFormat:@"%@,%@='%@'",values,column,[self getIvarWithName:column]];
        }
    }
    return [FIDDataBaseModel executeUpdateWithSqlstatement:[NSString stringWithFormat:@"update `%@` set  %@ where primaryID = '%@'",[[self class] getTableName],values,self.primaryID]];
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
/**
 执行数据库语句
 
 @param sqlstatement sqlite语句
 @return 返回是否更新成功
 */
+ (BOOL)executeUpdateWithSqlstatement:(NSString *)sqlstatement
{
    FMDatabase *database = [FIDDataBaseModel getDatabase];
    BOOL update = NO;
    if ([database open])
    {
        update =  [database executeUpdate:sqlstatement];
    }
    [database close];
    return update;
}


+ (FMDatabase *)getDatabase
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *executableFile = [infoDictionary objectForKey:(NSString *)kCFBundleExecutableKey];
    NSString *datebaseName = [NSString stringWithFormat:@"%@.sqlite",executableFile];
    FMDatabase *database = [FMDatabase databaseWithPath:[[NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES) lastObject]stringByAppendingPathComponent:datebaseName]];
    
    return database;
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
    FMDatabase *database = [FIDDataBaseModel getDatabase];
    if ([database open])
    {
        for (NSString *propertyname in [[self class]propertyOfSelf])
        {
            if (![database columnExists:propertyname inTableWithName:tablename]) {
                [[self class]executeUpdateWithSqlstatement:[NSString stringWithFormat:@"alter table `%@` add %@ text",tablename,propertyname]];
            }
        }
    }
    [database close];
}

+ (void)initialize
{
    if ([NSStringFromClass([self class])isEqualToString:@"FIDDataBaseModel"])
    {
        return;
    }
    else
    {
        NSString *tableKey = [NSString string];
        NSArray *propertyNames = [[self class]propertyOfSelf];
        for (NSInteger index = 0; index < [propertyNames count]; index++)
        {
            NSString *propertyname = propertyNames[index];
            if (index == 0)
            {
                tableKey = [NSString stringWithFormat:@"%@%@ text",tableKey,propertyname];
                continue;
            }
            tableKey = [NSString stringWithFormat:@"%@,%@ text",tableKey,propertyname];
        }
        [FIDDataBaseModel executeUpdateWithSqlstatement:[NSString stringWithFormat:@"create table if  not exists `%@%@` (primaryID integer PRIMARY KEY AUTOINCREMENT,%@)",kDatabaseHeadname,NSStringFromClass([self class]),tableKey]];
        [[self class]alertColumn];
    }
}

- (id)getIvarWithName:(NSString *)propertyname
{
    id obj = [self sendGetMethodWithPropertyName:propertyname];
    
    if ([obj respondsToSelector:@selector(length)])
    {
        if ([obj length] == 0)
        {
            obj = @"";
        }
    }
    else if (obj == nil)
    {
        obj = @"";
    };
    return obj;
}


@end


