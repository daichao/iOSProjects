//
//  ToDoItem.h
//  ToDoList
//
//  Created by bokeadmin on 15/6/11.
//  Copyright (c) 2015年 bokeadmin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ToDoItem : NSObject

@property NSString *itemName;
@property BOOL completed;
@property (readonly)NSDate *creationDate;

@end
