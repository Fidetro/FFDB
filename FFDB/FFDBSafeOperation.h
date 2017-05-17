//
//  FFDBSafeOperation.h
//  FFDB
//
//  Created by Fidetro on 2017/5/15.
//  Copyright © 2017年 Fidetro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FFDataBaseModel+Sqlite.h"
@interface FFDBSafeOperation : NSObject


/**
 查询对象

 @param dbClass 需要查询到类
 @return 返回类保存的所有对象
 */
+ (NSArray *)selectObjectWithFFDBClass:(Class)dbClass;

/**
 根据规则查询对象

 @param dbClass 需要查询到类
 @param format 规则 example: where name = 'fidetro' and age = '21'
 @return 返回类保存的所有对象
 */
+ (NSArray *)selectObjectWithFFDBClass:(Class)dbClass format:(NSString *)format;
/**
 插入对象
 
 @param objectList 需要插入的对象数组
 */
+ (void)insertObjectList:(NSArray <FFDataBaseModel *>*)objectList;
/**
 更新对象
 
 @param objectList 需要更新的对象数组
 */
+ (void)updateObjectList:(NSArray<FFDataBaseModel *> *)objectList;


/**
 根据规则更新对象

 @param dbClass 需要更新的类
 @param format 规则 example: set age = '24' where name = 'fidetro'
 @return 返回是否成功
 */
+ (BOOL)updateObjectWithFFDBClass:(Class)dbClass format:(NSString *)format;

/**
 删除对象
 
 @param objectList 需要删除的对象数组
 */
+ (void)deleteObjectList:(NSArray<FFDataBaseModel *> *)objectList;


/**
 根据规则删除对象

 @param dbClass 需要删除的类
 @param format format 规则 example: where name = 'fidetro' and age = '21'
 @return 返回是否成功
 */
+ (BOOL)deleteObjectWithFFDBClass:(Class)dbClass format:(NSString *)format;

@end
