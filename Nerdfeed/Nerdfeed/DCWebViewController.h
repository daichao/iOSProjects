//
//  DCWebViewController.h
//  Nerdfeed
//
//  Created by bokeadmin on 15/6/29.
//  Copyright (c) 2015年 bokeadmin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DCWebViewController : UIViewController<UISplitViewControllerDelegate>
@property(nonatomic,strong)NSURL *url;
@end
