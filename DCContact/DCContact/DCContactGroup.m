//
//  DCContactGroup.m
//  DCContact
//
//  Created by bokeadmin on 15/6/4.
//  Copyright (c) 2015年 bokeadmin. All rights reserved.
//

#import "DCContactGroup.h"

@implementation DCContactGroup
-(DCContactGroup*)initWithName:(NSString *)name andDetail:(NSString *)detail andContacts:(NSMutableArray *)contacts{
    if (self=[super init]) {
        self.name=name;
        self.detail=detail;
        self.contacts=contacts;
    }
    return self;
}


+(DCContactGroup*)initWithName:(NSString *)name andDetail:(NSString *)detail andContacts:(NSMutableArray *)contacts{
    DCContactGroup *group1=[[DCContactGroup alloc]initWithName:name andDetail:detail andContacts:contacts];
    return group1;
}
@end
