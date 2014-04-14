//
//  DRRRManager.h
//  TestChat
//
//  Created by 秦 道平 on 14-3-18.
//  Copyright (c) 2014年 秦 道平. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMPPFramework.h"

#define DRRRManager_Online_Notification @"DRRRManager_Online_Notification" ///登录成功或者失败时的通知
#define DRRRManager_StoreKey_Username @"signin.username"
#define DRRRManager_StoreKey_Password @"signin.password"
#define DRRRManager_StoreKey_Host @"signin.host"
#define DRRRManager_Roster_Receive_Subscribe @"DRRRManager_Roster_Receive_Subscribe" ///接受到订阅时的通知
@interface DRRRManager : NSObject<XMPPStreamDelegate,UIAlertViewDelegate>{
    XMPPStream* _xmppStream;
    BOOL _online;
    ///是否是注册，否则是登录
    BOOL _registerAction;
    XMPPReconnect *_xmppReconnect;    
}
@property (nonatomic,copy) NSString* username;
@property (nonatomic,copy) NSString* password;
@property (nonatomic,copy) NSString* host;
///当前的登录用户id
@property (nonatomic,copy) NSString* jid;
///是否在线
@property (nonatomic,readonly) BOOL online;
+(DRRRManager*)sharedManager;
@property (nonatomic,readonly) XMPPStream* xmppStream;
#pragma mark - action
///登录
-(void)signinWithUsername:(NSString*)username password:(NSString*)password host:(NSString*)host isregister:(BOOL)isregister;
///自动登录
-(void)autoSignin;
///退出
-(void)signout;
#pragma mark subscribe
#pragma mark - message
///发送xml
-(void)sendXmlString:(NSString*)xmlString;
@end
