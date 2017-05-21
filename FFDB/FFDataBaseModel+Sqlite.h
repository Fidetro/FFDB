//
//  FFDataBaseModel+Sqlite.h
//  FFDB
//
//  Created by Fidetro on 2017/5/11.
//  Copyright © 2017年 Fidetro. All rights reserved.
//
//  https://github.com/Fidetro/FFDB

#import "FFDataBaseModel.h"

@interface FFDataBaseModel (Sqlite)


/**
 创建表的SQL语句

 @return 返回SQL语句
 */
+ (NSString *)createTableSqlstatement;

/**
 查询SQL语句

 @param format 查询规则
 @return 返回SQL语句
 */
+ (NSString *)selectObjectSqlstatementWithFormat:(NSString *)format;

/**
 插入对象的所有属性的SQL语句

 @return 返回SQL语句
 */
- (NSString *)insertObjectSqlstatement;

/**
 根据字段更新对象的SQL语句

 @param columns 更新的字段
 @return 返回SQL语句
 */
- (NSString *)updateObjectSqlStatementWithColumns:(NSArray <NSString *>*)columns;

/**
 根据对象的所有属性生成SQL语句

 @return 返回SQL语句
 */
- (NSString *)deleteObjectSqlstatement;

/**
 根据规则删除SQL语句

 @param format 删除规则
 @return 返回SQL语句
 */
+ (NSString *)deleteObjectSqlstatementWithFormat:(NSString *)format;


@end
