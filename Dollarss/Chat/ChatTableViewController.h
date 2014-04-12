//
//  ChatTableViewController.h
//  Test-XMPP
//
//  Created by 秦 道平 on 14-3-29.
//  Copyright (c) 2014年 秦 道平. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "drrr.h"
@interface ChatTableViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    
}
@property (nonatomic,retain) DRRRRosterMember* member;
@property (nonatomic,retain) DRRRChatRoom* chatRoom;
@property (nonatomic,retain) IBOutlet UIView* sendMessageView;
@property (nonatomic,retain) IBOutlet UITextView* sendMessageText;
@property (nonatomic,retain) IBOutlet UIButton* sendMessageButton;
@property (nonatomic,retain) UITableView* tableView;
@end
