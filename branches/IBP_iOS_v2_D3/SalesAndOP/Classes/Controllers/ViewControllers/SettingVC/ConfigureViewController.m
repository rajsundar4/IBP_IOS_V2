
//
//  ConfigureViewController.m
//  SalesAndOP
//
//  Created by Mayur Birari on 11/07/13.
//  Copyright (c) 2013 Linear Logics Corp.. All rights reserved.
//

#import "ProgressHUD.h"
#import "AppDelegate.h"
#import "DataController.h"
#import "sapsopaServiceV0.h"
#import "SettingsUtilities.h"
#import "HomeViewController.h"
#import "AboutViewController.h"
#import "ConnectivitySettings.h"
#import "sapsopaRequestHandler.h"
#import "ConfigureViewController.h"
#import "sapsopaServiceDeclarations.h"
#import "OfflineOptionViewController.h"
#import "AllDictionaryKeys.h"
#import "UIConfigValue.h"
#import "ErrorMessages.h"

/*!
 @class ConfigureViewController
 @abstract This view controller is used to Display Settings, configuration detail.
 @discussion Setting screen will display views to Direct SQL connect,
 and Direct S&OP server connect, About App info.
 */
@interface ConfigureViewController () <UITableViewDataSource,UITableViewDelegate>{
    
    /// Local instace to represent about VC Screen.
    AboutViewController *aboutViewController;
    
    /// Offline option VC Screen.
    OfflineOptionViewController *offlineOptionViewController;
    
    // Default Dashboard textfields
    
    /// local textfield to represent server url
    UITextField* serverURLTF;
    /// local textfield to represent username
    UITextField* usernameTF;
    /// local textfield to represent password
    UITextField* passwordTF;
    
    
    /// local Direct S&OP Connection textfields
    UITextField* connectionNameTF;
    
    /// last used textfield reference, Other textfield object will be reused from 1st connection
    UITextField* lastTextField;
    
    /// flag to represent current login and session is valid or not.
    BOOL isLoginAndSessionValid;
    
    /// Used to show appropriate error alert.
    ErrorTags errorTag;
    
    /// Used for local session timeout, TableView.
    __weak IBOutlet UITableView *localSessionTimeoutTableView;
    /// Session timeout button.
    __weak IBOutlet UIButton *sessionTimeoutButton;
    /// local session timeout imageView.
    __weak IBOutlet UIImageView *localSessionTimeoutImageView;
    
    /// Array, used for local session timeout.
    NSArray *timeoutArray;
    /// flag to check the current status, whether tableview visible or not.
    BOOL isLocalSessionTimeoutTableViewInView;
    
    int localSessionTimeoutValue;
}

/*!
 \internal
 @method localSessionTiomeoutButtonPressed
 @abstract This method used to show local session timeout tableview with values.
 @discussion
 @param sender - action object.
 @result nil
 */
- (IBAction)localSessionTiomeoutButtonPressed:(id)sender;

@end

@implementation ConfigureViewController

#pragma mark - UIView life cycle.

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        [[DataController sharedDataInstance] registerOdataNotification];
        
        // Add observer for Request failed.
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(stopIndicatorAndShowError)
                                                     name:kRequestFailedKey object:nil];
        // Add observer for loading Report for user's default planning area.
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(loadReportsForUsersDefaultPlannigAreaFromDataController)
                                                     name:kGetReportViewsArray object:nil];
        // Add notification when user succesfully logoff.
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clearAllTextfields)
                                                     name:kUserLogoff object:nil];
    }
    
    return self;
}

/*!
 @method getUserName
 @abstract
 @discussion As S&OP server wants username always in Capital to make session valid
 @param nil.
 @result userName.
 */
- (NSString *)getUserName {
    
    return [usernameTF.text uppercaseString];
}

