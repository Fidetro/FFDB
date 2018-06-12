//
//  FFDBCustomTests.m
//  FFDBTests
//
//  Created by Fidetro on 2018/6/12.
//  Copyright © 2018年 Fidetro. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CustomModel.h"
#import "FFDBSafeOperation.h"
#import "FFDBTransaction.h"
@interface FFDBCustomTests : XCTestCase

@end

@implementation FFDBCustomTests

- (void)testModel
{
    CustomModel *testModel1 = [[CustomModel alloc]init];
    testModel1._name = @"hello";
    testModel1.mem = @"is me";
    testModel1._id = @"1123";
    [testModel1 insertObject];
    CustomModel *testModel2 = [[CustomModel alloc]init];
    testModel2._name = @"test2";
    [testModel2 insertObject];
    CustomModel *testModel3 = [[CustomModel alloc]init];
    testModel3._name = @"test3";
    [testModel3 insertObject];
    NSArray *array1 = [CustomModel selectFromClassAllObject];
    XCTAssertTrue(array1.count == 3);
    NSArray *array2 = [CustomModel selectFromClassWhereFormat:@"name = ?" values:@[@"hello"]];
    CustomModel *dbModel = [array2 lastObject];
    XCTAssertTrue(array2.count == 1&&[dbModel._name isEqualToString:@"hello"]&&(dbModel.memory.length == 0)&&([dbModel._id isEqualToString:@"1123"]);
    dbModel.name = @"test1";
    XCTAssertTrue([dbModel updateObject]);
    NSArray *array3 = [CustomModel selectFromClassWhereFormat:@"name = ?" values:@[@"test1"]];
    CustomModel *dbTModel = [array3 lastObject];
    XCTAssertTrue(array3.count == 1&&[dbTModel._name isEqualToString:@"test1"]&&(dbTModel.memory.length == 0)&&([dbModel._id isEqualToString:@"1123"]));
    XCTAssertTrue([CustomModel deleteFromClassWhereFormat:@"name = ?" values:@[@"test2"]]);
    XCTAssertTrue([CustomModel selectFromClassWhereFormat:@"name = ?" values:@[@"test2"]].count == 0);
    XCTAssertTrue([CustomModel deleteFromClassAllObject]);
    XCTAssertTrue([CustomModel selectFromClassAllObject].count == 0);
}

@end
