//
//  ChatTableViewCell.m
//  Test-XMPP
//
//  Created by 秦 道平 on 14-3-30.
//  Copyright (c) 2014年 秦 道平. All rights reserved.
//

#import "ChatTableViewCell.h"

@implementation ChatTableViewCell
@dynamic message;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _infoLabel=[[UILabel alloc]initWithFrame:CGRectMake(5.0f, 0.0f, self.frame.size.width-10, 30.0f)];
        _infoLabel.font=[UIFont systemFontOfSize:14.0f];
        _infoLabel.textColor=[UIColor grayColor];
        [self addSubview:_infoLabel];
        _messageText=[[UITextView alloc]initWithFrame:CGRectMake(0.0f, 15.0f, 320, self.frame.size.height-11.0f)];
        _messageText.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        _messageText.showsHorizontalScrollIndicator=NO;
        _messageText.showsVerticalScrollIndicator=NO;
        _messageText.editable=NO;
        _messageText.scrollEnabled=NO;
        _messageText.backgroundColor=[UIColor clearColor];
        _messageText.font=[UIFont systemFontOfSize:ChatTableViewCellFontSize];
        [self insertSubview:_messageText atIndex:0];
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
    [_message release];
    [_infoLabel release];
    [_messageText release];
    [super dealloc];
}
-(void)prepareForReuse{
    self.infoLabel.text=@"";
    self.messageText.text=@"";
    self.infoLabel.textAlignment=NSTextAlignmentLeft;
    self.messageText.textAlignment=NSTextAlignmentLeft;
    self.backgroundColor=[UIColor whiteColor];
}
-(void)setMessage:(DRRRMessageContent *)message{
    [_message release];
    [message retain];
    _message=message;
    self.messageText.text=message.body;
    NSDateFormatter* formatter=[[[NSDateFormatter alloc]init] autorelease];
    [formatter setDateStyle:NSDateFormatterShortStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    NSString* timeStr=[formatter stringFromDate:message.showTime];
    
    if (message.mySender){
        self.backgroundColor=[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.03f];
        self.infoLabel.textAlignment=NSTextAlignmentRight;
        self.messageText.textAlignment=NSTextAlignmentRight;
        if (message.isGroupChat){
            self.infoLabel.text=[NSString stringWithFormat:@"%@ at %@",message.fromName,timeStr];
        }
        else if (message.isChat){
            self.infoLabel.text=timeStr;
        }
        
    }
    else{
        self.backgroundColor=[UIColor whiteColor];
        self.messageText.textAlignment=NSTextAlignmentLeft;
        self.infoLabel.textAlignment=NSTextAlignmentLeft;
        self.infoLabel.text=[NSString stringWithFormat:@"%@ at %@",message.fromName,timeStr];
    }
}
-(DRRRMessageContent*)message{
    return _message;
}
@end
