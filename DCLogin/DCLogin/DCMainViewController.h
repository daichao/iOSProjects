//
//  DCMainViewController.h
//  DCLogin
//
//  Created by bokeadmin on 15/6/8.
//  Copyright (c) 2015年 bokeadmin. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark   定义一个协议用于参数传递

@protocol DCMainDelegate

-(void)showUserInfoWithUserName:(NSString *)userName;

@end

@interface DCMainViewController : UIViewController

@end
