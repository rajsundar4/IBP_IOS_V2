//
//  HelpViewController.m
//  S&OP
//
//  Created by Mayur Birari on 17/07/13.
//  Copyright (c) 2013 Linear Logics Corp.. All rights reserved.
//

//#import "MDGenerator.h"
#import "DataController.h"
#import "HelpViewController.h"

#define LANDSCAPE_WIDTH 1024
#define LANDSCAPE_HEIGHT 768
#define PORTRAIT_WIDTH 768
#define PORTRAIT_HEIGHT 1024


/*!
 @class HelpViewController
 @abstract This view controller is used to Display Help View.
 @discussion Help screen will display Help screen with guidline on How to
 used the Dashbaord/Charts.
 */
@interface HelpViewController ()

@end

@implementation HelpViewController


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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    //[self checkForOrientationOfView];
    
    NSString* helpImageName=nil;
    UIInterfaceOrientation fromInterfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    //UIDeviceOrientation currentDeviceOrientation = [[UIDevice currentDevice] orientation];
    if (fromInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || fromInterfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        //if ((self.interfaceOrientation == UIDeviceOrientationLandscapeLeft) || (self.interfaceOrientation == UIDeviceOrientationLandscapeRight)) {
        [self.view setFrame:CGRectMake(0, 0, LANDSCAPE_WIDTH, LANDSCAPE_HEIGHT)];
        [helpScreenImageView setFrame:CGRectMake(0, 0, LANDSCAPE_WIDTH, LANDSCAPE_HEIGHT)];
        [gotItButton setFrame:GOT_IT_BUTTON_LANDSCAPE];
        
        if (![[[[DataController sharedDataInstance] loginUser] userName] isEqualToString:@"guest"]) {
            if([[[DataController sharedDataInstance] reportPageLayoutArray] count] >3) {
                //if([[[MDGenerator sharedMDGeneratorInstance] reportPageLayoutArray] count] >3) {
                
                helpImageName = @"bg_help@2x";
            }
            else {
                
                helpImageName = @"bg_help02@2x";
            }
        }else{
            //Offline mode.
            if([[[DataController sharedDataInstance] reportPageLayoutArray] count] >3) {
                //if([[[MDGenerator sharedMDGeneratorInstance] reportPageLayoutArray] count] >3) {
                
                helpImageName = @"bg_help_offline01@2x";
            }
            else {
                
                helpImageName = @"bg_help_offline02@2x";
            }
        }
        
        
    }else{
        [self.view setFrame:CGRectMake(0, 0, PORTRAIT_WIDTH, PORTRAIT_HEIGHT)];
        [helpScreenImageView setFrame:CGRectMake(0, 0, PORTRAIT_WIDTH, PORTRAIT_HEIGHT)];
        [gotItButton setFrame:GOT_IT_BUTTON_PORTRAIT];
        
        if (![[[[DataController sharedDataInstance] loginUser] userName] isEqualToString:@"guest"]) {
            if([[[DataController sharedDataInstance] reportPageLayoutArray] count] >3) {
                //if([[[MDGenerator sharedMDGeneratorInstance] reportPageLayoutArray] count] >3) {
                
                helpImageName = @"bg_help_portrait@2x";
            }
            else {
                
                helpImageName = @"bg_help02_portrait@2x";
            }
        }else{
            //Offline mode
            if([[[DataController sharedDataInstance] reportPageLayoutArray] count] >3) {
                //if([[[MDGenerator sharedMDGeneratorInstance] reportPageLayoutArray] count] >3) {
                
                helpImageName = @"bg_help_offline01_portrait@2x";
            }
            else {
                
                helpImageName = @"bg_help_offline02_portrait@2x";
            }
        }
        
    }
    [helpScreenImageView setImage:[Global setImage:helpImageName]];
}

- (void) viewDidAppear:(BOOL)animated {

}

/*!
 @method removeHelpViewButtonPressed
 @abstract Used to remove Help screen
 @discussion This method used to remove Help screen from Dashboard
 @param sender - Action object.
 @result nil
 */
