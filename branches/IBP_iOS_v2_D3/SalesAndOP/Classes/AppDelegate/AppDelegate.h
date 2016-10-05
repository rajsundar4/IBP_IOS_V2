//
//  AppDelegate.h
//  SalesAndOP
//
//  Created by Mayur Birari on 03/07/13.
//  Copyright (c) 2013 Linear Logics Corp.. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeViewController.h"
#import "ConfigureViewController.h"

@class LoginViewController;
@class SplashViewController;


/*!
 \internal
 @class AppDelegate
 @abstract Application life cycle class
 @discussion This is an auto genereated class which represent every state of the
             App in each every loop event
 */
@interface AppDelegate : UIApplication <UIApplicationDelegate>

//To check if to rotate the view or not.
@property (assign, nonatomic) BOOL shouldRotate;

/// Represents Window object for the device.
@property (strong, nonatomic) UIWindow *window;

/// Instance for Home View Controller.
@property (strong, nonatomic) HomeViewController *homeViewController;

/// Instance for Login View Controller.
@property (strong, nonatomic) LoginViewController *loginViewController;

/// Instance for Splash View Controller.
@property (strong, nonatomic) SplashViewController *splashViewController;

/// Instance for Setting View Controller.
@property (strong, nonatomic) ConfigureViewController *configureViewController;


/*!
 \internal
 @method loadSettingViewController
 @abstract Displays setting VC
 @discussion This methods load Setting View in Window
 @param nil
 @result nil
 */
-(void)loadSettingViewController;

/*!
 \internal
 @method loadHomeViewController
 @abstract Displays Home VC
 @discussion This methods load Home-Dashboard View in Window
 @param nil
 @result nil
 */
-(void)loadHomeViewController;

/*!
 \internal
 @method showHomeViewController
 @abstract Displays Home VC
 @discussion This methods load Home-Dashboard View in Window
 @param nil
 @result nil
 */
-(void)showHomeViewController;

-(BOOL)isHomeViewControllerLoaded;

/*!
 \internal 
 @method showLoginScreen.
 @abstract
 @discussion Used to show login screen.
 @param nil.
 @result nil.
 */
- (void)showLoginScreen;

@end
