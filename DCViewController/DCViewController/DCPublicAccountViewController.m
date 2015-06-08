//
//  DCPublicAccountViewController.m
//  DCViewController
//
//  Created by bokeadmin on 15/6/8.
//  Copyright (c) 2015年 bokeadmin. All rights reserved.
//

#import "DCPublicAccountViewController.h"

@interface DCPublicAccountViewController ()

@end

@implementation DCPublicAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    
    //每次出栈都会销毁相应的子控制器
    NSLog(@"childViewControllers:%@",self.navigationController.childViewControllers);
    
    self.title=@"Public Account";
     self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"Add Friends" style:UIBarButtonItemStyleDone target:self action:@selector(gotoAddFriends)];
    
    
}

-(void)gotoAddFriends{
    
    //直接跳转到根控制器，也可以使用- (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated; 方法
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
    
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
