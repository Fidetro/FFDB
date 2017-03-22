//
//  ViewController.m
//  FIDDB
//
//  Created by Fidetro on 2017/3/22.
//  Copyright © 2017年 Fidetro. All rights reserved.
//

#import "ViewController.h"
#import "Person.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [Person deleteAllObject];
    Person *person = [[Person alloc]init];
    person.name = @"hello";
    //插入对象
    [person insertObject];
    
    for (Person *person in [Person selectAllObject]) {

        NSLog(@"%@",person.age);
        NSLog(@"%ld",[person.age length]);
    }
    


    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
