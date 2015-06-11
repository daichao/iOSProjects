//
//  ViewController.m
//  ToDoList
//
//  Created by bokeadmin on 15/6/11.
//  Copyright (c) 2015年 bokeadmin. All rights reserved.
//

#import "AddToDoItemViewController.h"

@interface AddToDoItemViewController ()

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;
@end

@implementation AddToDoItemViewController


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if (sender!=self.doneButton) {
        return;
    }
    if (self.textField.text.length>0) {
        self.toDoItem=[[ToDoItem alloc]init];
        self.toDoItem.itemName=self.textField.text;
        self.toDoItem.completed=NO;
        
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
