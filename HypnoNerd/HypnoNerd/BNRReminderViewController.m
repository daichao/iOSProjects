//
//  BNRReminderViewController.m
//  HypnoNerd
//
//  Created by bokeadmin on 15/5/25.
//  Copyright (c) 2015年 daichao. All rights reserved.
//

#import "BNRReminderViewController.h"

@interface BNRReminderViewController ()

@property (nonatomic,weak)IBOutlet UIDatePicker *datePicker;

@end

@implementation BNRReminderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSLog(@"BNRReminderViewController loaded its view.");
}
//如果是viewDidLoad，则只会在view被加载的第一次设置，而viewWillAppear，则每次加载view时都调用
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];//animated参数用于设置是否使用视图显示或消失的过渡动画
    self.datePicker.minimumDate=[NSDate dateWithTimeIntervalSinceNow:60];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self=[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self){
        UITabBarItem *tbi=self.tabBarItem;
        tbi.title=@"Reminder";
        UIImage *i=[UIImage imageNamed:@"Time.png"];
        tbi.image=i;
    }
    return self;
}

-(IBAction)addReminder:(id)sender{
    
    NSDate *date=self.datePicker.date;
    NSLog(@"Setting a reminder for %@",date);
    UILocalNotification *note=[[UILocalNotification alloc]init];
    note.alertBody=@"Hypnotize me!";
    note.fireDate=date;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:note];
}
@end
