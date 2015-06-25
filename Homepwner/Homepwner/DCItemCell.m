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
@end
