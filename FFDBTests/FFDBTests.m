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
#import "FFDBSafeOperation.h"
#import "FFDBTransaction.h"
@interface FFDBTests : XCTestCase

@end

@implementation FFDBTests



- (void)testModel
{
    TestModel *testModel1 = [[TestModel alloc]init];
    testModel1.name = @"hello";
    testModel1.memory = @"is me";
    testModel1.time = [NSDate date].timeIntervalSince1970;
    testModel1.testUint = 223;
    [testModel1 insertObject];
    TestModel *testModel2 = [[TestModel alloc]init];
    testModel2.name = @"test2";
    [testModel2 insertObject];
    TestModel *testModel3 = [[TestModel alloc]init];
    testModel3.name = @"test3";
    [testModel3 insertObject];
    NSArray *array1 = [TestModel selectFromClassAllObject];
    XCTAssertTrue(array1.count == 3);
    NSArray *array2 = [TestModel selectFromClassWhereFormat:@"name = ?" values:@[@"hello"]];
    TestModel *dbModel = [array2 lastObject];
    XCTAssertTrue(array2.count == 1&&[dbModel.name isEqualToString:@"hello"]&&(dbModel.memory.length == 0)&&(dbModel.testUint == 223));
    dbModel.name = @"test1";
    XCTAssertTrue([dbModel updateObject]);
    NSArray *array3 = [TestModel selectFromClassWhereFormat:@"name = ?" values:@[@"test1"]];
    TestModel *dbTModel = [array3 lastObject];
    XCTAssertTrue(array3.count == 1&&[dbTModel.name isEqualToString:@"test1"]&&(dbTModel.memory.length == 0)&&(dbTModel.testUint == 223));
    XCTAssertTrue([TestModel deleteFromClassWhereFormat:@"name = ?" values:@[@"test2"]]);
    XCTAssertTrue([TestModel selectFromClassWhereFormat:@"name = ?" values:@[@"test2"]].count == 0);
    XCTAssertTrue([TestModel deleteFromClassAllObject]);
    XCTAssertTrue([TestModel selectFromClassAllObject].count == 0);
}

- (void)testFFDBManager
{
    [TestModel deleteFromClassAllObject];
    [FFDBManager insertTable:[TestModel class] columns:@[@"name",@"testUint"] values:@[@"hello",@(223)] db:nil];
    [FFDBManager insertTable:[TestModel class] columns:@[@"name"] values:@[@"test2"] db:nil];
    [FFDBManager insertTable:[TestModel class] columns:@[@"name"] values:@[@"test3"] db:nil];
    NSArray *array1 = [FFDBManager selectFromClass:[TestModel class] columns:nil where:nil values:nil toClass:nil db:nil];
    XCTAssertTrue(array1.count == 3);
    NSArray *array2 = [FFDBManager selectFromClass:[TestModel class] columns:nil where:@"name = ?" values:@[@"hello"] toClass:nil db:nil];
    TestModel *dbModel = [array2 lastObject];
    XCTAssertTrue(array2.count == 1&&[dbModel.name isEqualToString:@"hello"]&&(dbModel.memory.length == 0)&&(dbModel.testUint == 223));
    BOOL result = [FFDBManager updateFromClass:[TestModel class] set:@[@"name"] where:@"name = ?" values:@[@"test1",@"hello"] db:nil];
    XCTAssertTrue(result);
    NSArray *array3 = [FFDBManager selectFromClass:[TestModel class] columns:nil where:@"name = ?" values:@[@"test1"] toClass:nil db:nil];
    TestModel *dbTModel = [array3 lastObject];
    XCTAssertTrue(array3.count == 1&&[dbTModel.name isEqualToString:@"test1"]&&(dbTModel.memory.length == 0)&&(dbTModel.testUint == 223));
    XCTAssertTrue([FFDBManager deleteFromClass:[TestModel class] where:@"name = ?" values:@[@"test2"] db:nil]);
    XCTAssertTrue([FFDBManager selectFromClass:[TestModel class] columns:nil where:@"name = ?" values:@[@"test2"] toClass:nil db:nil].count == 0);
    XCTAssertTrue([FFDBManager deleteFromClass:[TestModel class] where:nil values:nil db:nil]);
    XCTAssertTrue([FFDBManager selectFromClass:[TestModel class] columns:nil where:nil values:nil toClass:nil db:nil].count == 0);
}

