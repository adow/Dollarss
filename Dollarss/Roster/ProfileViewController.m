//
//  RosterStatusViewController.m
//  Test-XMPP
//
//  Created by 秦 道平 on 14-4-1.
//  Copyright (c) 2014年 秦 道平. All rights reserved.
//

#import "ProfileViewController.h"
#import "LogViewController.h"
#import "drrr.h"
#define RosterStatusViewController_Cell_Identity @"status-cell"

@interface ProfileViewController ()
@property (nonatomic,retain) NSIndexPath* currentIndexPath;
@property (nonatomic,retain) UITextField* statusText;
@end

@implementation ProfileViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onlineNotification:) name:DRRRManager_Online_Notification object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
//    self.navigationItem.leftBarButtonItem=[[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(onButtonCancel:)] autorelease];
//    self.navigationItem.rightBarButtonItem=[[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(onButtonDone:)] autorelease];
    self.navigationItem.title=@"我的状态";
    self.currentIndexPath=[NSIndexPath indexPathForRow:0 inSection:0];
    NSString* show=[DRRRRoster sharedRoster].currentMember.show;
    if ([show isEqualToString:DRRRRosterMemberPresenceShowChat]){
        self.currentIndexPath=[NSIndexPath indexPathForRow:0 inSection:0];
    }
    else if ([show isEqualToString:DRRRRosterMemberPresenceShowAway]){
        self.currentIndexPath=[NSIndexPath indexPathForRow:1 inSection:0];
    }
    else if ([show isEqualToString:DRRRRosterMemberPresenceShowDnd]){
        self.currentIndexPath=[NSIndexPath indexPathForRow:2 inSection:0];
    }
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:RosterStatusViewController_Cell_Identity];
    self.tableView.allowsMultipleSelection=NO;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_currentIndexPath release];
    [_statusText release];
    [super dealloc];
}

#pragma mark - Action
-(IBAction)onButtonCancel:(id)sender{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

-(IBAction)onButtonDone:(id)sender{
    NSString* show=@"";
    switch (_currentIndexPath.row) {
        case 0:
            show=DRRRRosterMemberPresenceShowChat;
            break;
        case 1:
            show=DRRRRosterMemberPresenceShowAway;
            break;
        case 2:
            show=DRRRRosterMemberPresenceShowDnd;
            break;
        default:
            break;
    }
    NSString* status=self.statusText.text;
    [[DRRRRoster sharedRoster] sendPresenceStatus:status show:show];
}
-(void)gotoLogViewController{
    LogViewController* logViewController=[[[LogViewController alloc]init] autorelease];
    logViewController.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:logViewController animated:YES];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section==0){
        return 1;
        
    }
    else if (section==1){
        return 3;
    }
    else if (section==2){
        return 1;
    }
    else{
        return 2;
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:RosterStatusViewController_Cell_Identity forIndexPath:indexPath];
    
    // Configure the cell...
    if (indexPath.section==0){
        cell.textLabel.text=[DRRRManager sharedManager].username;
    }
    if (indexPath.section==1){
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text=@"空闲";
                break;
            case 1:
                cell.textLabel.text=@"隐身";
                break;
            case 2:
                cell.textLabel.text=@"请勿打扰";
                break;
            default:
                break;
        }
        if (indexPath.section==self.currentIndexPath.section && indexPath.row==self.currentIndexPath.row){
            cell.accessoryType=UITableViewCellAccessoryCheckmark;
        }
        else{
            cell.accessoryType=UITableViewCellAccessoryNone;
        }
    }
    else if (indexPath.section==2){
        cell.accessoryType=UITableViewCellAccessoryNone;
        for (UIView* view  in cell.contentView.subviews) {
            if ([view isKindOfClass:[UITextField class]]){
                [view removeFromSuperview];
            }
        }
        if (!_statusText){
            _statusText=[[[UITextField alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 40.0f)] autorelease];
            _statusText.placeholder=@"我的状态描述";
            if ([DRRRRoster sharedRoster].currentMember.status){
                _statusText.text=[DRRRRoster sharedRoster].currentMember.status;
            }
            [_statusText addTarget:self action:@selector(onTextEndEditing:) forControlEvents:UIControlEventEditingDidEndOnExit];
        }
        [cell.contentView addSubview:_statusText];
    }
    else if (indexPath.section==3){
        if (indexPath.row==0){
            cell.textLabel.text=@"查看日志";
        }
        else if (indexPath.row==1){
            cell.backgroundColor=[UIColor redColor];
            cell.textLabel.textColor=[UIColor whiteColor];
            cell.textLabel.text=@"退出登录";
        }
    }
    
    return cell;
}
-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section==0){
        return @"用户名";
    }
    else if (section==1){
        return @"显示";
    }
    else if (section==2){
        return @"状态";
    }
    else{
        return nil;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==1){
        self.currentIndexPath=indexPath;
        [self.tableView reloadData];
        NSString* show=@"";
        switch (indexPath.row) {
            case 0:
                show=DRRRRosterMemberPresenceShowChat;
                break;
            case 1:
                show=DRRRRosterMemberPresenceShowAway;
                break;
            case 2:
                show=DRRRRosterMemberPresenceShowDnd;
                break;
            default:
                break;
        }
        NSString* status=self.statusText.text;
        [[DRRRRoster sharedRoster] sendPresenceStatus:status show:show];
    }
    else if (indexPath.section==3){
        if (indexPath.row==0){
            [self gotoLogViewController];
        }
        else if(indexPath.row==1){
            [[DRRRManager sharedManager] signout];
        }
    }
}
#pragma mark - UITextFieldDelegate
-(IBAction)onTextEndEditing:(id)sender{
    NSString* show=@"";
    switch (_currentIndexPath.row) {
        case 0:
            show=DRRRRosterMemberPresenceShowChat;
            break;
        case 1:
            show=DRRRRosterMemberPresenceShowAway;
            break;
        case 2:
            show=DRRRRosterMemberPresenceShowDnd;
            break;
        default:
            break;
    }
    NSString* status=self.statusText.text;
    [[DRRRRoster sharedRoster] sendPresenceStatus:status show:show];
}
#pragma mark - Notification
-(void)onlineNotification:(NSNotification*)notification{
    [self.tableView reloadData];
}
@end
