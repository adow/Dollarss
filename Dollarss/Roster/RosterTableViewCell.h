//
//  RosterTableViewCell.h
//  Test-XMPP
//
//  Created by 秦 道平 on 14-3-29.
//  Copyright (c) 2014年 秦 道平. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "drrr.h"
@interface RosterTableViewCell : UITableViewCell{
    DRRRRosterMember* _member;
}
@property (nonatomic,retain) UILabel* nameLabel;
@property (nonatomic,retain) UILabel* statusLabel;
@property (nonatomic,retain) DRRRRosterMember* member;
@end