- (IBAction)removeHelpViewButtonPressed:(id)sender {

    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

#pragma mark Interface orientation Methods

//  iOS8
- (void)viewWillTransitionToSize:(CGSize)size
       withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    DLog(@"viewWillTransitionToSize");
    
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    //[self checkForOrientationOfView];
    
    NSString* helpImageName=nil;
    UIInterfaceOrientation fromInterfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    //UIDeviceOrientation currentDeviceOrientation = [[UIDevice currentDevice] orientation];
    if (fromInterfaceOrientation == UIInterfaceOrientationPortrait || fromInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        //if ((self.interfaceOrientation == UIDeviceOrientationLandscapeLeft) || (self.interfaceOrientation == UIDeviceOrientationLandscapeRight)) {
        [self.view setFrame:CGRectMake(0, 0, PORTRAIT_WIDTH, PORTRAIT_HEIGHT)];
        [helpScreenImageView setFrame:CGRectMake(0, 0, PORTRAIT_WIDTH, PORTRAIT_HEIGHT)];
        [gotItButton setFrame:GOT_IT_BUTTON_LANDSCAPE];
        
        if (![[[[DataController sharedDataInstance] loginUser] userName] isEqualToString:@"guest"]) {
            if([[[DataController sharedDataInstance] reportPageLayoutArray] count] >3) {
                //if([[[MDGenerator sharedMDGeneratorInstance] reportPageLayoutArray] count] >3) {
                
                helpImageName = @"bg_help@2x";
            }
            else {
                
                helpImageName = @"bg_help02@2x";
            }
        }else{
            //Offline mode.
            if([[[DataController sharedDataInstance] reportPageLayoutArray] count] >3) {
                //if([[[MDGenerator sharedMDGeneratorInstance] reportPageLayoutArray] count] >3) {
                
                helpImageName = @"bg_help_offline01@2x";
            }
            else {
                
                helpImageName = @"bg_help_offline02@2x";
            }
        }
        
        
    }else{
        [self.view setFrame:CGRectMake(0, 0, LANDSCAPE_WIDTH, LANDSCAPE_HEIGHT)];
        [helpScreenImageView setFrame:CGRectMake(0, 0, LANDSCAPE_WIDTH, LANDSCAPE_HEIGHT)];
        [gotItButton setFrame:GOT_IT_BUTTON_PORTRAIT];
        
        if (![[[[DataController sharedDataInstance] loginUser] userName] isEqualToString:@"guest"]) {
            if([[[DataController sharedDataInstance] reportPageLayoutArray] count] >3) {
                //if([[[MDGenerator sharedMDGeneratorInstance] reportPageLayoutArray] count] >3) {
                
                helpImageName = @"bg_help_portrait@2x";
            }
            else {
                
                helpImageName = @"bg_help02_portrait@2x";
            }
        }else{
            //Offline mode
            if([[[DataController sharedDataInstance] reportPageLayoutArray] count] >3) {
                //if([[[MDGenerator sharedMDGeneratorInstance] reportPageLayoutArray] count] >3) {
                
                helpImageName = @"bg_help_offline01_portrait@2x";
            }
            else {
                
                helpImageName = @"bg_help_offline02_portrait@2x";
            }
        }
        
    }
    [helpScreenImageView setImage:[Global setImage:helpImageName]];
}


-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    DLog(@"didRotateFromInterfaceOrientation");
    [self checkForOrientationOfView];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}


#pragma mark Custom Method

/*!
 @method checkForOrientationOfView
 @abstract Used to set the image.
 @discussion This method used to set the image frame and its image according to the orientation.
 @param sender - none
 @result nil
 */
-(void)checkForOrientationOfView{
    DLog(@"checkForOrientationOfView");
    
    NSString* helpImageName=nil;
    UIInterfaceOrientation fromInterfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    //UIDeviceOrientation currentDeviceOrientation = [[UIDevice currentDevice] orientation];
    if (fromInterfaceOrientation == UIInterfaceOrientationPortrait || fromInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
    //if ((self.interfaceOrientation == UIDeviceOrientationLandscapeLeft) || (self.interfaceOrientation == UIDeviceOrientationLandscapeRight)) {
        [self.view setFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.height, [[UIScreen mainScreen] bounds].size.width)];
        [helpScreenImageView setFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.height, [[UIScreen mainScreen] bounds].size.width)];
        [gotItButton setFrame:GOT_IT_BUTTON_LANDSCAPE];
        
        if (![[[[DataController sharedDataInstance] loginUser] userName] isEqualToString:@"guest"]) {
            if([[[DataController sharedDataInstance] reportPageLayoutArray] count] >3) {
            //if([[[MDGenerator sharedMDGeneratorInstance] reportPageLayoutArray] count] >3) {
                
                helpImageName = @"bg_help@2x";
            }
            else {
                
                helpImageName = @"bg_help02@2x";
            }
        }else{
            //Offline mode.
            if([[[DataController sharedDataInstance] reportPageLayoutArray] count] >3) {
            //if([[[MDGenerator sharedMDGeneratorInstance] reportPageLayoutArray] count] >3) {
                
                helpImageName = @"bg_help_offline01@2x";
            }
            else {
                
                helpImageName = @"bg_help_offline02@2x";
            }
        }
        
        
    }else{
        [self.view setFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];
        [helpScreenImageView setFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width + 1, [[UIScreen mainScreen] bounds].size.height)];
        [gotItButton setFrame:GOT_IT_BUTTON_PORTRAIT];
        
        if (![[[[DataController sharedDataInstance] loginUser] userName] isEqualToString:@"guest"]) {
            if([[[DataController sharedDataInstance] reportPageLayoutArray] count] >3) {
            //if([[[MDGenerator sharedMDGeneratorInstance] reportPageLayoutArray] count] >3) {
                
                helpImageName = @"bg_help_portrait@2x";
            }
            else {
                
                helpImageName = @"bg_help02_portrait@2x";
            }
        }else{
            //Offline mode
            if([[[DataController sharedDataInstance] reportPageLayoutArray] count] >3) {
            //if([[[MDGenerator sharedMDGeneratorInstance] reportPageLayoutArray] count] >3) {
                
                helpImageName = @"bg_help_offline01_portrait@2x";
            }
            else {
                
                helpImageName = @"bg_help_offline02_portrait@2x";
            }
        }
        
    }
    [helpScreenImageView setImage:[Global setImage:helpImageName]];
}


@end
