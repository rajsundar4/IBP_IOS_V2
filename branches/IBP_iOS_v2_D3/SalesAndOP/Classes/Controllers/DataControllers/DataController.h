//
//  DataController.h
//  S&OP
//
//  Created by Ganesh D on 05/08/13.
//  Copyright (c) 2013 Linear Logics Corp.. All rights reserved.
//

#import "User.h"
#import "Report.h"
#import "Global.h"
#import "DBManager.h"
#import "ReportView.h"
#import "ReportPage.h"
//#import "MDGenerator.h"
#import <Foundation/Foundation.h>

/*!
 \internal
 @class DataController
 @abstract This class used to create shared data controller instance.
 @discussion Class represent controller which managed entities in array, Reports, 
 ReportViews, ReportPages.
 */
@interface DataController : NSObject{

    /// We are maintaining the asynch thread in threadQurue variable.
    dispatch_queue_t threadQueue;
    
    /// Count represent number of threads currently running in main memory.
    NSInteger threadCount;
}



#pragma mark - Property Declaration

/// Array used for store the Reports data.
@property (strong, nonatomic) NSMutableArray* reportsArray;
/// Array used for store the ReportViews data.
@property (strong, nonatomic) NSMutableArray* reportViewsArray;
/// Array used for store the ReportViews Attribute data.
@property (strong, nonatomic) NSMutableArray* reportViewsAttrArray;
/// Array used for store the ReportPages data.
@property (strong, nonatomic) NSMutableArray* reportPagesArray;
/// Array used for store the ReportPageLayout data.
@property (strong, nonatomic) NSMutableArray* reportPageLayoutArray;
/// Array used for store the favourit data.
@property (strong, nonatomic) NSMutableArray* favouritesArray;
/// NSString used for save default planning area.
@property (strong, nonatomic) Report *defaultReport;
/// Defalut Report page or chart model
@property (strong, nonatomic) NSObject *defaultReportPageModel;
/// User model to save username and password.
@property (strong, nonatomic) User* loginUser;
/// Used to create metadata xml.
//@property (strong, nonatomic) MDGenerator* mdGenerator;
/// Default plannig area string.
@property (strong, nonatomic) NSString *defaultPlanningAreaString;

@property (nonatomic,strong) NSDate *timeStamp;

#pragma mark - Method Declaration

/*!
 \internal
 @function sharedDataInstance.
 @abstract -
 @discussion This method is used to create unique instance for DataController.
 @param  nil.
 @result DataController.
 */
+ (DataController *)sharedDataInstance;

/*!
 \internal
 @function setBaseUrlFromServerTextField:
 @abstract -
 @discussion This method is used to get Charts(Report Views) for seleted planning area.
 @param  arg_serverText - Server text field text from ConfigureViewController.
 @result nil.
 */
- (void)setBaseUrlFromServerTextField:(NSString *)arg_serverText;

/*!
 \internal
 @function isLoginValid:
 @abstract -
 @discussion This method is used check the entered username and password are valid for login.
 @param  arg_username - Username.
 arg_password  - Password.
 @result  YES/NO.
 */
- (BOOL)isLoginValid:(NSString *)arg_username andPassword:(NSString *)arg_password
      andReturnError:(__autoreleasing NSError **)arg_error;


/*!
 \internal
 @function isSessionValid:
 @abstract -
 @discussion This method is used to check the session is valid or not.
 @param  arg_username - Username.
 arg_error - Return error.
 @result YES/NO for logged in user.
 */
- (BOOL)isSessionValid:(NSString *)arg_username
        andReturnError:(__autoreleasing NSError **)arg_error;

/*!
 \internal
 @function setLoginUserName:
 @abstract -
 @discussion This method is used to validate username and password.
 @param  username
 @param  password
 @result nil.
 */
- (void)setLoginUserName:(NSString *)username andPassword:(NSString *)password;

/*!
 \internal
 @function logoutFromApplicationAndReturnError:
 @abstract -
 @discussion This method is used to logout from app.
 @param  arg_error - Return error.
 @result YES/NO.
 */
- (BOOL)logoutFromApplication:(__autoreleasing NSError **)arg_error;

/*!
 \internal
 @function getUserPlanningAreaFormDataController:
 @abstract -
 @discussion This method is used to get all planning area for logged in user.
 @param  arg_username - Username.
 arg_error - Return error.
 @result nil.
 */
- (void)getDefaultUserPlanningAreaFormDataController:(NSString *)arg_username
                                      andReturnError:(__autoreleasing NSError **)arg_error;

