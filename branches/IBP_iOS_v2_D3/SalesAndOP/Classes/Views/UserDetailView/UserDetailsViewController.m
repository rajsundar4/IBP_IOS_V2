//
//  LogoffViewController.m
//  S&OP
//
//  Created by Ganesh D on 19/08/13.
//  Copyright (c) 2013 Linear Logics Corp.. All rights reserved.
//

#import "UserDetailsViewController.h"
#import "Global.h"

/*!
 @class UserDetailsViewController
 @abstract This view controller is used to Display user details.
 @discussion Screen will display username, logout like options.
 */
@interface UserDetailsViewController ()

@end

@implementation UserDetailsViewController
@synthesize logoffView;

#pragma mark View Life Cycle Methods

-(void)viewWillAppear:(BOOL)animated{
    if((self.interfaceOrientation == UIDeviceOrientationLandscapeLeft) || (self.interfaceOrientation == UIDeviceOrientationLandscapeRight)){
        //[self.view setFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];
        //NSLog(@"width: %f, height: %f", [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height );
        [self.logoffView setFrame:LOG_OFF_VIEW_LANDSCAPE];
    }else{
        //[self.view setFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];
        [self.logoffView setFrame:LOG_OFF_VIEW_PORTRAIT];
    }
}

#pragma mark Interface Orientation Methods

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    if((self.interfaceOrientation == UIDeviceOrientationLandscapeLeft) || (self.interfaceOrientation == UIDeviceOrientationLandscapeRight)){
        //[self.view setFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];
         [self.logoffView setFrame:LOG_OFF_VIEW_LANDSCAPE];
    }else{
        //[self.view setFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];
         [self.logoffView setFrame:LOG_OFF_VIEW_PORTRAIT];
    }
}

@end
