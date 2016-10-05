//
//  LoginViewController.m
//  S&OP
//
//  Created by Mayur Birari on 25/07/13.
//  Copyright (c) 2013 Linear Logics Corp.. All rights reserved.
//

#import "Global.h"
#import "AppDelegate.h"
#import "DataController.h"
#import "LoginViewController.h"

/*!
 @class LoginViewController
 @abstract This view controller is used to Display Login View.
 @discussion Help screen will display Login screen to validate the logined user, on inactivity timeout.
 */
@interface LoginViewController () {
    
    /// local textfield to represent username.
    UITextField* usernameTF;
    
    /// local textfield to represent password.
    UITextField* passwordTF;
    
    /// Used to call methods from other classes.
    AppDelegate* appDelegate;
    
    /// Used to show appropriate error alert.
    ErrorTags errorTag;
}

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    //  iOS8 fix
    if (self.view.frame.size.width > self.view.frame.size.height) {
        //if((self.interfaceOrientation == UIDeviceOrientationLandscapeLeft) || (self.interfaceOrientation == UIDeviceOrientationLandscapeRight)){
        [self.view setFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.height, [[UIScreen mainScreen] bounds].size.width)];
    }else{
        [self.view setFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];
    }
    NSLog(@"frame width: %f, height: %f", self.view.frame.size.width,self.view.frame.size.height);
    NSLog(@"mainScreen bounds width: %f, height: %f", [[UIScreen mainScreen] bounds].size.width,[[UIScreen mainScreen] bounds].size.height);
    
    // Setup username and password textfield
    usernameTF = (UITextField *)[self.view viewWithTag:kUsernameTextfieldTag];
    passwordTF = (UITextField *)[self.view viewWithTag:kPassworsTextfieldTag];
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:YES];
    
    //  iOS8 fix
    /**
    if (self.view.frame.size.width > self.view.frame.size.height) {
    //if((self.interfaceOrientation == UIDeviceOrientationLandscapeLeft) || (self.interfaceOrientation == UIDeviceOrientationLandscapeRight)){
        [self.view setFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.height, [[UIScreen mainScreen] bounds].size.width)];
    }else{
        [self.view setFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];
    }
    **/
    
    // Initialise appdelegate instance.
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [usernameTF setText:@""];
    [passwordTF setText:@""];
    
    if([[[NSUserDefaults standardUserDefaults] valueForKey:kSaveUsername] length]) {
        
        [usernameTF setText:[[NSUserDefaults standardUserDefaults] valueForKey:kSaveUsername]];
    }
}

/*!
 @method loginButtonPressed
 @abstract Used to verify login information
 @discussion This method used to do login  and validate user and information
 @param sender
 @result nil
 */
- (IBAction)loginButtonPressed:(id)sender {
    
    NSError __autoreleasing *returnError;
    
    if([Global isNetworkReachable]){
        
        // Start indicator.
        [Global showProgessindicator:self.view];
        
        if([usernameTF.text length]!=0 || [passwordTF.text length]!=0) {
            
            //NSError __autoreleasing *returnError;
            User *loginUser = [[DataController sharedDataInstance] loginUser];
            
            [usernameTF resignFirstResponder];
            [passwordTF resignFirstResponder];
            
            if(loginUser) {
                if([loginUser.userName isEqualToString:[usernameTF.text uppercaseString]] &&
                   [loginUser.password isEqualToString:passwordTF.text]) {
                    
                    // Remove indicator.
                    [Global hideProgessIndicator];
                    
                    [self.view removeFromSuperview];
                    
                    if(![[DataController sharedDataInstance] isSessionValid:loginUser.userName andReturnError:&returnError]) {
                        
                        BOOL isLogin=FALSE;
                        isLogin = [[DataController sharedDataInstance] isLoginValid:loginUser.userName andPassword:loginUser.password andReturnError:&returnError];
                        if(isLogin)
                            [appDelegate.homeViewController refreshButtonPressed:nil];
                        
                    }
                }
                else {
                    // Remove indicator.
                    [Global hideProgessIndicator];
                    [self showErrorOnWrongCredentials];
                }
            } // login and refresh view
            else {
                dispatch_async(dispatch_queue_create("com.ameri100.saop", DISPATCH_QUEUE_SERIAL), ^{
                    
                    NSError __autoreleasing *returnError;
                    
                    BOOL isLogin=FALSE;
                    isLogin = [[DataController sharedDataInstance] isLoginValid:[usernameTF.text uppercaseString] andPassword:passwordTF.text andReturnError:&returnError];
                    
                    // Get callback on Main thread.
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        
                        // Remove indicator.
                        [Global hideProgessIndicator];
                        
                        if(isLogin) {
                            
                            // Save username and password.
                            [[DataController sharedDataInstance] setLoginUserName:[usernameTF.text uppercaseString]
                                                                      andPassword:passwordTF.text];
                            
                            if([[[NSUserDefaults standardUserDefaults] valueForKey:kSaveUsername] length]) {
                                
                                [[NSUserDefaults standardUserDefaults] setValue:[usernameTF text] forKey:kSaveUsername];
                            }
                            
                            // Start indicator.
                            [Global showProgessindicator:self.view];
                            [appDelegate.configureViewController loadServiceCalls];
                            
                            [NSTimer scheduledTimerWithTimeInterval:7 target:self selector:@selector(removeSelfView) userInfo:nil repeats:NO];
                        }
                        else {
                            
                            if([[DataController sharedDataInstance] responseStatusCode] == kStatusCode404 ||
                               [[DataController sharedDataInstance] responseStatusCode] == kStatusCode0 ||
                               [[DataController sharedDataInstance] responseStatusCode] == kStatusCode405){
                                // Set login failed value to errorTag.
                                errorTag = NotFound;
                                [self showErrorAlerts];
                            }else{
                                // Set login failed value to errorTag.
                                errorTag = LoginFailed;
                                [self showErrorAlerts];
                            }
                            
                        }
                    });
                });
            }
        }
        else {
            // Remove indicator.
            [Global hideProgessIndicator];
            [Global displayAlertTitle:nil withAlertMessage:kWrongUsernameOrPassword
                     withCancelButton:kCancelAlertButton withOtherButtons:nil withForDelegate:nil withTag:kDefaultAlertTag];
        }
    }
    else{
        [Global displayNoNetworkAlert];
    }
}