- (void)viewDidLoad{
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // Set header label
    [self.headerView setTitleForTheHeader:@"Settings"];
    [self.headerView.helpButton addTarget:self action:@selector(aboutButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    // Apply the bg for left connection view
    [allConnectionview setBackgroundColor:[UIColor colorWithPatternImage:[Global setImage:@"bg2px_connectoptions"]]];
    
    // Load About view
    aboutViewController=[[AboutViewController alloc] initWithNibName:@"AboutViewController" bundle:nil];
    
    // Offline option buttons view
    offlineOptionViewController = [[OfflineOptionViewController alloc] initWithNibName:@"OfflineOptionViewController" bundle:nil];
    
    // Initialise timeout table view.
    [self setupForLocalSessionTimeout];
    
}

-(void)showCancelButtonIfNotFirstTime {
    
    AppDelegate* appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if([appDelegate isHomeViewControllerLoaded]) {
        
        [self.doneButton setFrame:CGRectMake(300, 454, 155, 53)];
        [self.downloadButton setFrame:CGRectMake(300, 454, 155, 53)];
        [self.cancelDirectOnlineConnectButton setHidden:NO];
        [self.cancelOfflineModeButtonPressed setHidden:NO];
    }
    
    if([[DataController sharedDataInstance] loginUser] == nil) {
        
        [self.doneButton setFrame:self.cancelDirectOnlineConnectButton.frame];
        [self.downloadButton setFrame:self.cancelOfflineModeButtonPressed.frame];
        [self.cancelDirectOnlineConnectButton setHidden:YES];
        [self.cancelOfflineModeButtonPressed setHidden:YES];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    
    // Clear username, password if user saved it then only we will retrived it
    [usernameTF setText:nil];
    [passwordTF setText:nil];
    
    // To load all services, creating new session if use press done button
    isLoginAndSessionValid = NO;
    
    // Select Direct s&op connection
    [(ProButton *)[allConnectionview viewWithTag:DirectConnectToSAOPButton] setSelected:NO];
    [self directSAOPConnectionButtonPressed:nil];
    
    // Check if setting load second time or more
    [self showCancelButtonIfNotFirstTime];
    
    // Restore Username, Connection name and Server url.
    [self setUsernameAndConnectionNameAndServerUrl];
    
}


- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    
    // Hide the local timeout tableview.
    [self hideTimeoutDropDownList];
      
}

#pragma mark - Custom methods

/*!
 @method saveConnectionNameAndServerUrl.
 @abstract
 @discussion This method used to save connection name and server url.
 @param nil.
 @result nil.
 */
- (void)saveConnectionNameAndServerUrl{
    
    [[NSUserDefaults standardUserDefaults] setValue:[connectionNameTF text] forKey:kSaveConnectionName];
    [[NSUserDefaults standardUserDefaults] setValue:[serverURLTF text] forKey:kSaveServerUrl];

}

/*!
 @method saveOfflineConnectionServerUrlToDownloadDatabase.
 @abstract
 @discussion This method used to save download sql db server url.
 @param nil.
 @result nil.
 */
- (void)saveOfflineConnectionServerUrlToDownloadDatabase{
    
    [[NSUserDefaults standardUserDefaults] setValue:[serverURLTF text] forKey:kSaveServerUrlDownloadDBOffline];
}


/*!
 @method setUsernameAndConnectionNameAndServerUrl.
 @abstract
 @discussion This method used to restore username, connection name and server url to textfield for connection type - Direct Connect toS&OP.
 @param nil.
 @result nil.
 */
- (void)setUsernameAndConnectionNameAndServerUrl{
    
    if(connectionType == DirectConnectToSAOPView) {
        // Username.
        if([[[NSUserDefaults standardUserDefaults] valueForKey:kSaveUsername] length]) {
            
            [usernameTF setText:[[NSUserDefaults standardUserDefaults] valueForKey:kSaveUsername]];
            
            [(UIButton *)[self.view viewWithTag:333] setSelected:YES];
        }
        
        // Connection name.
        if([[[NSUserDefaults standardUserDefaults] valueForKey:kSaveConnectionName] length])
            [connectionNameTF setText:[[NSUserDefaults standardUserDefaults] valueForKey:kSaveConnectionName]];
        // Server url.
        if([[[NSUserDefaults standardUserDefaults] valueForKey:kSaveServerUrl] length])
            [serverURLTF setText:[[NSUserDefaults standardUserDefaults] valueForKey:kSaveServerUrl]];
        // Session timeout - rft
        if([[NSUserDefaults standardUserDefaults] integerForKey:kSelectedLocalTimeoutValue])
            localSessionTimeoutValue = [[NSUserDefaults standardUserDefaults] integerForKey:kSelectedLocalTimeoutValue];
    }
    else {
        // Offline connection type
        //if(connectionType == DefaultDashboardView)
        
        // Username.
        if([[[NSUserDefaults standardUserDefaults] valueForKey:kSaveUsernameOffline] length]) {
            
            [usernameTF setText:[[NSUserDefaults standardUserDefaults] valueForKey:kSaveUsernameOffline]];
            [passwordTF setText:[[NSUserDefaults standardUserDefaults] valueForKey:kSavePasswordOffline]];
            [(UIButton *)[self.view viewWithTag:334] setSelected:YES];
        }
        
        // Server url.
        if([[[NSUserDefaults standardUserDefaults] valueForKey:kSaveServerUrlDownloadDBOffline] length])
            [serverURLTF setText:[[NSUserDefaults standardUserDefaults] valueForKey:kSaveServerUrlDownloadDBOffline]];
    }
    
}


/*!
 @method hideTimeoutDropDownList.
 @abstract
 @discussion This method used to hide the local timeout dropdown.
 @param nil.
 @result nil.
 */
- (void)hideTimeoutDropDownList{
    
    // Hide the local timeout tableview.
    [self hideLocalSessionTimeOutTableView:YES];
    isLocalSessionTimeoutTableViewInView = NO;
}

/*!
 @method setupForLocalSessionTimeout.
 @abstract
 @discussion This method used to set up local timeout in app.
 @param nil.
 @result nil.
 */
- (void)setupForLocalSessionTimeout{
    
    
    NSLog(@"Inside setupForLocalSessionTimeout function.");
    
    // Set tableview datasource and delegate.
    [localSessionTimeoutTableView setDataSource:self];
    [localSessionTimeoutTableView setDelegate:self];
    
    // At launch hide the tableview.
    [self hideTimeoutDropDownList];
    
    [sessionTimeoutButton.titleLabel setFont:kProFont_18];
    [sessionTimeoutButton setTitleColor:kTextFieldColor forState:UIControlStateNormal];
    
    timeoutArray = [[NSArray alloc] initWithObjects:[NSNumber numberWithFloat:5.0],
                    [NSNumber numberWithFloat:10.0],[NSNumber numberWithFloat:15.0],
                    [NSNumber numberWithFloat:20.0], nil];
    
    // rft
    if(![[NSUserDefaults standardUserDefaults]
         integerForKey:kSelectedLocalTimeoutValue]) {
        [[NSUserDefaults standardUserDefaults] setInteger:20 forKey:kSelectedLocalTimeoutValue];
    }
    
    localSessionTimeoutValue = [[NSUserDefaults standardUserDefaults] integerForKey:kSelectedLocalTimeoutValue];
    int rowIndex;
    
    switch (localSessionTimeoutValue) {
        case 0:
            rowIndex = 3;
            break;
        case 5:
            rowIndex = 0;
            break;
        case 10:
            rowIndex = 1;
            break;
        case 15:
            rowIndex = 2;
            break;
        case 20:
            rowIndex = 3;
            break;
        default:
            rowIndex = 3;
            break;
    }
    // Set first cell in table as selected by default.
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:rowIndex inSection:0];
    
    [localSessionTimeoutTableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    //[localSessionTimeoutTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:rowIndex inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
    [localSessionTimeoutTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:YES];
    
}


/*!
 @method hideLocalSessionTimeOutTableView:
 @abstract
 @discussion This method used to hide and unhide the table view.
 @param arg_bool - YES/NO.
 @result nil.
 */
- (void)hideLocalSessionTimeOutTableView:(BOOL)arg_bool{
    
    [localSessionTimeoutTableView setHidden:arg_bool];
    [localSessionTimeoutImageView setHidden:arg_bool];
}

/*!
 @method clearAllTextfields.
 @abstract
 @discussion This methods used to clear users all the data.
 @param nil.
 @result nil.
 */
- (void)clearAllTextfields{
    
    [self setUsernameAndConnectionNameAndServerUrl];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"LogOff"
                                                  object:nil];
}

/*!
 @method configureRequestHandlerSettings.
 @abstract
 @discussion This methods used to get current server url entered by the user.
 @param nil.
 @result nil.
 */
- (void)configureRequestHandlerSettings{
    
    //Initialize the request handler with the service document URL and SAP client from the application settings.
    [[sapsopaRequestHandler uniqueInstance] setServiceDocumentURL:
     [SettingsUtilities getServiceUrlFromUserSettings]];
    
    /* Set to 'NO' to disable service negotiation */
    [sapsopaRequestHandler uniqueInstance].useServiceNegotiation = YES;
	/* Set to 'YES' to use local metadata for service proxy initialization */
    [sapsopaRequestHandler uniqueInstance].useLocalMetadata = NO;
}

/*!
 @method stopIndicatorAndShowError.
 @abstract
 @discussion This methods called when request failed.
 @param nil.
 @result nil.
 */
- (void)stopIndicatorAndShowError{
    
    // Hide indicator.
    [Global hideProgessIndicator];
    
    [Global displayAlertTitle:nil withAlertMessage:kRequestFailedDescr
             withCancelButton:@"OK" withOtherButtons:nil withForDelegate:nil withTag:kDefaultAlertTag];
    
    // Remove observer.
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kRequestFailedKey object:nil];
}

