//
//  HomeViewController.m
//  SalesAndOP
//
//  Created by Mayur Birari on 11/07/13.
//  Copyright (c) 2013 Linear Logics Corp.. All rights reserved.
//

#import "ReportPage.h"
#import "AppDelegate.h"
#import "DataController.h"
#import "HomeViewController.h"
#import "HelpViewController.h"
#import "DataSetViewController.h"
#import "LeftMenuViewController.h"
#import "RightMenuViewController.h"
#import "UserDetailsViewController.h"
#import "DashboardVC.h"
#import "FullWebviewVC.h"

/*!
 @class HomeViewController
 @abstract This view controller is used to Display Home View.
 @discussion Home screen will display charts, dashboards, dataset and report views.
 */
@interface HomeViewController () {

    /// Object instance for left menu VC.
    LeftMenuViewController *leftMenuViewController;
    
    /// Object instance for right menu VC.
    RightMenuViewController *rightMenuViewController;
    
    /// Object instance for help VC.
    HelpViewController *helpViewController;
    
    /// Object instance for Planning area (Dataset) VC.
    DataSetViewController *dataSetViewController;
    
    /// Object instance for Dashboard/Chart VC, render by MAKIT.
    //MyMAViewController *maDashboardViewController;
    // Adding new dashboard controller, removing MAKit
    DashboardVC *dashboardViewController;
    FullWebviewVC *fullWebviewController;
    
    /// selected ReportView (Chart)
    ReportView *selectedReportView;
    
    /// Object instance for User detail VC, like logout, name etc.
    UserDetailsViewController *userDetailsViewController;
    
    /// flag to check user log off or not.
    BOOL isLogoffSuccesfull;
    
    /// flag to save the selected ReportView (Chart).
    BOOL isReportView;
    
    // load dashboard when app load first time
    BOOL isFirstLoadDashboard;
}

@end

@implementation HomeViewController

-(void)viewDidAppear:(BOOL)animated {

    [super viewDidAppear:animated];
    
    //To check for the current orientation.
    
    if((self.interfaceOrientation == UIDeviceOrientationLandscapeLeft) || (self.interfaceOrientation == UIDeviceOrientationLandscapeRight)){
        [dashboardViewController.view setFrame:kMyViewControllerFrame];
    }else{
        [dashboardViewController.view setFrame:kMyViewControllerFramePortrait];
    }
    
    if(!isFirstLoadDashboard)
      [self loadLastSelectedDashboardOrChartForSameUser];
    isFirstLoadDashboard = YES;
}

- (void)viewDidLoad{
    
    [super viewDidLoad];
    // Load view controllers.
    [self loadViewControllers];

    // Load initial title and Dashboard from first Report
    [self setInitialHeaderTitleAndView];

    // Load view controllers.
    //[self loadViewControllers];
    
    isLogoffSuccesfull = NO;
    
    // Default we set no, to load the dashboard
    isFirstLoadDashboard = NO;
    
    // load default Dashboard or Chart
    [self selectDefaultValueForDashboard];
}

#pragma mark - UIButton actions

/*!
 @method leftBarButtonSwipeLeft
 @abstract Used to display left menu bar
 @discussion This method used to display left menu bar by using Swipe left event
 @param sender
 @result nil
 */
- (IBAction)leftBarButtonSwipeLeft:(id)sender {
    
    DLog(@"class: %@ leftBarButtonSwipeLeft", [self class]);
    
    leftMenuViewController.view.frame = CGRectMake(-leftMenuViewController.view.frame.size.width,0,leftMenuViewController.view.frame.size.width,    leftMenuViewController.view.frame.size.height);
    [self addChildViewController:leftMenuViewController];
    [self.view addSubview:leftMenuViewController.view];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:kAnimationDuration];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView commitAnimations];
    
}

/*!
 @method rightBarButtonSwipeLeft
 @abstract Used to display right menu bar
 @discussion This method used to display right menu bar by using Swipe right event
 @param sender
 @result nil
 */
