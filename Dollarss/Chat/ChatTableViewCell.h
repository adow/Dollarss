//
//  ChatTableViewCell.h
//  Test-XMPP
//
//  Created by 秦 道平 on 14-3-30.
//  Copyright (c) 2014年 秦 道平. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "drrr.h"
#define ChatTableViewCellFontSize 17.0f

@interface ChatTableViewCell : UITableViewCell{
    DRRRMessageContent* _message;
}
@property (nonatomic,retain) DRRRMessageContent* message;
@property (nonatomic,retain) UITextView* messageText;
@property (nonatomic,retain) UILabel* infoLabel;
@end
