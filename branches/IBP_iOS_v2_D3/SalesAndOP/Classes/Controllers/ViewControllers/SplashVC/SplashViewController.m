//
//  SplashViewController.m
//  SalesAndOP
//
//  Created by Mayur Birari on 03/07/13.
//  Copyright (c) 2013 Linear Logics Corp.. All rights reserved.
//

#import "DBManager.h"
#import "AppDelegate.h"
#import "UIConfigValue.h"
#import "SplashViewController.h"

/*!
 @class SplashViewController
 @abstract This view controller is used for Splash.
 @discussion Splash screen will display for 5 seconds, and Animation will handle
 in this view controller, we integrated video file to show the animation.
 */
@interface SplashViewController () {
    
    /// Splash timer object which we created locally.
    NSTimer *splashTimer;
    
    /// Data Manager instance, first time app installation need to copy the
    /// sqlite file in data dictionary
    DBManager *database;

}

@end

@implementation SplashViewController

/*!
 @method loadConfigureView
 @abstract Displays setting VC
 @discussion This methods load Setting View in Window using AppDelegate instance
 @param nil
 @result nil
 */
-(void)loadConfigureView {
    
    AppDelegate* appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    [appDelegate loadSettingViewController];
    [splashTimer invalidate];
}

- (void)loadSettingsViewController
{
    AppDelegate* appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    if(appDelegate.configureViewController==nil) {
        appDelegate.configureViewController = [[ConfigureViewController alloc] initWithNibName:@"ConfigureViewController" bundle:nil];
    }
    
    //self.window.rootViewController = self.configureViewController;
    //[self.window makeKeyAndVisible];
    [appDelegate.configureViewController setModalInPopover:YES];
    [appDelegate.configureViewController setModalPresentationStyle:UIModalPresentationPageSheet];
    [self presentViewController:appDelegate.configureViewController animated:YES completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // 9 seconds timer to move from splash
    //splashTimer=[NSTimer scheduledTimerWithTimeInterval:kSplashScreenTimeout target:self selector:@selector(loadConfigureView) userInfo:nil repeats:NO];
    
    [self.view setUserInteractionEnabled:NO];
    
    //  Set timer for 3 seconds to show static image
    //  Then execute 'loadConfigureView' for fullscreen settings dialog
    //  'loadSettingsViewController' is new method to load moadal view.   Not functioning yet!
    //[NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(loadSettingsViewController) userInfo:nil repeats:NO];
    [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(loadConfigureView) userInfo:nil repeats:NO];
    
    // Load the data manager
    database = [[DBManager alloc] init];
    
}

/*!
 @method loadVideoAnimation
 @abstract Displays Splash Animation
 @discussion This methods load Splash animation in video player
 @param nil
 @result nil
 */
-(void) loadVideoAnimation {
    
    NSURL *fileURL = [NSURL fileURLWithPath:kSplashVideoURL];
    self.moviePlayerController = [[MPMoviePlayerController alloc] initWithContentURL:fileURL];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(introMovieFinished:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:self.moviePlayerController];
    
    // Hide the video controls from the user
    [self.moviePlayerController setControlStyle:MPMovieControlStyleNone];
    [self.moviePlayerController prepareToPlay];
    [self.moviePlayerController.view setFrame:kMoviewControllerFrame];
    
    [self.view addSubview:self.moviePlayerController.view];
    
    [self.moviePlayerController play];
}

/*!
 @method introMovieFinished
 @abstract notification on introductory splash video finish
 @discussion This methods remove the video player once the video finish
 @param nil
 @result nil
 */
- (void)introMovieFinished:(NSNotification *)notification {
    
    [self.moviePlayerController.view removeFromSuperview];
    self.moviePlayerController=nil;
    [self.view setUserInteractionEnabled:YES];
    
}
- (void)viewWillAppear:(BOOL)animated {
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
}

-(void)viewDidAppear:(BOOL)animated {
    
    // Load animation video
    //[self loadVideoAnimation];
    
    // Initialise database if user open app firsttime to copy db from bundle to dictionary
    [self performSelectorInBackground:@selector(setupDatabase) withObject:nil];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
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
    
    //[self loadConfigureView];
}

//Used to check whether to rotate the view or not.
- (BOOL)shouldAutorotate
{
    AppDelegate *mainDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    mainDelegate.shouldRotate = YES;
    return YES;
}

//Used to set the interfaceOrientations for that particular views
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscapeRight;
}

//Used to rotate the view in Portrait as well as landscape.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

#pragma mark- Database Manager

/*!
 @function   setupDatabase
 @abstract   connet with the sql database
 @discussion This method is used to connect with the document dictionary database.
 */
-(void)setupDatabase{
    
    [database setupDatabase];
    
}

@end
