//
//  RosterNewViewController.m
//  Test-XMPP
//
//  Created by 秦 道平 on 14-3-31.
//  Copyright (c) 2014年 秦 道平. All rights reserved.
//

#import "RosterNewViewController.h"
#import "drrr.h"
@interface RosterNewViewController ()

@end

@implementation RosterNewViewController

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
    self.navigationItem.leftBarButtonItem=[[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(onButtonCancel:)] autorelease];
    self.navigationItem.rightBarButtonItem=[[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(onButtonOk:)] autorelease];
    self.navigationItem.title=@"添加好友";
    UIColor* textBackgroundColor=[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.05f];
    if (!_jidText){
        _jidText=[[UITextField alloc]initWithFrame:CGRectMake(0.0f, 80.0f, 320.0f, 50.0f)];
        _jidText.backgroundColor=textBackgroundColor;
        _jidText.placeholder=@"输入对方的用户名";
        _jidText.keyboardType=UIKeyboardTypeEmailAddress;
        [self.view addSubview:_jidText];
    }
    if (!_nameText){
        _nameText=[[UITextField alloc]initWithFrame:CGRectMake(0.0f, 140.0f, 320.0f, 50.0f)];
        _nameText.backgroundColor=textBackgroundColor;
        _nameText.placeholder=@"昵称";
        [self.view addSubview:_nameText];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    [_jidText release];
    [_nameText release];
    [super dealloc];
}

-(IBAction)onButtonCancel:(id)sender{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
-(IBAction)onButtonOk:(id)sender{
    NSString* username=self.nameText.text;
    NSString* jid=self.jidText.text;
    [[DRRRRoster sharedRoster] subscribeToJid:jid name:username];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
@end