- (IBAction)rightBarButtonSwipeLeft:(id)sender {
    
    DLog(@"class: %@ rightBarButtonSwipeLeft", [self class]);
    
    [Global showProgessindicator:self.view];
    
    //  If first time selected we need to instantiate controller
    
    // jam issue?
    if (!rightMenuViewController)
        rightMenuViewController = [[RightMenuViewController alloc] initWithNibName:@"RightMenuViewController" bundle:nil];
    
    if (!rightMenuViewController.view.window) {
        [self addChildViewController:rightMenuViewController];
        [self.view addSubview:rightMenuViewController.view];
        
        //[Global hideProgessIndicator];
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:kAnimationDuration];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        [UIView commitAnimations];
    } else {
        [rightMenuViewController.view removeFromSuperview];
        [Global hideProgessIndicator];
    }
    
}



/*!
 @method helpButtonPressed
 @abstract Used to display Help screen
 @discussion This method used to display Help screen for how to used Dashboard
 @param sender
 @result nil
 */
- (IBAction)helpButtonPressed:(id)sender {
    DLog(@"HVC - Help button pressed!");
    [self addChildViewController:helpViewController];
    [self.view addSubview:helpViewController.view];
    
}

/*!
 @method userInfoButtonPressed:
 @abstract
 @discussion Used to call the show logoff option method.
 @param sender.
 @result nil.
 */
- (void)userInfoButtonPressed:(id)sender{

    // Add User detail view in super view.
    [self addChildViewController:userDetailsViewController];
    [self.view addSubview:userDetailsViewController.view];

    [self.headerView.userInfoButton setSelected:YES];
    
    // Get logged in user username.
    NSString *username = [NSString stringWithFormat:@"Logout %@",[[DataController sharedDataInstance] loginUser].userName];
    
    [userDetailsViewController.logoffButton setTitle:username
                                            forState:UIControlStateNormal];

    // Customise button.
    [userDetailsViewController.logoffButton.titleLabel setFont:kProFont_18];
    [userDetailsViewController.logoffButton setTitleColor:kCellLabelTextColor forState:UIControlStateNormal];
    [userDetailsViewController.logoffButton addTarget:self action:@selector(logoffButtonPressed:)
                                     forControlEvents:UIControlEventTouchUpInside];
}

/*!
 @method refreshButtonPressed:
 @abstract
 @discussion Used to refresh all data.
 @param sender.
 @result nil.
 */
- (void)refreshButtonPressed:(id)sender{

     if([Global isNetworkReachable]){
         
        // Start ProgessHUD.
        [Global showProgessindicator:self.view];
         
        // Make kLoadHomeView NO.
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kLoadHomeView];
        
         dispatch_async(dispatch_queue_create("com.ameri100.saop", DISPATCH_QUEUE_SERIAL), ^{
             
             // Give call to the load Models.
             [[DataController sharedDataInstance] loadDashboardDataCalls];
             
             dispatch_async(dispatch_get_main_queue(), ^{
                 
                 [[NSNotificationCenter defaultCenter] addObserver:self
                                                          selector:@selector(refreshHomeView)
                                                              name:kRefreshHomeView object:nil];
             });
         });
         
     }else{
         [Global displayNoNetworkAlert];
     }
}

/*!
 @method logoffButtonPressed:
 @abstract
 @discussion This methods used to logoff the current user.
 @param sender.
 @result nil.
 */