- (void)testFFDBSafe
{
    [TestModel deleteFromClassAllObject];
    TestModel *testModel1 = [[TestModel alloc]init];
    testModel1.name = @"hello";
    testModel1.memory = @"is me";
    testModel1.time = [NSDate date].timeIntervalSince1970;
    testModel1.testUint = 223;
    TestModel *testModel2 = [[TestModel alloc]init];
    testModel2.name = @"test2";
    __block int i = 0;
    [FFDBSafeOperation insertObjectList:@[testModel1,testModel2] completion:^(BOOL result, BOOL isFinal) {
        XCTAssertTrue(result);
        if (i == 0)
        {
            XCTAssertFalse(isFinal);
        }else
        {
            XCTAssertTrue(isFinal);
        }
        i++;
    }];
    [FFDBSafeOperation insertTable:[TestModel class] columns:@[@"name"] values:@[@"test3"] completion:^(BOOL result) {
        XCTAssertTrue(result);
    }];
    [FFDBSafeOperation selectAllObjectFromClass:[TestModel class] completion:^(NSArray *result) {
        XCTAssertTrue(result.count == 3);
    }];
    __block NSArray *array2;
    [FFDBSafeOperation selectFromClass:[TestModel class] columns:nil where:@"name = ?" values:@[@"hello"] toClass:nil completion:^(NSArray *result) {
        array2 = result;
    }];
    TestModel *dbModel = [array2 lastObject];
    XCTAssertTrue(array2.count == 1&&[dbModel.name isEqualToString:@"hello"]&&(dbModel.memory.length == 0)&&(dbModel.testUint == 223));
    [FFDBSafeOperation updateFromClass:[TestModel class] set:@[@"name"] where:@"name = ?" values:@[@"test1",@"hello"] completion:^(BOOL result) {
        XCTAssertTrue(result);
    }];
    __block NSArray *array3 = nil;
    [FFDBSafeOperation selectFromClass:[TestModel class] columns:nil where:@"name = ?" values:@[@"test1"] toClass:nil completion:^(NSArray *result) {
        array3 = result;
    }];
    TestModel *dbTModel = [array3 lastObject];
    XCTAssertTrue(array3.count == 1&&[dbTModel.name isEqualToString:@"test1"]&&(dbTModel.memory.length == 0)&&(dbTModel.testUint == 223));
    [FFDBSafeOperation deleteFromClass:[TestModel class] where:@"name = ?" values:@[@"test2"] completion:^(BOOL result) {
        XCTAssertTrue(result);
    }];
    [FFDBSafeOperation selectFromClass:[TestModel class] columns:nil where:@"name = ?" values:@[@"test2"] toClass:nil completion:^(NSArray *result) {
        XCTAssertTrue(result.count == 0);
    }];
    [FFDBSafeOperation deleteFromClass:[TestModel class] where:nil values:nil completion:^(BOOL result) {
        XCTAssertTrue(result);
    }];
    [FFDBSafeOperation selectAllObjectFromClass:[TestModel class] completion:^(NSArray *result) {
        XCTAssertTrue(result.count == 0);
    }];
    i = 0;
    [FFDBSafeOperation insertObjectList:@[testModel1,testModel2] completion:^(BOOL result,BOOL isFinal) {
        XCTAssertTrue(result);
        if (i == 0)
        {
            XCTAssertFalse(isFinal);
        }else
        {
            XCTAssertTrue(isFinal);
        }
        i++;
    }];
    [FFDBSafeOperation selectAllObjectFromClass:[TestModel class] completion:^(NSArray *list) {
        XCTAssertTrue(list.count == 2);
        i = 0;
        [FFDBSafeOperation deleteObjectList:list completion:^(BOOL result,BOOL isFinal) {
            XCTAssertTrue(result);
            if (i == 0)
            {
                XCTAssertFalse(isFinal);
            }else
            {
                XCTAssertTrue(isFinal);
            }
            i++;
            if (isFinal)
            {
                [FFDBSafeOperation selectAllObjectFromClass:[TestModel class] completion:^(NSArray *result) {
                    XCTAssertTrue(result.count == 0);
                }];
            }
        }];
    }];
}

