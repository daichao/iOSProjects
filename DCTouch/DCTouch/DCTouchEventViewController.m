//
//  ViewController.m
//  DCTouch
//
//  Created by bokeadmin on 15/6/8.
//  Copyright (c) 2015年 bokeadmin. All rights reserved.
//

#import "DCTouchEventViewController.h"
#import "DCImage.h"
@interface DCTouchEventViewController (){
    DCImage *_image;
}

@end

@implementation DCTouchEventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _image=[[DCImage alloc]initWithFrame:CGRectMake(50, 50, 150, 169)];
    
    [self.view addSubview:_image];
    
}

#pragma mark 视图控制器的触摸事件
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"UIViewController start touch");
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    //取得一个触摸对象
    UITouch *touch=[touches anyObject];
    
    //取得当前位置
    CGPoint current=[touch locationInView:self.view];
    
    //取得前一个位置
    CGPoint previous=[touch previousLocationInView:self.view];
    
    //移动前的中点位置
    CGPoint center=_image.center;
    
    //移动偏移量
    CGPoint offset=CGPointMake(current.x-previous.x, current.y-previous.y);
    
    //重新设置新位置
    _image.center=CGPointMake(center.x+offset.x, center.y+offset.y);
    
    NSLog(@"UIViewController moving...");
    
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"UIViewController touch end.");
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
