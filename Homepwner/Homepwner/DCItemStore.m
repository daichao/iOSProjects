//
//  DCItemStore.m
//  Homepwner
//
//  Created by daichao on 15/6/11.
//  Copyright (c) 2015年 daichao. All rights reserved.
//

#import "DCItemStore.h"
#import "BNRItem.h"
/*
 在类扩展中声明属性或方法，则只有这个类才能访问这个属性和方法，别的类无法访问
 */
@interface DCItemStore()
@property (nonatomic)NSMutableArray *privateItems;

@end
@implementation DCItemStore

+(instancetype)sharedStore{
    static DCItemStore *sharedStore=nil;
    if(!sharedStore){
        sharedStore=[[self alloc]initPrivate];
    }
    return sharedStore;
}

-(instancetype)init{
    @throw [NSException exceptionWithName:@"Singleton" reason:@"Use+[DCItemStore sharedStore]" userInfo:nil];
}

-(instancetype)initPrivate{
    self=[super init];
    if(self){
        _privateItems=[[NSMutableArray alloc]init];
    }
    return self;
}
-(NSArray *)allItems{
    return self.privateItems;
    
}
-(BNRItem*)createItem{
    BNRItem *item=[BNRItem randomItem];
    [self.privateItems addObject:item];
    return item;
}
@end
