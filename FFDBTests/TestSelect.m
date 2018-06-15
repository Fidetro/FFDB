//
//  TestSelect.m
//  FFDBTests
//
//  Created by Fidetro on 2018/6/12.
//  Copyright © 2018年 Fidetro. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Select.h"
#import "TestModel.h"
@interface TestSelect : XCTestCase

@end

@implementation TestSelect

- (void)testSelect1
{
    NSString *stmt1 = Select.begin(@"*").from([TestModel class]).stmt;
    NSString *stmt2 = @"select * from FFTestModel ";
    if (![stmt1 isEqualToString:stmt2])
    {
        NSLog(@"%@",stmt1);
        NSLog(@"%@",stmt2);
        assert(false);
    }
}

- (void)testSelect2
{
    NSString *stmt1 = Select.begin(@"*").from([TestModel class]).where(@"name = ?").stmt;
    NSString *stmt2 = @"select * from FFTestModel where name = ? ";
    if (![stmt1 isEqualToString:stmt2])
    {
        NSLog(@"%@",stmt1);
        NSLog(@"%@",stmt2);
        assert(false);
    }
}

- (void)testSelect3
{
    NSString *stmt1 = Select.begin(@"*").from([TestModel class]).where(@"name = ?").limit(@"1").stmt;
    NSString *stmt2 = @"select * from FFTestModel where name = ? limit 1 ";
    if (![stmt1 isEqualToString:stmt2])
    {
        NSLog(@"%@",stmt1);
        NSLog(@"%@",stmt2);
        assert(false);
    }
}

- (void)testSelect4
{
    NSString *stmt1 = Select.begin(@"*").from([TestModel class]).where(@"name = ?").limit(@"1").offset(@"2").stmt;
    NSString *stmt2 = @"select * from FFTestModel where name = ? limit 1 offset 2 ";
    if (![stmt1 isEqualToString:stmt2])
    {
        NSLog(@"%@",stmt1);
        NSLog(@"%@",stmt2);
        assert(false);
    }
}

- (void)testSelect5
{
    NSString *stmt1 = Select.begin(@[@"testKey",@"name"]).from([TestModel class]).where(@"name = ?").limit(@"1").offset(@"2").stmt;
    NSString *stmt2 = @"select (testKey,name) from FFTestModel where name = ? limit 1 offset 2 ";
    if (![stmt1 isEqualToString:stmt2])
    {
        NSLog(@"%@",stmt1);
        NSLog(@"%@",stmt2);
        assert(false);
    }
}

- (void)testSelect6
{
    NSString *stmt1 = Select.begin(@[@"testKey",@"name"]).from(@"TestModel").where(@"name = ?").limit(@"1").offset(@"2").stmt;
    NSString *stmt2 = @"select (testKey,name) from TestModel where name = ? limit 1 offset 2 ";
    if (![stmt1 isEqualToString:stmt2])
    {
        NSLog(@"%@",stmt1);
        NSLog(@"%@",stmt2);
        assert(false);
    }
}

@end
