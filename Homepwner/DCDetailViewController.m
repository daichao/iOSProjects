//
//  DCDetailViewController.m
//  Homepwner
//
//  Created by bokeadmin on 15/6/12.
//  Copyright (c) 2015年 daichao. All rights reserved.
//

#import "DCDetailViewController.h"
#import "BNRItem.h"

@interface DCDetailViewController ()

@end

@implementation DCDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
//view将要出现时调用
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    BNRItem *item=self.item;
    self.nameField.text=item.itemName;
    self.serialNumberField.text=item.serialNumber;
    self.valueField.text=[NSString stringWithFormat:@"%d",item.valueInDollars ];
    
    //创建NSDateFormatter 对象，用于将NSDate对象转化为简单的日期字符串
    static NSDateFormatter *dateFormatter=nil;
    if (!dateFormatter) {
        dateFormatter=[[NSDateFormatter alloc]init];
        dateFormatter.dateStyle=NSDateFormatterMediumStyle;
        dateFormatter.timeStyle=NSDateFormatterNoStyle;
    }
    
    //将转换后的日期字符串设置为dateLabel的标题
    self.dateLabel.text=[dateFormatter stringFromDate:item.dateCreated];
}
//view将要消失时调用
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    
    [self.view endEditing:YES];
    BNRItem *item=self.item;
    item.itemName=self.nameField.text;
    item.serialNumber=self.serialNumberField.text;
    item.valueInDollars=[self.valueField.text intValue];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
