//
//  BNRHypnosisViewController.m
//  HypnoNerd
//
//  Created by daichao on 15/5/22.
//  Copyright (c) 2015年 daichao. All rights reserved.
//

#import "BNRHypnosisViewController.h"
#import "BNRHypnosisView.h"

@implementation BNRHypnosisViewController
-(void)loadView{
    BNRHypnosisView *backgroundView=[[BNRHypnosisView alloc]init];
    self.view=backgroundView;
}

@end
