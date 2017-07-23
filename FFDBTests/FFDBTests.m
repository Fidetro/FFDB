//
//  FFDBTests.m
//  FFDBTests
//
//  Created by Fidetro on 2017/7/16.
//  Copyright © 2017年 Fidetro. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <Foundation/Foundation.h>
#import "TestModel.h"
@interface FFDBTests : XCTestCase

@end

@implementation FFDBTests

- (void)setUp {
    [super setUp];

    
}

- (void)testInsertTestModel {
    TestModel *testModel = [[TestModel alloc]init];
    testModel.name = @"hello";
    testModel.memory = @"is me";
    testModel.time = [NSDate date].timeIntervalSince1970;
    [testModel insertObject];
    NSArray *testArray = [TestModel selectFromClassPredicateWithFormat:@"where name = 'hello'"];
    XCTAssertTrue(testArray.count > 0,@"insert success");
}

- (void)testMemoryColumIsNull
{
        NSArray *testArray = [TestModel selectFromClassPredicateWithFormat:@"where name = 'hello'"];
    for (TestModel *testModel in testArray) {
        XCTAssertTrue([testModel.memory length] == 0,@"is ture");
    }
}


- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}



@end
