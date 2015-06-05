//
//  ViewController.m
//  DCContact
//
//  Created by bokeadmin on 15/6/4.
//  Copyright (c) 2015年 bokeadmin. All rights reserved.
//

#import "ViewController.h"
#import "DCContact.h"
#import "DCContactGroup.h"
#define kContactToolbarHeight 44

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>{
    UITableView *_tableView;
    NSMutableArray *_contacts;//联系人模型
    NSIndexPath *_selectedIndexPath;//当前选中的组和行
    UIToolbar *_toolbar;
    BOOL _isInsert;//记录是点击了插入还是删除按钮
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self initData];
    //创建一个分组样式的UITableView
    _tableView=[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.contentInset=UIEdgeInsetsMake(kContactToolbarHeight, 0, 0, 0);
     [self.view addSubview:_tableView];
    //添加工具栏
     [self addToolbar];
    
    //设置数据源
    _tableView.dataSource=self;
    //设置代理
    _tableView.delegate=self;
    
   
   
    
}

#pragma mark 加载数据
-(void)initData{
    _contacts=[[NSMutableArray alloc]init];
    DCContact *contact1=[DCContact initWithFirstName:@"Cui" andLastName:@"Kenshin" andPhoneNumber:@"18500131234"];
    DCContact *contact2=[DCContact initWithFirstName:@"Cui" andLastName:@"Tom" andPhoneNumber:@"18500131237"];
    DCContactGroup *group1=[DCContactGroup initWithName:@"C" andDetail:@"With names beginning with C" andContacts:[NSMutableArray arrayWithObjects:contact1,contact2, nil]];
    [_contacts addObject:group1];
    
    
    
    DCContact *contact3=[DCContact initWithFirstName:@"Lee" andLastName:@"Terry" andPhoneNumber:@"18500131238"];
    DCContact *contact4=[DCContact initWithFirstName:@"Lee" andLastName:@"Jack" andPhoneNumber:@"18500131239"];
    DCContact *contact5=[DCContact initWithFirstName:@"Lee" andLastName:@"Rose" andPhoneNumber:@"18500131240"];
    DCContactGroup *group2=[DCContactGroup initWithName:@"L" andDetail:@"With names beginning with L" andContacts:[NSMutableArray arrayWithObjects:contact3,contact4,contact5, nil]];
    [_contacts addObject:group2];
    
    
    
    DCContact *contact6=[DCContact initWithFirstName:@"Sun" andLastName:@"Kaoru" andPhoneNumber:@"18500131235"];
    DCContact *contact7=[DCContact initWithFirstName:@"Sun" andLastName:@"Rosa" andPhoneNumber:@"18500131236"];
    
    DCContactGroup *group3=[DCContactGroup initWithName:@"S" andDetail:@"With names beginning with S" andContacts:[NSMutableArray arrayWithObjects:contact6,contact7, nil]];
    [_contacts addObject:group3];
    
    
    DCContact *contact8=[DCContact initWithFirstName:@"Wang" andLastName:@"Stephone" andPhoneNumber:@"18500131241"];
    DCContact *contact9=[DCContact initWithFirstName:@"Wang" andLastName:@"Lucy" andPhoneNumber:@"18500131242"];
    DCContact *contact10=[DCContact initWithFirstName:@"Wang" andLastName:@"Lily" andPhoneNumber:@"18500131243"];
    DCContact *contact11=[DCContact initWithFirstName:@"Wang" andLastName:@"Emily" andPhoneNumber:@"18500131244"];
    DCContact *contact12=[DCContact initWithFirstName:@"Wang" andLastName:@"Andy" andPhoneNumber:@"18500131245"];
    DCContactGroup *group4=[DCContactGroup initWithName:@"W" andDetail:@"With names beginning with W" andContacts:[NSMutableArray arrayWithObjects:contact8,contact9,contact10,contact11,contact12, nil]];
    [_contacts addObject:group4];
    
    DCContact *contact13=[DCContact initWithFirstName:@"Zhang" andLastName:@"Joy" andPhoneNumber:@"18500131246"];
    DCContact *contact14=[DCContact initWithFirstName:@"Zhang" andLastName:@"Vivan" andPhoneNumber:@"18500131247"];
    DCContact *contact15=[DCContact initWithFirstName:@"Zhang" andLastName:@"Joyse" andPhoneNumber:@"18500131248"];
    DCContactGroup *group5=[DCContactGroup initWithName:@"Z" andDetail:@"With names beginning with Z" andContacts:[NSMutableArray arrayWithObjects:contact13,contact14,contact15, nil]];
    [_contacts addObject:group5];
    
}

