//
//  LoginViewController.h
//  S&OP
//
//  Created by Mayur Birari on 25/07/13.
//  Copyright (c) 2013 Linear Logics Corp.. All rights reserved.
//

#import <UIKit/UIKit.h>

/*!
 \internal
 @class LoginViewController
 @abstract This view controller is used to Display Login View.
 @discussion Help screen will display Login screen to validate the logined user, on inactivity timeout.
 */
@interface LoginViewController : UIViewController <UITextFieldDelegate>

/*!
 \internal
 @method loginButtonPressed
 @abstract Used to verify login information.
 @discussion This method used to do login  and validate user and information.
 @param sender - Action object.
 @result nil
 */
- (IBAction)loginButtonPressed:(id)sender;

@end
