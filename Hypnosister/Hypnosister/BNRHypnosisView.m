//
//  BNRHypnosisView.m
//  Hypnosister
//
//  Created by bokeadmin on 15/5/21.
//  Copyright (c) 2015年 bokeadmin. All rights reserved.
//

#import "BNRHypnosisView.h"

@interface BNRHypnosisView()

@property (strong,nonatomic)UIColor *circleColor;

@end

@implementation BNRHypnosisView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // All BNRHypnosisViews start with a clear background color
        self.backgroundColor = [UIColor clearColor];
        self.circleColor=[UIColor lightGrayColor];
    }
    return self;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
 */
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    CGRect bounds=self.bounds;
    
    //根据bounds计算中心点
    CGPoint center;
    center.x=bounds.origin.x + bounds.size.width / 2.0;
    center.y=bounds.origin.y + bounds.size.height / 2.0;
    
    //根据视图宽和高中的较小值计算圆形的半径
    float radius=hypot(bounds.size.width,bounds.size.height)/2.0;

    UIBezierPath *path=[[UIBezierPath alloc]init];
    for(float currentRadius=radius;currentRadius>0;currentRadius-=20){
        [path moveToPoint:CGPointMake(center.x+currentRadius,center.y)];
        //以中心为圆心，radius的值为半径，定义一个0到M_PI*2.0的弧度的路径(整圆)
        [path addArcWithCenter:center radius:currentRadius startAngle:0.0 endAngle:M_PI*2.0 clockwise:YES];
    }
    path.lineWidth=10;
    
//    [[UIColor lightGrayColor]setStroke];
    [self.circleColor setStroke];
    UIImage *logoImage=[UIImage imageNamed:@"logo.png"];
    [logoImage drawInRect:rect];
    //绘制路径
    [path stroke];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"%@ was touched",self);
    
    float red=(arc4random()%100)/100.0;
    float green=(arc4random()%100)/100.0;
    float blue=(arc4random()%100)/100.0;
    
    UIColor *randomColor=[UIColor colorWithRed:red green:green blue:blue alpha:1.0];
    
    self.circleColor=randomColor;
}

-(void)setCircleColor:(UIColor *)circleColor{
    _circleColor=circleColor;
    [self setNeedsDisplay];//重新绘制自己
}
@end
