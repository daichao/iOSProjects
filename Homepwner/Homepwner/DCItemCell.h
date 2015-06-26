//
//  DCItemCell.h
//  Homepwner
//
//  Created by bokeadmin on 15/6/24.
//  Copyright (c) 2015年 daichao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface DCItemCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *thumbnailView;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@property (weak, nonatomic) IBOutlet UILabel *serialNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property(nonatomic,copy)void(^actionBlock)(void);
@property(nonatomic,weak)IBOutlet NSLayoutConstraint *imageViewHeightConstraint;
//@property(nonatomic,weak)IBOutlet NSLayoutConstraint *imageViewWidthConstraint;

@end
