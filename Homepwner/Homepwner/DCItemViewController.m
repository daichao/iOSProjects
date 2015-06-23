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

@interface DCItemViewController ()<UITableViewDataSource>
@property(nonatomic,strong)IBOutlet UIView *headerView;//IBOutlet插座变量

@end

@implementation DCItemViewController

//-(UIView*)headerView{
//    if(!_headerView){
//        [[NSBundle mainBundle]loadNibNamed:@"HeaderView" owner:self options:nil];
//    }
//    return _headerView;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 注册一个标示符
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
//    UIView *header=self.headerView;
//    [self.tableView setTableHeaderView:header];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}
-(instancetype)init{
    self=[super initWithStyle:UITableViewStylePlain];
    if (self) {
        UINavigationItem *navItem=self.navigationItem;
        navItem.title=@"Homepwner";
        
        UIBarButtonItem *bbi=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:
                              UIBarButtonSystemItemAdd target:self action:@selector(addNewItem:)];
        navItem.rightBarButtonItem=bbi;
        navItem.leftBarButtonItem=self.editButtonItem;
    }
    return self;
}
#pragma mark 默认指定初始化
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
    DCDetailViewController *detailViewController=[[DCDetailViewController alloc]initForNewItem:YES];
    detailViewController.item=newItem;
    UINavigationController *navController=[[UINavigationController alloc]initWithRootViewController:detailViewController];
    [self presentViewController:navController animated:YES completion:nil];
//    //获取新创建的对象在allItems数组中的索引
//    NSInteger lastRow=[[[DCItemStore sharedStore]allItems]indexOfObject:newItem];
//    //在第一个表格段（section：0）插入与allItems数组中对象相对应的索引
//    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:lastRow inSection:0];
//    //将新行插入UITableView对象
//    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
    
}
#pragma mark 编辑按钮事件
//-(IBAction)toggleEditingMode:(id)sender{
//    if (self.isEditing) {
//        [sender setTitle:@"Edit" forState:UIControlStateNormal];
//        [self setEditing:NO animated:YES];
//    }else{
//        [sender setTitle:@"Done" forState:UIControlStateNormal];
//        [self setEditing:YES animated:YES];
//    }
//}

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
//点击选择了某一行
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    DCDetailViewController *detailView=[[DCDetailViewController alloc]init];
    DCDetailViewController *detailView=[[DCDetailViewController alloc]initForNewItem:NO];
    NSArray *items=[[DCItemStore sharedStore]allItems];
    BNRItem *selectedItem=items[indexPath.row];
    detailView.item=selectedItem;
    [self.navigationController pushViewController:detailView animated:YES];
    
}

@end
