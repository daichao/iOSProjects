//
//  DCStatus.m
//  DCStatus
//
//  Created by bokeadmin on 15/6/4.
//  Copyright (c) 2015年 bokeadmin. All rights reserved.
//

#import "DCStatus.h"

@implementation DCStatus
-(DCStatus*)initWithDictionary:(NSDictionary *)dic{
    if(self=[super init]){
        self.Id=[dic[@"Id"] longLongValue];
        self.profileImageUrl=dic[@"profileImageUrl"];
        self.userName=dic[@"userName"];
        self.mbtype=dic[@"mbtype"];
        self.createdAt=dic[@"createdAt"];
        self.source=dic[@"source"];
        self.text=dic[@"text"];
    }
    return self;
}
#pragma mark 初始化微博对象(静态方法)
+(DCStatus*)statusWithDictionary:(NSDictionary *)dic{
    DCStatus *status=[[DCStatus alloc]initWithDictionary:dic];
    return  status;
}

-(NSString*)source{
    return [NSString stringWithFormat:@"来自 %@",_source];
}

@end
