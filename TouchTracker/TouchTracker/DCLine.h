//
//  DCLine.h
//  TouchTracker
//
//  Created by bokeadmin on 15/6/16.
//  Copyright (c) 2015年 bokeadmin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface DCLine : UIView

@property (nonatomic) CGPoint begin;
@property (nonatomic) CGPoint end;
@property(nonatomic,weak)NSMutableArray *containingArray;

@end
