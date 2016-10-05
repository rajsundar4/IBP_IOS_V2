//
//  ErrorMessage.h
//  S&OP
//
//  Created by Mayur Birari on 26/07/13.
//  Copyright (c) 2013 Linear Logics Corp.. All rights reserved.
//

/*!
 \internal
 @class ErrorMessage
 @abstract This class holds global error messages
 @discussion ErrorMessage will represent general constant errror messages which
             required throught the application
 */

#pragma mark- Setting Screen

#define kLoginFailedTitle @"Login failure"
#define kLoginFailedDescr @"Please check your username or password."
#define kSessionInValid @"Session id is invalid, please contact support."
#define kInvalidServerUrlTitle @"Invalid url"
#define kInvalidServerUrlDescr @"Invalid url for S&OP server."
#define kTextfieldBlankTitle @"Insufficient user data"
#define kTextfieldBlankDescr @"Please enter all fields in the connection settings."
#define kRequestFailedDescr @"Request Failed."

#define kLogoffFailedDescr @"Logout failure."

#pragma mark - Login View

#define kWrongUsernameOrPassword @"Invalid username or password."

#pragma mark - DataController

#define kNoDefaultPlannigAreaFound @"No default planning area found. Please check the user's configuration on the S&OP system."

#pragma mark - Other

#define kNoInternetConnectionDescr @"No network connectivity. Please check your network connection."
#define kCancelAlertButton @"OK"
#define kSessionTimeOutDescr @"Your session has timed out, please login again."

#define kStatusCode404 404
#define kStatusCode0 0
#define kStatusCode405 405