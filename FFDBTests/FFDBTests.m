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
#import "CustomModel.h"
#import "FFDBSafeOperation.h"
#import "FFDBTransaction.h"
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
    testModel.testUint = 223;
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


- (void)testCustom
{
    [CustomModel deleteFromClassPredicateWithFormat:@"where id = '77'"];
    NSArray *customCount = [CustomModel selectFromClassAllObject];
    XCTAssert(customCount.count == 0,@"删除出错");
    
    CustomModel *custom = [[CustomModel alloc]init];
    custom._id = @"66";
    custom.mem = @"66";
    [custom insertObject];
    NSArray *customArray = [CustomModel selectFromClassPredicateWithFormat:@"where id = '66'"];
    XCTAssert(customArray.count != 0,@"插入出错");
    for (CustomModel *custom in customArray) {
        XCTAssertTrue([custom._id isEqualToString:@"66"],@"is ture");
        XCTAssertTrue([custom.mem length] == 0,@"is ture");
        custom._id = @"77";
        custom.mem = @"77";
        [custom updateObject];
    }
   NSArray *sevenArray = [CustomModel selectFromClassPredicateWithFormat:@"where id = '77'"];
    XCTAssert(sevenArray.count != 0,@"更新出错");
    for (CustomModel *custom in sevenArray) {
        XCTAssertTrue([custom._id isEqualToString:@"77"],@"is ture");
        XCTAssertTrue([custom.mem length] == 0,@"is ture");
        
    }
    
}

- (void)testTransaction
{
    [FFDBTransaction deleteObjectWithFFDBClass:[CustomModel class] format:@"where id = '77'" isRollBack:YES];
    
    NSArray *customCount = [FFDBTransaction selectObjectWithFFDBClass:[CustomModel class]];;
    XCTAssert(customCount.count == 0,@"删除出错");
    
    CustomModel *custom = [[CustomModel alloc]init];
    custom._id = @"66";
    custom.mem = @"66";
    [FFDBTransaction insertObjectList:@[custom] isRollBack:YES];
    NSArray *customArray = [FFDBTransaction selectObjectWithFFDBClass:[CustomModel class] format:@"where id = '66'"];
    
    XCTAssert(customArray.count != 0,@"插入出错");
    for (CustomModel *custom in customArray) {
        XCTAssertTrue([custom._id isEqualToString:@"66"],@"is ture");
        XCTAssertTrue([custom.mem length] == 0,@"is ture");
        custom._id = @"77";
        custom.mem = @"77";
        [FFDBTransaction updateObjectList:@[custom] isRollBack:YES];
    }
    
    NSArray *sevenArray = [FFDBTransaction selectObjectWithFFDBClass:[CustomModel class] format:@"where id = '77'"];;
    XCTAssert(sevenArray.count != 0,@"更新出错");
    for (CustomModel *custom in sevenArray) {
        XCTAssertTrue([custom._id isEqualToString:@"77"],@"is ture");
        XCTAssertTrue([custom.mem length] == 0,@"is ture");
        
    }
}

- (void)testSafe
{
    [FFDBSafeOperation deleteObjectWithFFDBClass:[CustomModel class] format:@"where id = '77'"];
    NSArray *customCount = [FFDBSafeOperation selectObjectWithFFDBClass:[CustomModel class]];;
    XCTAssert(customCount.count == 0,@"删除出错");
    CustomModel *custom = [[CustomModel alloc]init];
    custom._id = @"66";
    custom.mem = @"66";
    [FFDBSafeOperation insertObjectList:@[custom]];
    NSArray *customArray = [FFDBSafeOperation selectObjectWithFFDBClass:[CustomModel class] format:@"where id = '66'"];
    XCTAssert(customArray.count != 0,@"插入出错");
    for (CustomModel *custom in customArray) {
        XCTAssertTrue([custom._id isEqualToString:@"66"],@"is ture");
        XCTAssertTrue([custom.mem length] == 0,@"is ture");
        custom._id = @"77";
        custom.mem = @"77";
        [FFDBSafeOperation updateObjectList:@[custom]];
    }
    
    NSArray *sevenArray = [FFDBSafeOperation selectObjectWithFFDBClass:[CustomModel class] format:@"where id = '77'"];;
    XCTAssert(sevenArray.count != 0,@"更新出错");
    for (CustomModel *custom in sevenArray) {
        XCTAssertTrue([custom._id isEqualToString:@"77"],@"is ture");
        XCTAssertTrue([custom.mem length] == 0,@"is ture");
        
    }
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}



@end
