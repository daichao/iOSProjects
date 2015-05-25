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

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self=[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self){
        self.tabBarItem.title=@"Hypnotize";
        
        UIImage *i=[UIImage imageNamed:@"Hypno.png"];
        
        self.tabBarItem.image=i;
    }
    return self;
}
-(void)viewDidLoad{
    [super viewDidLoad];
    NSLog(@"BNRHypnosisViewController loaded its view.");
}

@end
