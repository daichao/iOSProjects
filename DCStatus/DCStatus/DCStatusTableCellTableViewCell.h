//
//  DCStatusTableCellTableViewCell.h
//  DCStatus
//
//  Created by bokeadmin on 15/6/4.
//  Copyright (c) 2015年 bokeadmin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DCStatus.h"


@interface DCStatusTableCellTableViewCell : UITableViewCell
#pragma mark 微博对象
@property(nonatomic,strong)DCStatus *status;
#pragma mark 单元格高度
@property(assign,nonatomic)CGFloat height;

@end
