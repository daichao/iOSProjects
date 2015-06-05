//
//  DCContactGroup.h
//  DCContact
//
//  Created by bokeadmin on 15/6/4.
//  Copyright (c) 2015年 bokeadmin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCContact.h"
@interface DCContactGroup : NSObject
@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *detail;
@property(nonatomic,strong)NSMutableArray *contacts;

-(DCContactGroup *)initWithName:(NSString*)name andDetail:(NSString*)detail andContacts:(NSMutableArray*)contacts;

+(DCContactGroup *)initWithName:(NSString *)name andDetail:(NSString *)detail andContacts:(NSMutableArray *)contacts;

@end
