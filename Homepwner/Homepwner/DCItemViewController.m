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
@property(nonatomic,strong)IBOutlet UIView *headerView;//IBOutlet插座变量

@end

@implementation DCItemViewController

-(UIView*)headerView{
    if(!_headerView){
        [[NSBundle mainBundle]loadNibNamed:@"HeaderView" owner:self options:nil];
    }
    return _headerView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    UIView *header=self.headerView;
    [self.tableView setTableHeaderView:header];
}

-(instancetype)init{
    self=[super initWithStyle:UITableViewStylePlain];
    if (self) {
//        for(int i=0;i<5;i++){
//            [[DCItemStore sharedStore]createItem];
//        }
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
//    UITableViewCell *cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableCell"];
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    NSArray *items=[[DCItemStore sharedStore] allItems];
    BNRItem *item=[items objectAtIndex:indexPath.row];
    cell.textLabel.text=[item debugDescription];
    return cell;
}

-(IBAction)addNewItem :(id)sender{
//    NSInteger lastRow=[self.tableView numberOfRowsInSection:0];
    BNRItem *newItem=[[DCItemStore sharedStore]createItem];
    //获取新创建的对象在allItems数组中的索引
    NSInteger lastRow=[[[DCItemStore sharedStore]allItems]indexOfObject:newItem];
    //在第一个表格段（section：0）插入与allItems数组中对象相对应的索引
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:lastRow inSection:0];
    //将新行插入UITableView对象
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
    
}

-(IBAction)toggleEditingMode:(id)sender{
    if (self.isEditing) {
        [sender setTitle:@"Edit" forState:UIControlStateNormal];
        [self setEditing:NO animated:YES];
    }else{
        [sender setTitle:@"Done" forState:UIControlStateNormal];
        [self setEditing:YES animated:YES];
    }
}
#pragma mark 删除表格行
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle==UITableViewCellEditingStyleDelete) {
        //删除数据
        NSArray *items=[[DCItemStore sharedStore]allItems];
        BNRItem *item=items[indexPath.row];
        [[DCItemStore sharedStore]removeItem:item];
        //删除表格视图中相应的表格行
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

#pragma mark 移动表格行
-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
    [[DCItemStore sharedStore]moveItemAtIndex:sourceIndexPath.row toIndex:destinationIndexPath.row];
}

@end
