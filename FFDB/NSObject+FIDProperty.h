//
//  NSObject+FIDProperty.h
//  runtimeCategory
//
//  Created by Fidetro on 2016/11/4.
//  Copyright © 2016年 Fidetro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
@interface NSObject (FIDProperty)

/**

 @return 返回所有属性名
 */
+ (NSArray *)propertyOfSelf;

/**
 获取对象所有公开的属性

 @return 返回公开属性对象的数组
 */
- (NSArray *)getPublicObject;

/**
 模型转字典


 @return 返回由对象所有属性组成字典(不含空的属性)
 */
- (NSDictionary *)modelToDictionary;

/**
 模型转字典
 
 
 @return 返回由对象所有属性组成字典(含空的属性)
 */
- (NSDictionary *)modelToDictionaryHaveNilProperty;

/**
 模型转数组
 
 
 @return 返回由对象所有属性组成数组(不含空的属性)
 */
- (NSArray *)modelToArray;

/**
 模型转数组
 
 
 @return 返回由对象所有属性组成数组(含空的属性)
 */
- (NSDictionary *)modelToArrayHaveNilProperty;


/**
 get属性
 
 @param propertyName 属性名
 
 @return 返回属性obj
 */
- (id)sendGetMethodWithPropertyName:(NSString *)propertyName;

/**
 set属性
 
 @param propertyName 属性名
 @param object       obj
 */
- (void)setPropertyWithName:(NSString *)propertyName object:(id)object;

@end
