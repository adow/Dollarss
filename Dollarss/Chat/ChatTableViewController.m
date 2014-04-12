//
//  ChatTableViewController.m
//  Test-XMPP
//
//  Created by 秦 道平 on 14-3-29.
//  Copyright (c) 2014年 秦 道平. All rights reserved.
//

#import "ChatTableViewController.h"
#import "drrr.h"
#import "ChatTableViewCell.h"
#import "InviteMemberToChatRoomViewController.h"
#define ChatTableViewCellIdentifier @"chat-cell"
#define SendMessageViewHeight 46.0f
@interface ChatTableViewController (){
    
}
///对话列表
@property (nonatomic,retain) NSArray* talklist;
@end

@implementation ChatTableViewController
-(id)init{
    self=[super init];
    if (self){
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidChangeFrame:) name:UIKeyboardDidChangeFrameNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTalkNotification:) name:DRRRRefreshTalksNotification object:nil];
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
    self.view.backgroundColor=[UIColor whiteColor];
    if(self.member){
        self.navigationItem.title=self.member.name;
    }
    if (self.chatRoom){
        self.navigationItem.title=self.chatRoom.name;
        self.navigationItem.rightBarButtonItem=[[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(onButtonInvite:)] autorelease];
    }
    
    if (!_tableView){
        CGRect rect=CGRectMake(0.0f, 0.0f, 320.0f, self.view.frame.size.height-SendMessageViewHeight);
        _tableView=[[UITableView alloc]initWithFrame:rect];
        _tableView.dataSource=self;
        _tableView.delegate=self;
        [self.view addSubview:_tableView];
        [self.tableView registerClass:[ChatTableViewCell class] forCellReuseIdentifier:ChatTableViewCellIdentifier];
    }
    
    self.tableView.separatorInset=UIEdgeInsetsZero;
    if (!_sendMessageView){
        _sendMessageView=[[UIView alloc]initWithFrame:CGRectMake(0.0f, self.view.frame.size.height-SendMessageViewHeight,
                                                                 320.0f, SendMessageViewHeight)];
        _sendMessageView.backgroundColor=[UIColor lightGrayColor];
        [self.view addSubview:_sendMessageView];
        _sendMessageText=[[UITextView alloc]initWithFrame:CGRectMake(0.0f, 1.0f, 230.0f, 44.0f)];
        _sendMessageText.font=[UIFont systemFontOfSize:17.0f];
        [_sendMessageView addSubview:_sendMessageText];
        _sendMessageButton=[[UIButton alloc]initWithFrame:CGRectMake(240.0f, 1.0f, 60.0f, 44.0f)];
        [_sendMessageButton setTitle:@"Send" forState:UIControlStateNormal];
        [_sendMessageView addSubview:_sendMessageButton];
        [_sendMessageButton addTarget:self action:@selector(onButtonSend:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self reloadTable];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
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
    [_member release];
    [_talklist release];
    [_sendMessageButton release];
    [_sendMessageText release];
    [_sendMessageView release];
    [_tableView release];
    [super dealloc];
}
#pragma mark - Action
-(IBAction)onButtonSend:(id)sender{
    if (self.sendMessageText.text.length>0){
        if (self.member){
            [[DRRRMessage sharedMessage] sendMessage:self.sendMessageText.text toJid:self.member.jid toName:self.member.name];
        }
        else{
            [[DRRRMessage sharedMessage] sendMessage:self.sendMessageText.text inChatRoom:self.chatRoom.chatRoomJid];
        }
        self.sendMessageText.text=@"";
    }
}
-(void)reloadTable{
    if (self.member){
        [[DRRRRoster sharedRoster] _clearUnreadTotalForJid:self.member.jid];
        self.talklist=[[DRRRMessage sharedMessage] talksWithJid:self.member.jid];
    }
    else{
        self.talklist=[[DRRRMessage sharedMessage] talksWithJid:self.chatRoom.chatRoomJid];
    }
    [self.tableView reloadData];
    if (self.talklist.count>0){
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.talklist.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    
}
-(IBAction)onButtonInvite:(id)sender{
    InviteMemberToChatRoomViewController* inviteViewController=[[[InviteMemberToChatRoomViewController alloc]initWithStyle:UITableViewStyleGrouped] autorelease];
    inviteViewController.chatRoom=self.chatRoom;
    UINavigationController* navigation=[[UINavigationController alloc]initWithRootViewController:inviteViewController];
    [self presentViewController:navigation animated:YES completion:^{
        
    }];
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
    return _talklist.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChatTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ChatTableViewCellIdentifier forIndexPath:indexPath];
        // Configure the cell...
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    DRRRMessageContent* chat=self.talklist[indexPath.row];
    cell.message=chat;
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    DRRRMessageContent* chat=self.talklist[indexPath.row];
    CGFloat height=[self calculateMessageSize:chat.body];
    return fmaxf(height+44.0f, 60.0f);
}
-(CGFloat)calculateMessageSize:(NSString*)message{
    NSDictionary* attributes=@{NSFontAttributeName:[UIFont systemFontOfSize:ChatTableViewCellFontSize]};
//    CGSize size=[message sizeWithAttributes:attributes];
//    return size.height+44.0f;
    CGRect rect=[message boundingRectWithSize:CGSizeMake(320.0f, 300.0f) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
    return ceilf(rect.size.height);
}

#pragma mark - Notification
-(void)refreshTalkNotification:(NSNotification*)notification{
//    int unread_total=[[DRRRRoster sharedRoster] memberByJid:self.member.jid].unread_total;
//    NSLog(@"unread_total:%d",unread_total);
    [self reloadTable];
}
#pragma mark keyboard notification
-(void)keyboardWillChangeFrame:(NSNotification*)notification{
    NSDictionary *userInfo = [notification userInfo];
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    //    NSLog(@"keyboardRect:%@",NSStringFromCGRect(keyboardRect));
    [self updateTableViewAndMessageView:keyboardRect];
}
-(void)keyboardDidChangeFrame:(NSNotification*)notification{
    if (self.talklist.count>0){
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.talklist.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}
-(void)updateTableViewAndMessageView:(CGRect)keyboardRect{
    CGRect sendMessageViewFrame=self.sendMessageView.frame;
    sendMessageViewFrame.origin.y=keyboardRect.origin.y-sendMessageViewFrame.size.height;
    self.sendMessageView.frame=sendMessageViewFrame;
    CGRect tableFrame=self.tableView.frame;
    tableFrame.size.height=sendMessageViewFrame.origin.y;
    self.tableView.frame=tableFrame;
    
    
}
@end
