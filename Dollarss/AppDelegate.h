//
//  AppDelegate.h
//  Test-XMPP
//
//  Created by 秦 道平 on 14-3-25.
//  Copyright (c) 2014年 秦 道平. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "DDFileLogger.h"
#import "DDASLLogger.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    DDFileLogger* _fileLogger;
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,retain) ViewController* viewController;
@property (nonatomic,readonly) DDFileLogger* fileLogger;
@end