/*!
 @method loginProcess.
 @abstract
 @discussion This methods used to complete login process.
 @param nil.
 @result nil.
 */
- (void)loginProcess{
    
    NSError *error = nil;
    BOOL loginResult = NO;
    BOOL logoutResult = NO;
    NSError __autoreleasing *returnError;
    BOOL sessionStatus = NO;
    
    // Check the authentication type then proceed for login process
    switch ([ConnectivitySettings authenticationType]) {
            
        case UsernamePasswordAuthenticationType:
            
            // Save server text field url
            [[NSUserDefaults standardUserDefaults] setValue:serverURLTF.text
                                                     forKey:kSaveServerUrlMannualy];
            [self configureRequestHandlerSettings];
            
            // Set base server url.
            [[DataController sharedDataInstance] setBaseUrlFromServerTextField:serverURLTF.text];
            
            // Put the login username and password to login.
            DLog(@"name - %@",[self getUserName]);
            loginResult = [[DataController sharedDataInstance] isLoginValid:[self getUserName]
                                                                andPassword:passwordTF.text
                                                             andReturnError:&error];
            if(loginResult){
                DLog(@"name - %@",[self getUserName]);
                // Check session is active with passing the username,
                sessionStatus = [[DataController sharedDataInstance]
                                 isSessionValid:[self getUserName]
                                 andReturnError:&returnError];
                
                if(sessionStatus){
                    
                    // Save username and password.
                    [[DataController sharedDataInstance] setLoginUserName:[self getUserName]
                                                              andPassword:passwordTF.text];
                    
                    // Save connection name and server url.
                    [self saveConnectionNameAndServerUrl];
                    
                    // login and session are valid.
                    isLoginAndSessionValid = YES;
                    
                    
                }else{
                    
                    logoutResult = [[DataController sharedDataInstance]
                                    logoutFromApplication:&returnError];
                    
                    if(logoutResult){
                        
                        // Set invalid session value to errorTag.
                        errorTag = InvalidSession;
                        [self showErrorAlerts];
                        [passwordTF setText:nil];
                        
                    }else{
                        // Set logout failed value to errorTag.
                        errorTag = LogoutFailed;
                        [self showErrorAlerts];
                    }
                }
            }else{
                
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
            break;
            
        default:
            break;
    }
    
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
    isLoginAndSessionValid = NO;
    
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

/*!
 @method loadCalls.
 @abstract
 @discussion This methods used to give call to load services from backend.
 @param nil.
 @result nil.
 */
- (void)loadServiceCalls{
    
    NSError __autoreleasing *returnError;
    
    // Get default plannig area.
    [[DataController sharedDataInstance] getDefaultUserPlanningAreaFormDataController:[self getUserName]
                                                                       andReturnError:&returnError];
    // Give call to the load Models.
    [[DataController sharedDataInstance] loadDashboardDataCalls];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadHomeScreen)
                                                 name:kGetAllODataWithDispatchAsyncKey
                                               object:nil];
}

