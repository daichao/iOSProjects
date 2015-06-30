//
//  DCCoursesViewController.h
//  Nerdfeed
//
//  Created by bokeadmin on 15/6/29.
//  Copyright (c) 2015年 bokeadmin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DCWebViewController;
@interface DCCoursesViewController : UITableViewController
@property(nonatomic,strong)NSURLSession *session;
@property(nonatomic,copy)NSArray *courses;
@property(nonatomic)DCWebViewController *webViewController;
@end