#pragma mark 添加工具栏
-(void)addToolbar{
    CGRect frame=self.view.frame;
    _toolbar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, kContactToolbarHeight)];
    [self.view addSubview:_toolbar];
    UIBarButtonItem *removeButton=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(remove)];
    UIBarButtonItem *flexibleButton=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *addButton=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(add)];
    NSArray *buttonArray=[NSArray arrayWithObjects:removeButton,flexibleButton,addButton , nil];
    _toolbar.items=buttonArray;
}

#pragma mark 删除按钮
-(void)remove{
    //直接通过下面的方法设置编辑状态没有动画
    _isInsert=false;
    [_tableView setEditing:!_tableView.isEditing animated:true];
}

#pragma mark 添加按钮
-(void)add{
    _isInsert=true;
    [_tableView setEditing:!_tableView.isEditing animated:true];
}

#pragma mark 代理-编辑操作(删除或添加)
-(void)tableView:(UITableView*)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    DCContactGroup *group=_contacts[indexPath.section];
    DCContact *contact=group.contacts[indexPath.row];
    
    if(editingStyle==UITableViewCellEditingStyleDelete){
        [group.contacts removeObject:contact];
        //考虑到性能，这里不能使用reloaddata
        //使用下面的方法既可以局部刷新又有动画效果
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];
        //如果当前组中没有数据则移除组刷新整个表格
        if(group.contacts.count==0){
            [_contacts removeObject:group];
            [tableView reloadData];
        }
    }
    else if (editingStyle==UITableViewCellEditingStyleInsert){
        DCContact *newContact=[[DCContact alloc]init];
        newContact.firstName=@"first";
        newContact.lastName=@"last";
        newContact.phoneNumber=@"12345678901";
        [group.contacts insertObject:newContact atIndex:indexPath.row];
        [tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];
    }
}


#pragma mark 排序
//只要实现这个方法在编辑状态右侧就有排序图标
-(void)tableView:(UITableView*)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
    DCContactGroup *sourceGroup=_contacts[sourceIndexPath.section];
    DCContact *sourceContact=sourceGroup.contacts[sourceIndexPath.row];
    DCContactGroup *destinationGroup=_contacts[destinationIndexPath.section];
    
    [sourceGroup.contacts removeObject:sourceContact];
    [destinationGroup.contacts insertObject:sourceContact atIndex:destinationIndexPath.row];
    if(sourceGroup.contacts.count==0){
        [_contacts removeObject:sourceGroup];
        [tableView reloadData];
    }
}

#pragma  mark 取得当前操作状态 根据不同的状态左侧出现不同的操作按钮
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_isInsert) {
        return UITableViewCellEditingStyleInsert;
    }
    return UITableViewCellEditingStyleDelete;
}



#pragma mark - 数据源方法
#pragma mark 返回分组数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSLog(@"计算分组数");
    return _contacts.count;
}

#pragma mark 返回每组行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"计算每组(组%li)行数",section);
    DCContactGroup *group1=_contacts[section];
    return group1.contacts.count;
}

