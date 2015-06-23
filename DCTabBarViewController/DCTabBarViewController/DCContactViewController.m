
//
//  DCContactViewController.m
//  DCTabBarViewController
//
//  Created by daichao on 15/6/7.
//  Copyright (c) 2015年 daichao. All rights reserved.
//

#import "DCContactViewController.h"

@interface DCContactViewController()

@end

@implementation DCContactViewController
-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor whiteColor];
    self.tabBarItem.title=@"Contact";
    self.tabBarItem.image=[UIImage imageNamed:@"tabbar_contacts.png"];
    self.tabBarItem.selectedImage=[UIImage imageNamed:@"tabbar_contactsHL.png"];

    
}
@end
