//
//  RosterNewViewController.h
//  Test-XMPP
//
//  Created by 秦 道平 on 14-3-31.
//  Copyright (c) 2014年 秦 道平. All rights reserved.
//

#import <UIKit/UIKit.h>
@class  RosterNewViewController;
@protocol RosterNewViewControllerDelegate<NSObject>
-(void)cancelRosterNewViewController:(RosterNewViewController*)rosterNewViewController;
-(void)saveRosterNewViewController:(RosterNewViewController*)rosterNewViewController;
@end
@interface RosterNewViewController : UIViewController{
    
}
@property (nonatomic,retain) UITextField* nameText;
@property (nonatomic,retain) UITextField* jidText;
@property (nonatomic,assign) id<RosterNewViewControllerDelegate> delegate;
@end
