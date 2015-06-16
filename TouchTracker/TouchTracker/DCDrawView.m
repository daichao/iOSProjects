//
//  DCDrawView.m
//  TouchTracker
//
//  Created by bokeadmin on 15/6/16.
//  Copyright (c) 2015年 bokeadmin. All rights reserved.
//

#import "DCDrawView.h"
#import "DCLine.h"
@interface DCDrawView()
//@property (nonatomic,strong)DCLine *currentLine;
@property(nonatomic,strong)NSMutableDictionary *linesInProgress;
@property(nonatomic,strong)NSMutableArray *finishedLines;
@property(nonatomic,weak)DCLine *selectedLine;

@end
@implementation DCDrawView

#pragma mark 画直线
-(void)strokeLine:(DCLine *)line{
    UIBezierPath *bp=[UIBezierPath bezierPath];
    bp.lineWidth=10;
    bp.lineCapStyle=kCGLineCapRound;
    
    [bp moveToPoint:line.begin];
    [bp addLineToPoint:line.end];
    [bp stroke];
}

#pragma mark UIView方法，画图
- (void)drawRect:(CGRect)rect {
    //用黑色绘制已经完成的线条
    [[UIColor blackColor]set];
    for(DCLine *line in self.finishedLines){
        [self strokeLine:line];
    }
    [[UIColor redColor]set];
    for(NSValue *key in self.linesInProgress){
        [self strokeLine:self.linesInProgress[key]];
        
    }
    if(self.selectedLine){
        [[UIColor greenColor]set];
        [self strokeLine:self.selectedLine];
    }
    
//    if(self.currentLine){
//        //同红色绘制正在画的线条
//        [[UIColor redColor]set];
//        [self strokeLine:self.currentLine];
//    }
}

#pragma mark 双击界面
-(void)doubleTap:(UIGestureRecognizer*)gr{
    NSLog(@"Recognized Double Tap");
    [self.linesInProgress removeAllObjects];
    [self.finishedLines removeAllObjects];
    [self setNeedsDisplay];
}

-(void)deleteLine:(id)sender{
    [self.finishedLines removeObject:self.selectedLine];
    //重置整个视图
    [self setNeedsDisplay];
}

#pragma mark 单击界面
-(void)tap:(UIGestureRecognizer*)gr{
    NSLog(@"Recognized tap");
    CGPoint point=[gr locationInView:self];
    self.selectedLine=[self lineAtPoint:point];
    if (self.selectedLine) {
        [self becomeFirstResponder];
        UIMenuController *menu=[UIMenuController sharedMenuController];
        
        UIMenuItem *deleteItem=[[UIMenuItem alloc]initWithTitle:@"Delete" action:@selector(deleteLine:)];
        menu.menuItems=@[deleteItem];
        
        [menu setTargetRect:CGRectMake(point.x, point.y, 2, 2) inView:self];
        [menu setMenuVisible:YES animated:YES];
    }
    else{
        [[UIMenuController sharedMenuController]setMenuVisible:NO animated:YES];
    }
    [self setNeedsDisplay];
}
//如果要将某个自定义的UIView子类对象设置为第一响应对象，就必须覆盖该对象的canBecomeFirstResponder
-(BOOL)canBecomeFirstResponder{
    return YES;
}

#pragma mark
-(DCLine*)lineAtPoint:(CGPoint)p{
    //找出离p最近的DCLine对象
    for(DCLine *l in self.finishedLines){
        CGPoint start=l.begin;
        CGPoint end=l.end;
        
        //检查线条的若干点
        for(float t=0.0;t<=1.0;t+=0.05){
            float x=start.x+t*(end.x-start.x);
            float y=start.y+t*(end.y-start.y);
            //如果线条的某个点和p的距离在20点以内，就返回相应的DCLine对象
            if(hypot(x-p.x, y-p.y)<20.0){
                return  l;
            }
        }
    }
    return nil;
    
}
#pragma mark 初始化界面
-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if(self){
        self.linesInProgress=[[NSMutableDictionary alloc]init];
        self.finishedLines=[[NSMutableArray alloc]init];
        self.backgroundColor=[UIColor grayColor];
        self.multipleTouchEnabled=YES;
        UITapGestureRecognizer *doubleTapRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTap:)];
        doubleTapRecognizer.numberOfTapsRequired=2;
        doubleTapRecognizer.delaysTouchesBegan=YES;
        [self addGestureRecognizer:doubleTapRecognizer];
        
        UITapGestureRecognizer *tapRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
        tapRecognizer.delaysTouchesBegan=YES;
        [tapRecognizer requireGestureRecognizerToFail:doubleTapRecognizer];
        [self addGestureRecognizer:tapRecognizer];
    }
    return self;
}

#pragma mark UIResponder的方法 开始点击
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"%@",NSStringFromSelector(_cmd));
    for(UITouch *t in touches){
        CGPoint location=[t locationInView:self];
        DCLine *line=[[DCLine alloc]init];
        line.begin=location;
        line.end=location;
        NSValue *key=[NSValue valueWithNonretainedObject:t];
        self.linesInProgress[key]=line;
    }
    [self setNeedsDisplay];
//    UITouch *t=[touches anyObject];
//    
//    //根据触摸位置创建DCLine对象
//    CGPoint location=[t locationInView:self];
//    
//    self.currentLine=[[DCLine alloc]init];
//    self.currentLine.begin=location;
//    self.currentLine.end=location;
//    
//    [self setNeedsDisplay];
}
#pragma  mark 按着屏幕移动
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"%@",NSStringFromSelector(_cmd));
    for (UITouch *t in touches) {
        NSValue *key=[NSValue valueWithNonretainedObject:t];
        DCLine *line=self.linesInProgress[key];
        line.end=[t locationInView:self];
    }
//    UITouch *t=[touches anyObject];
//    CGPoint location=[t locationInView:self];
//    self.currentLine.end=location;
    [self setNeedsDisplay];
}
#pragma mark 移动结束
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"%@",NSStringFromSelector(_cmd));
    for(UITouch *t in touches){
        NSValue *key=[NSValue valueWithNonretainedObject:t];
        DCLine *line=self.linesInProgress[key];
        [self.finishedLines addObject:line];
        [self.linesInProgress removeObjectForKey:key];
        
    }
//    [self.finishedLines addObject:self.currentLine];
//    self.currentLine=nil;
    [self setNeedsDisplay];
    
}
#pragma mark 取消或被中断操作
-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"%@",NSStringFromSelector(_cmd));
    for(UITouch *t in touches){
        NSValue *key=[NSValue valueWithNonretainedObject:t];
        [self.linesInProgress removeObjectForKey:key];
    }
    
    [self setNeedsDisplay];
}
@end
