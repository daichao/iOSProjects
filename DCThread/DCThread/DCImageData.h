//
//  DCImageData.h
//  DCThread
//
//  Created by bokeadmin on 15/6/9.
//  Copyright (c) 2015年 bokeadmin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DCImageData : NSObject
#pragma mark 索引
@property (nonatomic,assign)int index;
#pragma  mark 图片数据
@property(nonatomic,strong)NSData *data;

@end
