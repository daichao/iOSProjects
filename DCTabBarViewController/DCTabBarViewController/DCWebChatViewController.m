//
//  DCWebChatViewController.m
//  DCTabBarViewController
//
//  Created by daichao on 15/6/7.
//  Copyright (c) 2015年 daichao. All rights reserved.
//

#import "DCWebChatViewController.h"

@interface DCWebChatViewController()

@end


@implementation DCWebChatViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    //设置视图控制器的标题
    self.title=@"Chat";
    //通过tabBarController或parentViewController可以得到其父视图控制器；
    NSLog(@"%i",self.tabBarController==self.parentViewController);
    
    
    
    self.tabBarItem.title=@"Web Chat";
    self.tabBarItem.image=[UIImage imageNamed:@"tabbar_mainframe.png"];
    self.tabBarItem.selectedImage=[UIImage imageNamed:@"tabbar_mainframeHL.png"];
    
    self.tabBarItem.badgeValue=@"5";
    
}

@end
