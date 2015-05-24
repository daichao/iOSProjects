//
//  AppDelegate.m
//  HypnoNerd
//
//  Created by daichao on 15/5/22.
//  Copyright (c) 2015年 daichao. All rights reserved.
//

#import "AppDelegate.h"
#import "BNRHypnosisViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window=[[UIWindow alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    BNRHypnosisViewController *hvc=[[BNRHypnosisViewController alloc]init];
    self.window.rootViewController=hvc;
    /**
     *如果是自己实现rootViewController
     -(void)setRootViewController:(UIViewController *)viewController{
        //获取根视图控制器的视图
     UIView *rootView=viewController.view;
     
     //根据UIWindow对象的bounds，为视图创建相应的frame
     CGRect viewFrame=self.bounds;
     rootView.frame=viewFrame;
     
     //将视图作为子视图加入UIWindow对象
     [self addSubView:rootView];
     
     //将viewController赋给实例变量_rootViewController
     _rootViewController=viewController;
     }
     **/
    self.window.backgroundColor=[UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
