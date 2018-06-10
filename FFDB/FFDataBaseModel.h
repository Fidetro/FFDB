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
+ (NSArray <__kindof FFDataBaseModel *>*)selectFromClassPredicateWithFormat:(NSString *)format
                                                                     values:(NSArray <id>*)values;

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
 update object by format

 @param setColumns columns
 @param whereFormat Like sqlstatement rule, example: name = 'fidetro' and age = '21'
 @param values values of columns
 @return update successfully
 */
+ (BOOL)updateFromClassSet:(NSArray <NSString *>*)setColumns
                     where:(NSString *)whereFormat
                    values:(NSArray <id>*)values;





/**
 update object by KVO
 
 @param update_block You can set object property into update_block
 */
- (void)updateObjectWithBlock:(void(^)())update_block;







@end
