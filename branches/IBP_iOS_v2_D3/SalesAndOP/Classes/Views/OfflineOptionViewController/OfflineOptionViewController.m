//
//  OfflineOptionViewController.m
//  S&OP
//
//  Created by Mayur Birari on 04/10/13.
//  Copyright (c) 2013 Linear Logics Corp.. All rights reserved.
//

#import "AppDelegate.h"
#import "OfflineOptionViewController.h"

@interface OfflineOptionViewController ()

@end

@implementation OfflineOptionViewController

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
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:YES];
    
    if((self.interfaceOrientation == UIDeviceOrientationLandscapeLeft) || (self.interfaceOrientation == UIDeviceOrientationLandscapeRight)){
        [self.view setFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];
        [self.view setFrame:CGRectMake(0, 0, 1024, 768)];
    }else{
        [self.view setFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];
        [self.view setFrame:CGRectMake(0, 0, 768, 1024)];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)offlineEnableDatabaseButtonPressed:(id)sender {
    
    [self.view removeFromSuperview];
    
    AppDelegate* appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [appDelegate.configureViewController enableOfflineDemoButtonPressed:nil];
    
}

- (IBAction)downloadButtonPressed:(id)sender {
    
    [self.view removeFromSuperview];
    
    AppDelegate* appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [appDelegate.configureViewController showDefaultDashboardConnectionView];
    
}

- (IBAction)cancelOfflineButtonPressed:(id)sender {
    
    [self.view removeFromSuperview];
}
@end
