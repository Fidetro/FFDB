//
//  FIDDataBaseModel.h
//  FFDB
//
//  Created by Fidetro on 2017/3/22.
//  Copyright © 2017年 Fidetro. All rights reserved.
//
//  https://github.com/Fidetro/FFDB

#import <Foundation/Foundation.h>
#import <FMDB/FMDB.h>
#import "FFDBManager.h"


extern NSString *const kDatabaseHeadname;


@interface FFDataBaseModel : NSObject
///** primary id,use to update **/
//@property(nonatomic,strong,readonly) NSString *primaryID;

/**
 select all object from class
 
 @return class objects
 */
+ (NSArray <__kindof FFDataBaseModel *>*)selectFromClassAllObject;

/**
 select object by format
 
 @param format Like sqlstatement rule, example: where name = 'fidetro' and age = '21'
 @return class objects
 */
+ (NSArray <__kindof FFDataBaseModel *>*)selectFromClassWhereFormat:(NSString *)format
                                                             values:(NSArray <id>*)values;



/**
 select object by format extra
 
 exmaple: [TestModel selectFromClassWhereFormat:nil orderBy:@"time desc" limit:@"2" offset:@"2" values:nil];
 
 @return class objects
 */
+ (NSArray <__kindof FFDataBaseModel *>*)selectFromClassWhereFormat:(NSString *)whereFormat
                                                            orderBy:(NSString *)orderBy
                                                              limit:(NSString *)limit
                                                             offset:(NSString *)offset
                                                             values:(NSArray <id>*)values;


/**
 delete object
 @return delete successfully
 */
- (BOOL)deleteObject;

/**
 delete all object from class
 
 @return delete successfully
 */
+ (BOOL)deleteFromClassAllObject;


/**
 delete object by format
 
 @param whereFormat Like sqlstatement rule,  example: name = 'fidetro' and age = '21'
 @param values values of columns
 @return delete successfully
 */
+ (BOOL)deleteFromClassWhereFormat:(NSString *)whereFormat
                            values:(NSArray <id>*)values;

/**
 insert object
 
 @return insert successfully
 */
- (BOOL)insertObject;

/**
 update object for all columns
 @return update successfully
 */
- (BOOL)updateObject;

/**
 update object by columns
 
 @param columns Need to update columns
 @param db set database when use SafeOperation or Transaction,it should be alway nil
 @return update successfully
 */
- (BOOL)updateObjectByCloumns:(NSArray *)columns db:(FMDatabase *)db;

/**
 update object by format

 @param setColumns columns
 @param whereFormat Like sqlstatement rule, example: name = 'fidetro' and age = '21'
 @param values values of columns
 @return update successfully
 */
+ (BOOL)updateFromClassSet:(NSArray <NSString *>*)setColumns
                     where:(NSString *)whereFormat
                    values:(NSArray <id>*)values;



- (BOOL)insertObject:(FMDatabase *)db;
- (BOOL)deleteObject:(FMDatabase *)db;
- (BOOL)updateObject:(FMDatabase *)db;



@end