-(void)removeSelfView {
    
    // Remove indicator.
    [Global hideProgessIndicator];
    [self.view removeFromSuperview];
    
}

/*!
 @method showErrorAlerts.
 @abstract
 @discussion This methods used to show appropriate error alert.
 @param nil.
 @result nil.
 */
- (void)showErrorAlerts{
    
    // Stop ProgessHUD.
    [Global hideProgessIndicator];
    
    switch (errorTag) {
        case LoginFailed:
            
            [Global displayAlertTitle:kLoginFailedTitle
                     withAlertMessage:kLoginFailedDescr
                     withCancelButton:kCancelAlertButton
                     withOtherButtons:nil
                      withForDelegate:nil
                              withTag:kDefaultAlertTag];
            break;
            
        case InsufficientData:
            
            [Global displayAlertTitle:kTextfieldBlankTitle
                     withAlertMessage:kTextfieldBlankDescr
                     withCancelButton:kCancelAlertButton
                     withOtherButtons:nil
                      withForDelegate:nil
                              withTag:kDefaultAlertTag];
            break;
            
        case InvalidServerUrl:
            
            [Global displayAlertTitle:kInvalidServerUrlTitle
                     withAlertMessage:kInvalidServerUrlDescr
                     withCancelButton:kCancelAlertButton
                     withOtherButtons:nil
                      withForDelegate:nil
                              withTag:kDefaultAlertTag];
            break;
            
        case InvalidSession:
            
            [Global displayAlertTitle:nil
                     withAlertMessage:kSessionInValid
                     withCancelButton:kCancelAlertButton
                     withOtherButtons:nil
                      withForDelegate:nil
                              withTag:kDefaultAlertTag];
            break;
            
        case LogoutFailed:
            
            [Global displayAlertTitle:nil
                     withAlertMessage:kLogoffFailedDescr
                     withCancelButton:kCancelAlertButton
                     withOtherButtons:nil
                      withForDelegate:nil
                              withTag:kDefaultAlertTag];
            break;
            
        case NotFound:
            
            [Global displayAlertTitle:kInvalidServerUrlTitle
                     withAlertMessage:kInvalidServerUrlDescr
                     withCancelButton:kCancelAlertButton
                     withOtherButtons:nil
                      withForDelegate:nil
                              withTag:kDefaultAlertTag];
            break;
            
        case SessionTimeout:
            break;
            
        default:
            break;
    }
}

- (void)showErrorOnWrongCredentials {
    
    static int count=0;
    
    [Global displayAlertTitle:nil withAlertMessage:kWrongUsernameOrPassword
             withCancelButton:kCancelAlertButton withOtherButtons:nil withForDelegate:nil withTag:kDefaultAlertTag];
    count++;
    
    if(count>4) {
        
        count=0;
        [appDelegate loadSettingViewController];
    }
}

#pragma mark- UITextFieldDelegate

// called when 'return' key pressed. return NO to ignore.
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if(textField == usernameTF) {
        
        [passwordTF becomeFirstResponder];
    }
    else if (textField == passwordTF){
        
        [passwordTF resignFirstResponder];
        
        [self loginButtonPressed:passwordTF];
        
    }
    return YES;
}

// became first responder
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    // Make placehoder text nil.
    [textField setPlaceholder:nil];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if(textField == usernameTF) {
        [usernameTF setPlaceholder:@"Username"];
    }
    else if (textField == passwordTF){
        [passwordTF setPlaceholder:@"Password"];
    }
    
}

@end
