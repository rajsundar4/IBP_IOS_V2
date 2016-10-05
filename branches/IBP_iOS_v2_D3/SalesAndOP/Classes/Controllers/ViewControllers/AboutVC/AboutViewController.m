//
//  LoginViewController.m
//  S&OP
//
//  Created by Mayur Birari on 25/07/13.
//  Copyright (c) 2013 Linear Logics Corp. All rights reserved.
//

#import "AboutViewController.h"

/*!
 @class AboutViewController
 @abstract This view controller is used to Display About app information.
 @discussion From Setting screen, user can called About Screen by pressing info icon.
 */
@interface AboutViewController ()

@end

@implementation AboutViewController
@synthesize versionLabel;

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
    //To set the bundle version of the app.
    [versionLabel setText:[NSString stringWithFormat:@"Version %@",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]]];
}

-(void)viewWillAppear:(BOOL)animated{
    if((self.interfaceOrientation == UIDeviceOrientationLandscapeLeft) || (self.interfaceOrientation == UIDeviceOrientationLandscapeRight)){
        [self.view setFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];
    }else{
        [self.view setFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark- UITouch delegate

// UIView touch began delegate
// touch it is handling (those touches it received in touchesBegan:withEvent:).
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self.view removeFromSuperview];
}


@end
