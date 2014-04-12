//
//  InviteMemberToChatRoomViewController.m
//  Test-XMPP
//
//  Created by 秦 道平 on 14-4-12.
//  Copyright (c) 2014年 秦 道平. All rights reserved.
//

#import "InviteMemberToChatRoomViewController.h"
#define CellIdentity @"invite-cell"
@interface InviteMemberToChatRoomViewController ()

@end

@implementation InviteMemberToChatRoomViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.navigationItem.title=@"邀请好友";
    self.navigationItem.leftBarButtonItem=[[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(onButtonCancel:)] autorelease];
    self.navigationItem.rightBarButtonItem=[[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(onButtonDone:)] autorelease];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellIdentity];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Action
-(IBAction)onButtonCancel:(id)sender{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
-(IBAction)onButtonDone:(id)sender{
    NSString* username=self.memberJidText.text;
    NSString* password=self.passwordText.text;
    NSString* reason=self.reasonText.text;
    [[DRRRChatRoomManager sharedChatRoomManager] inviteMember:username toChatRoomJid:self.chatRoom.chatRoomJid reason:reason withPassword:password];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 1;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return @"好友用户名";
        case 1:
            return @"房间密码(如果需要密码)";
        case 2:
            return @"邀请说明";
            
        default:
            return nil;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentity forIndexPath:indexPath];
    
    // Configure the cell...
    switch (indexPath.section) {
        case 0:
        {
            if (!_memberJidText){
                _memberJidText=[[UITextField alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 40.0f)];
                _memberJidText.keyboardType=UIKeyboardTypeEmailAddress;
                _memberJidText.placeholder=@"id或者Jid";
            }
            [cell.contentView addSubview:_memberJidText];
        }
            break;
        case 1:
        {
            if (!_passwordText){
                _passwordText=[[UITextField alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 40.0f)];
                _passwordText.secureTextEntry=YES;
            }
            [cell.contentView addSubview:_passwordText];
        }
            break;
        case 2:{
            if (!_reasonText){
                _reasonText=[[UITextField alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 40.0f)];
            
            }
            [cell.contentView addSubview:_reasonText];
        }
            break;
        default:
            break;
    }
    
    return cell;
}



@end
