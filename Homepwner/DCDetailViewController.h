//
//  DCDetailViewController.h
//  Homepwner
//
//  Created by bokeadmin on 15/6/12.
//  Copyright (c) 2015年 daichao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BNRItem;
@interface DCDetailViewController : UIViewController
-(instancetype)initForNewItem:(BOOL)isNew;
@property(nonatomic,strong)BNRItem *item;

@end
