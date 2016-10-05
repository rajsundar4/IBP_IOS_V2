//
//  LogoffViewController.h
//  S&OP
//
//  Created by Ganesh D on 19/08/13.
//  Copyright (c) 2013 Linear Logics Corp.. All rights reserved.
//

#import <UIKit/UIKit.h>

/*!
 \internal
 @class UserDetailsViewController
 @abstract This view controller is used to Display user details.
 @discussion Screen will display username, logout like options.
 */
@interface UserDetailsViewController : UIViewController

/// log out button for current login user.
@property (weak, nonatomic) IBOutlet UIButton *logoffButton;
@property (weak,nonatomic) IBOutlet UIView *logoffView;

@end
