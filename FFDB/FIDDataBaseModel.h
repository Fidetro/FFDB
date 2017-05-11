//
//  FIDDataBaseModel.h
//  FFDB
//
//  Created by Fidetro on 2017/3/22.
//  Copyright © 2017年 Fidetro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDB/FMDB.h>
#import "FFDBManager.h"
#import "NSObject+FIDProperty.h"
//#import "FMDatabase+FFExtern.h"

@interface FIDDataBaseModel : NSObject
/** 主键id，作为更新的索引，不可以修改 **/
@property(nonatomic,strong,readonly) NSString *primaryID;

/**
 查询子类所有对象
 
 @return 返回子类保存的所有对象
 */
+ (NSArray *)selectAllObject;

/**
 根据规则查询
 
 @param format 规则 example: where name = 'fidetro' and age = '21'
 @return 返回子类符合规则的对象
 */
+ (NSArray *)selectObjectPredicateWithFormat:(NSString *)format;

/**
 删除所有对象
 
 @return 返回是否成功
 */
+ (BOOL)deleteAllObject;

/**
 删除对象

 @return 返回是否成功
 */
- (BOOL)deleteObject;

/**
 根据规则删除对象
 
 @param format 规则 example: where name = 'fidetro' and age = '21'
 @return 是否成功
 */
+ (BOOL)deleteObjectPredicateWithFormat:(NSString *)format;


/**
 插入对象
 
 @return 返回是否成功
 */
- (BOOL)insertObject;


/**
 根据规则更新对象

 @param format 规则 example: set age = '24' where name = 'fidetro'
 @return 返回是否成功
 */
+ (BOOL)updateObjectPredicateWithFormat:(NSString *)format;
/**
 更新对象

 @return 返回是否成功
 */
- (BOOL)updateObject;


/**
 根据字段更新

 @param columns 需要更新的字段
 @return 返回是否成功
 */
- (BOOL)updateObjectWithColumns:(NSArray *)columns;


/**
 更新对象，相对于updateObject效率会更高

 @param update_block 在block中写需要更新的属性
 */
- (void)updateObjectWithBlock:(void(^)())update_block;

/**
 获取FMDatabase对象
 
 @return FMDatabase对象
 */
+ (FMDatabase *)getDatabase;

/**
 获取类在FMDB对应的表名
 
 @return 表名
 */
+ (NSString *)getTableName;


@end