/*!
 @method loadReportsForUsersDefaultPlannigAreaFromDataController.
 @abstract
 @discussion This methods used to give call to get reports for users default planning area.
 @param nil.
 @result nil.
 */
- (void)loadReportsForUsersDefaultPlannigAreaFromDataController{
    
    [[DataController sharedDataInstance] loadReportsForUsersDefaultPlannigArea];
}

/*!
 @method loadHomeScreen.
 @abstract
 @discussion This methods used to show home screen.
 @param nil.
 @result nil.
 */
- (void)loadHomeScreen{
    
    // Stop ProgessHUD.
    [Global hideProgessIndicator];
    
    AppDelegate* appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate loadHomeViewController];
}

#pragma mark - Validation methods

/*!
 @method isAllTextFieldHaveValidText.
 @abstract
 @discussion This methods used to return bool value if all textfield have valid data.
 @param nil.
 @result YES/NO.
 */
- (BOOL)isAllTextFieldHaveValidText{
    
    BOOL boolToReturn = NO;
    if(connectionType == DirectConnectToSAOPView) {
        
        if([self isEnteredTextIsValid:[usernameTF text]] &&
           [self isEnteredTextIsValid:[passwordTF text]] &&
           [self isEnteredTextIsValid:[serverURLTF text]] &&
           [self isEnteredTextIsValid:[connectionNameTF text]]){
            boolToReturn = YES;
        }
    }
    else {
        
        if([self isEnteredTextIsValid:[usernameTF text]] &&
           [self isEnteredTextIsValid:[passwordTF text]] &&
           [self isEnteredTextIsValid:[serverURLTF text]]){
            boolToReturn = YES;
        }
    }
    return boolToReturn;
    
}

/*!
 @method isServerAndPortValid:
 @abstract
 @discussion This methods used to check that entered URL is valid with port or not.
 @param arg_serverTextfieldText - server textfield text.
 @result YES/NO.
 */
- (BOOL)isServerAndPortValid:(NSString *)arg_serverTextfieldText{
    
    BOOL isServerAndPortAreValid = NO;
    
    NSURL *serverUrl = [NSURL URLWithString:arg_serverTextfieldText];
    
    NSRange range = [arg_serverTextfieldText rangeOfString:@"https://"];
    NSString *subString = nil;
    
    // Check whether the entered server url contain the "http://" or not.
    if (!(range.location == NSNotFound))
        subString = [arg_serverTextfieldText substringFromIndex:NSMaxRange(range)];
    
    if(serverUrl && [serverUrl host] && [[serverUrl scheme] isEqualToString:@"https"] && [self isSubstringContainSpecialChar:subString])
        isServerAndPortAreValid = YES;
    
    return isServerAndPortAreValid;
}

