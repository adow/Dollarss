//
//  ViewController.h
//  Test-XMPP
//
//  Created by 秦 道平 on 14-3-25.
//  Copyright (c) 2014年 秦 道平. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface CellCommand:NSObject
@property (nonatomic,copy) NSString* title;
@property (nonatomic,assign) SEL action;
-(id)initWithTitle:(NSString*)title action:(SEL)action;
+(id)cellCommandWithTitle:(NSString*)title action:(SEL)action;
@end
@interface ViewController : UITableViewController{
    NSMutableArray* _cellCommandList;
}
@end
