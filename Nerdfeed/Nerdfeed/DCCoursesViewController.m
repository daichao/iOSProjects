//
//  DCCoursesViewController.m
//  Nerdfeed
//
//  Created by bokeadmin on 15/6/29.
//  Copyright (c) 2015年 bokeadmin. All rights reserved.
//

#import "DCCoursesViewController.h"
#import "DCWebViewController.h"

@interface DCCoursesViewController ()<NSURLSessionDataDelegate>

@end

@implementation DCCoursesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
}

-(instancetype)initWithStyle:(UITableViewStyle)style{
    self=[super initWithStyle:style];
    if(self){
        self.navigationItem.title=@"DaiChao Courses";
        NSURLSessionConfiguration *config=[NSURLSessionConfiguration defaultSessionConfiguration];
        _session=[NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
        [self fetchFeed];
    }
    return self;
}

-(void)fetchFeed{
//    NSString *requestString=@"http://bookapi.bignerdranch.com/courses.json";
    NSString *requestString=@"https://bookapi.bignerdranch.com/private/courses.json";
    NSURL *url=[NSURL URLWithString:requestString];
    NSURLRequest *req=[NSURLRequest requestWithURL:url];
    NSURLSessionDataTask *dataTask=[self.session dataTaskWithRequest:req completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSDictionary *jsonObject=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        self.courses=jsonObject[@"courses"];
        NSLog(@"%@",_courses);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
    [dataTask resume];
}
//web认证
-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential *))completionHandler{
   
    NSURLCredential *cred=[NSURLCredential credentialWithUser:@"BigNerdRanch" password:@"AchieveNerdvana" persistence:NSURLCredentialPersistenceForSession];//用户名、密码、认证的有效期
    
    completionHandler(NSURLSessionAuthChallengeUseCredential,cred);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    // Return the number of sections.
//    return 0;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.courses count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    NSDictionary *course=self.courses[indexPath.row];
    cell.textLabel.text=course[@"title"];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *course=self.courses[indexPath.row];
    NSURL *URL=[NSURL URLWithString:course[@"url"]];
    self.webViewController.title=course[@"title"];
    self.webViewController.url=URL;
//    [self.navigationController pushViewController:self.webViewController animated:YES];
    //webview不是splitview的主从对象之一，但是masternav包含webview，所以webview也会返回splitview
    //如果ipad竖屏显示，则不会显示splitview，不会显示主从两个对象，但是会显示webview
    if(!self.splitViewController){
        [self.navigationController pushViewController:self.webViewController animated:YES];
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
