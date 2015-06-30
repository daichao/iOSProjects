//
//  DCImageTransformer.m
//  Homepwner
//
//  Created by bokeadmin on 15/6/30.
//  Copyright (c) 2015年 daichao. All rights reserved.
//

#import "DCImageTransformer.h"
#import <UIKit/UIKit.h>
@implementation DCImageTransformer
+(Class)transformedValueClass{
    return [NSData class];
}
//转换
-(id)transformedValue:(id)value{
    if(!value){
        return nil;
    }
    if([value isKindOfClass:[NSData class]]){
        return  value;
    }
    return  UIImagePNGRepresentation(value);
}
//恢复
-(id)reverseTransformedValue:(id)value{
    return [UIImage imageWithData:value];
}
@end
