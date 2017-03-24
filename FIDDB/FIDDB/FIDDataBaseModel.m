//
//  FIDDataBaseModel.m
//  FIDDB
//
//  Created by Fidetro on 2017/3/22.
//  Copyright © 2017年 Fidetro. All rights reserved.
//

#import "FIDDataBaseModel.h"
NSString *const kDatabaseHeadname = @"FID";
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
    if ([database open]) {
        FMResultSet *resultSet;
        if ([format length] != 0) {
            resultSet = [database executeQuery:[NSString stringWithFormat:@"select *from `%@` %@",[[self class] getTableName],format]];
        }else{
            resultSet = [database executeQuery:[NSString stringWithFormat:@"select *from `%@`",[[self class] getTableName]]];
        }
        
        while ([resultSet next]) {
            
            NSMutableDictionary *param = [NSMutableDictionary dictionary];
            for (NSString *propertyname in [[self class] propertyOfSelf]) {
                
                [param setObject:[resultSet stringForColumn:propertyname] forKey:propertyname];
                
            }
            [param setObject:[resultSet stringForColumn:@"primaryID"] forKey:@"primaryID"];
            [params addObject:[[self class] yy_modelWithJSON:param]];
        }
        
    }
    
    [database close];
    
    return [params copy];
}

+ (BOOL)deleteAllObject
{
    return [[self class] deleteObjectPredicateWithFormat:nil];
}

+ (BOOL)deleteObjectPredicateWithFormat:(NSString *)format
{
    if ([format length] != 0) {
        return [FIDDataBaseModel executeUpdateWithSqlstatement:[NSString stringWithFormat:@"delete from `%@` %@",[[self class] getTableName],format]];
    }else{
        return [FIDDataBaseModel executeUpdateWithSqlstatement:[NSString stringWithFormat:@"delete from `%@`",[[self class] getTableName]]];
    }
    
}

- (BOOL)insertObject
{
    NSString *keys = [NSString string];
    NSString *values = [NSString string];
    for (NSInteger index = 0; index < [[[self class]propertyOfSelf]count]; index++) {
        NSString *propertyname = [[self class]propertyOfSelf][index];
        if (index == 0) {
            keys = [NSString stringWithFormat:@"%@'%@'",keys,propertyname];
            values = [NSString stringWithFormat:@"%@'%@'",values,[self getIvarWithName:propertyname]];
            continue;
        }
        keys = [NSString stringWithFormat:@"%@,'%@'",keys,propertyname];
        values = [NSString stringWithFormat:@"%@,'%@'",values,[self getIvarWithName:propertyname]];
    }
    return [FIDDataBaseModel executeUpdateWithSqlstatement:[NSString stringWithFormat:@"insert into `%@` (%@) values(%@) ",[[self class] getTableName],keys,values]];
}

- (BOOL)updateObject{
    NSString *values = [NSString string];
    for (NSInteger index = 0; index < [[[self class]propertyOfSelf]count]; index++) {
        NSString *propertyname = [[self class]propertyOfSelf][index];
        if (index == 0) {
            
            values = [NSString stringWithFormat:@"%@%@='%@'",values,propertyname,[self getIvarWithName:propertyname]];
            continue;
        }
        
        values = [NSString stringWithFormat:@"%@,%@='%@'",values,propertyname,[self getIvarWithName:propertyname]];
    }
    
    return [FIDDataBaseModel executeUpdateWithSqlstatement:[NSString stringWithFormat:@"update `%@` set  %@ where %@",[[self class] getTableName],values,self.primaryID]];
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
    BOOL update;
    if ([database open]) {
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
    NSString *tableKey = [NSString string];
    for (NSInteger index = 0; index < [[[self class]propertyOfSelf]count]; index++) {
        NSString *propertyname = [[self class]propertyOfSelf][index];
        if (index == 0) {
            tableKey = [NSString stringWithFormat:@"%@%@ text",tableKey,propertyname];
            continue;
        }
        tableKey = [NSString stringWithFormat:@"%@,%@ text",tableKey,propertyname];
    }
    [FIDDataBaseModel executeUpdateWithSqlstatement:[NSString stringWithFormat:@"create table if  not exists `%@%@` (primaryID integer PRIMARY KEY AUTOINCREMENT,%@)",kDatabaseHeadname,NSStringFromClass([self class]),tableKey]];
    [[self class]alertColumn];
    return [NSString stringWithFormat:@"%@%@",kDatabaseHeadname,NSStringFromClass([self class])];
}



/**
 添加新的字段
 */
+ (void)alertColumn{
    NSString *tablename = [NSString stringWithFormat:@"%@%@",kDatabaseHeadname,NSStringFromClass([self class])];
    FMDatabase *database = [FIDDataBaseModel getDatabase];
    if ([database open]) {
        for (NSString *propertyname in [[self class]propertyOfSelf]) {
            if (![database columnExists:propertyname inTableWithName:tablename]) {
                [[self class]executeUpdateWithSqlstatement:[NSString stringWithFormat:@"alter table `%@` add %@ text",tablename,propertyname]];
            }
        }
    }
    [database close];
}

- (id)getIvarWithName:(NSString *)propertyname{
    id obj = [self sendGetMethodWithPropertyName:propertyname];
    
    if ([obj respondsToSelector:@selector(length)]) {
        if ([obj length] == 0) {
            obj = @"";
        }
    }else if (obj == nil){
        obj = @"";
    };
    return obj;
}


@end


