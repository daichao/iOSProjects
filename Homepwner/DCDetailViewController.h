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
@property(nonatomic,strong)BNRItem *item;
//因为nameField属性指向的不是xib文件中的顶层对象，所以将引用类型设置为weak
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *serialNumberField;
@property (weak, nonatomic) IBOutlet UITextField *valueField;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;

@end
