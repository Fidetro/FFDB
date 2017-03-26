//
//  ViewController.m
//  FIDDB
//
//  Created by Fidetro on 2017/3/22.
//  Copyright © 2017年 Fidetro. All rights reserved.
//

#import "ClassRoomViewController.h"
#import "ClassRoom.h"
@interface ClassRoomViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/** 教室 **/
@property(nonatomic,strong) NSMutableArray<ClassRoom *> *classroomArray;
@end

@implementation ClassRoomViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

}

- (IBAction)addNewClassRoom:(id)sender
{
    ClassRoom *classRoom = [[ClassRoom alloc]init];
    classRoom.name = @"new room";
    [classRoom insertObject];
    [self selectAndUpdateEvent];
    [self.tableView reloadData];
}

- (void)selectAndUpdateEvent
{
    NSArray *dataArray = [ClassRoom selectAllObject];
    self.classroomArray = [NSMutableArray arrayWithArray:dataArray];
}

#pragma mark - --------------------------UITableView dataSource--------------------------

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.classroomArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        
    }
    
    ClassRoom *classRoom = self.classroomArray[indexPath.row];
    cell.textLabel.text = classRoom.name;
    return cell;
    
}
#pragma mark - --------------------------UITableView delegate--------------------------

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{

}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ClassRoom *classRoom = self.classroomArray[indexPath.row];
    UITableViewRowAction *editAction =[UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"Edit" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Edit ClassRoom Name" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = @"ClassRoom name";
        }];
        UIAlertAction *enterAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * action) {
        UITextField *textField = [alert.textFields lastObject];
        classRoom.name = textField.text;
        [classRoom updateObject];
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                                                             }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        [alert addAction:enterAction];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
    }];
    UITableViewRowAction *deleteAction =[UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"Delete" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [classRoom deleteObject];
        [self selectAndUpdateEvent];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
    }];
    return @[deleteAction,editAction];
}

- (void)setTableView:(UITableView *)tableView
{
    _tableView = tableView;
    _tableView.delegate = self;
    _tableView.dataSource = self;
}

- (NSMutableArray<ClassRoom *> *)classroomArray
{
    if (!_classroomArray) {
        
        NSArray *dataArray = [ClassRoom selectAllObject];
        
        if (dataArray.count == 0) {
            ClassRoom *classRoom = [[ClassRoom alloc]init];
            classRoom.name = @"default Room";
            [classRoom insertObject];
        }
        
        _classroomArray = [NSMutableArray arrayWithArray:dataArray];
    }
    return _classroomArray;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