- (void)logoffButtonPressed:(id)sender{
    
    [self.headerView.userInfoButton setSelected:NO];
    
    // Remove User detail view from super view.
    [userDetailsViewController.view removeFromSuperview];
    [userDetailsViewController removeFromParentViewController];
    
    if([Global isNetworkReachable]){
        // Start ProgessHUD.
        [Global showProgessindicator:self.view];
        
        dispatch_async(dispatch_queue_create("com.ameri100.saop", DISPATCH_QUEUE_SERIAL), ^{
            // Start logoff process.
            [self logoffProcess];
            // Get callback on Main thread.
            dispatch_async(dispatch_get_main_queue(), ^{

                if (isLogoffSuccesfull) {
                    
                    // nil loginuser, we will load fresh Data for new user and
                    // no need to maintain previous selection.
                    [[DataController sharedDataInstance] setLoginUser:nil];
                    
                    // If session is valid then call all services.
                    [[NSNotificationCenter defaultCenter] postNotificationName:kUserLogoff object:nil];
                    // Used to clear data from NSUserDefaults to laod default data.
                    [self doneWithLogoff];
                    
                }else{

                    // Show error alert.
                    [Global hideProgessIndicator];
                    [Global displayAlertTitle:@"" withAlertMessage:kLogoffFailedDescr withCancelButton:kCancelAlertButton
                             withOtherButtons:nil withForDelegate:nil withTag:kDefaultAlertTag];
                    
                }
            });
        });
    }else{
        [Global displayNoNetworkAlert];
    }
}

#pragma mark - For showing previous selected dashboard or chart for same user.

/*!
 @method selectDefaultValueForDashboard.
 @abstract
 @discussion This methods used to get default dashboard value and name.
 @param nil.
 @result nil.
 */
- (void)selectDefaultValueForDashboard{
    
    // otherwise take default name for dashbaord and name.
    DataController* sharedDataController = [DataController sharedDataInstance];
    if([sharedDataController defaultReportPageModel] == nil)
        sharedDataController.defaultReportPageModel = [[sharedDataController reportPagesArray] objectAtIndex:0];
}

/*!
 @method loadLastSelectedDashboardOrChartForSameUser.
 @abstract
 @discussion This methods used to load last selected chart or dashboard if user is same.
 @param nil.
 @result nil.
 */
- (void)loadLastSelectedDashboardOrChartForSameUser{
    
    [self loadDashboardOnHomeScreen:[[DataController sharedDataInstance] defaultReportPageModel]];
  
}

#pragma mark - Custom methods

/*!
 @method loadViewControllers.
 @abstract
 @discussion This methods used to load view controllers used in this view.
 @param nil.
 @result nil.
 */
- (void)loadViewControllers{
    
    // Initializing Left Menu View
    leftMenuViewController = [[LeftMenuViewController alloc] initWithNibName:@"LeftMenuViewController" bundle:nil];
    leftMenuViewController.leftMenuViewDelegate=self;
    
    // Initialize right menu view
    rightMenuViewController = [[RightMenuViewController alloc] initWithNibName:@"RightMenuViewController" bundle:nil];
    
    // Initializing Help Menu View
    helpViewController=[[HelpViewController alloc] initWithNibName:@"HelpViewController" bundle:nil];
    
    // Initialising DataSet
    dataSetViewController=[[DataSetViewController alloc] initWithNibName:@"DataSetViewController" bundle:nil];
    
    // Initialising LogoffView.
    userDetailsViewController = [[UserDetailsViewController alloc] initWithNibName:@"UserDetailsViewController" bundle:nil];
}

/*!
 @method refreshHomeView
 @abstract
 @discussion This methods used to refresh the home view.
 @param nil.
 @result nil.
 */
