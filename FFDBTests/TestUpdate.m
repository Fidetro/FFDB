//
//  TestUpdate.m
//  FFDBTests
//
//  Created by Fidetro on 2018/6/11.
//  Copyright © 2018年 Fidetro. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "FFDB.h"
#import "TestModel.h"
@interface TestUpdate : XCTestCase

@end

@implementation TestUpdate

- (void)testUpdate1
{
    NSString *stmt1 = Update.begin([TestModel class]).set(@"name = ?").stmt;
    NSString *stmt2 = @"update FFTestModel set name = ? ";
    if (![stmt1 isEqualToString:stmt2])
    {
        NSLog(@"%@",stmt1);
        NSLog(@"%@",stmt2);
        assert(false);
    }
}

- (void)testUpdate2
{
    NSString *stmt1 = Update.begin([TestModel class]).set(@"name = ?").where(@"name = ?").stmt;
    NSString *stmt2 = @"update FFTestModel set name = ? where name = ? ";
    if (![stmt1 isEqualToString:stmt2])
    {
        NSLog(@"%@",stmt1);
        NSLog(@"%@",stmt2);
        assert(false);
    }
}

- (void)testUpdate3
{
    NSString *stmt1 = Update.begin([TestModel class]).set(@[@"name",@"time"]).stmt;
    NSString *stmt2 = @"update FFTestModel set name=?,time=? ";
    if (![stmt1 isEqualToString:stmt2])
    {
        NSLog(@"%@",stmt1);
        NSLog(@"%@",stmt2);
        assert(false);
    }
}

- (void)testUpdate4
{
    NSString *stmt1 = Update.begin([TestModel class]).set(@[@"name",@"time"]).where(@"name = ?").stmt;
    NSString *stmt2 = @"update FFTestModel set name=?,time=? where name = ? ";
    if (![stmt1 isEqualToString:stmt2])
    {
        NSLog(@"%@",stmt1);
        NSLog(@"%@",stmt2);
        assert(false);
    }
}

- (void)testUpdate5
{
    NSString *stmt1 = Update.begin(@"TestModel").set(@[@"name",@"time"]).where(@"name = ?").stmt;
    NSString *stmt2 = @"update TestModel set name=?,time=? where name = ? ";
    if (![stmt1 isEqualToString:stmt2])
    {
        NSLog(@"%@",stmt1);
        NSLog(@"%@",stmt2);
        assert(false);
    }
}

@end