/*!
 @method isSubstringContainSpecialChar:
 @abstract
 @discussion This methods used to check that entered URL contain any special char or not.
 @param arg_substring - substring from NSURL.
 @result YES/NO.
 */
- (BOOL)isSubstringContainSpecialChar:(NSString *)arg_substring{
    
    BOOL isSubStringContainsSpecialChar = NO;
    
    NSString *specialCharacterString = @"!~`@#$%^&*+();{}[],<>\\/\"\'";
    NSCharacterSet *specialCharacterSet = [NSCharacterSet
                                           characterSetWithCharactersInString:specialCharacterString];
    
    if (![arg_substring rangeOfCharacterFromSet:specialCharacterSet].length)
        isSubStringContainsSpecialChar =  YES;
    
    return isSubStringContainsSpecialChar;
}

/*!
 @method isEnteredTextIsValid:
 @abstract
 @discussion This methods used to check there is data in text field or not.
 @param arg_textfieldText - entered text.
 @result YES/NO.
 */
- (BOOL)isEnteredTextIsValid:(NSString *)arg_textfieldText{
    
    BOOL boolToReturn = NO;
    
    // For checking white space in entered string.
    NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *trimmedText = [arg_textfieldText stringByTrimmingCharactersInSet:whitespace];
    
    if(![arg_textfieldText length] || ![trimmedText length]){
        // Text was empty or only whitespace.
        boolToReturn = NO;
    } else {
        boolToReturn = YES;
    }
    
    return boolToReturn;
}

#pragma mark - UIButton action methods

/*!
 @method localSessionTiomeoutButtonPressed:
 @abstract
 @discussion This method used to show local session timeout tableview with values.
 @param sender -
 @result nil.
 */
- (IBAction)localSessionTiomeoutButtonPressed:(id)sender {
    
    DLog(@"isLocalSessionTimeoutTableViewInView - %d",isLocalSessionTimeoutTableViewInView);
    
    if(isLocalSessionTimeoutTableViewInView){
        isLocalSessionTimeoutTableViewInView = YES;
    }else{
        isLocalSessionTimeoutTableViewInView = NO;
    }
    [self hideLocalSessionTimeOutTableView:isLocalSessionTimeoutTableViewInView];
    isLocalSessionTimeoutTableViewInView = !isLocalSessionTimeoutTableViewInView;
}


-(void) logoutProcess {
    
    // logout from app.
    NSError __autoreleasing *returnError;
    [[DataController sharedDataInstance] logoutFromApplication:&returnError];
    
}

/*!
 @method doneButtonPressed
 @abstract Done button pressed to connect to Service and data layer
 @discussion This methods loads Dashboard View on Window
 @param sender
 @result nil
 */
- (IBAction)doneButtonPressed:(id)sender {
    
    // Hide local time out ddl.
    [self hideTimeoutDropDownList];
    
    // Remove last keyboard reference
    [lastTextField resignFirstResponder];
    
    // Add observer for check request failed.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopIndicatorAndShowError)
                                                 name:kRequestFailedKey object:nil];
    // Make kLoadHomeView YES.
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kLoadHomeView];
    
    // verify whether usernamecheckbox selected or not.
    [self saveUserNameValueInDefault];
    
    if([self isAllTextFieldHaveValidText]){
        
        if([self isServerAndPortValid:serverURLTF.text]){
            
            if([Global isNetworkReachable]){
                // Start ProgessHUD.
                [Global showProgessindicator:self.view];
                
                // Log out old user if session present in app
                //[self logoutProcess];
                
                dispatch_async(dispatch_queue_create("com.ameri100.saop", DISPATCH_QUEUE_SERIAL), ^{
                    // Start login process.
                    [self loginProcess];
                    // Get callback on Main thread.
                    dispatch_async(dispatch_get_main_queue(), ^{
                        DLog(@"dispatch_get_main_queue");
                        if (isLoginAndSessionValid) {
                            
                            // If session is valid then call all services.
                            [self loadServiceCalls];
                            
                            // Save seleted value in NSUsrDefault and retrive at runtime.
                            [[NSUserDefaults standardUserDefaults] setInteger:localSessionTimeoutValue
                                                                       forKey:kSelectedLocalTimeoutValue];
                            
                        }else{
                            [Global hideProgessIndicator];
                        }
                    });
                });
            }else{
                [Global displayNoNetworkAlert];
            }
        }
        else{
            // Set invalid server url value to errorTag.
            errorTag = InvalidServerUrl;
            [self showErrorAlerts];
        }
    }
    else{
        // Set insufficent data value to errorTag.
        errorTag = InsufficientData;
        [self showErrorAlerts];
    }
    
}

/*!
 @method cancelDirectOnlineConnectButtonPressed
 @abstract
 @discussion logined user wants to go back on Home Screen, Cancel is implemented to stop user from loading.
 @param sender - button action sender.
 */
