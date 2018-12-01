//
//  ReadmeTests.m
//  FFDBTests
//
//  Created by Fidetro on 2018/12/1.
//  Copyright © 2018 Fidetro. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Person.h"
@interface ReadmeTests : XCTestCase

@end

@implementation ReadmeTests

- (void)test
{
    //插入:
    Person *person = [[Person alloc]init];//创建对象
    person.name = @"Fidetro";//设置属性
    [person insertObject];//插入数据
    
    //查询:
    [Person selectFromClassAllObject];//等同于查询Person表中所有的对象
    [Person selectFromClassWhereFormat:@"age = ? and name =  ? " values:@[@"15",@"Fidetro"]];//等同于查询年龄是15和名字叫Fidetro的数据
    //更新：
    NSArray *updatePersonArray = [Person selectFromClassWhereFormat:@" name = ? " values:@[@"Fidetro"]];//先查询到要更新的数据
    Person *lastPerson = [updatePersonArray lastObject];
    assert([lastPerson.name isEqualToString:@"Fidetro"]);
    lastPerson.age = 24;
    [lastPerson updateObject];
    
    //删除:
    NSArray *deletePersonArray = [Person selectFromClassWhereFormat:@"age = ? and name =  ? " values:@[@"24",@"Fidetro"]];//先查询到要删除的数据
    Person *deletePerson = [deletePersonArray lastObject];
    assert(deletePerson.age == 24);
    [deletePerson deleteObject];
}

@end