- (void)testFFDBTransaction
{
    TestModel *testModel1 = [[TestModel alloc]init];
    testModel1.name = @"hello";
    testModel1.memory = @"is me";
    testModel1.time = [NSDate date].timeIntervalSince1970;
    testModel1.testUint = 223;
    TestModel *testModel2 = [[TestModel alloc]init];
    testModel2.name = @"test2";
    __block int i = 0;
    [FFDBTransaction insertObjectList:@[testModel1,testModel2] isRollBack:YES completion:^(BOOL result,BOOL isFinal) {
        XCTAssertTrue(result);
        if (i == 0)
        {
            XCTAssertFalse(isFinal);
        }else
        {
            XCTAssertTrue(isFinal);
        }
        i++;
    }];
    [FFDBTransaction insertTable:[TestModel class] columns:@[@"name"] values:@[@"test3"] isRollBack:YES completion:^(BOOL result) {
        XCTAssertTrue(result);
    }];
    [FFDBTransaction selectAllObjectFromClass:[TestModel class] completion:^(NSArray *result) {
        XCTAssertTrue(result.count == 3);
    }];
    __block NSArray *array2;
    [FFDBTransaction selectFromClass:[TestModel class] columns:nil where:@"name = ?" values:@[@"hello"] toClass:nil completion:^(NSArray *result) {
        array2 = result;
    }];
    TestModel *dbModel = [array2 lastObject];
    XCTAssertTrue(array2.count == 1&&[dbModel.name isEqualToString:@"hello"]&&(dbModel.memory.length == 0)&&(dbModel.testUint == 223));
    [FFDBTransaction updateFromClass:[TestModel class] set:@[@"name"] where:@"name = ?" values:@[@"test1",@"hello"] isRollBack:YES completion:^(BOOL result) {
        XCTAssertTrue(result);
    }];
    __block NSArray *array3 = nil;
    [FFDBTransaction selectFromClass:[TestModel class] columns:nil where:@"name = ?" values:@[@"test1"] toClass:nil completion:^(NSArray *result) {
        array3 = result;
    }];
    TestModel *dbTModel = [array3 lastObject];
    XCTAssertTrue(array3.count == 1&&[dbTModel.name isEqualToString:@"test1"]&&(dbTModel.memory.length == 0)&&(dbTModel.testUint == 223));
    [FFDBTransaction deleteFromClass:[TestModel class] where:@"name = ?" values:@[@"test2"] isRollBack:YES completion:^(BOOL result) {
        XCTAssertTrue(result);
    }];
    [FFDBTransaction selectFromClass:[TestModel class] columns:nil where:@"name = ?" values:@[@"test2"] toClass:nil completion:^(NSArray *result) {
        XCTAssertTrue(result.count == 0);
    }];
    [FFDBTransaction deleteFromClass:[TestModel class] where:nil values:nil isRollBack:YES completion:^(BOOL result) {
        XCTAssertTrue(result);
    }];
    [FFDBTransaction selectAllObjectFromClass:[TestModel class] completion:^(NSArray *result) {
        XCTAssertTrue(result.count == 0);
    }];
    i = 0;
    [FFDBTransaction insertObjectList:@[testModel1,testModel2] isRollBack:YES completion:^(BOOL result,BOOL isFinal) {
        XCTAssertTrue(result);
        if (i == 0)
        {
            XCTAssertFalse(isFinal);
        }else
        {
            XCTAssertTrue(isFinal);
        }
        i++;
    }];
    __block NSArray *array4 = nil;
    [FFDBTransaction selectAllObjectFromClass:[TestModel class] completion:^(NSArray *result) {
        XCTAssertTrue(result.count == 2);
        array4 = result;
    }];
    i = 0;
    [FFDBTransaction deleteObjectList:array4 isRollBack:YES completion:^(BOOL result,BOOL isFinal) {
        XCTAssertTrue(result);
        if (i == 0)
        {
            XCTAssertFalse(isFinal);
        }else
        {
            XCTAssertTrue(isFinal);
        }
        i++;
    }];
    [FFDBTransaction selectAllObjectFromClass:[TestModel class] completion:^(NSArray *result) {
        XCTAssertTrue(result.count == 0);
    }];
}

