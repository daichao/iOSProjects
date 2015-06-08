//
//  DCImage.m
//  DCTouch
//
//  Created by bokeadmin on 15/6/8.
//  Copyright (c) 2015年 bokeadmin. All rights reserved.
//

#import "DCImage.h"

@implementation DCImage
-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if(self){
        UIImage *img=[UIImage imageNamed:@"photo.png"];
        [self setBackgroundColor:[UIColor colorWithPatternImage:img]];
        self.userInteractionEnabled=YES;
    }
         return self;
}

#pragma mark UIView的触摸事件
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"UIView start touch...");
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"UIView moving...");
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"UIView touch end.");
}
-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    
}

@end
