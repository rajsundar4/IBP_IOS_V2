//
//  AppDelegate.m
//  SalesAndOP
//
//  Created by Mayur Birari on 03/07/13.
//  Copyright (c) 2013 Linear Logics Corp.. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "SplashViewController.h"
#import "DataController.h"
#import <MessageUI/MessageUI.h>

NSTimer *idleTimer=nil;

/*!
 @class AppDelegate
 @abstract Application life cycle class
 @discussion This is an auto genereated class which represent every state of the
 App in each every loop event
 */
@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    
    [self initializeNSUserDefaults];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // Override point for customization after application launch.
    self.splashViewController = [[SplashViewController alloc] initWithNibName:@"SplashViewController" bundle:nil];
    self.window.rootViewController = self.splashViewController;
    [self.window makeKeyAndVisible];
    
    return YES;
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application{
    
    //[(LocalSessionTimeout *)[UIApplication sharedApplication] resetIdleTimer];
}

- (void)applicationDidBecomeActive:(UIApplication *)application{
    
    //[(LocalSessionTimeout *)[UIApplication sharedApplication] invalidateTimer];
    
    if([[NSUserDefaults standardUserDefaults]
        integerForKey:kSelectedLocalTimeoutValue] && ![idleTimer isValid])
        [self showLoginScreen];
}

#pragma mark - Custom Methods

/*!
 @method showLoginScreen.
 @abstract
 @discussion Used to show login screen.
 @param nil.
 @result nil.
 */
- (void)showLoginScreen {
    
    // Every time app becomes active and user on dashboard, app will ask him todo login again
    if([self.window.rootViewController isKindOfClass:[HomeViewController class]] && ![[[[DataController sharedDataInstance] loginUser] userName] isEqualToString:@"guest"]) {
        
        //[self.homeViewController logoffProcess];
        
        if(!self.loginViewController){
            
            self.loginViewController = [[LoginViewController alloc]
                                        initWithNibName:@"LoginViewController" bundle:nil];
        }
        
        
        // Login should be add at the top of the view
        UIViewController* topViewController = self.window.rootViewController;
        while ([topViewController presentedViewController]) {
            
            if([[topViewController presentedViewController] isKindOfClass:[MFMailComposeViewController class]]) {
                
                [topViewController dismissViewControllerAnimated:NO completion:^{}];
                break;
            }
            topViewController=[topViewController presentedViewController];
        }
        
        [topViewController.view addSubview:self.loginViewController.view];
        [self.loginViewController viewWillAppear:YES];
    }
}

/*!
 @method loadSettingViewController
 @abstract Displays setting VC
 @discussion This methods load Setting View in Window
 @param nil
 @result nil
 */
-(void)loadSettingViewController {
    
    if(self.configureViewController==nil) {
        self.configureViewController = [[ConfigureViewController alloc] initWithNibName:@"ConfigureViewController" bundle:nil];
    }
    
    self.window.rootViewController = self.configureViewController;
    [self.window makeKeyAndVisible];
    
    
}

/*!
 @method loadHomeViewController
 @abstract Displays Home VC
 @discussion This methods load Home-Dashboard View in Window
 @param nil
 @result nil
 */
-(void)loadHomeViewController {
    
    if(self.homeViewController!=nil) {
        self.homeViewController=nil;
    }
    self.homeViewController = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
    self.window.rootViewController = self.homeViewController;
    [self.window makeKeyAndVisible];
    
}

/*!
 @method showHomeViewController
 @abstract Displays Home VC
 @discussion This methods load Home-Dashboard View in Window
 @param nil
 @result nil
 */
-(void)showHomeViewController {
    
    if(self.homeViewController == nil) {
        self.homeViewController = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
    }
    self.window.rootViewController = self.homeViewController;
    [self.window makeKeyAndVisible];
    
}

-(BOOL)isHomeViewControllerLoaded {
    
    BOOL isHomeLoaded= NO;
    
    if(self.homeViewController) {
        
        isHomeLoaded = YES;
    }
    
    return isHomeLoaded ;
}

#pragma mark-
#pragma Touch Event delegate

- (void)sendEvent:(UIEvent *)event {
    [super sendEvent:event];
    
    // Only want to reset the timer on a Began touch or an Ended touch, to reduce the number of timer resets.
    NSSet *allTouches = [event allTouches];
    if ([allTouches count] > 0) {
        // allTouches count only ever seems to be 1, so anyObject works here.
        UITouchPhase phase = ((UITouch *)[allTouches anyObject]).phase;
        // if (phase == UITouchPhaseBegan || phase == UITouchPhaseEnded)
        if (phase == UITouchPhaseBegan)
            [self resetIdleTimer];
    }
}

- (void)resetIdleTimer {
    if (idleTimer) {
        [idleTimer invalidate];
    }
    
    int maxIdleTime = [[NSUserDefaults standardUserDefaults]
                       integerForKey:kSelectedLocalTimeoutValue];
    if(maxIdleTime) {
        idleTimer = [NSTimer scheduledTimerWithTimeInterval:maxIdleTime*60 target:self selector:@selector(idleTimerExceeded) userInfo:nil repeats:NO];
    }
}

- (void)idleTimerExceeded {
    DLog(@"idle time exceeded");
    
        [self showLoginScreen];
}

//Returns the supported interface orientations for the particular view.
- (NSUInteger) application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    if(self.shouldRotate)
    {
        self.shouldRotate = NO;
        return UIInterfaceOrientationMaskLandscapeRight;
        
    }
    return UIInterfaceOrientationMaskLandscapeRight | UIInterfaceOrientationMaskPortraitUpsideDown | UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskPortrait;
}

- (void) initializeNSUserDefaults
{
    [[NSUserDefaults standardUserDefaults] setValue:@" " forKey:kMode];
    [[NSUserDefaults standardUserDefaults] setValue:@" " forKey:kAuthCode];
    [[NSUserDefaults standardUserDefaults] setValue:@"OFFLINE" forKey:kJamStatus];
    
}

@end
