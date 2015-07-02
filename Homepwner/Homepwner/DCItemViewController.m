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
#import "DCItemCell.h"
#import "DCImageStore.h"
#import "DCImageViewController.h"


@interface DCItemViewController ()<UITableViewDataSource,UIPopoverControllerDelegate>
@property(nonatomic,strong)IBOutlet UIView *headerView;//IBOutlet插座变量
@property(nonatomic,strong)UIPopoverController *imagePopover;
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
//    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    //创建UINib对象，该对象代表包含了DCItemCell的NIB文件
    UINib *nib=[UINib nibWithNibName:@"DCItemCell" bundle:nil];
    //通过UINib对象注册相应的nib文件
    [self.tableView registerNib:nib forCellReuseIdentifier:@"DCItemCell"];
//    UIView *header=self.headerView;
//    [self.tableView setTableHeaderView:header];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [self.tableView reloadData];
    [self updateTableViewForDynamicTypeSize];
}

-(void)updateTableViewForDynamicTypeSize{
    static NSDictionary *cellHeightDictionary;
    if(!cellHeightDictionary){
        cellHeightDictionary=@{
                               UIContentSizeCategoryExtraExtraExtraLarge:@75,
                               UIContentSizeCategoryExtraExtraLarge:@65,
                               UIContentSizeCategoryExtraLarge:@55,
                               UIContentSizeCategoryLarge:@44,
                               UIContentSizeCategoryMedium:@44,
                               UIContentSizeCategorySmall:@44,
                               UIContentSizeCategoryExtraSmall:@44
                               };
    }
    NSString *userSize=[[UIApplication sharedApplication]preferredContentSizeCategory];
    
    NSNumber *cellHeight=cellHeightDictionary[userSize];
    [self.tableView setRowHeight:cellHeight.floatValue];
    [self.tableView reloadData];
    
}


-(instancetype)init{
    self=[super initWithStyle:UITableViewStylePlain];
    if (self) {
        UINavigationItem *navItem=self.navigationItem;
        navItem.title=@"Homepwner";
        
        self.restorationIdentifier=NSStringFromClass([self class]);
        self.restorationClass=[self class];
        
        UIBarButtonItem *bbi=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:
                              UIBarButtonSystemItemAdd target:self action:@selector(addNewItem:)];
        navItem.rightBarButtonItem=bbi;
        navItem.leftBarButtonItem=self.editButtonItem;
        
        
        NSNotificationCenter *nc=[NSNotificationCenter defaultCenter];
        [nc addObserver:self selector:@selector(updateTableViewForDynamicTypeSize) name:UIContentSizeCategoryDidChangeNotification object:nil];
    }
    return self;
}

-(void)dealloc{
    NSNotificationCenter *NC=[NSNotificationCenter defaultCenter];
    [NC removeObserver:self];
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
//    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    //获取DCItemCell对象，返回的可能是现有的对象，也可能是新创建的对象
    DCItemCell *cell=[tableView dequeueReusableCellWithIdentifier:@"DCItemCell" forIndexPath:indexPath];
    NSArray *items=[[DCItemStore sharedStore] allItems];
    BNRItem *item=[items objectAtIndex:indexPath.row];
//    cell.textLabel.text=[item debugDescription];
    //根据DCItemCell对象设置DCItemCell对象
    cell.nameLabel.text=item.itemName;
    cell.serialNumberLabel.text=item.serialNumber;
    cell.valueLabel.text=[NSString stringWithFormat:@"$%d",item.valueInDollars];
    cell.thumbnailView.image=item.thumbnail;
    __weak DCItemCell *weakCell =cell;
    cell.actionBlock=^{
        NSLog(@"Going to show image for %@",item);
        DCItemCell *strongCell=weakCell;
        if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPad){
            NSString *itemKey=item.itemKey;
            UIImage *img=[[DCImageStore sharedStore]imageForKey:itemKey];
            if(!img){
                return;
            }
            //根据UITableView对象的坐标系获取UIImageView对象的位置和大小
//            CGRect rect=[self.view convertRect:cell.thumbnailView.bounds fromView:cell.thumbnailView];
            CGRect rect=[self.view convertRect:strongCell.thumbnailView.bounds fromView:strongCell.thumbnailView];
            DCImageViewController *ivc=[[DCImageViewController alloc]init];
            ivc.image=img;
            
            self.imagePopover=[[UIPopoverController alloc]initWithContentViewController:ivc];
            self.imagePopover.delegate=self;
            self.imagePopover.popoverContentSize=CGSizeMake(600, 600) ;
            [self.imagePopover presentPopoverFromRect:rect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        }
    };
    return cell;
}

-(void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController{
    self.imagePopover=nil;
}

-(IBAction)addNewItem :(id)sender{
//    NSInteger lastRow=[self.tableView numberOfRowsInSection:0];
    BNRItem *newItem=[[DCItemStore sharedStore]createItem];
    DCDetailViewController *detailViewController=[[DCDetailViewController alloc]initForNewItem:YES];
    detailViewController.item=newItem;
    detailViewController.dismissBlock=^{
        [self.tableView reloadData];
    };
    UINavigationController *navController=[[UINavigationController alloc]initWithRootViewController:detailViewController];
    navController.restorationIdentifier=NSStringFromClass([navController class]);
    navController.modalPresentationStyle=UIModalPresentationFormSheet;//模态显示
    /*
     不可以这样写，否则detailview会覆盖itemview，但是navigationbar不会被覆盖，也就是说由父视图控制器显示子视图
     */
//    navController.modalPresentationStyle=UIModalPresentationCurrentContext;
//    self.definesPresentationContext=YES;
//    navController.modalTransitionStyle=UIModalTransitionStyleCoverVertical;//从底部滑入
//    navController.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;//淡入
    navController.modalTransitionStyle=UIModalTransitionStyleFlipHorizontal;//3D效果翻转
    
    //模拟书页卷角,如果使用这个效果，则必须确保view全屏显示，与上面三个动画效果不同，使用书页卷角动画，必须将
    // navController.modalPresentationStyle=UIModalPresentationFormSheet;注释掉
//    navController.modalTransitionStyle=UIModalTransitionStylePartialCurl;
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
