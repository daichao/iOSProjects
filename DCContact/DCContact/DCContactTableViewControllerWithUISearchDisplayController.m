//
//  DCContactTableViewControllerWithUISearchDisplayController.m
//  DCContact
//
//  Created by bokeadmin on 15/6/5.
//  Copyright (c) 2015年 bokeadmin. All rights reserved.
//

#import "DCContactTableViewControllerWithUISearchDisplayController.h"
#import "DCContact.h"
#import "DCContactGroup.h"
#define dSearchbarHeight 44

@interface DCContactTableViewControllerWithUISearchDisplayController ()<UISearchBarDelegate,UISearchDisplayDelegate>{
    UITableView *_tableView;
    UISearchBar *_searchBar;
    UISearchDisplayController *_searchDisplayController;//在ios8.0以后就替代了UISearchDisplayController
    NSMutableArray *_contacts;//联系人模型
    NSMutableArray *_searchContacts;//符合条件的搜索联系人
    
    
}

@end

@implementation DCContactTableViewControllerWithUISearchDisplayController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    
    [self addSearchBar];
    
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    
    //如果当前是UISearchDisplayController内部的tableView则不分组
    if (tableView==self.searchDisplayController.searchResultsTableView) {
        return 1;
    }
    return _contacts.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

   
    //如果当前是UISearchDisplayController内部的tableView则使用搜索数据
    if (tableView==self.searchDisplayController.searchResultsTableView) {
        return _searchContacts.count;
    }
    DCContactGroup *group1=_contacts[section];
    return group1.contacts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DCContact *contact=nil;
    //如果当前是UISearchDisplayController内部的tableView则使用搜索数据
    if (tableView==self.searchDisplayController.searchResultsTableView) {
        contact=_searchContacts[indexPath.row];
    }else{
        DCContactGroup *group=_contacts[indexPath.section];
        contact=group.contacts[indexPath.row];
    }
    
    static NSString *cellIdentifier=@"UITableViewCellIdentifierKey1";
    
    //首先根据标识去缓存池取
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    //如果缓存池没有取到则重新创建并放到缓存池中
    if(!cell){
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text=[contact getName];
    cell.detailTextLabel.text=contact.phoneNumber;
    
    return cell;
}


#pragma mark - 代理方法
#pragma mark 设置分组标题
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (tableView==self.searchDisplayController.searchResultsTableView) {
        return @"搜索结果";
    }
    DCContactGroup *group=_contacts[section];
    return group.name;
}
#pragma mark 选中之前
-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_searchBar resignFirstResponder];//退出键盘
    return indexPath;
}

#pragma mark - UISearchDisplayController代理方法
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString{
    [self searchDataWithKeyWord:searchString];
    return YES;
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
-(void)searchDataWithKeyWord:(NSString *)keyWord{
    //_isSearching=YES;
    _searchContacts=[NSMutableArray array];
    [_contacts enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        DCContactGroup *group=obj;
        [group.contacts enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            DCContact *contact=obj;
            if ([contact.firstName.uppercaseString containsString:keyWord.uppercaseString]||[contact.lastName.uppercaseString containsString:keyWord.uppercaseString]||[contact.phoneNumber containsString:keyWord]) {
                [_searchContacts addObject:contact];
            }
        }];
    }];
}
#pragma mark 添加搜索栏
-(void)addSearchBar{
    _searchBar=[[UISearchBar alloc]init];
    [_searchBar sizeToFit];//大小自适应容器
    _searchBar.placeholder=@"Please input key word...";
    _searchBar.autocapitalizationType=UITextAutocapitalizationTypeNone;
    _searchBar.showsCancelButton=YES;//显示取消按钮
    //添加搜索框到页眉位置
    _searchBar.delegate=self;
    self.tableView.tableHeaderView=_searchBar;
    
    _searchDisplayController=[[UISearchDisplayController alloc]initWithSearchBar:_searchBar contentsController:self];
    _searchDisplayController.delegate=self;
    _searchDisplayController.searchResultsDataSource=self;
    _searchDisplayController.searchResultsDelegate=self;
    [_searchDisplayController setActive:NO animated:YES];
    
}

@end
