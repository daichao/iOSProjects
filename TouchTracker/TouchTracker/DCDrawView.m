//
//  DCDrawView.m
//  TouchTracker
//
//  Created by bokeadmin on 15/6/16.
//  Copyright (c) 2015年 bokeadmin. All rights reserved.
//

#import "DCDrawView.h"
#import "DCLine.h"
@interface DCDrawView()<UIGestureRecognizerDelegate>
//@property (nonatomic,strong)DCLine *currentLine;
@property(nonatomic,strong)UIPanGestureRecognizer *moveRecognizer;
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
//-(int)numberOfLines{
//    int count=0;
//    if(_finishedLines&&_linesInProgress){
//        count=[_finishedLines count]+[_linesInProgress count];
//    }
//    return count;
//}
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
//    [self.finishedLines removeAllObjects];
    self.finishedLines=[[NSMutableArray alloc]init];
    [self setNeedsDisplay];
}
#pragma mark 删除线条
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
        //使视图成为UIMenuItem动作消息的目标
        [self becomeFirstResponder];
        //获取UIMenuController对象
        UIMenuController *menu=[UIMenuController sharedMenuController];
        //创建一个新的标题为“Delete”的UIMenuIetm对象
        UIMenuItem *deleteItem=[[UIMenuItem alloc]initWithTitle:@"Delete" action:@selector(deleteLine:)];
        menu.menuItems=@[deleteItem];
        //先为UIMenuController对象设置显示区域，然后将其设置为可见
        [menu setTargetRect:CGRectMake(point.x, point.y, 2, 2) inView:self];
        [menu setMenuVisible:YES animated:YES];
    }
    else{
        //如果没有选中的线条，就隐藏UIMenuController对象
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
#pragma mark 长按实现
-(void)longPress:(UIGestureRecognizer*)gr{
    if(gr.state==UIGestureRecognizerStateBegan){
        CGPoint point=[gr locationInView:self];
        self.selectedLine =[self lineAtPoint:point];
        
        if(self.selectedLine){
            [self.linesInProgress removeAllObjects];
        }
    }else if(gr.state==UIGestureRecognizerStateEnded){
        self.selectedLine=nil;
        
    }
    [self setNeedsDisplay];
    
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    if(gestureRecognizer==self.moveRecognizer){
        return YES;
    }
    return NO;
}


#pragma mark 移动
-(void)moveLine:(UIPanGestureRecognizer*)gr{
    if(!self.selectedLine){
        return;
    }
    if(gr.state==UIGestureRecognizerStateChanged){
        //获取手指的拖移距离
        CGPoint translation=[gr translationInView:self];
        
        //将拖移距离加至选中的线条的起点和终点
        CGPoint begin=self.selectedLine.begin;
        CGPoint end=self.selectedLine.end;
        begin.x+=translation.x;
        begin.y+=translation.y;
        end.x+=translation.x;
        end.y+=translation.y;
        //为选中的线条设置新的起点和终点
        self.selectedLine.begin=begin;
        self.selectedLine.end=end;
        
        [self setNeedsDisplay];
        //将手指的当前位置设置为拖移手势的起始位置
        [gr setTranslation:CGPointZero inView:self];
    }
}

#pragma mark 初始化界面
-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if(self){
        self.linesInProgress=[[NSMutableDictionary alloc]init];
        self.finishedLines=[[NSMutableArray alloc]init];
        self.backgroundColor=[UIColor grayColor];
        self.multipleTouchEnabled=YES;
        //双击
        UITapGestureRecognizer *doubleTapRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTap:)];
        doubleTapRecognizer.numberOfTapsRequired=2;
        doubleTapRecognizer.delaysTouchesBegan=YES;
        [self addGestureRecognizer:doubleTapRecognizer];
        //单击
        UITapGestureRecognizer *tapRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
        tapRecognizer.delaysTouchesBegan=YES;
        //区分双击和单击
        [tapRecognizer requireGestureRecognizerToFail:doubleTapRecognizer];
        [self addGestureRecognizer:tapRecognizer];
        //长按
        UILongPressGestureRecognizer *pressRecognizer=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
        [self addGestureRecognizer:pressRecognizer];
        //拖移
        self.moveRecognizer=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(moveLine:)];
        self.moveRecognizer.delegate=self;
        //当cancelsTouchesInView的值为NO时，意味着这个对象所依附的UIVIEW对象仍然会收到相应的UIResponder消息，从而有机会处理相关的UITouch对象。
        self.moveRecognizer.cancelsTouchesInView=NO;
        [self addGestureRecognizer:_moveRecognizer];
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
        line.containingArray=self.finishedLines;
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
