//
//  RosterViewController.m
//  Test-XMPP
//
//  Created by 秦 道平 on 14-3-29.
//  Copyright (c) 2014年 秦 道平. All rights reserved.
//

#import "RosterViewController.h"
#import "drrr.h"
#import "SigninViewController.h"
#import "RosterTableViewCell.h"
#import "ChatTableViewController.h"
#import "ProfileViewController.h"
#import "LogViewController.h"
#define RosterTableViewCellIdentity @"roster-cell"
#define RosterTableViewCellIdentityLog @"log-cell"
#define RosterViewController_AlertView_ReceiveSubscribe 100
@interface RosterViewController(){
    
}
///正在邀请你关注的用户
@property (nonatomic,retain) DRRRRosterMember* receiveSubscribeMember;
@end

@implementation RosterViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onlineNotification:) name:DRRRManager_Online_Notification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateRosterNotification:) name:DRRRRosterUpdateNotification object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    
    self.view.backgroundColor=[UIColor whiteColor];
//    self.navigationItem.leftBarButtonItem=[[[UIBarButtonItem alloc]initWithTitle:@"登录" style:UIBarButtonItemStylePlain target:self action:@selector(showSigninViewController:)] autorelease];
    UIBarButtonItem* barButtonSubscribe=[[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(gotoRosterNewViewController:)] autorelease];
    UIBarButtonItem* barButtonOrganize=[[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:self action:@selector(onButtonOrganize:)] autorelease];
//    self.navigationItem.rightBarButtonItem=[[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(gotoRosterNewViewController:)] autorelease];
    self.navigationItem.rightBarButtonItems=@[barButtonSubscribe,barButtonOrganize];
    NSMutableString* title=[NSMutableString stringWithString:@"联系人"];
    self.navigationItem.title=title;
    [self.tableView registerClass:[RosterTableViewCell class] forCellReuseIdentifier:RosterTableViewCellIdentity];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:RosterTableViewCellIdentityLog];


}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.hidesBottomBarWhenPushed=NO;
}
-(void)viewDidAppear:(BOOL)animated{
    if ([[DRRRRoster sharedRoster] currentMember].show){
        [self.titleButton setTitle:[DRRRRoster sharedRoster].currentMember.show forState:UIControlStateNormal];
    }

    [super viewDidAppear:animated];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_titleButton release];
    [super dealloc];
}
#pragma mark - Action
-(void)onTitleButton:(UIButton*)sender{
    NSLog(@"title button");
    ProfileViewController* rosterStatusViewController=[[[ProfileViewController alloc]initWithStyle:UITableViewStyleGrouped] autorelease];
    UINavigationController* navigation=[[UINavigationController alloc]initWithRootViewController:rosterStatusViewController];
    [self presentViewController:navigation animated:YES completion:^{
        
    }];
}
-(void)showSigninViewController:(UIButton*)sender{
    if (![DRRRManager sharedManager].online){
        SigninViewController* signinViewController=[[[SigninViewController alloc]init] autorelease];
        UINavigationController* navigation=[[[UINavigationController alloc]initWithRootViewController:signinViewController] autorelease];
        [self presentViewController:navigation animated:YES completion:^{
            
        }];
    }
    else{
        [[DRRRManager sharedManager] signout];
        [self.tableView reloadData];
        
    }
}
-(void)onButtonOrganize:(UIButton*)sender{
    [self.tableView setEditing:!self.tableView.isEditing animated:YES];
}
-(void)gotoChatWithMember:(DRRRRosterMember*)member{
    ChatTableViewController* chatTableViewController=[[ChatTableViewController alloc]init];
    chatTableViewController.hidesBottomBarWhenPushed=YES;
    chatTableViewController.member=member;
    [self.navigationController pushViewController:chatTableViewController animated:YES];
}
-(void)gotoRosterNewViewController:(UIButton*)sender{
    RosterNewViewController* rosterNewViewController=[[[RosterNewViewController alloc]init] autorelease];
    UINavigationController* navigationViewController=[[[UINavigationController alloc]initWithRootViewController:rosterNewViewController] autorelease];
    [self presentViewController:navigationViewController animated:YES completion:^{
        
    }];
}
-(void)gotoReceiveSubscribe:(DRRRRosterMember*)member{
    self.receiveSubscribeMember=member;
    NSString* message=[NSString stringWithFormat:@"您想接受 %@ 的关注吗?",member.name];
    UIAlertView* alert=[[[UIAlertView alloc]initWithTitle:@"接收关注" message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"接收",@"拒绝", nil] autorelease];
    alert.tag=RosterViewController_AlertView_ReceiveSubscribe;
    [alert show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag==RosterViewController_AlertView_ReceiveSubscribe){
        NSLog(@"buttonIndex:%d",buttonIndex);
        switch (buttonIndex) {
            case 1:{
                [[DRRRRoster sharedRoster] acceptSubscribeFromJid:self.receiveSubscribeMember.jid name:self.receiveSubscribeMember.name];
            }
                break;
            case 2:{
                
            }
                break;
            default:
                break;
        }
    }
}
-(void)gotoLogViewController:(UIButton*)sender{
    LogViewController* logViewController=[[[LogViewController alloc]init] autorelease];
    [self.navigationController pushViewController:logViewController animated:YES];
}
#pragma mark RosterNewViewControllerDelegate
-(void)cancelRosterNewViewController:(RosterNewViewController *)rosterNewViewController{
    self.navigationController.navigationBarHidden=NO;
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        self.navigationController.navigationBar.userInteractionEnabled=YES;
//    });
    
}
-(void)saveRosterNewViewController:(RosterNewViewController *)rosterNewViewController{
    self.navigationController.navigationBarHidden=NO;
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        self.navigationController.navigationBar.userInteractionEnabled=YES;
//    });
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    int total=[DRRRRoster sharedRoster].memberTotal;
    return total;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DRRRRosterMember* member=[[DRRRRoster sharedRoster] memberAtIndex:(int)indexPath.row];
    NSLog(@"%@",member);
    RosterTableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:RosterTableViewCellIdentity];
    cell.member=member;
    return cell;
    
    
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    DRRRRosterMember* member=[[DRRRRoster sharedRoster] memberAtIndex:indexPath.row];
    [[DRRRRoster sharedRoster] unsubscribeJid:member.jid];
    [self.tableView setEditing:NO animated:NO];
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DRRRRosterMember* member=[[DRRRRoster sharedRoster] memberAtIndex:indexPath.row];
    if (member.want_to_subscribe_me){
        [self gotoReceiveSubscribe:member];
    }
    else{
        [self gotoChatWithMember:member];
    }

}

#pragma mark - Notification
-(void)onlineNotification:(NSNotification*)notification{
    
    BOOL signin=[notification.object boolValue];
    if (signin){
        [self.navigationItem.leftBarButtonItem setTitle:@"退出"];
        [[DRRRRoster sharedRoster] queryRosterList];
    }
    else{
        

    }
}
-(void)updateRosterNotification:(NSNotification*)notification{
    [self.tableView reloadData];
}
@end