- (IBAction)cancelDirectOnlineConnectButtonPressed:(id)sender {
    
    if([[[[DataController sharedDataInstance] loginUser] userName] isEqualToString:@"guest"])
        connectionType=DefaultDashboardView;
    else
        connectionType=DirectConnectToSAOPView;
    
    AppDelegate* appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate showHomeViewController];
}

/*!
 @method cancelOfflineModeButtonPressed
 @abstract
 @discussion logined user wants to go back on Home Screen, Cancel is implemented to stop user from loading.
 @param sender - button action sender.
 */
- (IBAction)cancelOfflineModeButtonPressed:(id)sender {
    
    if([[[[DataController sharedDataInstance] loginUser] userName] isEqualToString:@"guest"])
        connectionType=DefaultDashboardView;
    else
        connectionType=DirectConnectToSAOPView;    
    
    AppDelegate* appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate showHomeViewController];
}

/*!
 @method saveUserNameToggleButtonPressed
 @abstract this toggle button used to save the username
 @discussion This methods save the authentication info
 @param sender
 @result nil
 */
- (IBAction)saveUserNameToggleButtonPressed:(id)sender {
    
    // Hide timeout table.
    [self hideTimeoutDropDownList];
    
    UIButton* toggleButton=(UIButton *)sender;
    
    [toggleButton setSelected:!toggleButton.selected];
    
    [self saveUserNameValueInDefault];
    
}
-(void) saveUserNameValueInDefault{
    
    UIButton* savedUserNameButton=(UIButton *)[self.view viewWithTag:333];
    if(savedUserNameButton.selected){
        [[NSUserDefaults standardUserDefaults] setValue:[usernameTF text] forKey:kSaveUsername];
         
    }else {
        
        [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:kSaveUsername];
    }
}

/*!
 @method saveAuthenticationForOfflineButtonPressed
 @abstract this toggle button used to save the authentication
 @discussion This methods save the authentication info for offline scenario
 @param sender
 @result nil
 */
- (IBAction)saveAuthenticationForOfflineButtonPressed:(id)sender {
    
    // Hide timeout table.
    [self hideTimeoutDropDownList];
    
    UIButton* toggleButton=(UIButton *)sender;
    
    [toggleButton setSelected:!toggleButton.selected];
    
    [self saveAuthenticationValuesInDefault];
}

-(void) saveAuthenticationValuesInDefault{
    
    UIButton* savedAuthenticationButton=(UIButton *)[self.view viewWithTag:334];
    if(savedAuthenticationButton.selected){
        [[NSUserDefaults standardUserDefaults] setValue:[usernameTF text] forKey:kSaveUsernameOffline];
        [[NSUserDefaults standardUserDefaults] setValue:[passwordTF text] forKey:kSavePasswordOffline];
    }else{
        [[NSUserDefaults standardUserDefaults] setValue:nil forKey:kSaveUsernameOffline];
        [[NSUserDefaults standardUserDefaults] setValue:nil forKey:kSavePasswordOffline];
    }
}

/*!
 @method aboutButtonPressed
 @abstract Used to display About screen
 @discussion This method used to display About screen, info of the app maker
 @param sender
 @result nil
 */
- (IBAction)aboutButtonPressed:(id)sender {
    
    DLog(@"CVC - About button pressed.");
    // Hide keyboard.
    [self.view endEditing:YES];
    [self addChildViewController:aboutViewController];
    [self.view addSubview:aboutViewController.view];
    
}

/*!
 \internal
 @method defaultDashboardConnectionButtonPressed
 @abstract This button pressed to  open the connect panel for default Dashboard
 @discussion This methods loads SQL Connect panel with required fields
 @param sender
 @result nil
 */
- (IBAction)defaultDashboardConnectionButtonPressed:(id)sender {
    
    [[NSUserDefaults standardUserDefaults] setValue:@"DEMODB" forKey:kMode];
    
    // Hide keyboard.
    [self.view endEditing:YES];
    
    if(![(ProButton *)[allConnectionview viewWithTag:DefaultDashboardButton] isSelected]) {
    [self.view addSubview:offlineOptionViewController.view];
    }
    
}

/*!
 @method showDefaultDashboardConnectionView
 @abstract This button pressed to  open the connect panel for default Dashboard.
 @discussion This methods loads SQL Connect panel with required fields.
 @param sender - action object.
 @result nil
 */
