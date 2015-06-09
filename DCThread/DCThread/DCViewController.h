//
//  DCViewController.h
//  DCThread
//
//  Created by bokeadmin on 15/6/9.
//  Copyright (c) 2015年 bokeadmin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DCViewController : UIViewController
#pragma mark 图片资源存储容器
@property(atomic,strong)NSMutableArray *imageNames;

#pragma mark 当前加载的图片索引(图片链接地址连续)
@property(atomic,assign)int currentIndex;

@end
