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
 CREATE TABLE SQL statement

 @return SQL statement String
 */
+ (NSString *)createTableSqlstatement;

/**
 SELECT SQL statement

 @param format Select * from rule
 @return SQL statement String
 */
+ (NSString *)selectFromClassSQLStatementWithFormat:(NSString *)format;


/**
 INSERT SQL statement by colums
 
 @param columns Need to insert colums
 @return SQL statement String
 */
- (NSString *)insertFromClassSQLStatementWithColumns:(NSArray <NSString *>*)columns;

/**
 UPDATE SQL statement by colums

 @param columns Need to update colums
 @return SQL statement String
 */
- (NSString *)updateFromClassSQLStatementWithColumns:(NSArray <NSString *>*)columns;

/**
 DELETE SQL statement String

 @return SQL statement String
 */
- (NSString *)deleteObjectSqlstatement;

/**
 DELETE SQL statement String

 @param format Delete rule
 @return SQL statement String
 */
+ (NSString *)deleteFromSQLStatementWithFormat:(NSString *)format;




- (NSString *)stringWithInsertValueOfColumns:(NSArray <NSString *>*)columns;

- (NSString *)stringWithUpdateSetValueOfColumns:(NSArray <NSString *>*)columns;

@end
