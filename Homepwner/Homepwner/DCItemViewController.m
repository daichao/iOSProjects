//
//  ViewController.m
//  Homepwner
//
//  Created by daichao on 15/6/11.
//  Copyright (c) 2015年 daichao. All rights reserved.
//

#import "DCItemViewController.h"
#import "BNRItem.h"
#import "DCItemStore.h"

@interface DCItemViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation DCItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
-(instancetype)init{
    self=[super initWithStyle:UITableViewStylePlain];
    if (self) {
        for(int i=0;i<5;i++){
            [[DCItemStore sharedStore]createItem];
        }
    }
    return self;
}
-(instancetype)initWithStyle:(UITableViewStyle)style{
   return  [self init];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[[DCItemStore sharedStore]allItems]count];
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableCell"];
    NSArray *items=[[DCItemStore sharedStore] allItems];
    BNRItem *item=[items objectAtIndex:indexPath.row];
    cell.textLabel.text=[item debugDescription];
    return cell;
}


@end
