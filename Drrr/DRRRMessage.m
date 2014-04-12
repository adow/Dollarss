//
//  DRRRManager.m
//  Test-XMPP
//
//  Created by 秦 道平 on 14-3-28.
//  Copyright (c) 2014年 秦 道平. All rights reserved.
//
#import "DRRRMessage.h"
#import "DRRRRoster.h"
#import "DRRRManager.h"
#import "XMPPPresence+DRRR.h"
@implementation DRRRMessageContent
-(NSString*)talkid{
    return self.fromJid;
}
-(instancetype)initWithXMPPMessage:(XMPPMessage *)message{
    self=[super init];
    if (self){
        self.type=message.type;
        self.fromJid=[message.from bare];
        if ([self.type isEqualToString:@"chat"]){
            self.fromName=[message.from user];
        }
        else if ([self.type isEqualToString:@"groupchat"]){
            self.fromName=[message.from resource];
        }
        self.toJid=[message.to bare];
        self.toName=[message.to user];
        self.body=message.body;
        self.thread=message.thread;
        self.time=[NSDate date];
        self.messageid=message.attributesAsDictionary[@"id"];
        for (NSXMLElement* element in message.children) {
            if ([element.name isEqualToString:@"delay"]){
                NSString* delayStr=element.attributesAsDictionary[@"stamp"];
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
                NSArray *arr=[delayStr componentsSeparatedByString:@"T"];
                NSString *dateStr=[arr objectAtIndex:0];
                NSString *timeStr=[[[arr objectAtIndex:1] componentsSeparatedByString:@"."] objectAtIndex:0];
                self.delayTime = [dateFormatter dateFromString:[NSString stringWithFormat:@"%@T%@+0000",dateStr,timeStr]];
                break;
            }
        }
        //chatroom invite
        for (NSXMLElement* element in message.children) {
            if ([element.name isEqualToString:@"x"] && [element.xmlns isEqualToString:@"http://jabber.org/protocol/muc#user"]){
                self.chatRoom_invite=YES;
                self.chatRoom_invite_chatRoomJid=self.fromJid;
                for (NSXMLElement* element_a in element.children) {
                    if ([element_a.name isEqualToString:@"invite"]){
                        self.chatRoom_invite_fromMemberJid=element_a.attributesAsDictionary[@"from"];
                        for (NSXMLElement* element_b in element_a.children) {
                            if ([element_b.name isEqualToString:@"reason"]){
                                self.chatRoom_invite_reason=element_b.stringValue;
                            }
                        }
                    }
                    else if ([element_a.name isEqualToString:@"password"]){
                        self.chatRoom_invite_password=element_a.stringValue;
                    }
                }
            }
        }
    }
    return self;
}
-(void)dealloc{
    [_messageid release];
    [_toJid release];
    [_toName release];
    [_fromJid release];
    [_fromName release];
    [_body release];
    [_time release];
    [_type release];
    [_delayTime release];
    [_thread release];
    [super dealloc];
}
-(NSString*)description{
    return [NSString stringWithFormat:@"<0x%lx %@ toJid=%@, toName=%@, fromJid=%@, fronName=%@, body=%@, time=%@,type=%@,delayTime=%@,thread=%@>",(unsigned long)self,[self class],self.toJid,self.toName,self.fromJid,self.fromName,self.body,self.time,self.type,self.delayTime,self.thread];
}
-(BOOL)isChat{
    return [self.type isEqualToString:@"chat"];
}
-(BOOL)isGroupChat{
    return [self.type isEqualToString:@"groupchat"];
}
-(BOOL)mySender{
    if (self.isChat){
        return [self.fromJid isEqualToString:[DRRRManager sharedManager].jid];
    }
    else if (self.isGroupChat){
        return [self.fromName isEqualToString:[DRRRManager sharedManager].username];
    }
    return NO;
}
-(NSDate*)showTime{
    return self.delayTime?self.delayTime:self.time;
}
@end

