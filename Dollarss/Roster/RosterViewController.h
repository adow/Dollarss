//
//  RosterViewController.h
//  Test-XMPP
//
//  Created by 秦 道平 on 14-3-29.
//  Copyright (c) 2014年 秦 道平. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RosterNewViewController.h"
@interface RosterViewController : UITableViewController<RosterNewViewControllerDelegate,UIAlertViewDelegate>{
    BOOL _observer;
}
@property (nonatomic,retain) UIButton* titleButton;
@end
