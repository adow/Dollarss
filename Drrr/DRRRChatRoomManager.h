//
//  DRRRGroupChat.h
//  Test-XMPP
//
//  Created by 秦 道平 on 14-4-2.
//  Copyright (c) 2014年 秦 道平. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMPP.h"
#pragma mark - DRRRChatRoomMember
///聊天室的一个成员
@interface DRRRChatRoomMember : NSObject{

}
@property (nonatomic,copy) NSString* chatRoomJid;
@property (nonatomic,copy) NSString* chatRoomMembername;
@property (nonatomic,copy) NSString* chatRoomMemberJid;
@property (nonatomic,copy) NSString* affiliation;
@property (nonatomic,copy) NSString* role;
@property (nonatomic,copy) NSString* show;
@property (nonatomic,copy) NSString* status;
///修改名字时的新名字
@property (nonatomic,copy) NSString* nick;
-(id)initWithPresence:(XMPPPresence*)presence;
@end
#pragma mark - DRRRChatRoomInfoField
///聊天室房间信息的各个字段
@interface DRRRChatRoomInfoField:NSObject{
    
}
@property (nonatomic,copy) NSString* var;
@property (nonatomic,copy) NSString* label;
@property (nonatomic,copy) NSString* value;
-(id)initWithVar:(NSString*)var
             label:(NSString*)label
             value:(NSString*)value;
@end
#pragma mark - DRRRChatRoomInfo
///聊天室房间信息
@interface DRRRChatRoomInfo:NSObject{
    NSMutableArray* _features;
    NSMutableDictionary* _fields;
}
@property (nonatomic,readonly) NSArray* features;
@property (nonatomic,readonly) NSDictionary* fields;
@property (nonatomic,copy) NSString* category;
@property (nonatomic,copy) NSString* name;
@property (nonatomic,copy) NSString* type;
@property (nonatomic,readonly) BOOL public;
@property (nonatomic,readonly) BOOL needPassword;
@property (nonatomic,readonly) BOOL membersOnly;
@property (nonatomic,readonly) NSString* roomDescription;
@property (nonatomic,readonly) NSString* subject;
@property (nonatomic,readonly) int occupants;
@property (nonatomic,readonly) NSString* creationdate;
-(id)initWithIq:(XMPPIQ*)iq;
@end
#pragma mark - DRRRChatRoom
#define DRRRChatRoomRefreshRoomsNotification @"DRRRChatRoomRefreshRoomsNotification" ///刷新房间列表时发出的通知
///聊天室房间
@interface DRRRChatRoom : NSObject{
    NSMutableDictionary* _memberList;
}
///chatRoomMemberJid and DRRRChatRoomMember
@property (nonatomic,readonly) NSDictionary* memberList;
@property (nonatomic,copy) NSString* chatRoomJid;
@property (nonatomic,copy) NSString* name;
///房间信息
@property (nonatomic,retain) DRRRChatRoomInfo* chatRoomInfo;
-(id)initWithChatRoomJid:(NSString*)chatRoomJid;
///更新房间成员信息
-(void)updateChatRoomMember:(DRRRChatRoomMember*)chatRoomMember;
///获取房间内的一个成员
-(DRRRChatRoomMember*)chatRoomMember:(NSString*)chatRoomMemberJid;
@end
#pragma mark - DRRRChatRoomManager
///多人聊天室功能操作
@interface DRRRChatRoomManager : NSObject<XMPPStreamDelegate>{
    NSMutableDictionary* _chatRooms;
    ///service 列表
    NSMutableArray* _chatRoomServices;
}
+(DRRRChatRoomManager*)sharedChatRoomManager;
///发送http://jabber.org/protocol/disco#info
-(void)queryInfoJid:(NSString*)jid;
///发送http://jabber.org/protocol/disco#items
-(void)queryItemsJid:(NSString*)jid;
///发现mcu服务
-(void)queryMCU;
///查询服务列表
-(void)queryServices;
///查询服务下的房间列表
-(void)queryChatRoomsInService:(NSString*)service;
///查询一个房间的信息
-(void)queryChatRoomInfo:(NSString*)roomJid;
///查询房间的条目
-(void)queryChatRoomItems:(NSString*)roomJid;
///进入一个房间
-(void)joinInChatRoom:(NSString*)roomJid withPassword:(NSString*)password;
///退出一个房间
-(void)quitChatRoom:(NSString*)roomJid;
#pragma mark - ChatRoom
@property (nonatomic,readonly) NSDictionary* chatRooms;
///房间信息,房间总是存在
-(DRRRChatRoom*)chatRoom:(NSString*)roomJid;
#pragma mark - ChatRoomMembers
///更新房间成员信息
-(void)updateDRRRGroupChatMember:(DRRRChatRoomMember*)chatRoomMember;
///获得房间内的一个成员
-(DRRRChatRoomMember*)member:(NSString*)jid
                  inChatRoom:(NSString*)chatRoomJid;
/*邀请一个成员进入房间
 <message
 from='crone1@shakespeare.lit/desktop'
 to='darkcave@chat.shakespeare.lit'>
 <x xmlns='http://jabber.org/protocol/muc#user'>
 <invite to='hecate@shakespeare.lit'>
 <reason>
 Hey Hecate, this is the place for all good witches!
 </reason>
 </invite>
 </x>
 </message>
 */
-(void)inviteMember:(NSString*)jid
      toChatRoomJid:(NSString*)chatRoomJid
             reason:(NSString*)reason 
       withPassword:(NSString*)password;
@end
