//
//  DCItemStore.h
//  Homepwner
//
//  Created by daichao on 15/6/11.
//  Copyright (c) 2015年 daichao. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BNRItem;
@interface DCItemStore : NSObject
@property(nonatomic,readonly)NSArray *allItems;//编译器不会为allItems生成取方法和实例变量_allItems
+(instancetype)sharedStore;
-(BNRItem*)createItem;
-(void)removeItem:(BNRItem*)item;
-(void)moveItemAtIndex:(NSUInteger)fromIndex
               toIndex:(NSUInteger)toIndex;
-(BOOL)saveChanges;
-(NSArray*)allAssetTypes;
@end
