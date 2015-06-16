//
//  ViewController.m
//  TouchTracker
//
//  Created by bokeadmin on 15/6/16.
//  Copyright (c) 2015年 bokeadmin. All rights reserved.
//

#import "DCViewController.h"
#import "DCDrawView.h"

@interface DCViewController ()

@end

@implementation DCViewController

-(void)loadView{
    self.view=[[DCDrawView alloc]initWithFrame:CGRectZero];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
