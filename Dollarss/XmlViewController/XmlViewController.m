//
//  XmlViewController.m
//  Test-XMPP
//
//  Created by 秦 道平 on 14-4-5.
//  Copyright (c) 2014年 秦 道平. All rights reserved.
//

#import "XmlViewController.h"
#import "drrr.h"
@interface XmlViewController ()

@end

@implementation XmlViewController

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
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationItem.title=@"xmpp debug";
    self.navigationItem.rightBarButtonItem=[[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(onButtonDone:)] autorelease];
    UIColor* grayColor=[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.03f];
    if (!_inputTextView){
        _inputTextView=[[UITextView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, self.view.frame.size.height/2)];
        _inputTextView.backgroundColor=grayColor;
        [self.view addSubview:_inputTextView];
    }
    if (!_outputTextView){
        _outputTextView=[[UITextView alloc]initWithFrame:CGRectMake(0.0f, self.view.frame.size.height/2+5.0f, 320.0f, self.view.frame.size.height/2)];
        _outputTextView.backgroundColor=grayColor;
        [self.view addSubview:_outputTextView];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)onButtonDone:(id)sender{
    self.outputTextView.text=@"";
    [[DRRRManager sharedManager] sendXmlString:self.inputTextView.text];
    
    
}

@end