- (void)refreshHomeView{

    [Global hideProgessIndicator];
    // Load selected dashboard or chart.
    // First check that last chart/dashboard was not deleted.
    /**
    NSMutableArray *reportViewArray = [[DataController sharedDataInstance] reportViewsArray];
    NSMutableArray *reportPageArray = [[DataController sharedDataInstance] reportPagesArray];
    BOOL FoundIt = NO;
    
    NSObject *defaultReport = [[DataController sharedDataInstance] defaultReportPageModel];
    ReportPage *tdefaultReportPage = (ReportPage *) defaultReport;
    for (ReportPage *reportpage in reportPageArray) {
        if ([reportpage.reportPageId isEqual: tdefaultReportPage.reportPageId] ) {
            [self loadDashboardOnHomeScreen:[[DataController sharedDataInstance] defaultReportPageModel]];
            FoundIt = YES;
            break;
        }
    }

    if (FoundIt == NO) {
        ReportView *tdefaultReportView = (ReportView *) defaultReport;
        for (ReportView *reportview in reportViewArray) {
            if ([reportview.reportViewId isEqual:tdefaultReportView.reportViewId]) {
                [self loadDashboardOnHomeScreen:[[DataController sharedDataInstance] defaultReportPageModel]];
                FoundIt = YES;
                break;
            }
        }
    }
    **/
    [self loadDashboardOnHomeScreen:[[DataController sharedDataInstance] defaultReportPageModel]];
    // Refresh dataset array.
    [dataSetViewController fillDatasetArray];
    // Refresh left view menu.
    [leftMenuViewController refreshLeftMenu];
    // Remove observer.
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kRefreshHomeView object:nil];
}

- (void)logoffProcess{
    
    NSError __autoreleasing *error;
    isLogoffSuccesfull = [[DataController sharedDataInstance] logoutFromApplication:&error];
}

/*!
 @method loadDashboardOnHomeScreen
 @abstract Displays dashboard prefer by login user
 @discussion This methods load MAKIT Dashboard subview
 @param nil
 @result nil
 */
- (void)loadDashboardOnHomeScreen:(id)reportPageModel {
    
    // Show progress indicator
    [Global showProgessindicator:self.view];
    
    dispatch_async(dispatch_queue_create("com.ameri100.saop", DISPATCH_QUEUE_SERIAL), ^{
        // Start loading procedure process.
        NSString* title=@"";
        if([reportPageModel isKindOfClass:[ReportPage class]]) {
            //[[DataController sharedDataInstance] loadSelectedDashboard:reportPageModel];
            title=[(ReportPage*)reportPageModel reportPageName];
        }
        else {
            [[DataController sharedDataInstance] loadSelectedChart:reportPageModel];
            title=[(ReportView*)reportPageModel reportViewName];
            //title=[NSString stringWithFormat:@"%@-%@",[(ReportView*)reportPageModel reportViewName], [(ReportView *) reportPageModel MAKitChartFunction]];
        }
        // Get callback on Main thread.
        dispatch_async(dispatch_get_main_queue(), ^{
            DLog(@"dispatch_get_main_queue- home VC");
            
            [Global hideProgessIndicator];
            
            //  Check for existing DB or full VCs and remove
            if(dashboardViewController){
                [dashboardViewController.view removeFromSuperview];
                [dashboardViewController removeFromParentViewController];
                dashboardViewController=nil;
            }
            
            if (fullWebviewController) {
                [fullWebviewController.view removeFromSuperview];
                [fullWebviewController removeFromParentViewController];
                fullWebviewController = nil;
            }
            
            if([reportPageModel isKindOfClass:[ReportPage class]]) {
                //  Create DashboardVC
                dashboardViewController = [[DashboardVC alloc] initWithNibName:@"DashboardVC" bundle:nil];
                [dashboardViewController setReportPage:reportPageModel];
                //[self addChildViewController:dashboardViewController];
                //[self.view addSubview:dashboardViewController.view];
                
                //  iOS8
                if (self.view.frame.size.width > self.view.frame.size.height) {
                //if((self.interfaceOrientation == UIDeviceOrientationLandscapeLeft) || (self.interfaceOrientation == UIDeviceOrientationLandscapeRight)){
                    [dashboardViewController.view setFrame:kMyViewControllerFrame];
                }else{
                    [dashboardViewController.view setFrame:kMyViewControllerFramePortrait];
                }
                
                //  [maDashboardViewController.view setFrame:kMyViewControllerFrame];
                [self addChildViewController:dashboardViewController];
                [self.view addSubview:dashboardViewController.view];

            } else {
                fullWebviewController = [[FullWebviewVC alloc] initWithNibName:@"FullWebviewVC" bundle:nil];
                [fullWebviewController setChart:reportPageModel];
                //[fullWebviewController.dismissButton setHidden:YES];
                [fullWebviewController setChartFromDashboard:FALSE];
                //  iOS8
                if (self.view.frame.size.width < self.view.frame.size.height) {
                //if((self.interfaceOrientation == UIDeviceOrientationLandscapeLeft) || (self.interfaceOrientation == UIDeviceOrientationLandscapeRight)){
                    [fullWebviewController.view setFrame:kMyViewControllerFrame];
                }else{
                    [fullWebviewController.view setFrame:kMyViewControllerFramePortrait];
                }
                
                [self addChildViewController:fullWebviewController];
                [self.view addSubview:fullWebviewController.view];
                
            }
            
            //Create MAViewController
            /**
            if(maDashboardViewController){
                
                [maDashboardViewController.view removeFromSuperview];
                [maDashboardViewController removeFromParentViewController];
                maDashboardViewController=nil;
            }
            maDashboardViewController = [[MyMAViewController alloc] init];
            ChartQuery *query = [[ChartQuery alloc] init];
            maDashboardViewController.metaDataPath = [NSString stringWithString:kMetaDataDashboardFileName];
            maDashboardViewController.title = title;
            maDashboardViewController.theme = [[MAKitTheme_SAOPDefault alloc] init];
            maDashboardViewController.dataSource = query;
            
            //Code is to check for the current interface orientation.
            if((self.interfaceOrientation == UIDeviceOrientationLandscapeLeft) || (self.interfaceOrientation == UIDeviceOrientationLandscapeRight)){
                [maDashboardViewController.view setFrame:kMyViewControllerFrame];
            }else{
                [maDashboardViewController.view setFrame:kMyViewControllerFramePortrait];
            }
      
           //  [maDashboardViewController.view setFrame:kMyViewControllerFrame];
            [self addChildViewController:maDashboardViewController];
            [self.view addSubview:maDashboardViewController.view];
            **/
            
            // Set title
            [self.headerView setTitleForTheHeader:title];
            
            // Check if we launching Home screen first time on the device, show help screen
            if (![[NSUserDefaults standardUserDefaults] boolForKey:@"HasLaunchOnce"]) {
                
                // This is app first launch ever
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"HasLaunchOnce"];
                [self helpButtonPressed:nil];
            }
            [self.view bringSubviewToFront:helpViewController.view];
            DLog(@"dispatch_get_main_queue-home VC-exiting block");
            
        });
    });
}

