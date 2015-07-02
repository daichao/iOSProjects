//
//  DCAssetTypeViewController.m
//  Homepwner
//
//  Created by bokeadmin on 15/7/2.
//  Copyright (c) 2015年 daichao. All rights reserved.
//

#import "DCAssetTypeViewController.h"
#import "DCItemStore.h"
#import "BNRItem.h"

@interface DCAssetTypeViewController ()

@end

@implementation DCAssetTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(instancetype)init{
    return [super initWithStyle:UITableViewStylePlain];
}
-(instancetype)initWithStyle:(UITableViewStyle)style{
    return [self init];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[[DCItemStore sharedStore]allAssetTypes]count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    NSArray *allAssets=[[DCItemStore sharedStore]allAssetTypes];
    NSManagedObject *assetType=allAssets[indexPath.row];
    
    //通过键值编码得到DCAssetType对象的label属性
    NSString *assetLabel=[assetType valueForKey:@"label"];
    cell.textLabel.text=assetLabel;
    
    //为当前选中的对象加上勾选标记
    if (assetType==self.item.assetType) {
        cell.accessoryType=UITableViewCellAccessoryCheckmark;
    }
    else{
        cell.accessoryType=UITableViewCellAccessoryNone;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType=UITableViewCellAccessoryCheckmark;
    NSArray *allAssets=[[DCItemStore sharedStore]allAssetTypes];
    NSManagedObject *assetType=allAssets[indexPath.row];
    self.item.assetType=assetType;
    [self.navigationController popViewControllerAnimated:YES];
}

@end
