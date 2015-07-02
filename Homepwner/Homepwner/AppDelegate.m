//
//  AppDelegate.m
//  Homepwner
//
//  Created by daichao on 15/6/11.
//  Copyright (c) 2015年 daichao. All rights reserved.
//

#import "AppDelegate.h"
#import "DCItemViewController.h"
#import "DCItemStore.h"
@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
willFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
//    // Override point for customization after application launch.
//    _window=[[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
//    _window.backgroundColor=[UIColor whiteColor];
    //如果应用没有触发状态恢复，就创建并设置各个试图控制器
    if(!self.window.rootViewController){
        DCItemViewController *dcitem=[[DCItemViewController alloc]init];
        UINavigationController *navController=[[UINavigationController alloc]initWithRootViewController:dcitem];
        //将类名设为恢复标示
        navController.restorationIdentifier=NSStringFromClass([navController class]);
        //   [ main addChildViewController:dcitem];
        _window.rootViewController=navController;
    }
    
    [_window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    BOOL succcess=[[DCItemStore sharedStore]saveChanges];
    if(succcess){
        NSLog(@"Saved all of the items");
    }else{
        NSLog(@"could not save any of the items");
    }
}
-(BOOL)application:(UIApplication*)application shouldSaveApplicationState:(NSCoder *)coder{
    return YES;
}

-(BOOL)application:(UIApplication *)application shouldRestoreApplicationState:(NSCoder *)coder{
    return  YES;
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
