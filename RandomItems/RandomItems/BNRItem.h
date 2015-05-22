//
//  BNRItem.h
//  RandomItems
//
//  Created by bokeadmin on 15/5/19.
//  Copyright (c) 2015年 bokeadmin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BNRItem : NSObject
//{
//    NSString *_itemName;
//    NSString *_serialNumber;
//    int _valueInDollars;
//    NSDate *_dateCreated;
//}

@property(nonatomic,strong) BNRItem *containedItem;
@property(nonatomic,weak) BNRItem *container;

@property(nonatomic,copy) NSString *itemName;
@property(nonatomic,copy) NSString *serialNumber;
@property(nonatomic) int valueInDollars;
@property(nonatomic,readonly,strong) NSDate *dateCreated;

+(instancetype)randomItem;

-(instancetype)initWithItemName:(NSString *)name
                 valueInDollars:(int)value
                   serialNumber:(NSString *)sNumber;

-(instancetype)initWithItemName:(NSString *)name;
-(instancetype)initWithItemName:(NSString *)name
                   serialNumber:(NSString *)sNumber;

//-(void)setItemName:(NSString *)str;
//-(NSString *)itemName;
//
//-(void)setSerialNumber:(NSString *)str;
//-(NSString *)serialNumber;
//
//-(void)setValueInDollars:(int)v;
//-(int)valueInDollars;
//
//-(NSDate *)dateCreated;

@end
