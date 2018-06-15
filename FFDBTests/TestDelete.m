//
//  TestDelete.m
//  FFDBTests
//
//  Created by Fidetro on 2018/6/11.
//  Copyright © 2018年 Fidetro. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "FFDB.h"
#import "TestModel.h"
@interface TestDelete : XCTestCase

@end

@implementation TestDelete

- (void)testDelete1
{
    NSString *stmt1 = Delete.begin(nil).from([TestModel class]).stmt;
    NSString *stmt2 = @"delete from FFTestModel ";
    if (![stmt1 isEqualToString:stmt2])
    {
        NSLog(@"%@",stmt1);
        NSLog(@"%@",stmt2);
        assert(false);
    }
}

- (void)testDelete2
{
    NSString *stmt1 = Delete.begin(nil).from([TestModel class]).where(@"name = zhang").stmt;
    NSString *stmt2 = @"delete from FFTestModel where name = zhang ";
    if (![stmt1 isEqualToString:stmt2])
    {
        NSLog(@"%@",stmt1);
        NSLog(@"%@",stmt2);
        assert(false);
    }
}

- (void)testDelete3
{
    NSString *stmt1 = Delete.begin(nil).from(@"TestModel").stmt;
    NSString *stmt2 = @"delete from TestModel ";
    if (![stmt1 isEqualToString:stmt2])
    {
        NSLog(@"%@",stmt1);
        NSLog(@"%@",stmt2);
        assert(false);
    }
}

- (void)testDelete4
{
    NSString *stmt1 = Delete.begin(nil).from(@"TestModel").where(@"name = zhang").stmt;
    NSString *stmt2 = @"delete from TestModel where name = zhang ";
    if (![stmt1 isEqualToString:stmt2])
    {
        NSLog(@"%@",stmt1);
        NSLog(@"%@",stmt2);
        assert(false);
    }
}


@end