- (void)showDefaultDashboardConnectionView {
    
    if(![(ProButton *)[allConnectionview viewWithTag:DefaultDashboardButton] isSelected]) {
        // Set connection type as default
        connectionType  = DefaultDashboardView;
        
        // Textfield allocation for default Sample db connection
        [lastTextField resignFirstResponder];
        serverURLTF=(UITextField *)[self.view viewWithTag:DefaultDashboardServerUrlTF];
        usernameTF=(UITextField *)[self.view viewWithTag:DefaultDashboardUsernameTF];
        passwordTF=(UITextField *)[self.view viewWithTag:DefaultDashboardPasswordTF];
        
        [(ProButton *)[allConnectionview viewWithTag:DefaultDashboardButton] setSelected:YES];
        [(ProButton *)[allConnectionview viewWithTag:DirectConnectToSAOPButton] setSelected:NO];
        [[self.view viewWithTag:DefaultDashboardView] setHidden:NO];
        [[self.view viewWithTag:DefaultDashboardView] setUserInteractionEnabled:YES];
        [[self.view viewWithTag:DirectConnectToSAOPView] setHidden:YES];
        [[self.view viewWithTag:DirectConnectToSAOPView] setUserInteractionEnabled:NO];
        
        // Restore Username, Connection name and Server url.
        [self setUsernameAndConnectionNameAndServerUrl];
    }
}

/*!
 @method directSAOPConnectionButtonPressed
 @abstract This button pressed to  open the connect panel for S&OP Server connect
 @discussion This methods loads S&OP Connect panel with required fields
 @param sender
 @result nil
 */
- (IBAction)directSAOPConnectionButtonPressed:(id)sender {
    
    if(![(ProButton *)[allConnectionview viewWithTag:DirectConnectToSAOPButton] isSelected]) {
        
        
        
        // Set connection ad direct
        connectionType = DirectConnectToSAOPView;
        
        // Textfield allocation for direct S&OP connection
        [lastTextField resignFirstResponder];
        connectionNameTF=(UITextField *)[self.view viewWithTag:DirectDashboardConnectionNameTF];
        serverURLTF=(UITextField *)[self.view viewWithTag:DirectDashboardServerUrlTF];
        usernameTF=(UITextField *)[self.view viewWithTag:DirectDashboardUsernameTF];
        passwordTF=(UITextField *)[self.view viewWithTag:DirectDashboardPasswordTF];
        
        
        [(ProButton *)[allConnectionview viewWithTag:DefaultDashboardButton] setSelected:NO];
        [(ProButton *)[allConnectionview viewWithTag:DirectConnectToSAOPButton] setSelected:YES];
        [[self.view viewWithTag:DefaultDashboardView] setHidden:YES];
        [[self.view viewWithTag:DefaultDashboardView] setUserInteractionEnabled:NO];
        [[self.view viewWithTag:DirectConnectToSAOPView] setHidden:NO];
        [[self.view viewWithTag:DirectConnectToSAOPView] setUserInteractionEnabled:YES];
        
        // Restore Username, Connection name and Server url.
        [self setUsernameAndConnectionNameAndServerUrl];
    }
}

#pragma mark- UITextFieldDelegate

// called when 'return' key pressed. return NO to ignore.
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    switch (connectionType) {
        case DirectConnectToSAOPView:
            switch ([textField tag]) {
                case DirectDashboardConnectionNameTF:
                    
                    [serverURLTF becomeFirstResponder];
                    break;
                    
                case DirectDashboardServerUrlTF:
                    
                    [usernameTF becomeFirstResponder];
                    break;
                    
                case DirectDashboardUsernameTF:
                    
                    [passwordTF becomeFirstResponder];
                    break;
                    
                case DirectDashboardPasswordTF:
                    
                    [self doneButtonPressed:passwordTF];
                    [passwordTF resignFirstResponder];
                    break;
                    
                default:
                    break;
            }
            break;
        case DefaultDashboardView:
            switch ([textField tag]) {
                    
                case DefaultDashboardServerUrlTF:
                    
                    [usernameTF becomeFirstResponder];
                    break;
                    
                case DefaultDashboardUsernameTF:
                    
                    [passwordTF becomeFirstResponder];
                    break;
                    
                case DefaultDashboardPasswordTF:
                    
                    [self sqliteDBDownloadButtonPressed:passwordTF];
                    [passwordTF resignFirstResponder];
                    break;
                    
                default:
                    break;
            }
            
            break;
            
        default:
            break;
    }
    
    return YES;
}

// became first responder
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    // Hide the local timeout tableview.
    [self hideTimeoutDropDownList];
    
    lastTextField = textField;
    // Make placehoder text nil.
    [textField setPlaceholder:nil];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    [textField setPlaceholder:@"Required"];
}

#pragma mark - UITouch delegate

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self hideTimeoutDropDownList];
}

