//
//  ViewController.m
//  Test-XMPP
//
//  Created by 秦 道平 on 14-3-25.
//  Copyright (c) 2014年 秦 道平. All rights reserved.
//

#import "ViewController.h"
#import "drrr.h"
#import "XmlViewController.h"

#define CELL_IDENTITY @"cell-command"
#pragma mark - CellComamnd
@implementation CellCommand
-(id)initWithTitle:(NSString *)title action:(SEL)action{
    self=[super init];
    if (self){
        self.title=title;
        self.action=action;
    }
    return self;
}
+(id)cellCommandWithTitle:(NSString *)title action:(SEL)action{
    CellCommand* cellCommand=[[CellCommand alloc]initWithTitle:title action:action];
    return [cellCommand autorelease];
}
-(void)dealloc{
    [_title release];
    [super dealloc];
}
@end
#pragma mark - ViewController
@interface ViewController ()

@end

@implementation ViewController
-(id)init{
    self=[super init];
    if (self){
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationUpdateRoster:) name:DRRRRosterUpdateNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationRefreshTalks:) name:DRRRRefreshTalksNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onlineNotification:) name:DRRRManager_Online_Notification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationRefreshRooms:) name:DRRRChatRoomRefreshRoomsNotification object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor=[UIColor darkGrayColor];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CELL_IDENTITY];
    _cellCommandList=[[NSMutableArray alloc]init];
    [_cellCommandList addObject:[CellCommand cellCommandWithTitle:@"Signin" action:@selector(onButtonSignin:)]];
    [_cellCommandList addObject:[CellCommand cellCommandWithTitle:@"Register" action:@selector(onButtonRegister:)]];
    [_cellCommandList addObject:[CellCommand cellCommandWithTitle:@"Send Message" action:@selector(onButtonSendMessage:)]];
    [_cellCommandList addObject:[CellCommand cellCommandWithTitle:@"Send Presence" action:@selector(onButtonPresence:)]];
    [_cellCommandList addObject:[CellCommand cellCommandWithTitle:@"Subscribe" action:@selector(onButtonSubscribe:)]];
    [_cellCommandList addObject:[CellCommand cellCommandWithTitle:@"Roster" action:@selector(onButtonRoster:)]];
    [_cellCommandList addObject:[CellCommand cellCommandWithTitle:@"Unsubscribe" action:@selector(onButtonUnsubscribe:)]];
    [_cellCommandList addObject:[CellCommand cellCommandWithTitle:@"ChatRoom List" action:@selector(onButtonChatRoomList:)]];
    [_cellCommandList addObject:[CellCommand cellCommandWithTitle:@"Join" action:@selector(onButtonJoin:)]];
    [_cellCommandList addObject:[CellCommand cellCommandWithTitle:@"ChatRoom Message" action:@selector(onButtonChatRoomMessage:)]];
    [_cellCommandList addObject:[CellCommand cellCommandWithTitle:@"Invite" action:@selector(onButtonInvite:)]];
    [_cellCommandList addObject:[CellCommand cellCommandWithTitle:@"XML" action:@selector(onButtonXml:)]];
    
    
    
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
#pragma mark - UITableViewDataSource and UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _cellCommandList.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:CELL_IDENTITY];
    CellCommand* command=_cellCommandList[indexPath.row];
    cell.textLabel.text=command.title;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CellCommand* cellCommand=_cellCommandList[indexPath.row];
    [self performSelector:cellCommand.action withObject:nil];
}
#pragma mark - Action
-(IBAction)onButtonSignin:(id)sender{
    [[DRRRManager sharedManager] signinWithUsername:@"adow" password:@"cloudq" host:@"222.191.249.155" isregister:NO];
//    [[DRRRManager sharedManager] signinWithUsername:@"adow" password:@"cloudq" host:@"222.191.249.155" isregister:NO];
}
-(IBAction)onButtonRegister:(id)sender{
    
}
-(IBAction)onButtonSendMessage:(id)sender{
//    [[DRRRManager sharedManager] sendMessage:@"hello" toJid:@"saber@222.191.249.155" toName:@"saber"];
    [[DRRRMessage sharedMessage] sendMessage:@"hello" toJid:@"bdow@222.191.249.155" toName:@"bdow"];

}
-(IBAction)onButtonPresence:(id)sender{
    [[DRRRRoster sharedRoster] sendPresenceStatus:@"休息" show:@"chat"];
    
    
}
-(IBAction)onButtonSubscribe:(id)sender{
    [[DRRRRoster sharedRoster] subscribeToJid:@"bdow" name:@"bdow"];
}
-(IBAction)onButtonRoster:(id)sender{
//    [[DRRRManager sharedManager] rosterList];
    [[DRRRRoster sharedRoster] queryRosterList];
}
-(IBAction)onButtonUnsubscribe:(id)sender{
    [[DRRRRoster sharedRoster] unsubscribeJid:@"bdow"];
}
-(IBAction)onButtonMCU:(id)sender{
//    [[DRRRGroupChat sharedGroupChat] queryMCU];
//    [[DRRRGroupChat sharedGroupChat] queryServices];
//    [[DRRRChatRoomManager sharedChatRoomManager] queryChatRoomsInService:@"conference.222.191.249.155"];
//    [[DRRRChatRoomManager sharedChatRoomManager] queryChatRoomInfo:@"test@conference.222.191.249.155"];
//    [[DRRRChatRoomManager sharedChatRoomManager] queryChatRoomItems:@"test@conference.222.191.249.155"];
    [[DRRRChatRoomManager sharedChatRoomManager] queryMCU];
    
}
-(IBAction)onButtonChatRoomList:(id)sender{
    [[DRRRChatRoomManager sharedChatRoomManager] queryServices];
//    [[DRRRChatRoomManager sharedChatRoomManager] queryChatRoomsInService:@"conference.222.191.249.155"];
}
-(IBAction)onButtonJoin:(id)sender{
    [[DRRRChatRoomManager sharedChatRoomManager] joinInChatRoom:@"test@conference.222.191.249.155" withPassword:@"123456"];
}
-(IBAction)onButtonInvite:(id)sender{
    [[DRRRChatRoomManager sharedChatRoomManager] inviteMember:@"bdow@222.191.249.155" toChatRoomJid:@"test@conference.222.191.249.155" reason:@"test" withPassword:nil];
}
-(IBAction)onButtonXml:(id)sender{
    XmlViewController* xmlViewController=[[[XmlViewController alloc]init] autorelease];
    [self.navigationController pushViewController:xmlViewController animated:YES];
}
-(IBAction)onButtonChatRoomMessage:(id)sender{
    [[DRRRMessage sharedMessage] sendMessage:@"a" inChatRoom:@"test@conference.222.191.249.155"];
}
#pragma mark - Notification
-(void)notificationUpdateRoster:(NSNotification*)notification{
    DRRRRosterMember* member=notification.object;
    NSLog(@"%@",member);
}
-(void)notificationRefreshTalks:(NSNotification*)notification{
    NSString* talkid=notification.userInfo[DRRRRefreshTalksNotification_UserInfo_TalkId];
    NSString* new_message=notification.userInfo[DRRRRefreshTalksNotification_UserInfo_NewMessage];
    NSLog(@"talkid:%@",talkid);
    NSLog(@"new message:%@",new_message);
}
-(void)onlineNotification:(NSNotification*)notification{
    BOOL signin=[notification.object boolValue];
    NSLog(@"signin:%d",signin);
}
-(void)notificationRefreshRooms:(NSNotification*)notification{
    NSLog(@"%@",[DRRRChatRoomManager sharedChatRoomManager].chatRooms);
}
@end
