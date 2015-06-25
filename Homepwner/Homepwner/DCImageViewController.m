//
//  DCImageViewController.m
//  Homepwner
//
//  Created by bokeadmin on 15/6/25.
//  Copyright (c) 2015年 daichao. All rights reserved.
//

#import "DCImageViewController.h"

@interface DCImageViewController ()

@end

@implementation DCImageViewController
-(void)loadView{
    UIImageView *imageView=[[UIImageView alloc]init];
    imageView.contentMode=UIViewContentModeScaleAspectFit;
    self.view=imageView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    UIImageView *imageView=(UIImageView*)self.view;
    imageView.image=self.image;
}
@end
