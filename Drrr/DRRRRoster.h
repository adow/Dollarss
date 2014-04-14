//
//  XMPPRoster.h
//  Test-XMPP
//
//  Created by 秦 道平 on 14-3-27.
//  Copyright (c) 2014年 秦 道平. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMPP.h"
#pragma mark - DRRRRosterMember
#define DRRRRosterMemberPresenceShowChat @"chat" ///空闲
#define DRRRRosterMemberPresenceShowAway @"away" ///离开
#define DRRRRosterMemberPresenceShowDnd @"dnd" ///请勿打扰
#define DRRRRosterUpdateNotification @"DRRRRosterUpdateNotification" ///更新联系人列表时通知
///一个联系人
@interface DRRRRosterMember:NSObject{
    
}
@property (nonatomic,copy) NSString* jid;
@property (nonatomic,copy) NSString* name;
@property (nonatomic,copy) NSString* availableStr;
@property (nonatomic,copy) NSString* status;
@property (nonatomic,copy) NSString* show;
@property (nonatomic,copy) NSString* group;
@property (nonatomic,copy) NSString* subscription;
@property (nonatomic,readonly) BOOL available;
///还未读的消息数量
@property (nonatomic,assign) int unread_total;
///正在邀请订阅我中
@property (nonatomic,assign) BOOL want_to_subscribe_me;
-(id)initWithPresence:(XMPPPresence*)presence;
///从iq query roster 的element来创建
-(id)initWithRosterElement:(NSXMLElement*)element;
@end
#pragma mark - DRRRRoster
///联系人列表
@interface DRRRRoster : NSObject<XMPPStreamDelegate>{
    
}
///好友列表
@property (nonatomic,retain) NSMutableDictionary* memberList;
///联系人数量
@property (nonatomic,readonly) NSInteger memberTotal;
+(DRRRRoster*)sharedRoster;
#pragma mark - Action
#pragma mark member
///更新一个联系人信息
-(DRRRRosterMember*)updateMember:(DRRRRosterMember*)member;
///获取一个联系人信息
-(DRRRRosterMember*)memberByJid:(NSString*)jid;
///获取一个联系人信息
-(DRRRRosterMember*)memberAtIndex:(int)index;
///当前登录的用户
-(DRRRRosterMember*)currentMember;
///获取联系人的列表
-(void)queryRosterList;
#pragma mark unread
///增加未读消息数量
-(DRRRRosterMember*)_increaseUnreadTotalForJid:(NSString*)jid;
///清空未读消息数量
-(DRRRRosterMember*)_clearUnreadTotalForJid:(NSString*)jid;
#pragma mark status presence
///修改状态
-(void)sendPresenceStatus:(NSString *)status show:(NSString *)show;
#pragma mark subscribe
///关注联系人
-(void)subscribeToJid:(NSString *)jid name:(NSString *)name;
///取消关注联系人
-(void)unsubscribeJid:(NSString *)jid;
///接受其他人的关注
-(void)acceptSubscribeFromJid:(NSString *)jid
                         name:(NSString *)name;
@end
