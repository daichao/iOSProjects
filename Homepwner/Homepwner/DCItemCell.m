//
//  DCItemCell.m
//  Homepwner
//
//  Created by bokeadmin on 15/6/24.
//  Copyright (c) 2015年 daichao. All rights reserved.
//

#import "DCItemCell.h"

@implementation DCItemCell
-(IBAction)showImage:(id)sender{
    //调用Block对象之前要检查Block对象是否存在
    if(self.actionBlock){
        self.actionBlock();
    }
}

-(void)updateInterfaceForDynamicTypeSize{
    UIFont *font=[UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    self.nameLabel.font=font;
    self.serialNumberLabel.font=font;
    self.valueLabel.font=font;
    
    static NSDictionary *imageSizeDictionary;
    if(!imageSizeDictionary){
        imageSizeDictionary=@{UIContentSizeCategoryExtraExtraExtraLarge:@65,
                              UIContentSizeCategoryExtraExtraLarge:@55,
                              UIContentSizeCategoryExtraLarge:@45,
                              UIContentSizeCategoryLarge:@40,
                              UIContentSizeCategoryMedium:@40,
                              UIContentSizeCategorySmall:@40,
                              UIContentSizeCategoryExtraSmall:@40};
    }
    NSString *userSize=[[UIApplication sharedApplication]preferredContentSizeCategory];
    NSNumber *imageSize=imageSizeDictionary[userSize];
    self.imageViewHeightConstraint.constant=imageSize.floatValue;
//    self.imageViewWidthConstraint.constant=imageSize.floatValue;
}

-(void)awakeFromNib{
    [self updateInterfaceForDynamicTypeSize];
    
    NSNotificationCenter *nc=[NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(updateInterfaceForDynamicTypeSize) name:UIContentSizeCategoryDidChangeNotification object:nil];
    
    NSLayoutConstraint *constraint=[NSLayoutConstraint constraintWithItem:self.thumbnailView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.thumbnailView attribute:NSLayoutAttributeWidth multiplier:1 constant:0];
    [self.thumbnailView addConstraint:constraint];
}

-(void)dealloc{
    NSNotificationCenter *nc=[NSNotificationCenter defaultCenter];
    [nc removeObserver:self];
}
@end
