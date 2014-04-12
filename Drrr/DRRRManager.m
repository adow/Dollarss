//
//  DRRRManager.m
//  TestChat
//
//  Created by 秦 道平 on 14-3-18.
//  Copyright (c) 2014年 秦 道平. All rights reserved.
//

#import "DRRRManager.h"
#import "DRRRMessage.h"
#import "DRRRRoster.h"
#import "DRRRChatRoomManager.h"
#define DRRRManager_Alert_Key_Receive_Subscribe 100 ///接受好友邀请的提醒框
@interface DRRRManager(){
    
}
///正在邀请你关注的好友
@property (nonatomic,copy) NSString* _receiveSubscribeName;
@end
@implementation DRRRManager
static DRRRManager* _sharedManager;
+(DRRRManager*)sharedManager{
    if (!_sharedManager){
        _sharedManager=[[super allocWithZone:NULL]init];
        [_sharedManager setupXMPP];
    }
    return _sharedManager;
}
-(void)setupXMPP{
    _xmppStream = [[XMPPStream alloc] init];
    [_xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    [_xmppStream addDelegate:[DRRRMessage sharedMessage] delegateQueue:dispatch_get_main_queue()];
    [_xmppStream addDelegate:[DRRRRoster sharedRoster] delegateQueue:dispatch_get_main_queue()];
    [_xmppStream addDelegate:[DRRRChatRoomManager sharedChatRoomManager] delegateQueue:dispatch_get_main_queue()];
#if !TARGET_IPHONE_SIMULATOR
	{
        _xmppStream.enableBackgroundingOnSocket = YES;
	}
#endif
    _xmppReconnect = [[XMPPReconnect alloc] init];
    [_xmppReconnect activate:_xmppStream];
    self.online=NO;
}
-(XMPPStream*)xmppStream{
    return _xmppStream;
}
#pragma mark - default methods
+(id)allocWithZone:(struct _NSZone *)zone{
    return [[self sharedManager] retain];
}
+(id)copyWithZone:(struct _NSZone *)zone{
    return self;
}
-(id)retain{
    return self;
}
-(NSUInteger)retainCount{
    return NSUIntegerMax;
}
-(oneway void)release{
    return;
}
-(id)autorelease{
    return self;
}
-(void)dealloc{
    [__receiveSubscribeName release];
    [_jid release];
    [_xmppReconnect release];
    [_xmppStream release];
    [_username release];
    [_password release];
    [_host release];
    [super dealloc];
}
#pragma mark - action
#pragma connect login and register
-(void)signinWithUsername:(NSString *)username
                  password:(NSString *)password
                      host:(NSString *)host
                isregister:(BOOL)isregister {
    self.username=username;
    self.password=password;
    self.host=host;
    if (![_xmppStream isDisconnected]){
        return;
    }
    _registerAction=isregister;
    //    self.username=@"adow@shintekimacbook-pro.local";
    //    self.password=@"cloudq";
    //    NSString* domain=@"shintekimacbook-pro.local";
    self.jid=[NSString stringWithFormat:@"%@@%@",self.username,self.host];
    [_xmppStream setMyJID:[XMPPJID jidWithString:_jid resource:@"drrr"]];
    [_xmppStream setHostName:host];
    NSError *error = nil;
    BOOL result=[_xmppStream connectWithTimeout:3.0f error:&error];
    NSLog(@"connect:%d,%@",result,error);
    [[NSUserDefaults standardUserDefaults] setObject:DRRRManager_StoreKey_Username forKey:username];
    [[NSUserDefaults standardUserDefaults] setObject:DRRRManager_StoreKey_Password forKey:password];
    [[NSUserDefaults standardUserDefaults] setObject:DRRRManager_StoreKey_Host forKey:host];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(void)signout{
    //发送下线状态
    XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];
    [_xmppStream sendElement:presence];
    self.online=NO;
    [_xmppStream disconnect];
    [[DRRRRoster sharedRoster].memberList removeAllObjects];
}
-(void)autoSignin{
    NSString* username=[[NSUserDefaults standardUserDefaults] stringForKey:DRRRManager_StoreKey_Username];
    NSString* password=[[NSUserDefaults standardUserDefaults] stringForKey:DRRRManager_StoreKey_Password];
    NSString* host=[[NSUserDefaults standardUserDefaults] stringForKey:DRRRManager_StoreKey_Host];
    [self signinWithUsername:username password:password host:host isregister:NO];
}
-(void)setOnline:(BOOL)online{
    _online=online;
    if (online){
        //发送在线状态
        [[NSNotificationCenter defaultCenter] postNotificationName:DRRRManager_Online_Notification object:[NSNumber numberWithBool:YES]];
    }
    else{
        
        [[NSNotificationCenter defaultCenter] postNotificationName:DRRRManager_Online_Notification object:[NSNumber numberWithBool:NO]];
    }
}
-(BOOL)online{
    return _online;
}
#pragma mark message
-(void)sendXmlString:(NSString *)xmlString{
    NSXMLElement* element=[[NSXMLElement alloc]initWithXMLString:xmlString error:nil];
    [self.xmppStream sendElement:element];
}
#pragma mark subscribe
#pragma mark - xmpp delegate
-(void)xmppStreamDidConnect:(XMPPStream *)sender{
    //验证密码
    NSError* error=nil;
    BOOL result;
    if (!_registerAction){
        result=[_xmppStream authenticateWithPassword:self.password error:&error];
    }
    else{
        result=[_xmppStream registerWithPassword:self.password error:&error];
    }
    ///注册只要一次，之后就改为登录，防止在重复连接的时候又去注册
    _registerAction=NO;
    NSLog(@"authenticated:%d,%@",result,error);
}
-(void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error{
    
}
-(void)xmppStreamDidAuthenticate:(XMPPStream *)sender{
    //发送在线状态
    XMPPPresence *presence = [XMPPPresence presence];
    [_xmppStream sendElement:presence];
}
-(void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(DDXMLElement *)error{
//    [[NSNotificationCenter defaultCenter] postNotificationName:DRRRManager_Signin_Notification object:[NSNumber numberWithBool:NO]];
    self.online=NO;
}
-(void)xmppStreamDidRegister:(XMPPStream *)sender{
    NSLog(@"register");
    NSError* error=nil;
    [_xmppStream authenticateWithPassword:self.password error:&error];
}
-(void)xmppStream:(XMPPStream *)sender didNotRegister:(DDXMLElement *)error{
    NSLog(@"not register");
}
-(void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message{
    ///message 全部由 DRRRMessage处理
}
-(void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence{
//    NSLog(@"presence = %@", presence);
    ///只处理如果是当前用户的状态，其他有DRRRRoster, DRRRChatRoom处理
    XMPPJID* jidFrom=[presence from];
    XMPPJID* jidTo=[presence to];
    NSString *presenceFromUser = [jidFrom user];
    NSString* presenceFromJid=[jidFrom bare];
    //取得好友状态
    NSString *presenceType = [presence type]; //online/offline
    //当前用户是否在线
    NSString *userId = [[sender myJID] user];
    if ([presenceFromUser isEqualToString:userId]){
        if ([presenceType isEqualToString:@"available"]){
            self.online=YES;
        }
        else if ([presenceType isEqualToString:@"unavailable"]){
            self.online=NO;
        }
        
    }
    
}
- (BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq{
    ///由 DRRRRoster处理
    return YES;
}
@end
