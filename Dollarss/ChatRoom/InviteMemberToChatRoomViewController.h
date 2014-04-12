//
//  InviteMemberToChatRoomViewController.h
//  Test-XMPP
//
//  Created by 秦 道平 on 14-4-12.
//  Copyright (c) 2014年 秦 道平. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "drrr.h"
@interface InviteMemberToChatRoomViewController : UITableViewController{
    
}
@property (nonatomic,retain) UITextField* memberJidText;
@property (nonatomic,retain) UITextField* reasonText;
@property (nonatomic,retain) UITextField* passwordText;
@property (nonatomic,retain) DRRRChatRoom* chatRoom;
@end
