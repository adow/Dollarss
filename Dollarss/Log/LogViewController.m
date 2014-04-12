//
//  LogViewController.m
//  Test-XMPP
//
//  Created by 秦 道平 on 14-4-2.
//  Copyright (c) 2014年 秦 道平. All rights reserved.
//

#import "LogViewController.h"
#import "AppDelegate.h"
@interface LogViewController ()<UITextViewDelegate>

@end

@implementation LogViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title=@"调试日志";
    if (!_textLogs){
        _textLogs=[[UITextView alloc]initWithFrame:self.view.bounds];
        _textLogs.showsHorizontalScrollIndicator=NO;
        _textLogs.editable=NO;
        _textLogs.delegate=self;
        [self.view addSubview:_textLogs];
    }
    AppDelegate* app=[UIApplication sharedApplication].delegate;
    NSArray* files=[app.fileLogger.logFileManager sortedLogFileNames];
    NSArray* paths=[app.fileLogger.logFileManager sortedLogFilePaths];
    NSLog(@"files:%@",files);
    NSLog(@"paths:%@",paths);
    NSString* top_file=paths[0];
    NSString* log=[NSString stringWithContentsOfFile:top_file encoding:NSUTF8StringEncoding error:nil];
    self.textLogs.text=log;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CGFloat scroll=self.textLogs.contentSize.height-self.textLogs.frame.size.height;
        [self.textLogs setContentOffset:CGPointMake(0.0f, scroll) animated:YES];
        
    });
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    _textLogs.delegate=nil;
    [_textLogs release];
    [super dealloc];
}
#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    NSLog(@"%f",scrollView.contentOffset.y);
}
@end
