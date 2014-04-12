//
//  SigninViewController.m
//  Test-XMPP
//
//  Created by 秦 道平 on 14-3-29.
//  Copyright (c) 2014年 秦 道平. All rights reserved.
//

#import "SigninViewController.h"
#import "drrr.h"
#define Username_Key @"Dollarss.username"
#define Password_Key @"Dollarss.password"
#define Host_Key @"Dollarss.host"
@interface SigninViewController ()

@end

@implementation SigninViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationItem.title=@"登录";
    self.navigationItem.rightBarButtonItem=[[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(onButtonDone:)] autorelease];
//    self.navigationItem.leftBarButtonItem=[[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(onButtonCancel:)] autorelease];
    UIColor* textBackgroundColor=[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.05f];
    if (!_usernameText){
        _usernameText=[[UITextField alloc]initWithFrame:CGRectMake(0.0f, 80.0f, 320.0f, 50.0f)];
        _usernameText.backgroundColor=textBackgroundColor;
        _usernameText.placeholder=@"用户名";
        _usernameText.keyboardType=UIKeyboardTypeEmailAddress;
        [self.view addSubview:_usernameText];
        _usernameText.text=[[NSUserDefaults standardUserDefaults] stringForKey:Username_Key];
    }
    if (!_passwordText){
        _passwordText=[[UITextField alloc]initWithFrame:CGRectMake(0.0f, 140.0f, 320.0f, 50.0f)];
        _passwordText.backgroundColor=textBackgroundColor;
        _passwordText.secureTextEntry=YES;
        _passwordText.placeholder=@"密码";
        [self.view addSubview:_passwordText];
        _passwordText.text=[[NSUserDefaults standardUserDefaults] stringForKey:Password_Key];
    }
    if (!_hostText){
        _hostText=[[UITextField alloc]initWithFrame:CGRectMake(0.0f, 200.0f, 320.0f, 50.0f)];
        _hostText.backgroundColor=textBackgroundColor;
        _hostText.placeholder=@"服务器";
        _hostText.keyboardType=UIKeyboardTypeEmailAddress;
        [self.view addSubview:_hostText];
        NSString* host=[[NSUserDefaults standardUserDefaults] stringForKey:Host_Key];
        if (!host){
            _hostText.text=@"222.191.249.155";
        }
        else{
            _hostText.text=host;
        }
    }
    if (!_signupSwith){
        _signupSwith=[[UISwitch alloc]initWithFrame:CGRectMake(270.0f, 260.0f, 100.0f, 50.0f)];
        _signupSwith.on=NO;
        [self.view addSubview:_signupSwith];
        UILabel* signupLabel=[[UILabel alloc]initWithFrame:CGRectMake(160.0f, 250.0f, 100.0f, 50.0f)];
        signupLabel.textAlignment=NSTextAlignmentRight;
        signupLabel.text=@"注册帐号";
        signupLabel.textColor=[UIColor grayColor];
        [self.view addSubview:signupLabel];
    }
    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onlineNotification:) name:DRRRManager_Online_Notification object:nil];
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    [_usernameText release];
    [_passwordText release];
    [_hostText release];
    [_signupSwith release];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}
#pragma mark - Action
-(IBAction)onButtonDone:(id)sender{
    NSString* username=self.usernameText.text;
    NSString* password=self.passwordText.text;
    NSString* host=self.hostText.text;
    [[NSUserDefaults standardUserDefaults] setObject:username forKey:Username_Key];
    [[NSUserDefaults standardUserDefaults] setObject:password forKey:Password_Key];
    [[NSUserDefaults standardUserDefaults] setObject:host forKey:Host_Key];
    [[NSUserDefaults standardUserDefaults] synchronize];
    BOOL signup=self.signupSwith.on;
    [[DRRRManager sharedManager] signinWithUsername:username password:password host:host isregister:signup];
}
-(IBAction)onButtonCancel:(id)sender{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
#pragma mark - Notification
-(void)onlineNotification:(NSNotification*)notification{
    BOOL online=[notification.object boolValue];
    if (online){
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
}
@end
