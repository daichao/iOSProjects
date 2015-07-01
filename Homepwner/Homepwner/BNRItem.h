//
//  BNRItem.h
//  Homepwner
//
//  Created by bokeadmin on 15/7/1.
//  Copyright (c) 2015年 daichao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>
//@class NSManagedObject;

@interface BNRItem : NSManagedObject

@property (nonatomic, strong) NSDate * dateCreated;
@property (nonatomic, strong) NSString * itemKey;
@property (nonatomic, strong) NSString * itemName;
//@property (nonatomic, retain) NSNumber * orderingValue;
@property(nonatomic)double orderingValue;
@property (nonatomic, strong) NSString * serialNumber;
//@property (nonatomic, strong) id thumbnail;
@property(nonatomic,strong)UIImage *thumbnail;
//@property (nonatomic, strong) NSNumber * valueInDollars;
@property(nonatomic)int valueInDollars;
@property (nonatomic, strong) NSManagedObject *assetType;

-(void)setThumbnailFromImage:(UIImage *)image;
@end
