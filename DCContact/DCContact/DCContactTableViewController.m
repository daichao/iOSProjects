//
//  DCContactTableViewController.m
//  DCContact
//
//  Created by bokeadmin on 15/6/5.
//  Copyright (c) 2015年 bokeadmin. All rights reserved.
//

#import "DCContactTableViewController.h"
#import "DCContact.h"
#import "DCContactGroup.h"
#define dSearchbarHeight 44

@interface DCContactTableViewController ()<UISearchBarDelegate>{
    UITableView *_tableView;
    UISearchBar *_searchBar;
    NSMutableArray *_contacts;//联系人模型
    NSMutableArray *_searchContacts;//符合条件的搜索联系人
    BOOL _isSearching;
    
}
@end

@implementation DCContactTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化数据
    [self initData];
    //添加搜索框
    [self addSearchBar];
    

}


#pragma mark 数据源方法
//分组数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if(_isSearching){
        return 1;
    }
    return _contacts.count;
}

//每组行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_isSearching) {
        return _searchContacts.count;
    }
    DCContactGroup *group1=_contacts[section];
    return group1.contacts.count;
    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DCContact *contact=nil;
    if(_isSearching){
        contact=_searchContacts[indexPath.row];
        
    }
    else{
        DCContactGroup *group =_contacts[indexPath.section];
        contact=group.contacts[indexPath.row];
    }
    
    
    static NSString *cellIdentifies=@"UITableViewCellIdentifierKey1";
    
    //首先根据标示去缓存池取
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifies];
    if(!cell){
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifies];
    }
    cell.textLabel.text=[contact getName];
    cell.detailTextLabel.text=contact.phoneNumber;
    return  cell;
    
}
#pragma mark 代理方法
#pragma mark 设置分组标题
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    DCContactGroup *group=_contacts[section];
    return group.name;
}

#pragma mark 搜索框代理
#pragma mark 取消搜索
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    _isSearching=NO;
    _searchBar.text=@"";
    [self.tableView reloadData];
    
}

#pragma mark 输入搜索关键字
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if([_searchBar.text isEqual:@""]){
        _isSearching=NO;
        [self.tableView reloadData];
        return;
    }
    [self searchDataWithKeyWord:_searchBar.text];
}

#pragma mark 点击虚拟键盘上的搜索时
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self searchDataWithKeyWord:_searchBar.text];
    [_searchBar resignFirstResponder];//放弃第一响应者对象，关闭虚拟键盘
}

#pragma mark 重写状态样式方法
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
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



#pragma mark 搜索形成新数据
-(void)searchDataWithKeyWord:(NSString*)keyWord{
    _isSearching=YES;
    _searchContacts=[NSMutableArray array];
    [_contacts enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        DCContactGroup *group=obj;
        [group.contacts enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            DCContact *contact=obj;
            if ([contact.firstName.uppercaseString containsString:keyWord.uppercaseString]||
                [contact.lastName.uppercaseString containsString:keyWord.uppercaseString]||[contact.phoneNumber containsString:keyWord]) {
                [_searchContacts addObject:contact];
            }
        }];
    }];
    
    //刷新表格，一定要加上，否则没效果,然后去调用数据源方法，根据定义的搜索状态去决定显示原始数据还是搜索结果。
    [self.tableView reloadData];
}



#pragma mark 添加搜索栏
-(void)addSearchBar{
    CGRect searchBarRect=CGRectMake(0, 0, self.view.frame.size.width, dSearchbarHeight);
    _searchBar=[[UISearchBar alloc]initWithFrame:searchBarRect];
    _searchBar.placeholder=@"Please input key word...";
    _searchBar.showsCancelButton=YES;//显示取消按钮
    
    _searchBar.delegate=self;
    self.tableView.tableHeaderView=_searchBar;
}

@end