#pragma mark- UITableViewDatasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [timeoutArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* rowIdentifier=@"Cell";
    UITableViewCell* cell= [tableView dequeueReusableCellWithIdentifier:rowIdentifier];
    
    if(cell == nil) {
        
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:rowIdentifier];
        
        // Add custom label in cell.
        UILabel *customLabel = [[UILabel alloc] initWithFrame:kCellCustomLabelFrameInLocalTimeoutTable];
        [customLabel setTag:kCustomLabelInSettingViewTag];
        [customLabel setBackgroundColor:[UIColor clearColor]];
        [customLabel setFont:kProFont_18];
        [customLabel setTextColor:kTextFieldColor];
        [customLabel setHighlightedTextColor:kCellLabelTextColor];
        [cell setIndentationLevel:1];
        [cell.contentView addSubview:customLabel];
    }
    
    NSString *timeout = [NSString stringWithFormat:@"%@ min",
                         [[timeoutArray objectAtIndex:indexPath.row] stringValue]];
    // Set text to custom label.
    UILabel *localCustomLabel = (UILabel *)[cell viewWithTag:kCustomLabelInSettingViewTag];
    [localCustomLabel setText:timeout];
    
    
    // Add selection view.
    UIView *selectionColor = [[UIView alloc] init];
    [selectionColor setBackgroundColor:[UIColor whiteColor]];
    [cell setSelectedBackgroundView:selectionColor];
    selectionColor=nil;
    
    return cell;
}

#pragma mark- UITableViewDelegate.

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    localSessionTimeoutValue = [[timeoutArray objectAtIndex:indexPath.row] intValue];
    NSString *timeout = [NSString stringWithFormat:@"%d min",localSessionTimeoutValue];
    [sessionTimeoutButton setTitle:timeout forState:UIControlStateNormal];
    
    // Hide tableview and bg imageview.
    [self hideTimeoutDropDownList];
}

- (BOOL) validateUrl: (NSString *) candidate {
    
    BOOL isURLValid = FALSE;
    
    NSURL* url = [NSURL URLWithString:candidate];
    
    if([url host] && [url scheme]) {
        
        isURLValid = TRUE;
    }
    
    return isURLValid;
}

#pragma mark - offline support methods

/*!
 @method sqliteDBDownloadButtonPressed
 @abstract
 @discussion For the guest user to know about the application, he can download the SQLite DB file from LinearLogics server.
 @param sender - button action sender.
 */
- (IBAction)sqliteDBDownloadButtonPressed:(id)sender {
    
    // Remove last keyboard reference
    [lastTextField resignFirstResponder];
    
    // verify whether authentication checkbox selected or not.
    [self saveAuthenticationValuesInDefault];
    
    if([self isAllTextFieldHaveValidText]){
        
        if([self validateUrl:serverURLTF.text]){
            
            if([Global isNetworkReachable]){
                // Start ProgessHUD.
                [Global showProgessindicator:self.view];
                
                // Create instance of Download Manager and download the file
                DBDownloadManager* downloadManager = [[DBDownloadManager alloc] init];
                
                [downloadManager setDbDownloadDelegate:self];
                
                [downloadManager saopDBRequest:serverURLTF.text username:usernameTF.text password:passwordTF.text];
                
            }
            else {
                [Global displayNoNetworkAlert];
            }
        }
        else{
            // Set invalid server url value to errorTag.
            errorTag = InvalidServerUrl;
            [self showErrorAlerts];
        }
    }
    else{
        // Set insufficent data value to errorTag.
        errorTag = InsufficientData;
        [self showErrorAlerts];
    }
}

/*!
 @method usedOfflineDemoButtonPressed
 @abstract
 @discussion This button provide functionality to access/used the dummy database which is provided with the build version.
 @param sender - button action sender.
 */
- (IBAction)enableOfflineDemoButtonPressed:(id)sender {
    
    [self showDefaultDashboardConnectionView];
    
    [Global showProgessindicator:self.view];
    
    dispatch_async(dispatch_queue_create("com.ameri100.saop", DISPATCH_QUEUE_SERIAL), ^{
        
        //[self logoutProcess];
        
        [[DataController sharedDataInstance] setLoginUserName:@"guest" andPassword:@"password"];
        // Give call to the load Models.
        [[DataController sharedDataInstance] loadsAllDataModelsFromSqliteDatabase];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self loadHomeScreen];
        });
    });
}

#pragma Mark- DB DownloadManager Delegates

/*!
 @method databaseFileDownloadSuccessfully
 @abstract Used to observe the success of downloading.
 */
-(void)databaseFileDownloadSuccessfully {
    
    // Stop and hide progress indicator
    [Global hideProgessIndicator];
    
    [self saveOfflineConnectionServerUrlToDownloadDatabase];
    
    [Global displayAlertTitle:@"" withAlertMessage:@"S&OP's Database has been downloaded successfully." withCancelButton:@"Done" withOtherButtons:nil withForDelegate:nil withTag:0];
    
    [self enableOfflineDemoButtonPressed:nil];
}

/*!
 @method failToDownloadSqlFile
 @abstract Used to observe the failure (error).
 @param errorMessage
 */
-(void)failToDownloadSqlFile:(NSString *)errorMessage {
    
    // Stop and hide progress indicator
    [Global hideProgessIndicator];
    
    [Global displayAlertTitle:@"Error!" withAlertMessage:errorMessage withCancelButton:@"OK" withOtherButtons:nil withForDelegate:nil withTag:0];
    
}

@end
