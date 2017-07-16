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
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)insertTestModel
{
    TestModel *testModel = [[TestModel alloc]init];
    testModel.name = @"hello";
    testModel.memory = @"is me";
    testModel.time = [NSDate date].timeIntervalSince1970;
    [testModel insertObject];
    NSArray *testArray = [TestModel selectFromClassPredicateWithFormat:@"where name = 'hello'"];
    XCTAssertTrue(testArray.count > 0,@"insert error");
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