#pragma mark返回每行的单元格
/**
 *
 -(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)方法调用很频繁，无论是初始化、上下滚动、刷新都会调用此方法，所有在这里执行的操作一定要注意性能；
 可重用标识可以有多个，如果在UITableView中有多类结构不同的Cell，可以通过这个标识进行缓存和重新；
 */
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //NSIndexPath是一个结构体，记录了组和行信息
    NSLog(@"生成单元格(组：%li,行%li)",indexPath.section,indexPath.row);
    DCContactGroup *group=_contacts[indexPath.section];
    DCContact *contact=group.contacts[indexPath.row];
    
    //由于此方法调用十分频繁，cell的标示声明成静态变量有利于性能优化
    static NSString *cellIdentifier=@"UITableViewCellIdentifierKey1";
    static NSString *cellIdentifierForFirstRow=@"UITableViewCellIdentifiereKeyWithSwitch";
    
    //首先根据标示去缓存池取
    UITableViewCell *cell;
    if(indexPath.row==0){
        cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifierForFirstRow];
    }else{
        
        cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    }
    //如果缓存池没有则重新创建并放到缓存池中
    if(!cell){
        if (indexPath.row==0) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifierForFirstRow];
            UISwitch *sw=[[UISwitch alloc]init];
            [sw addTarget:self action:@selector(switchValueChange:) forControlEvents:UIControlEventValueChanged];
            cell.accessoryView=sw;
            
        }
        else{
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1    reuseIdentifier:cellIdentifier];
            cell.accessoryType=UITableViewCellAccessoryDetailButton;
        }
      
    }
    if(indexPath.row==0){
       ((UISwitch *)cell.accessoryView).tag=indexPath.section;
    }

    cell.textLabel.text=[contact getName];
    cell.detailTextLabel.text=contact.phoneNumber;
    NSLog(@"cell :%@",cell);
    return cell;
}

#pragma mark 返回每组头标题名称
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSLog(@"生成组（组%li）名称",section);
    DCContactGroup *group=_contacts[section];
    return group.name;
}

#pragma mark 返回每组尾部说明
-(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    NSLog(@"生成尾部（组%li）详情",section);
    DCContactGroup *group=_contacts[section];
    return group.detail;
}
#pragma mark 创建索引
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    NSLog(@"生成组索引");
    NSMutableArray *indexs=[[NSMutableArray alloc]init];
    for(DCContactGroup *group in _contacts){
        [indexs addObject:group.name];
    }
    return indexs;
}

#pragma mark -代理方法
#pragma mark 设置分组标题内容高度
-(CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section{
   
    return  40;
}

-(CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 50;
        
    }
    return 40;
}

-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}

#pragma mark 点击行
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _selectedIndexPath=indexPath;
    DCContactGroup *group=_contacts[indexPath.section];
    DCContact *contact=group.contacts[indexPath.row];
    //创建弹出窗口
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"System Info" message:[contact getName] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    alert.alertViewStyle=UIAlertViewStylePlainTextInput;
    UITextField *textField=[alert textFieldAtIndex:0];
    textField.text=contact.phoneNumber;
    [alert show];
}
#pragma mark 窗口代理方法，用户保存数据
-(void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    //当点击了第二个按钮OK
    if(buttonIndex==1){
        UITextField *textField=[alertView textFieldAtIndex:0];
        //修改模型数据
        DCContactGroup *group=_contacts[_selectedIndexPath.section];
        DCContact *contact=group.contacts[_selectedIndexPath.row];
        contact.phoneNumber=textField.text;
        //刷新表格
//        [_tableView reloadData];//不可取，刷新了整个UITableView
        NSArray *indexPaths=@[_selectedIndexPath];
        [_tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationLeft];//后面的参数代表更新时的动画
        
    }
}

#pragma mark重写状态样式方法
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

#pragma mark 切换开关转化事件
-(void)switchValueChange:(UISwitch*)sw{
    NSLog(@"section:%li,switch:%i",sw.tag,sw.on);
}


@end
