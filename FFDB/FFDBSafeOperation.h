//
//  FFDBSafeOperation.h
//  FFDB
//
//  Created by Fidetro on 2017/5/15.
//  Copyright © 2017年 Fidetro. All rights reserved.
//
//  https://github.com/Fidetro/FFDB

#import <Foundation/Foundation.h>
#import "FMDatabase+FFExtern.h"
@class FFDataBaseModel;
@interface FFDBSafeOperation : NSObject


/**
 select all object

 @param dbClass  by class
 */
+ (void)selectAllObjectFromClass:(Class)dbClass
                      completion:(QueryResult)block;

/**
 select object by format

 @param dbClass query dbClass
 @param columns query columns
 @param whereFormat Like sqlstatement rule, example: name = 'fidetro' and age = '21'
 @param toClass return to class
 @param values values of columns
 */
+ (void)selectFromClass:(Class)dbClass
                columns:(NSArray <NSString *>*)columns
                  where:(NSString *)whereFormat
                 values:(NSArray <id>*)values
                toClass:(Class)toClass
             completion:(QueryResult)block;

/**
 insert object
 
 @param objectList Need to insert the array of objects
 */
+ (void)insertObjectList:(NSArray <__kindof FFDataBaseModel *>*)objectList
              completion:(UpdateResult)block;

/**
 insertObject by columns
 
 @param table need insert table class
 @param columns insert Columns,if nil,then will be insert model all property
 @param values values of columns
 */
+ (void)insertTable:(Class)table
            columns:(NSArray <NSString *>*)columns
             values:(NSArray <id>*)values
         completion:(UpdateResult)block;

/**
 update object
 
 @param objectList Need to update the array of objects
 */
+ (void)updateObjectList:(NSArray<__kindof FFDataBaseModel *> *)objectList
              completion:(UpdateResult)block;

/**
 Update dbClass
 
 @param dbClass need update dbClass
 @param setColumns columns
 @param whereFormat Like sqlstatement rule, example: name = 'fidetro' and age = '21'
 @param values values of columns
 */
+ (void)updateFromClass:(Class)dbClass
                    set:(NSArray <NSString *>*)setColumns
                  where:(NSString *)whereFormat
                 values:(NSArray <id>*)values
             completion:(UpdateResult)block;

/**
 delete object
 
 @param objectList Need to delete the array of objects
 */
+ (void)deleteObjectList:(NSArray<__kindof FFDataBaseModel *> *)objectList
              completion:(UpdateResult)block;


/**
 delete all object from class
 
 @param dbClass delete dbClass
 @param whereFormat Like sqlstatement rule, example: name = 'fidetro' and age = '21'
 @param values values of columns
 */
+ (void)deleteFromClass:(Class)dbClass
                  where:(NSString *)whereFormat
                 values:(NSArray <id>*)values
             completion:(UpdateResult)block;


@end