@implementation DRRRMessage
static DRRRMessage* _sharedMessage;
+(DRRRMessage*)sharedMessage{
    if (!_sharedMessage){
        _sharedMessage=[[super allocWithZone:NULL]init];
        [_sharedMessage setupMessage];
    }
    return _sharedMessage;
}
-(void)setupMessage{
    _messageBundle=[[NSMutableDictionary alloc]init];
}
#pragma mark - default methods
+(id)allocWithZone:(struct _NSZone *)zone{
    return [[self sharedMessage] retain];
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
    [_messageBundle release];
    [super dealloc];
}
-(NSDictionary*)messageBundle{
    return _messageBundle;
}
#pragma mark - message
-(NSArray*)talksWithJid:(NSString *)jid{
    return _messageBundle[jid];
}
-(void)_receiveMessage:(DRRRMessageContent *)message{
    NSMutableArray* talks=_messageBundle[message.talkid];
    if (!talks){
        talks=[NSMutableArray array];
        _messageBundle[message.talkid]=talks;
    }
    [talks addObject:message];
    [[DRRRRoster sharedRoster] _increaseUnreadTotalForJid:message.talkid];
    [[NSNotificationCenter defaultCenter] postNotificationName:DRRRRefreshTalksNotification object:message];
}
-(DRRRMessageContent*)sendMessage:(NSString *)message
                            toJid:(NSString *)toJid
                           toName:(NSString *)toName{
    NSString* talkId=toJid;
    NSMutableArray* talks=_messageBundle[talkId];
    if (!talks){
        talks=[NSMutableArray array];
        _messageBundle[talkId]=talks;
    }
    DRRRMessageContent* content=[[[DRRRMessageContent alloc]init] autorelease];
    content.toJid=toJid;
    content.toName=toName;
    content.fromJid=[DRRRManager sharedManager].jid;
    content.fromName=[DRRRManager sharedManager].username;
    content.body=message;
    content.type=@"chat";
    content.time=[NSDate date];
    [talks addObject:content];
    ///更新对话列表的通知
    [[NSNotificationCenter defaultCenter] postNotificationName:DRRRRefreshTalksNotification object:content];
    ///发送xml
    //XMPPFramework主要是通过KissXML来生成XML文件
    //生成<body>文档
    NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
    [body setStringValue:message];
    //生成XML消息文档
    NSXMLElement *mes = [NSXMLElement elementWithName:@"message"];
    //消息类型
    [mes addAttributeWithName:@"type" stringValue:@"chat"];
    //发送给谁
    [mes addAttributeWithName:@"to" stringValue:toJid];
    //由谁发送
    [mes addAttributeWithName:@"from" stringValue:[DRRRManager sharedManager].username];
    //组合
    [mes addChild:body];
    //发送消息
    [[DRRRManager sharedManager].xmppStream sendElement:mes];
    return content;
}
-(void)sendMessage:(NSString *)message inChatRoom:(NSString *)chatRoomJid{
    NSString* talkId=chatRoomJid;
    NSMutableArray* talks=_messageBundle[talkId];
    if (!talks){
        talks=[NSMutableArray array];
        _messageBundle[talkId]=talks;
    }

    ///发送xml
    //XMPPFramework主要是通过KissXML来生成XML文件
    //生成<body>文档
    NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
    [body setStringValue:message];
    //生成XML消息文档
    NSXMLElement *mes = [NSXMLElement elementWithName:@"message"];
    //消息类型
    [mes addAttributeWithName:@"type" stringValue:@"groupchat"];
    //发送给谁
    [mes addAttributeWithName:@"to" stringValue:chatRoomJid];
    //由谁发送
    [mes addAttributeWithName:@"from" stringValue:[DRRRManager sharedManager].jid];
    //组合
    [mes addChild:body];
    //发送消息
    [[DRRRManager sharedManager].xmppStream sendElement:mes];
}
#pragma mark - XMPPStreamDelegate
-(void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message{
    if (![message isChatRoomInvite] && !message.body){
        NSLog(@"body is empty");
        return;
    }
    DRRRMessageContent* content=[[[DRRRMessageContent alloc]initWithXMPPMessage:message] autorelease];
    [self _receiveMessage:content];
}
-(void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence{
    
}
-(BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq{
    return YES;
}
@end
