//
//  DCMeViewController.m
//  DCLogin
//
//  Created by bokeadmin on 15/6/8.
//  Copyright (c) 2015年 bokeadmin. All rights reserved.
//

#import "DCMeViewController.h"

@interface DCMeViewController (){
    UILabel *_lbUserInfo;
}

@end

@implementation DCMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //信息显示标签
    _lbUserInfo =[[UILabel alloc]initWithFrame:CGRectMake(0, 100, 320, 30)];
    _lbUserInfo.textAlignment=NSTextAlignmentCenter;
    _lbUserInfo.textColor=[UIColor colorWithRed:23/255.0 green:180/255.0 blue:237/255.0 alpha:1];
    [self.view addSubview:_lbUserInfo];
    
    //关闭按钮
    UIButton *btnClose=[UIButton buttonWithType:UIButtonTypeSystem];
    btnClose.frame=CGRectMake(110, 200, 100, 30);
    [btnClose setTitle:@"关闭" forState:UIControlStateNormal];
    [btnClose addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnClose];
    //设置传值信息
    _lbUserInfo.text=_userInfo;
}



#pragma  mark 关闭
-(void)close{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
