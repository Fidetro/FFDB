//
//  TestInsert.m
//  FFDBTests
//
//  Created by Fidetro on 2018/6/11.
//  Copyright © 2018年 Fidetro. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "FFDB.h"
#import "TestModel.h"
@interface TestInsert : XCTestCase

@end

@implementation TestInsert

- (void)testInsert1
{
    NSString *stmt1 = Insert.begin(nil).into([TestModel class]).columns(@[@"name",@"testUint"]).values(@(2)).stmt;
    NSString *stmt2 = @"insert into FFTestModel (name,testUint) values (?,?) ";
    if (![stmt1 isEqualToString:stmt2])
    {
        NSLog(@"%@",stmt1);
        NSLog(@"%@",stmt2);
        assert(false);
    }
}

- (void)testInsert2
{
    NSString *stmt1 = Insert.begin(nil).into(@"TestModel").columns(@[@"name",@"testUint"]).values(@(2)).stmt;
    NSString *stmt2 = @"insert into TestModel (name,testUint) values (?,?) ";
    if (![stmt1 isEqualToString:stmt2])
    {
        NSLog(@"%@",stmt1);
        NSLog(@"%@",stmt2);
        assert(false);
    }
}

- (void)testInsert3
{
    NSString *stmt1 = Insert.begin(nil).into(@"TestModel").columns(@[@"name",@"testUint"]).values(@"(?,?)").stmt;
    NSString *stmt2 = @"insert into TestModel (name,testUint) values (?,?) ";
    if (![stmt1 isEqualToString:stmt2])
    {
        NSLog(@"%@",stmt1);
        NSLog(@"%@",stmt2);
        assert(false);
    }
}

- (void)testInsert4
{
    NSString *stmt1 = Insert.begin(nil).into(@"TestModel").columns(@"(name,testUint)").values(@(2)).stmt;
    NSString *stmt2 = @"insert into TestModel (name,testUint) values (?,?) ";
    if (![stmt1 isEqualToString:stmt2])
    {
        NSLog(@"%@",stmt1);
        NSLog(@"%@",stmt2);
        assert(false);
    }
}

- (void)testInsert5
{
    NSString *stmt1 = Insert.begin(nil).into(@"TestModel").columns(@"(name,testUint)").values(@"(?,?)").stmt;
    NSString *stmt2 = @"insert into TestModel (name,testUint) values (?,?) ";
    if (![stmt1 isEqualToString:stmt2])
    {
        NSLog(@"%@",stmt1);
        NSLog(@"%@",stmt2);
        assert(false);
    }
}



@end
