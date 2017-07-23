//
//  SQLFormatTests.m
//  FFDBTests
//
//  Created by Fidetro on 2017/7/23.
//  Copyright © 2017年 Fidetro. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSString+FFDBExtern.h"
#import "NSString+FFDBSQLStatement.h"
#import "FFDBLog.h"
#import "TestModel.h"
#import "ClassRoom.h"
@interface SQLFormatTests : XCTestCase

@end

@implementation SQLFormatTests


- (void)testColumnsString
{
    FFDBDLog(@"%@",[NSString stringWithColumns:@[@"one"]]);
    FFDBDLog(@"%@",[NSString stringWithColumns:@[@"one",@"two"]]);
    
}
- (void)testTableNameOfClassesString
{
    FFDBDLog(@"%@",[NSString stringWithTableNameOfClasses:@[[ClassRoom class]]]);
    FFDBDLog(@"%@",[NSString stringWithTableNameOfClasses:@[[ClassRoom class],[TestModel class]]]);
}

- (void)testSelectStatement
{
    FFDBDLog(@"%@",[NSString stringWithSelectColumns:nil fromClasses:@[[ClassRoom class]] SQLStatementWithFormat:nil])
    FFDBDLog(@"%@",[NSString stringWithSelectColumns:nil fromClasses:@[[ClassRoom class]] SQLStatementWithFormat:@"where name = 'fidetro'"])
}

- (void)testDeleteStatement
{
    FFDBDLog(@"%@",[NSString stringWithDeleteFromClass:[ClassRoom class] SQLStatementWithFormat:nil])
    FFDBDLog(@"%@",[NSString stringWithDeleteFromClass:[ClassRoom class] SQLStatementWithFormat:@"where name = 'fidetro'"])
}

- (void)testInsertStatement
{
    TestModel *model = [[TestModel alloc]init];
    model.name = @"名字";
    FFDBDLog(@"%@",[NSString stringWithInsertObject:model columns:nil])
    FFDBDLog(@"%@",[NSString stringWithInsertObject:model columns:@[@"name"]])
    FFDBDLog(@"%@",[NSString stringWithInsertObject:model columns:@[@"time"]])
}

- (void)testUpdateStatement
{
    
}

- (void)setUp {
    [super setUp];
    
}

- (void)tearDown {
    
    [super tearDown];
}


@end
