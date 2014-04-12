//
//  DRRRManager.h
//  Test-XMPP
//
//  Created by 秦 道平 on 14-3-28.
//  Copyright (c) 2014年 秦 道平. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "XMPP.h"
#define DRRRRefreshTalksNotification @"DRRRRefreshTalksNotification" ///刷新对话列表的通知
#define DRRRRefreshTalksNotification_UserInfo_TalkId @"talkid" ///userinfo 中的 talkid
#define DRRRRefreshTalksNotification_UserInfo_NewMessage @"new-message" ///userinfo 中的new-message
#pragma mark - DRRRMessageContent
/*
 对应一条XMPP Message
 来自一个联系人的chat 时
 
     <message xmlns="jabber:client" id="GixiF-64" to="adow@222.191.249.155" from="bdow@222.191.249.155/Spark 2.6.3" type="chat">
     <body>abc</body>
     <thread>Ll1CIG</thread>
     <x xmlns="jabber:x:event">
     <offline/>
     <composing/>
     </x>
     <delay xmlns="urn:xmpp:delay" from="222.191.249.155" stamp="2014-04-05T12:19:14.506Z"/>
     <x xmlns="jabber:x:delay" from="222.191.249.155" stamp="20140405T12:19:14"/>
     </message>
 
 来自一个多人聊天房间时
 
     <message xmlns="jabber:client" id="1Xuxl-46" to="adow@222.191.249.155/drrr" type="groupchat" from="test@conference.222.191.249.155/bdow">
     <body>aaa</body>
     <x xmlns="jabber:x:event">
     <offline/>
     <delivered/>
     <displayed/>
     <composing/>
     </x>
     <delay xmlns="urn:xmpp:delay" stamp="2014-04-02T06:27:36.747Z" from="test@conference.222.191.249.155/bdow"/>
     <x xmlns="jabber:x:delay" stamp="20140402T06:27:36" from="test@conference.222.191.249.155/bdow"/>
     </message>
 
 也有可能来自一个房间的邀请
 
     <message to="bdow@222.191.249.155" from="test@conference.222.191.249.155">
     <x xmlns="http://jabber.org/protocol/muc#user">
     <invite from="adow@222.191.249.155">
     <reason>test</reason>
     </invite>
     <password>123456</password>
     </x>
     <x xmlns="jabber:x:conference" jid="test@conference.222.191.249.155"/>
     </message>
*/
@interface DRRRMessageContent:NSObject{
    
}
@property (nonatomic,copy) NSString* messageid;
@property (nonatomic,copy) NSString* toJid;
@property (nonatomic,copy) NSString* toName;
@property (nonatomic,copy) NSString* fromJid;
@property (nonatomic,copy) NSString* fromName;
@property (nonatomic,copy) NSString* body;
@property (nonatomic,copy) NSDate* time;
@property (nonatomic,copy) NSString* type;
@property (nonatomic,copy) NSDate* delayTime;
@property (nonatomic,copy) NSString* thread;
///有delayTime时显示delayTime,没有时显示time
@property (nonatomic,readonly) NSDate* showTime;
///是否是房间邀请
@property (nonatomic,assign) BOOL chatRoom_invite;
///邀请房间的jid
@property (nonatomic,copy) NSString* chatRoom_invite_chatRoomJid;
///邀请进入房间的会员
@property (nonatomic,copy) NSString* chatRoom_invite_fromMemberJid;
///获得邀请到房间的原因
@property (nonatomic,copy) NSString* chatRoom_invite_reason;
///进入邀请房间的密码
@property (nonatomic,copy) NSString* chatRoom_invite_password;
///会话标识
@property (nonatomic,readonly) NSString* talkid;
///是否是单人聊天
@property (nonatomic,readonly) BOOL isChat;
///是否是多人聊天
@property (nonatomic,readonly) BOOL isGroupChat;
///是否是我发送的消息
@property (nonatomic,readonly) BOOL mySender;
-(instancetype)initWithXMPPMessage:(XMPPMessage*)message;
@end
#pragma mark - DRRRMessage
@interface DRRRMessage : NSObject<XMPPStreamDelegate>{
    NSMutableDictionary* _messageBundle;
}
@property (nonatomic,readonly) NSDictionary* messageBundle;
+(DRRRMessage*)sharedMessage;
///与一个人的回话列表
-(NSArray*)talksWithJid:(NSString*)jid;
///收到消息
-(void)_receiveMessage:(DRRRMessageContent*)message;
///发送消息
-(DRRRMessageContent*)sendMessage:(NSString*)message
                            toJid:(NSString*)toJid
                           toName:(NSString*)toName;
///在房间内发出消息
-(void)sendMessage:(NSString*)message
                       inChatRoom:(NSString*)chatRoomJid;
@end