/*!
 \internal
 @function loadReportsForUsersDefaultPlannigArea.
 @abstract -
 @discussion This method is used to load Reports for Default plannig area.
 @param  nil.
 @result nil.
 */
- (void)loadReportsForUsersDefaultPlannigArea;

/*!
 \internal
 @function getReportsForDefaultPlanningArea:
 @abstract -
 @discussion This method is used to get Reports data for default planning area.
 @param  arg_planningAreaString - default planning area name.
 @result Report model.
 */
- (Report *)getReportsForDefaultPlanningArea:(NSString *)arg_planningAreaString;

/*!
 \internal
 @function isLoginValid:
 @abstract -
 @discussion This method is used to register the notification for Request Handler.
 @param  nil.
 @result nil.
 */
- (void)registerOdataNotification;

/*!
 \internal
 @function loadDashboardDataCalls
 @abstract -
 @discussion This method is used to give call to the request handler methods.
 @param  nil.
 @result nil.
 */
- (void)loadDashboardDataCalls;

/*!
 \internal
 @function getUserFavoritesFromDataControllerWithUsername:
 @abstract -
 @discussion This method is used to get all favourite data for logged in user.
 @param  arg_username - Username.
 arg_error - Return error.
 @result nil.
 */
- (void)getUserFavoritesFromDataControllerWithUsername:(NSString *)arg_username
                                              andReturnError:(__autoreleasing NSError **)arg_error;

/*!
 \internal
 @function getReportJsonSyncFromDataControllerWithReportview:
 @abstract -
 @discussion This method is used to get dataset for Reportviewids.
 @param  arg_reportView - ReportViewId.
 arg_error - Return error.
 @result Dataset dictionary for logged in user.
 */
- (NSDictionary *)getReportJsonSyncFromDataControllerWithReportview:(NSString *)arg_reportView
                                             andReturnError:(__autoreleasing NSError **)arg_error;

/*!
 \internal
 @function getChartsForSelectedPlanningArea:
 @abstract -
 @discussion This method is used to get Charts(Report Views) for seleted planning area.
 @param  arg_report - Report model.
 @result NSMutableArray with charts data.
 */
- (NSMutableArray *)getChartsForSelectedPlanningArea:(Report *)arg_report;

/*!
 \internal
 @function loadSelectedDashboard:
 @abstract -
 @discussion This method is used to generated MetaData Xml and Dictionary 
             for MAKIT framework on the selection of Dashboard
 @param  reportPage.
 @result nil.
 */
- (void)loadSelectedDashboard:(ReportPage *)reportPage;

/*!
 \internal
 @function loadSelectedChart:
 @abstract -
 @discussion This method is used to generated MetaData xml and Dictionary 
             for MAKit framework on the selection of Chart
 @param  reportPage.
 @result nil.
 */
- (void)loadSelectedChart:(ReportView *)reportView;

/*!
 \internal
 @function responseStatusCode.
 @abstract -
 @discussion This method is used to get response status code from request handler.
 @param  nil.
 @result Response status code.
 */
- (int)responseStatusCode;

/*!
 \internal
 @function sortInAscendingOrder:
 @abstract -
 @discussion This method is used to sort array in Ascending order.
 @param  arg_array - Main ReportPage Array.
 @result nil.
 */
- (NSArray*)sortInAscendingOrder:(NSMutableArray *)arg_array;


/*!
 \internal
 @function sortInAlphabeticallyOrder:
 @abstract -
 @discussion This method is used to sort array in Alphabetical order.
 @param  arg_array - Main ReportView Array.
 @result nil.
 */
- (NSArray *)sortInAlphabeticallyOrder:(NSMutableArray *)arg_array;

/*!
 \internal 
 @function insertAllDataModelsInSqliteDatabase
 @abstract 
 @discussion This method is used to save model information in database like 
             Report, ReportPage, ReportView, ReportViewAttr and ReportPageLayout.
 @result nil.
 */
-(void)insertAllDataModelsInSqliteDatabase;

/*!
 \internal 
 @function loadsAllDataModelsFromSqliteDatabase
 @abstract
 @discussion This method is used to load model information in Data Controller like
 Report, ReportPage, ReportView, ReportViewAttr and ReportPageLayout.
 @result nil.
 */
-(void)loadsAllDataModelsFromSqliteDatabase;

- (NSMutableArray *)getListOfReportPageLayoutForReportPage:(ReportPage *)reportPage;
- (NSMutableArray *)getListOFJSONDataForCharts:(NSMutableArray *)pageLayoutArray;
- (NSMutableArray *)assignValuesToTheReportViewAttributes:(NSMutableArray *) reportViewArray;

@end
