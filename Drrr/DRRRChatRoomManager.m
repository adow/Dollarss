//
//  DRRRGroupChat.m
//  Test-XMPP
//
//  Created by 秦 道平 on 14-4-2.
//  Copyright (c) 2014年 秦 道平. All rights reserved.
//

#import "DRRRChatRoomManager.h"
#import "DRRRManager.h"
#import "XMPP+DRRR.h"
#pragma mark - DRRRChatRoomMember
@implementation DRRRChatRoomMember
-(void)dealloc{
    [_chatRoomJid release];
    [_chatRoomMembername release];
    [_chatRoomMemberJid release];
    [_affiliation release];
    [_role release];
    [_show release];
    [_status release];
    [_nick release];
    [super dealloc];
}
-(NSString*)description{
    return [NSString stringWithFormat:@"<0x%lx %@ chatRoomJid=%@,chatRoomMembername=%@,chatRoomMemberJid=%@,affiliation=%@, role=%@, show=%@, status=%@, nick=%@ >",(unsigned long)self,[self class],self.chatRoomJid,self.chatRoomMembername,self.chatRoomMemberJid,self.affiliation,self.role,self.show,self.status,self.nick];
}
-(id)initWithPresence:(XMPPPresence *)presence{
    self=[super init];
    if (self){
        
        if (presence.childCount>0){
            /*进入房间时获取的其他成员列表
             <presence xmlns="jabber:client" id="GixiF-41" to="adow@222.191.249.155/drrr" from="test@conference.222.191.249.155/bdow">
             <x xmlns="http://jabber.org/protocol/muc#user">
             <item jid="bdow@222.191.249.155/Spark 2.6.3" affiliation="member" role="participant"/>
             </x>
             </presence>
             */
            /*退出房间时收到状态
             <presence xmlns="jabber:client" from="test@conference.222.191.249.155/adow" to="adow@222.191.249.155/drrr" type="unavailable">
             <x xmlns="http://jabber.org/protocol/muc#user">
             <item jid="adow@222.191.249.155/drrr" affiliation="owner" role="none"/></x>
             </presence>
             
             */
            for (NSXMLElement* element in presence.children) {
                if ([element.name isEqualToString:@"x"] && [element.xmlns isEqualToString:@"http://jabber.org/protocol/muc#user"]){
                    XMPPJID* jidFrom=[presence from];
                    NSString* chatRoomJid=[jidFrom bare];
                    NSString* chatRoomMemberName=[jidFrom resource];
                    NSXMLElement* element_item=element.children[0];
                    NSString* chatRoomMemberJid=[[XMPPJID jidWithString:element_item.attributesAsDictionary[@"jid"]] bare];
                    NSString* affiliation=element_item.attributesAsDictionary[@"affiliation"];
                    NSString* role=element_item.attributesAsDictionary[@"role"];
                    NSString* nick=element_item.attributesAsDictionary[@"nick"];
                    NSString* status=[presence status];
                    NSString* show=[presence show];
                    self.chatRoomJid=chatRoomJid;
                    self.chatRoomMembername=chatRoomMemberName;
                    self.chatRoomMemberJid=chatRoomMemberJid;
                    self.affiliation=affiliation;
                    self.role=role;
                    self.status=status;
                    self.show=show;
                    self.nick=nick;
                    break;
                }
            }
            
        }
    }
    return self;
}
@end
#pragma mark - DRRRChatRoomInfoField
@implementation DRRRChatRoomInfoField
-(id)initWithVar:(NSString *)var label:(NSString *)label value:(NSString *)value{
    self=[super init];
    if (self){
        self.var=var;
        self.label=label;
        self.value=value;
    }
    return self;
}
-(void)dealloc{
    [_var release];
    [_label release];
    [_value release];
    [super dealloc];
}
-(NSString*)description{
    return [NSString stringWithFormat:@"<0x%lx %@ var=%@, label=%@, value=%@>",(unsigned long)self,[self class],self.var,self.label,self.value];
}
@end
#pragma mark - DRRRChatRoomInfo
@implementation DRRRChatRoomInfo
-(id)init{
    self=[super init];
    if (self){
        _features=[[NSMutableArray alloc]init];
        _fields=[[NSMutableDictionary alloc]init];
    }
    return self;
}
-(void)dealloc{
    [_features release];
    [_fields release];
    [_category release];
    [_name release];
    [_type release];
    [super dealloc];
}
-(NSArray*)features{
    return _features;
}
-(NSDictionary*)fields{
    return _fields;
}
-(id)initWithIq:(XMPPIQ *)iq{
    self=[super init];
    if (self){
        _features=[[NSMutableArray alloc]init];
        _fields=[[NSMutableDictionary alloc]init];
        NSXMLElement* element_query=iq.childElement;
        if ([element_query.xmlns isEqualToString:@"http://jabber.org/protocol/disco#info"]){
            for (NSXMLElement* element in element_query.children) {
                if ([element.name isEqualToString:@"identity"]){
                    self.category=element.attributesAsDictionary[@"category"];
                    self.name=element.attributesAsDictionary[@"name"];
                    self.type=element.attributesAsDictionary[@"type"];
                }
                else if ([element.name isEqualToString:@"feature"]){
                    NSString* value=element.attributesAsDictionary[@"var"];
                    [_features addObject:value];
                }
                else if ([element.name isEqualToString:@"x"]){
                    for (NSXMLElement* element_field in element.children) {
                        NSString* var=element_field.attributesAsDictionary[@"var"];
                        NSString* label=element_field.attributesAsDictionary[@"label"];
                        NSXMLElement* element_value=element_field.children[0];
                        NSString* value=element_value.stringValue;
                        DRRRChatRoomInfoField* field=[[[DRRRChatRoomInfoField alloc]initWithVar:var label:label value:value] autorelease];
                        _fields[var]=field;
                    }
                }
            }
        }
    }
    return self;
}
-(NSString*)description{
    return [NSString stringWithFormat:@"<0x%lx %@ category=%@, name=%@, type=%@,public=%d, membersonly=%d, password=%d, description=%@,subject=%@,occupants=%d,creationdate=%@,\nfeatures=%@,\nfields=%@>",(unsigned long)self,[self class],self.category,self.name,self.type,self.public,self.membersOnly,self.needPassword,self.roomDescription,self.subject,self.occupants,self.creationdate,self.features,self.fields];
}
-(BOOL)checkFeature:(NSString*)featureStr{
    for (NSString* feature in _features) {
        if ([feature isEqualToString:featureStr]){
            return YES;
        }
    }
    return NO;
}
-(BOOL)public{
    return [self checkFeature:@"muc_public"];
}
-(BOOL)needPassword{
    return [self checkFeature:@"muc_passwordprotected"];
}
-(BOOL)membersOnly{
    return [self checkFeature:@"muc_membersonly"];
}
-(NSString*)roomDescription{
    return ((DRRRChatRoomInfoField*)_fields[@"muc#roominfo_description"]).value;
}
-(NSString*)subject{
    return ((DRRRChatRoomInfoField*)_fields[@"muc#roominfo_subject"]).value;
}
-(int)occupants{
    return [((DRRRChatRoomInfoField*)_fields[@"muc#roominfo_occupants"]).value intValue];
}
-(NSString*)creationdate{
    return ((DRRRChatRoomInfoField*)_fields[@"x-muc#roominfo_creationdate"]).value;
}
@end
#pragma mark - DRRRChatRoom
@implementation DRRRChatRoom
-(void)dealloc{
    [_memberList release];
    [_chatRoomJid release];
    [_name release];
    [_chatRoomInfo release];
    [super dealloc];
}
-(NSString*)description{
    return [NSString stringWithFormat:@"<0x%lx %@ chatRoomJid=%@,name=%@, memberList=%@>",(unsigned long)self,[self class],self.chatRoomJid,self.name,self.memberList];
}
-(NSDictionary*)memberList{
    return _memberList;
}
-(id)initWithChatRoomJid:(NSString *)chatRoomJid{
    self=[super init];
    if (self){
        self.chatRoomJid=chatRoomJid;
        _memberList=[[NSMutableDictionary alloc]init];
    }
    return self;
}
-(void)updateChatRoomMember:(DRRRChatRoomMember *)chatRoomMember{
    if (![self.chatRoomJid isEqualToString:chatRoomMember.chatRoomJid]){
        NSLog(@"chat room not matched");
        return;
    }
    ///role none的时候从成员中删除
    if ([chatRoomMember.role isEqualToString:@"none"]){
        [_memberList removeObjectForKey:chatRoomMember.chatRoomMemberJid];
    }
    else{
        ///新的成员
        if (!_memberList[chatRoomMember.chatRoomMemberJid]){
            _memberList[chatRoomMember.chatRoomMemberJid]=chatRoomMember;
        }
        ///现有成员修改信息，只是复制数据
        else{
            DRRRChatRoomMember* member=_memberList[chatRoomMember.chatRoomMemberJid];
            ///改名了
            if (chatRoomMember.nick){
                member.chatRoomMembername=chatRoomMember.nick;
            }
            if (chatRoomMember.affiliation){
                member.affiliation=chatRoomMember.affiliation;
            }
            if (chatRoomMember.role){
                member.role=chatRoomMember.role;
            }
            if (chatRoomMember.show){
                member.show=chatRoomMember.show;
            }
            if (chatRoomMember.status){
                member.status=chatRoomMember.status;
            }
        }
    }
}
-(DRRRChatRoomMember*)chatRoomMember:(NSString *)chatRoomMemberJid{
    return _memberList[chatRoomMemberJid];
}
@end
#pragma mark - DRRRChatRoomManager
@interface DRRRChatRoomManager(){
    
}
@property (nonatomic,readonly) DRRRManager* manager;
@end
@implementation DRRRChatRoomManager
static DRRRChatRoomManager* _sharedChatRoomManager;
+(DRRRChatRoomManager*)sharedChatRoomManager{
    if (!_sharedChatRoomManager){
        _sharedChatRoomManager=[[super allocWithZone:NULL]init];
        [_sharedChatRoomManager setup];
    }
    return _sharedChatRoomManager;
}
-(void)setup{
    _chatRooms=[[NSMutableDictionary alloc]init];
    _chatRoomServices=[[NSMutableArray alloc]init];
}
#pragma mark - default methods
+(id)allocWithZone:(struct _NSZone *)zone{
    return [[self sharedChatRoomManager] retain];
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
    [_chatRooms release];
    [_chatRoomServices release];
    [super dealloc];
}
#pragma mark - property
-(DRRRManager*)manager{
    return [DRRRManager sharedManager];
}
#pragma mark - mcu
-(void)queryInfoJid:(NSString *)jid{
    DRRRManager* manager=[DRRRManager sharedManager];
    XMPPIQ* iq=[XMPPIQ iqWithType:@"get"];
    [iq addAttributeWithName:@"from" stringValue:manager.jid];
    [iq addAttributeWithName:@"id" stringValue:@"disco-1"];
    [iq addAttributeWithName:@"to" stringValue:jid];
    NSXMLElement* element_query=[NSXMLElement elementWithName:@"query" xmlns:@"http://jabber.org/protocol/disco#info"];
    [iq addChild:element_query];
    [manager.xmppStream sendElement:iq];
}
-(void)queryItemsJid:(NSString *)jid{
    XMPPIQ* iq=[XMPPIQ iqWithType:@"get"];
    [iq addAttributeWithName:@"from" stringValue:self.manager.jid];
    [iq addAttributeWithName:@"id" stringValue:@"disco-3"];
    [iq addAttributeWithName:@"to" stringValue:jid];
    NSXMLElement* element_query=[NSXMLElement elementWithName:@"query" xmlns:@"http://jabber.org/protocol/disco#items"];
    [iq addChild:element_query];
    [self.manager.xmppStream sendElement:iq];
}
-(void)queryMCU{

    [self queryInfoJid:self.manager.jid];
}
-(void)queryServices{
    [self queryItemsJid:self.manager.host];
}
-(void)queryChatRoomsInService:(NSString *)service{
    [self queryItemsJid:service];
}
-(void)queryChatRoomInfo:(NSString *)roomJid{
    [self queryInfoJid:roomJid];
}
-(void)queryChatRoomItems:(NSString *)roomJid{
    [self queryItemsJid:roomJid];
}
-(void)joinInChatRoom:(NSString *)roomJid withPassword:(NSString *)password{
    NSString* memberJid=[NSString stringWithFormat:@"%@/%@",roomJid,self.manager.username];
    XMPPPresence* presence=[XMPPPresence presence];
    [presence addAttributeWithName:@"from" stringValue:self.manager.jid];
    [presence addAttributeWithName:@"to" stringValue:memberJid];
    NSXMLElement* element_x=[NSXMLElement elementWithName:@"x" xmlns:@"http://jabber.org/protocol/muc"];
    [presence addChild:element_x];
    if (password){
        NSXMLElement* elemnt_password=[NSXMLElement elementWithName:@"password"];
        [elemnt_password setStringValue:password];
        [element_x addChild:elemnt_password];
    }
    [self.manager.xmppStream sendElement:presence];
}
-(void)quitChatRoom:(NSString *)roomJid{
    NSString* memberJid=[NSString stringWithFormat:@"%@/%@",roomJid,self.manager.username];
    XMPPPresence* presence=[XMPPPresence presenceWithType:@"unavailable"];
    [presence addAttributeWithName:@"from" stringValue:self.manager.jid];
    [presence addAttributeWithName:@"to" stringValue:memberJid];
    [self.manager.xmppStream sendElement:presence];
}
#pragma mark - ChatRoom
-(NSDictionary*)chatRooms{
    return _chatRooms;
}
-(DRRRChatRoom*)chatRoom:(NSString *)roomJid{
    DRRRChatRoom* chatRoom=_chatRooms[roomJid];
    if (!chatRoom){
        chatRoom=[[[DRRRChatRoom alloc]initWithChatRoomJid:roomJid] autorelease];
        _chatRooms[roomJid]=chatRoom;
    }
    return chatRoom;
}
#pragma mark - ChatRoomMembers
-(void)updateDRRRGroupChatMember:(DRRRChatRoomMember *)chatRoomMember{
    if (!chatRoomMember)
        return;
    DRRRChatRoom* chatRoom=[self chatRoom:chatRoomMember.chatRoomJid];
    [chatRoom updateChatRoomMember:chatRoomMember];
}
-(DRRRChatRoomMember*)member:(NSString *)jid
                  inChatRoom:(NSString *)chatRoomJid{
    DRRRChatRoom* chatRoom=_chatRooms[chatRoomJid];
    if (!chatRoom){
        chatRoom=[[[DRRRChatRoom alloc]initWithChatRoomJid:chatRoomJid] autorelease];
        _chatRooms[chatRoomJid]=chatRoom;
    }
    DRRRChatRoomMember* member=chatRoom.memberList[jid];
    if (!member){
        member=[[[DRRRChatRoomMember alloc]init] autorelease];
        member.chatRoomJid=chatRoomJid;
        member.chatRoomMemberJid=jid;
    }
    return member;
}
-(void)inviteMember:(NSString *)jid
      toChatRoomJid:(NSString *)chatRoomJid
             reason:(NSString*)reason
       withPassword:(NSString *)password{
    /*
     <message id="chatroom-1" to="test@conference.222.191.249.155">
     <x xmlns="http://jabber.org/protocol/muc#user">
     <invite to="bdow@222.191.249.155">
     <reason>test</reason>
     </invite>
     </x>
     </message>
     */
    if ([jid rangeOfString:@"@"].location==NSNotFound){
        jid=[NSString stringWithFormat:@"%@@%@",jid,[DRRRManager sharedManager].host];
    }
    XMPPMessage* message=[[XMPPMessage alloc]init];
    [message addAttributeWithName:@"id" stringValue:@"chatroom-1"];
    [message addAttributeWithName:@"to" stringValue:chatRoomJid];
    NSXMLElement* element_x=[NSXMLElement elementWithName:@"x" xmlns:@"http://jabber.org/protocol/muc#user"];
    [message addChild:element_x];
    NSXMLElement* element_invite=[NSXMLElement elementWithName:@"invite"];
    [element_invite addAttributeWithName:@"to" stringValue:jid];
    [element_x addChild:element_invite];
    if (reason){
        NSXMLElement* element_reason=[NSXMLElement elementWithName:@"reason"];
        element_reason.stringValue=reason;
        [element_invite addChild:element_reason];
    }
    if (password){
        NSXMLElement* element_password=[NSXMLElement elementWithName:@"password"];
        element_password.stringValue=password;
        [element_x addChild:element_password];
    }
    [[DRRRManager sharedManager].xmppStream sendElement:message];
}
#pragma mark - XMPPStreamDelegate
-(void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message{
    
    
}
-(void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence{
    if ([presence isChatRoomPresence]){
        /*进入房间时获取的其他成员列表
         <presence xmlns="jabber:client" id="GixiF-41" to="adow@222.191.249.155/drrr" from="test@conference.222.191.249.155/bdow">
         <x xmlns="http://jabber.org/protocol/muc#user">
         <item jid="bdow@222.191.249.155/Spark 2.6.3" affiliation="member" role="participant"/>
         </x>
         </presence>
         */
        /*退出房间时收到状态
         <presence xmlns="jabber:client" from="test@conference.222.191.249.155/adow" to="adow@222.191.249.155/drrr" type="unavailable">
         <x xmlns="http://jabber.org/protocol/muc#user">
         <item jid="adow@222.191.249.155/drrr" affiliation="owner" role="none"/></x>
         </presence>
         
         */
        DRRRChatRoomMember* member=[[[DRRRChatRoomMember alloc]initWithPresence:presence] autorelease];
        [self updateDRRRGroupChatMember:member];
    }
}
-(BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq{
    ///房间条目
    if ([iq isChatRoomItems]){
        ///是否是服务地址返回的
        BOOL is_service_results=NO;
        NSXMLElement* element=iq.childElement;
        for (NSXMLElement* element_item in element.children) {
            NSString* chatRoomJid=element_item.attributesAsDictionary[@"jid"];
            NSString* chatRoomName=element_item.attributesAsDictionary[@"name"];
            ///chatRoomJid里面没有@就说明他只是一个service地址
            if ([chatRoomJid rangeOfString:@"@"].location==NSNotFound){
                [_chatRoomServices addObject:chatRoomJid];
                is_service_results=YES;
            }
            else{
                DRRRChatRoom* chatRoom=[self chatRoom:chatRoomJid];
                chatRoom.name=chatRoomName;
            }
        }
        ///如果只是服务地址，那去获取每个服务下的房间列表
        if (is_service_results){
            for (NSString* serviceJid in _chatRoomServices) {
                [self queryChatRoomsInService:serviceJid];
            }
        }
        ///如果是房间列表返回，那更新通知
        else{
            [[NSNotificationCenter defaultCenter] postNotificationName:DRRRChatRoomRefreshRoomsNotification object:nil];
        }
    }
    ///房间信息查询
    else if ([iq isChatRoomInfo]){
        NSString* chatRoomJid=[[iq from] bare];
        DRRRChatRoom* chatRoom=[self chatRoom:chatRoomJid];
        DRRRChatRoomInfo* chatRoomInfo=[[[DRRRChatRoomInfo alloc]initWithIq:iq] autorelease];
        chatRoom.chatRoomInfo=chatRoomInfo;
        NSLog(@"chatRoomInfo:%@",chatRoomInfo);
        [[NSNotificationCenter defaultCenter] postNotificationName:DRRRChatRoomRefreshRoomsNotification object:chatRoom];
    }
    return YES;
}
@end
