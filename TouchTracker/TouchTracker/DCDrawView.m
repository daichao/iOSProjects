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

@end
@implementation DCDrawView


-(void)strokeLine:(DCLine *)line{
    UIBezierPath *bp=[UIBezierPath bezierPath];
    bp.lineWidth=10;
    bp.lineCapStyle=kCGLineCapRound;
    
    [bp moveToPoint:line.begin];
    [bp addLineToPoint:line.end];
    [bp stroke];
}

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
    
//    if(self.currentLine){
//        //同红色绘制正在画的线条
//        [[UIColor redColor]set];
//        [self strokeLine:self.currentLine];
//    }
}


-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if(self){
        self.linesInProgress=[[NSMutableDictionary alloc]init];
        self.finishedLines=[[NSMutableArray alloc]init];
        self.backgroundColor=[UIColor grayColor];
        self.multipleTouchEnabled=YES;
    }
    return self;
}

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

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"%@",NSStringFromSelector(_cmd));
    for(UITouch *t in touches){
        NSValue *key=[NSValue valueWithNonretainedObject:t];
        [self.linesInProgress removeObjectForKey:key];
    }
    
    [self setNeedsDisplay];
}
@end
