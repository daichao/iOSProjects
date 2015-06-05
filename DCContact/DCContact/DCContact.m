//
//  DCContact.m
//  DCContact
//
//  Created by bokeadmin on 15/6/4.
//  Copyright (c) 2015年 bokeadmin. All rights reserved.
//

#import "DCContact.h"

@implementation DCContact
-(DCContact *)initWithFirstName:(NSString *)firstName andLastName:(NSString *)lastName andPhoneNumber:(NSString *)phoneNumber{
    if(self=[super init]){
        self.firstName=firstName;
        self.lastName=lastName;
        self.phoneNumber=phoneNumber;
    }
    return  self;
}

-(NSString*)getName{
    return [NSString stringWithFormat:@"%@ %@,",_lastName,_firstName];
}
+(DCContact*)initWithFirstName:(NSString *)firstName andLastName:(NSString *)lastName andPhoneNumber:(NSString *)phoneNumber{
    DCContact *contact1=[[DCContact alloc]initWithFirstName:firstName andLastName:lastName andPhoneNumber:phoneNumber];
    return  contact1;
}
@end
