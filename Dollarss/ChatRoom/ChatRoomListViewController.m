//
//  ChatRoomListViewController.m
//  Test-XMPP
//
//  Created by 秦 道平 on 14-4-11.
//  Copyright (c) 2014年 秦 道平. All rights reserved.
//

#import "ChatRoomListViewController.h"
#import "ChatTableViewController.h"
#import "InviteMemberToChatRoomViewController.h"
#define ChatRoomListCellIdentity @"chatroom-cell"
@interface ChatRoomListViewController ()<UIAlertViewDelegate>
@property (nonatomic,assign) DRRRChatRoom* selectedChatRoom;
@end

@implementation ChatRoomListViewController
-(id)initWithStyle:(UITableViewStyle)style{
    self=[super initWithStyle:style];
    if (self){
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshChatRoomListNotification:) name:DRRRChatRoomRefreshRoomsNotification object:nil];
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
    self.navigationItem.title=@"群组";
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:ChatRoomListCellIdentity];
    
    [self reloadTable];
    
    
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
-(void)reloadTable{
    [[DRRRChatRoomManager sharedChatRoomManager] queryServices];
}
#pragma mark - Action


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [DRRRChatRoomManager sharedChatRoomManager].chatRooms.allKeys.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ChatRoomListCellIdentity forIndexPath:indexPath];
    
    NSDictionary* chatRooms=[DRRRChatRoomManager sharedChatRoomManager].chatRooms;
    NSString* chatRoomJid=chatRooms.allKeys[indexPath.row];
    DRRRChatRoom* chatRoom=chatRooms[chatRoomJid];
    cell.textLabel.text=chatRoom.name;
    if (chatRoom.chatRoomInfo){
        cell.accessoryType=UITableViewCellAccessoryDetailDisclosureButton;
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary* chatRooms=[DRRRChatRoomManager sharedChatRoomManager].chatRooms;
    NSString* chatRoomJid=chatRooms.allKeys[indexPath.row];
    DRRRChatRoom* chatRoom=chatRooms[chatRoomJid];
    if (chatRoom.chatRoomInfo){
        self.selectedChatRoom=chatRoom;
        if(chatRoom.chatRoomInfo.needPassword){
            UIAlertView* alert=[[[UIAlertView alloc]initWithTitle:@"密码" message:@"进入房间需要提供密码" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"进入", nil] autorelease];
            alert.alertViewStyle=UIAlertViewStyleSecureTextInput;
            [alert show];
            return;
        }
        else{
            [self gotoSelectedChatRoomWithPassword:nil];
        }
    }
    else{
        [[DRRRChatRoomManager sharedChatRoomManager] queryChatRoomInfo:chatRoomJid];
    }
}
-(void)gotoSelectedChatRoomWithPassword:(NSString*)password{
    [[DRRRChatRoomManager sharedChatRoomManager] joinInChatRoom:self.selectedChatRoom.chatRoomJid withPassword:password];
    ChatTableViewController* chatTableViewController=[[[ChatTableViewController alloc]init] autorelease];
    chatTableViewController.hidesBottomBarWhenPushed=YES;
    chatTableViewController.chatRoom=self.selectedChatRoom;
    [self.navigationController pushViewController:chatTableViewController animated:YES];
}
#pragma mark - UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            
            break;
        case 1:
        {
            NSString* password=[alertView textFieldAtIndex:0].text;
            [self gotoSelectedChatRoomWithPassword:password];
        }
            break;
        default:
            break;
    }
}

#pragma mark - Notification
-(void)refreshChatRoomListNotification:(NSNotification*)notification{
    NSDictionary* chatRooms=[DRRRChatRoomManager sharedChatRoomManager].chatRooms;
    NSLog(@"chatRooms:\n%@",chatRooms);
    [self.tableView reloadData];
}

-(void)signinNotification:(NSNotification*)notification{
    BOOL online=[notification.object boolValue];
    if (online){
        [self reloadTable];
    }
}

@end
