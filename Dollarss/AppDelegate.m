//
//  AppDelegate.m
//  Test-XMPP
//
//  Created by 秦 道平 on 14-3-25.
//  Copyright (c) 2014年 秦 道平. All rights reserved.
//

#import "AppDelegate.h"
#import "XMPPFramework.h"
#import "RosterViewController.h"
#import "ChatRoomListViewController.h"
#import "ProfileViewController.h"
#import "RootTabViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    ///log
    [DDLog addLogger:[DDASLLogger sharedInstance]];
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    _fileLogger=[[DDFileLogger alloc]init];
    _fileLogger.rollingFrequency=60*60*24;
    _fileLogger.logFileManager.maximumNumberOfLogFiles = 3;
    [DDLog addLogger:_fileLogger];
    ///
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    
//    _viewController=[[ViewController alloc]init];
//    UINavigationController* navigation=[[[UINavigationController alloc]initWithRootViewController:_viewController] autorelease];
//    self.window.rootViewController=navigation;
    
    RosterViewController* rosterViewController=[[[RosterViewController alloc]initWithStyle:UITableViewStylePlain] autorelease];
    UINavigationController* navigationRoster=[[[UINavigationController alloc]initWithRootViewController:rosterViewController] autorelease];
    navigationRoster.tabBarItem.title=@"好友";
    navigationRoster.tabBarItem.image=[UIImage imageNamed:@"chat"];
    
    //UIViewController* chatRoomViewController=[[[UIViewController alloc]init] autorelease];
    ChatRoomListViewController* chatRoomViewController=[[ChatRoomListViewController alloc]init];
    UINavigationController* navigationChatRoom=[[[UINavigationController alloc]initWithRootViewController:chatRoomViewController] autorelease];
    navigationChatRoom.tabBarItem.title=@"群组";
    navigationChatRoom.tabBarItem.image=[UIImage imageNamed:@"groupchat"];
    
    ProfileViewController* profileViewController=[[[ProfileViewController alloc]initWithStyle:UITableViewStyleGrouped] autorelease];
    UINavigationController* navigationProfile=[[[UINavigationController alloc]initWithRootViewController:profileViewController] autorelease];
    navigationProfile.tabBarItem.title=@"我的";
    navigationProfile.tabBarItem.image=[UIImage imageNamed:@"profile"];
    
    NSArray* viewControllers=@[navigationRoster,navigationChatRoom,navigationProfile,];
    
    RootTabViewController* rootController=[[[RootTabViewController alloc]init] autorelease];
    rootController.view.backgroundColor=[UIColor whiteColor];
    rootController.viewControllers=viewControllers;
    rootController.selectedIndex=0;
    self.window.rootViewController=rootController;
    [self.window makeKeyAndVisible];
    return YES;
}

-(void)dealloc{
    [_fileLogger release];
    [_viewController release];
    [super dealloc];
}

-(DDFileLogger*)fileLogger{
    return _fileLogger;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
