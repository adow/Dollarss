//
//  RootTabViewController.m
//  Test-XMPP
//
//  Created by 秦 道平 on 14-4-11.
//  Copyright (c) 2014年 秦 道平. All rights reserved.
//

#import "RootTabViewController.h"
#import "drrr.h"
#import "SigninViewController.h"

@interface RootTabViewController ()

@end

@implementation RootTabViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)init{
    self=[super init];
    if (self){
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onlineNotification:) name:DRRRManager_Online_Notification object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

#pragma mark - Notification
-(void)onlineNotification:(NSNotification*)notification{
    BOOL online=[notification.object boolValue];
    if (!online){
        SigninViewController* signinViewController=[[[SigninViewController alloc]init] autorelease];
        UINavigationController* navigationController=[[[UINavigationController alloc]initWithRootViewController:signinViewController] autorelease];
        [self presentViewController:navigationController animated:YES completion:^{
            
        }];
    }
}
@end