/*!
 @method loadConfigureView
 @abstract Displays setting VC
 @discussion This methods load Setting View in Window
 @param nil
 @result nil
 */
-(void)loadConfigureView {
  
    // Commenting intenet checking condition
    //    if([Global isNetworkReachable] || (connectionType == DefaultDashboardView)) {
    
    AppDelegate* appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate loadSettingViewController];
    
    //}else{
    //  [Global displayNoNetworkAlert];
    //}
}

/*!
 @method doneWithLogoff.
 @abstract 
 @discussion This methods used to clear data from NSUserDefaults to load default data.
 @param nil
 @result nil
 */
- (void)doneWithLogoff{
    
    
    isFirstLoadDashboard = NO;
    
    AppDelegate* appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate showLoginScreen];
    
    
}

/*!
 @method loadDataSetView
 @abstract Displays dataset VC
 @discussion This methods load planning area in tableview
 @param nil
 @result nil
 */
-(void)loadDataSetView {
    
    [self addChildViewController:dataSetViewController];
    [self.view addSubview:dataSetViewController.view];
    [self.headerView.datasetButton setSelected:YES];
}

- (void) setInitialHeaderTitleAndView {
    
    // Setup home view.
    [self.headerView setUpHomeScreenComponent];
    
    [self.headerView.leftBarButton addTarget:self action:@selector(leftBarButtonSwipeLeft:)
                            forControlEvents:UIControlEventTouchUpInside];
    [self.headerView.rightBarButton addTarget:self action:@selector(rightBarButtonSwipeLeft:)
                             forControlEvents:UIControlEventTouchUpInside];
    [self.headerView.helpButton addTarget:self action:@selector(helpButtonPressed:)
                         forControlEvents:UIControlEventTouchUpInside];
    [self.headerView.settingsButton addTarget:self action:@selector(loadConfigureView)
                             forControlEvents:UIControlEventTouchUpInside];
    [self.headerView.datasetButton addTarget:self action:@selector(loadDataSetView)
                            forControlEvents:UIControlEventTouchUpInside];
    [self.headerView.userInfoButton addTarget:self action:@selector(userInfoButtonPressed:)
                             forControlEvents:UIControlEventTouchUpInside];
    [self.headerView.refreshButton addTarget:self action:@selector(refreshButtonPressed:)
                            forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark- UITouch delegate

// UIView touch began delegate
// touch it is handling (those touches it received in touchesBegan:withEvent:).
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:kAnimationDuration];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    leftMenuViewController.view.frame = CGRectMake(-leftMenuViewController.view.frame.size.width,0,leftMenuViewController.view.frame.size.width,    leftMenuViewController.view.frame.size.height);
    [UIView commitAnimations];
    [leftMenuViewController.view removeFromSuperview];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:kAnimationDuration];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    rightMenuViewController.view.frame = CGRectMake(-rightMenuViewController.view.frame.size.width,0,rightMenuViewController.view.frame.size.width,    rightMenuViewController.view.frame.size.height);
    [UIView commitAnimations];
    [rightMenuViewController.view removeFromSuperview];
    
    [dataSetViewController.view removeFromSuperview];
    [dataSetViewController removeFromParentViewController];
    [self.headerView.datasetButton setSelected:NO];
    
    // Remove log off view.
    [self.headerView.userInfoButton setSelected:NO];
    [userDetailsViewController.view removeFromSuperview];
    [userDetailsViewController removeFromParentViewController];
}

