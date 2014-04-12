//
//  RosterTableViewCell.m
//  Test-XMPP
//
//  Created by 秦 道平 on 14-3-29.
//  Copyright (c) 2014年 秦 道平. All rights reserved.
//

#import "RosterTableViewCell.h"

@implementation RosterTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _nameLabel=[[UILabel alloc]initWithFrame:CGRectInset(self.bounds, 15.0f, 0.0f)];
        [self addSubview:_nameLabel];
        _statusLabel=[[UILabel alloc]initWithFrame:self.bounds];
        _statusLabel.textColor=[UIColor grayColor];
        _statusLabel.textAlignment=NSTextAlignmentRight;
        [self addSubview:_statusLabel];
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)dealloc{
    [_member release];
    [super dealloc];
}
-(void)prepareForReuse{
    [super prepareForReuse];
    self.nameLabel.textColor=[UIColor grayColor];
    self.nameLabel.text=@"";
    self.statusLabel.text=@"";
}
-(void)setMember:(DRRRRosterMember *)member{
    [_member release];
    [member retain];
    _member=member;
    if (!member.unread_total){
        self.nameLabel.text=member.name;
    }
    else{
        self.nameLabel.text=[NSString stringWithFormat:@"%@ (%d)",member.name,member.unread_total];
    }
    NSMutableString* status=[NSMutableString string];
    if (member.show){
        [status appendString:member.show];
    }
    if (status.length>0){
        [status appendString:@"/"];
    }
    if (member.status){
        [status appendString:member.status];
    }
    if (member.want_to_subscribe_me){
        status=[NSMutableString stringWithString:@"正在邀请"];
    }
    self.statusLabel.text=status;
    if (member.available){
        self.nameLabel.textColor=[UIColor darkTextColor];
    }
    else{
        self.nameLabel.textColor=[UIColor grayColor];
    }
}
-(DRRRRosterMember*)member{
    return _member;
}

@end
