//
//  ConfigureViewController.h
//  SalesAndOP
//
//  Created by Mayur Birari on 11/07/13.
//  Copyright (c) 2013 Linear Logics Corp.. All rights reserved.
//

#import "ProButton.h"
#import <UIKit/UIKit.h>
#import "DBDownloadManager.h"
#import "HeaderViewController.h"
//#include "ActivationCode.h"

/*!
 \internal
 @class ConfigureViewController
 @abstract This view controller is used to Display Settings, configuration detail.
 @discussion Setting screen will display views to Direct SQL connect, 
             and Direct S&OP server connect, About App info.
 */
@interface ConfigureViewController : UIViewController <UITextFieldDelegate, DBDownloadDelegate>
{

    /// Vertical view, represents All connection tabs.
    __weak IBOutlet UIView *allConnectionview;
    
}

/// Instance of the singleton Header View.
@property (weak, nonatomic) IBOutlet HeaderViewController *headerView;

@property (weak, nonatomic) IBOutlet ProButton *doneButton;

@property (weak, nonatomic) IBOutlet ProButton *cancelDirectOnlineConnectButton;

@property (weak, nonatomic) IBOutlet ProButton *downloadButton;

@property (weak, nonatomic) IBOutlet ProButton *cancelOfflineModeButtonPressed;

/*!
 \internal
 @method doneButtonPressed
 @abstract Done button pressed to connect to Service and data layer.
 @discussion This methods loads Dashboard View on Window.
 @param sender - action object.
 @result nil
 */
- (IBAction)doneButtonPressed:(id)sender;

/*!
 \internal
 @method saveUserNameToggleButtonPressed
 @abstract this toggle button used to save the username.
 @discussion This methods save the authentication info.
 @param sender - action object.
 @result nil
 */
- (IBAction)saveUserNameToggleButtonPressed:(id)sender;

/*!
 \internal 
 @method saveAuthenticationForOfflineButtonPressed
 @abstract this toggle button used to save the authentication
 @discussion This methods save the authentication info for offline scenario
 @param sender
 @result nil
 */
- (IBAction)saveAuthenticationForOfflineButtonPressed:(id)sender;

/*!
 \internal
 @method defaultDashboardConnectionButtonPressed
 @abstract This button pressed to  open the connect panel for default Dashboard.
 @discussion This methods loads SQL Connect panel with required fields.
 @param sender - action object.
 @result nil
 */
- (IBAction)defaultDashboardConnectionButtonPressed:(id)sender;

/*!
 \internal
 @method showDefaultDashboardConnectionView
 @abstract This button pressed to  open the connect panel for default Dashboard.
 @discussion This methods loads SQL Connect panel with required fields.
 @param sender - action object.
 @result nil
 */
- (void)showDefaultDashboardConnectionView;

/*!
 \internal
 @method directSAOPConnectionButtonPressed
 @abstract This button pressed to  open the connect panel for S&OP Server connect.
 @discussion This methods loads S&OP Connect panel with required fields.
 @param sender - action object.
 @result nil
 */
- (IBAction)directSAOPConnectionButtonPressed:(id)sender;

/*!
 \internal
 @method getUserName
 @abstract
 @discussion As S&OP server wants username always in Capital to make session valid.
 @param nil.
 @result userName - returns username in capital string.
 */
- (NSString *)getUserName;

/*!
 \internal
 @method cancelDirectOnlineConnectButtonPressed
 @abstract
 @discussion logined user wants to go back on Home Screen, Cancel is implemented to stop user from loading.
 @param sender - button action sender.
 */
- (IBAction)cancelDirectOnlineConnectButtonPressed:(id)sender;

/*!
 \internal
 @method cancelOfflineModeButtonPressed
 @abstract
 @discussion logined user wants to go back on Home Screen, Cancel is implemented to stop user from loading.
 @param sender - button action sender.
 */
- (IBAction)cancelOfflineModeButtonPressed:(id)sender;

/*!
 \internal
 @method sqliteDBDownloadButtonPressed
 @abstract
 @discussion For the guest user to know about the application, he can download the SQLite DB file from LinearLogics server.
 @param sender - button action sender.
 */
- (IBAction)sqliteDBDownloadButtonPressed:(id)sender;

/*!
 \internal
 @method usedOfflineDemoButtonPressed
 @abstract
 @discussion This button provide functionality to access/used the dummy database which is provided with the build version.
 @param sender - button action sender.
 */
- (IBAction)enableOfflineDemoButtonPressed:(id)sender;


/*!
 @method loadCalls.
 @abstract
 @discussion This methods used to give call to load services from backend.
 @param nil.
 @result nil.
 */
- (void)loadServiceCalls ;
@end