#pragma mark- LeftMenuViewDelegates

-(void)selectDashboardToLoad:(ReportPage *)selectedReportPage {
   
    [self loadDashboardOnHomeScreen:selectedReportPage];
    
    
    [DataController sharedDataInstance].defaultReportPageModel = selectedReportPage;
}

-(void)selectChartToLoad:(ReportView *)_selectedReportView {

    [self loadDashboardOnHomeScreen:_selectedReportView];
    /**
    FullWebviewVC *fullChartView = [[FullWebviewVC alloc] initWithNibName:@"FullWebviewVC" bundle:nil];
    [fullChartView setChart:_selectedReportView];
    [fullChartView setReportviewID:_selectedReportView.reportViewId];
    [fullChartView.dismissButton setHidden:YES];
    **/
    [DataController sharedDataInstance].defaultReportPageModel = _selectedReportView;
}


#pragma mark - Interface Orientation methods
-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    /**
    if((self.interfaceOrientation == UIDeviceOrientationLandscapeLeft) || (self.interfaceOrientation == UIDeviceOrientationLandscapeRight)){
        [maDashboardViewController.view setFrame:kMyViewControllerFrame];
    }else{
        [maDashboardViewController.view setFrame:kMyViewControllerFramePortrait];
    }
     **/
}

//Used to check whether to rotate the view or not.
- (BOOL)shouldAutorotate
{
    
    UIViewController* topViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    while ([topViewController presentedViewController]) {
        
        topViewController = [topViewController presentedViewController];
        if([topViewController isKindOfClass:[UINavigationController class]]) {
            
            UINavigationController* nvc = (UINavigationController *)topViewController;
            
            if([[nvc viewControllers] count] >= 2) {
            
                UIViewController* vc=[[nvc viewControllers] objectAtIndex:0];
                [vc viewDidLoad];
                [vc viewWillAppear:YES];
            }
        }
    }
    
    return YES;
}

@end
