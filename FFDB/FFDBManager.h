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
 insertObject by columns
 
 @param model need insert model
 @param columns insert Columns,if nil,then will be insert model all property
 @param values values of columns
 @param db set database when use SafeOperation or Transaction,it should be alway nil
 @return isSuccess
 */
+ (BOOL)insertObject:(__kindof FFDataBaseModel *)model
             columns:(NSArray <NSString *>*)columns
              values:(NSArray <id>*)values
                  db:(FMDatabase *)db;
/**
 insertObject by columns
 
 @param table need insert table class
 @param columns insert Columns,if nil,then will be insert model all property
 @param values values of columns
 @param db set database when use SafeOperation or Transaction,it should be alway nil
 @return isSuccess
 */
+ (BOOL)insertTable:(Class)table
            columns:(NSArray <NSString *>*)columns
             values:(NSArray <id>*)values
                 db:(FMDatabase *)db;

/**
 select object by params
 
 @param dbClass query dbClass
 @param columns query columns
 @param whereFormat Like sqlstatement rule, example: name = 'fidetro' and age = '21'
 @param toClass return to class
 @param values values of columns
 @param db set database when use SafeOperation or Transaction,it should be alway nil
 @return class objects
 */
+ (NSArray *)selectFromClass:(Class)dbClass
                     columns:(NSArray <NSString *>*)columns
                       where:(NSString *)whereFormat
                      values:(NSArray <id>*)values
                     toClass:(Class)toClass
                          db:(FMDatabase *)db;





/**
 delete all object from class
 
 @param dbClass delete dbClass
 @param whereFormat Like sqlstatement rule, example: name = 'fidetro' and age = '21'
 @param values values of columns
 @param db set database when use SafeOperation or Transaction,it should be alway nil
 @return isSuccess
 */
+ (BOOL)deleteFromClass:(Class)dbClass
                  where:(NSString *)whereFormat
                 values:(NSArray <id>*)values
                     db:(FMDatabase *)db;



/**
 Update dbClass
 
 @param dbClass need update dbClass
 @param setColumns columns
 @param whereFormat Like sqlstatement rule, example: name = 'fidetro' and age = '21'
 @param values values of columns
 @param db set database when use SafeOperation or Transaction,it should be alway nil
 @return isSuccess
 */
+ (BOOL)updateFromClass:(Class)dbClass
                    set:(NSArray <NSString *>*)setColumns
                  where:(NSString *)whereFormat
                 values:(NSArray <id>*)values
                     db:(FMDatabase *)db;






/**
 alert new columns to dbClass
 
 @param dbClass dbClass
 */
+ (void)alterFromClass:(Class)dbClass;

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
