//
//  DCWebViewController.m
//  Nerdfeed
//
//  Created by bokeadmin on 15/6/29.
//  Copyright (c) 2015年 bokeadmin. All rights reserved.
//

#import "DCWebViewController.h"

@interface DCWebViewController ()

@end

@implementation DCWebViewController
-(void)loadView{
    UIWebView *webView=[[UIWebView alloc]init];
    webView.scalesPageToFit=YES;
    self.view=webView;
}

-(void)setUrl:(NSURL *)url{
    _url=url;
    if(_url){
        NSURLRequest *req=[NSURLRequest requestWithURL:_url];
        [(UIWebView*)self.view loadRequest:req];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)splitViewController:(UISplitViewController *)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)pc{
    barButtonItem.title=@"Courses";
    self.navigationItem.leftBarButtonItem=barButtonItem;
}

-(void)splitViewController:(UISplitViewController *)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem{
    if(barButtonItem==self.navigationItem.leftBarButtonItem){
        self.navigationItem.leftBarButtonItem=nil;
    }
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
