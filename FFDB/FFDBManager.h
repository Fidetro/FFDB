//
//  FFDBManager.h
//  FFDB
//
//  Created by Fidetro on 2017/5/11.
//  Copyright © 2017年 Fidetro. All rights reserved.
//
//  https://github.com/Fidetro/FFDB

#import <Foundation/Foundation.h>
#import <FMDB/FMDB.h>


@class FFDataBaseModel;
@interface FFDBManager : NSObject

/**
 select object by params
 
 @param columns query columns
 @param dbClass query dbClass
 @param format Like sqlstatement rule, example: where name = 'fidetro' and age = '21'
 @return class objects
 */
+ (NSArray <__kindof FFDataBaseModel *>*)selectColumns:(NSArray <NSString *>*)columns
                 fromClass:(Class)dbClass
    SQLStatementWithFormat:(NSString *)format;

+ (long long int)selectCountfromClasses:(NSArray <Class>*)dbClasses
                 SQLStatementWithFormat:(NSString *)format;

/**
 Contingency query
 
 @param columns query columns ,if nil,then will be query toClass all property
 @param dbClasses query dbClass
 @param toClass return this class Objects
 @param format Like sqlstatement rule, example: where name = 'fidetro' and age = '21'
 @return toClass Array
 */
+ (NSArray <__kindof FFDataBaseModel *>*)selectColumns:(NSArray <NSString *>*)columns
                                           fromClasses:(NSArray <Class>*)dbClasses
                                               toClass:(Class)toClass
                                SQLStatementWithFormat:(NSString *)format;



/**
 delete all object from class
 
 @param dbClass delete dbClass
 @param format Like sqlstatement rule, example: where name = 'fidetro' and age = '21'
 @return isSuccess
 */
+ (BOOL)deleteFromClass:(Class)dbClass
 SQLStatementWithFormat:(NSString *)format;


/**
 insertObject by columns
 
 @param model need insert model
 @param columns insert Columns,if nil,then will be insert model all property
 @return isSuccess
 */
+ (BOOL)insertObject:(__kindof FFDataBaseModel *)model
             columns:(NSArray <NSString *>*)columns;


/**
 Update dbClass
 
 @param dbClass need update dbClass
 @param format Like sqlstatement rule, example: where name = 'fidetro' and age = '21'
 @return isSuccess
 */
+ (BOOL)updateFromClass:(Class)dbClass
 SQLStatementWithFormat:(NSString *)format;


/**
 update object by columns
 
 @param model need update model
 @param columns update columns,if nil,then will be update model all property
 @return isSuccess
 */
+ (BOOL)updateObject:(__kindof FFDataBaseModel *)model
             columns:(NSArray <NSString *>*)columns;


/**
 custom query SQL

 @param toClass return toClass Object
 @param format SQL statement exmaple:select * from person
 @return return this class Objects
 */
+ (NSArray <__kindof FFDataBaseModel *>*)selectDBToClass:(Class)toClass
                                  SQLStatementWithFormat:(NSString *)format;

/**
 custom update

 @param format SQL statement
 @return isSuccess
 */
+ (BOOL)updateDBWithSQLStatementWithFormat:(NSString *)format;

/**
 alert new columns to dbClass
 
 @param dbClass dbClass
 @param columns alert columns
 */
+ (void)alterFromClass:(Class)dbClass
               columns:(NSArray <NSString *>*)columns;

/**
 then will be create Table by Class property
 
 @param dbClass dbClass
 @return isSuccess
 */
+ (BOOL)createTableFromClass:(Class)dbClass;


/**
 FFDB databasePath
 */
+ (NSString *)databasePath;

/**
 FMDatabase object
 */
+ (FMDatabase *)database;



@end