- (void)testFFDBManagerSelect
{
    [TestModel deleteFromClassAllObject];
    for (int i = 1; i < 10; i++)
    {
        TestModel *model = [[TestModel alloc] init];
        model.time = i;
        [model insertObject];
    }
    
    NSArray <TestModel *>*list1 = [FFDBManager selectFromClass:[TestModel class] columns:@[@"time"] where:nil orderBy:@"time desc" limit:nil offset:nil values:nil toClass:[TestModel class] db:nil];
    double tmp1 = 0;
    for (TestModel *model in list1)
    {
        if (tmp1 != 0)
        {
            XCTAssertTrue(tmp1 > model.time);
        }
        tmp1 = tmp1 == 0 ? model.time : tmp1;
    }
    
    
    NSArray <TestModel *>*list2 = [FFDBManager selectFromClass:[TestModel class] columns:@[@"time"] where:nil orderBy:@"time asc" limit:nil offset:nil values:nil toClass:[TestModel class] db:nil];
    double tmp2 = 0;
    for (TestModel *model in list2)
    {
        if (tmp2 != 0)
        {
            XCTAssertTrue(tmp2 < model.time);
        }
        tmp2 = tmp2 == 0 ? model.time : tmp2;
    }
    
    NSArray <TestModel *>*list3 = [FFDBManager selectFromClass:[TestModel class] columns:@[@"time"] where:nil orderBy:@"time asc" limit:@"5" offset:nil values:nil toClass:[TestModel class] db:nil];
    XCTAssertTrue(list3.count == 5);
    
    NSArray <TestModel *>*list4 = [FFDBManager selectFromClass:[TestModel class] columns:@[@"time"] where:nil orderBy:@"time desc" limit:@"2" offset:@"2" values:nil toClass:[TestModel class] db:nil];
    XCTAssertTrue(list4[0].time == 7);
    XCTAssertTrue(list4[1].time == 6);
}


- (void)testSelect
{
    [TestModel deleteFromClassAllObject];
    for (int i = 1; i < 10; i++)
    {
        TestModel *model = [[TestModel alloc] init];
        model.time = i;
        [model insertObject];
    }
    
    
    NSArray <TestModel *>*list1 = [TestModel selectFromClassWhereFormat:nil orderBy:@"time desc" limit:nil offset:nil values:nil];;
    double tmp1 = 0;
    for (TestModel *model in list1)
    {
        if (tmp1 != 0)
        {
            XCTAssertTrue(tmp1 > model.time);
        }
        tmp1 = tmp1 == 0 ? model.time : tmp1;
    }
    
    
    NSArray <TestModel *>*list2 = [TestModel selectFromClassWhereFormat:nil orderBy:@"time asc" limit:nil offset:nil values:nil];
    double tmp2 = 0;
    for (TestModel *model in list2)
    {
        if (tmp2 != 0)
        {
            XCTAssertTrue(tmp2 < model.time);
        }
        tmp2 = tmp2 == 0 ? model.time : tmp2;
    }
    
    NSArray <TestModel *>*list3 = [TestModel selectFromClassWhereFormat:nil orderBy:@"time asc" limit:@"5" offset:nil values:nil];
    XCTAssertTrue(list3.count == 5);
    
    NSArray <TestModel *>*list4 = [TestModel selectFromClassWhereFormat:nil orderBy:@"time desc" limit:@"2" offset:@"2" values:nil];
    XCTAssertTrue(list4[0].time == 7);
    XCTAssertTrue(list4[1].time == 6);
}
@end
