//
//  DCLoginViewController.h
//  DCLogin
//
//  Created by bokeadmin on 15/6/8.
//  Copyright (c) 2015年 bokeadmin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DCMainDelegate;

@interface DCLoginViewController : UIViewController

#pragma mark 定义代理

@property(nonatomic,strong) id<DCMainDelegate> delegate;

@end
