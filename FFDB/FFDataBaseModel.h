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
/** primary id,use to update **/
@property(nonatomic,strong,readonly) NSString *primaryID;

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
+ (NSArray <__kindof FFDataBaseModel *>*)selectFromClassPredicateWithFormat:(NSString *)format;

/**
 delete all object from class
 
 @return delete successfully
 */
+ (BOOL)deleteFromClassAllObject;

/**
 delete object

 @return delete successfully
 */
- (BOOL)deleteObject;

/**
 delete object by format
 
 @param format Like sqlstatement rule,  example: where name = 'fidetro' and age = '21'
 @return delete successfully
 */
+ (BOOL)deleteFromClassPredicateWithFormat:(NSString *)format;

/**
 insert object
 
 @return insert successfully
 */
- (BOOL)insertObject;

/**
 update object by format

 @param format Like sqlstatement rule,  example: set age = '24' where name = 'fidetro'
 @return update successfully
 */
+ (BOOL)updateFromClassPredicateWithFormat:(NSString *)format;

/**
 update object for all columns

 @return update successfully
 */
- (BOOL)updateObject;
/**
 update object by columns
 
 @param columns Need to update columns
 @return update successfully
 */
- (BOOL)updateObjectSetColumns:(NSArray *)columns;

/**
 find primaryID will update object,if not insert
 */
- (BOOL)upsert;


/**
 find columns will update object,if not insert
 */
- (BOOL)upsertWithColumns:(NSArray *)columns;






/**
 update object by KVO
 
 @param update_block You can set object property into update_block
 */
- (void)updateObjectWithBlock:(void(^)())update_block;







@end
