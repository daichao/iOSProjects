//
//  BNRHypnosisViewController.m
//  HypnoNerd
//
//  Created by daichao on 15/5/22.
//  Copyright (c) 2015年 daichao. All rights reserved.
//

#import "BNRHypnosisViewController.h"
#import "BNRHypnosisView.h"
@interface BNRHypnosisViewController()<UITextFieldDelegate>
@end


@implementation BNRHypnosisViewController

-(void)loadView{
    CGRect frame=[[UIScreen mainScreen]bounds];
    
    BNRHypnosisView *backgroundView=[[BNRHypnosisView alloc]initWithFrame:frame];
    
    CGRect textfieldRect=CGRectMake(70, 70, 240, 30);
    UITextField *textField=[[UITextField alloc]initWithFrame:textfieldRect];
    
    textField.borderStyle=UITextBorderStyleRoundedRect;//边框的类型
    textField.placeholder=@"Hypnotize me";//输入框默认内容
    textField.returnKeyType=UIReturnKeyDone;//将return键改为Done
//    textField.autocapitalizationType=WORD_BIT;//自动大写功能
//    textField.autocorrectionType=YES;//拼写建议功能
//    textField.enablesReturnKeyAutomatically=YES;//自动换行
////    textField.keyboardType=URL;
//    textField.secureTextEntry=YES;//将输入内容转为“.”，通常用于输入密码。
    textField.delegate=self;
    
    [backgroundView addSubview:textField];
    self.view=backgroundView;
}

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self=[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self){
        self.tabBarItem.title=@"Hypnotize";
        
        UIImage *i=[UIImage imageNamed:@"Hypno.png"];
        
        self.tabBarItem.image=i;
    }
    return self;
}
-(void)viewDidLoad{
    [super viewDidLoad];
    NSLog(@"BNRHypnosisViewController loaded its view.");
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
//    NSLog(@"%@",textField.text);
    [self drawHypnoticMessage:textField.text];
    textField.text=@"";
    [textField resignFirstResponder];
    return  YES;
}

//随机绘制20个UILabel对象
-(void)drawHypnoticMessage:(NSString *)message{
    for(int i=0;i<20;i++){
        UILabel *messageLabel=[[UILabel alloc]init];
        //设置UILabel对象的文字和颜色
        messageLabel.backgroundColor=[UIColor clearColor];
        messageLabel.textColor=[UIColor whiteColor];
        messageLabel.text=message;
        
        //根据需要显示的文字调整UILabel对象的大小
        [messageLabel sizeToFit];
        
        //获取随机x坐标
        //是UILabel对象的宽度不超出BNRHypnosisViewController的view宽度
        int width=(int)(self.view.bounds.size.width-messageLabel.bounds.size.width);
        int x=arc4random()%width;
        
        //获取随机y坐标
        //使UILabel对象的高度不超出BNRHypnosisViewController的view高度
        int height=(int)(self.view.bounds.size.height-messageLabel.bounds.size.height);
        int y=arc4random()%height;
        
        //设置UILabel对象的frame
        CGRect frame=messageLabel.frame;
        frame.origin=CGPointMake(x, y);
        messageLabel.frame=frame;
        
        //将uilabel对象添加到BNRHypnosisViewController的view中
        [self.view addSubview:messageLabel];
        
        
        //添加运动效果，必须在真机上运行，稍倾斜屏幕，会发现UILabel对象会随着倾斜方向移动
        UIInterpolatingMotionEffect *motionEffect;
        motionEffect=[[UIInterpolatingMotionEffect alloc]initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
        motionEffect.minimumRelativeValue=@(-25);
        motionEffect.maximumRelativeValue=@(25);
        [messageLabel addMotionEffect:motionEffect];
        
        
        motionEffect=[[UIInterpolatingMotionEffect alloc]initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
        motionEffect.minimumRelativeValue=@(-25);
        motionEffect.maximumRelativeValue=@(25);
        [messageLabel addMotionEffect:motionEffect];
    }
}
@end
