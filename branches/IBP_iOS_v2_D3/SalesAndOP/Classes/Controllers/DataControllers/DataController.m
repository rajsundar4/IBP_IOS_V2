//
//  DataController.m
//  S&OP
//
//  Created by Ganesh D on 05/08/13.
//  Copyright (c) 2013 Linear Logics Corp.. All rights reserved.
//

#import "Report.h"
#import "Global.h"
#import "DBManager.h"
#import "ReportView.h"
#import "ReportPage.h"
#import "ErrorMessages.h"
#import "UIConfigValue.h"
#import "ReportViewAttr.h"
#import "DataController.h"
#import "ReportPageLayout.h"
#import "AllDictionaryKeys.h"
#import "sapsopaRequestHandler.h"

@implementation DataController

#pragma mark - Synthesize Property
@synthesize timeStamp;

/*!
 @function sharedDataInstance.
 @abstract -
 @discussion This method is used to create unique instance for DataController.
 @param  nil.
 @result DataController.
 */
+ (DataController *)sharedDataInstance{
    
    static DataController *dataController;
    
    if(!dataController){
        
        dataController = [[DataController alloc] init];
        
    }
    
    return dataController;
    
}

#pragma mark - Custom methods

/*!
 @function isLoginValid:
 @abstract -
 @discussion This method is used to register the notification for Request Handler.
 @param  nil.
 @result nil.
 */
- (void)registerOdataNotification {
    
    // Register the method that will be executed when the appropriate Request Handler method is completed.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadReportsCompleted:)
                                                 name:kLoadReportsCompletedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadReportpagesCompleted:)
                                                 name:kLoadReportpagesCompletedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadReportviewsCompleted:)
                                                 name:kLoadReportviewsCompletedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadReportpagelayoutCompleted:)
                                                 name:kLoadReportpagelayoutCompletedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadReportviewCompleted:)
                                                 name:kLoadReportviewCompletedNotification object:nil];
    
    
}

/*!
 @function loadDashboardDataCalls
 @abstract -
 @discussion This method is used to give call to the request handler methods.
 @param  nil.
 @result nil.
 */
- (void)loadDashboardDataCalls{
    
    [self initialiseThreadQueue];
    [[sapsopaRequestHandler uniqueInstance] loadReports];
    [[sapsopaRequestHandler uniqueInstance] loadReportviews];
    [[sapsopaRequestHandler uniqueInstance] loadReportview];
    [[sapsopaRequestHandler uniqueInstance] loadReportpages];
    [[sapsopaRequestHandler uniqueInstance] loadReportpagelayout];
}

/*!
 @function isLoginValid:
 @abstract -
 @discussion This method is used check the entered username and password are valid for login.
 @param  arg_username - Username.
 arg_password  - Password.
 @result YES/NO.
 */
- (BOOL)isLoginValid:(NSString *)arg_username andPassword:(NSString *)arg_password
      andReturnError:(__autoreleasing NSError **)arg_error{
    
    BOOL boolToReturn = NO;
    boolToReturn = [[sapsopaRequestHandler uniqueInstance] executeSOPLoginWithUsername:arg_username
                                                                           andPassword:arg_password andReturnError:arg_error];
    return boolToReturn;
}

/*!
 @function isSessionValid:
 @abstract -
 @discussion This method is used to check the session is valid or not.
 @param  arg_username - Username.
 arg_error - Return error.
 @result YES/NO.
 */
- (BOOL)isSessionValid:(NSString *)arg_username andReturnError:(__autoreleasing NSError **)arg_error{
    DLog(@"name - %@",arg_username);
    BOOL boolToReturn = NO;
    boolToReturn = [[sapsopaRequestHandler uniqueInstance] getUserSession:arg_username
                                                           andReturnError:arg_error];
    return boolToReturn;
}

/*!
 @function responseStatusCode.
 @abstract -
 @discussion This method is used to get response status code from request handler.
 @param  nil.
 @result Response status code.
 */
- (int)responseStatusCode{
    
    DLog(@"%d",[[sapsopaRequestHandler uniqueInstance] responseCode]);
    return [[sapsopaRequestHandler uniqueInstance] responseCode];
}

/*!
 @function logoutFromApplication:
 @abstract -
 @discussion This method is used to logout from app.
 @param  arg_error - Return error.
 @result YES/NO.
 */
- (BOOL)logoutFromApplication:(__autoreleasing NSError **)arg_error{
    
    BOOL boolToReturn = NO;
    boolToReturn = [[sapsopaRequestHandler uniqueInstance] executeSOPLogoutAndReturnError:arg_error];
    return boolToReturn;
}

/*!
 @function getUserPlanningAreaFormDataController:
 @abstract -
 @discussion This method is used to get all planning area for logged in user.
 @param  arg_username - Username.
 arg_error - Return error.
 @result DataController.
 */
- (void)getDefaultUserPlanningAreaFormDataController:(NSString *)arg_username
                                      andReturnError:(__autoreleasing NSError **)arg_error{
    
    NSString *stringToAdd = nil;
    stringToAdd = [[sapsopaRequestHandler uniqueInstance]
                   getUserPlanningAreaWithUsername:arg_username andReturnError:arg_error];
    
    if(stringToAdd){
        // Add default plannig area to DefaultPlannigArea.
        [self setDefaultPlanningAreaString:stringToAdd];
    }
    else{
        // Show error.
        [Global displayAlertTitle:nil
                 withAlertMessage:kNoDefaultPlannigAreaFound withCancelButton:kCancelAlertButton
                 withOtherButtons:nil
                  withForDelegate:self withTag:kDefaultAlertTag];
    }
}

/*!
 @function loadReportsForUsersDefaultPlannigArea.
 @abstract -
 @discussion This method is used to load Reports for Default plannig area.
 @param  nil.
 @result nil.
 */
- (void)loadReportsForUsersDefaultPlannigArea{
    
    self.defaultReport = [self getReportsForDefaultPlanningArea:self.defaultPlanningAreaString];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kGetReportViewsArray
                                                  object:nil];
}

/*!
 @function getUserFavoritesFromDataControllerWithUsername:
 @abstract -
 @discussion This method is used to get all favourite data for logged in user.
 @param  arg_username - Username.
 arg_error - Return error.
 @result DataController.
 */
- (void)getUserFavoritesFromDataControllerWithUsername:(NSString *)arg_username
                                        andReturnError:(__autoreleasing NSError **)arg_error{
    
    NSDictionary *dictToAdd = [[sapsopaRequestHandler uniqueInstance] getUserFavoritesWithUsername:arg_username
                                                                                       andPlanArea:nil
                                                                                    andReturnError:arg_error];
    [self.favouritesArray addObject:dictToAdd];
}

/*!
 @function getReportJsonSyncFromDataControllerWithReportview:
 @abstract -
 @discussion This method is used to get dataset for Reportviewids.
 @param  arg_reportView - ReportViewId.
 arg_error - Return error.
 @result Dataset dictionary.
 */
- (NSDictionary *)getReportJsonSyncFromDataControllerWithReportview:(NSString *)arg_reportView
                                                     andReturnError:(__autoreleasing NSError **)arg_error{
    
    NSDictionary *dictToReturn = [[NSDictionary alloc] init];
    
    dictToReturn = [[sapsopaRequestHandler uniqueInstance]
                    loadReportJsonSyncWithReportview:arg_reportView andReturnError:arg_error];
    
    return dictToReturn;
}

/*!
 @function initialiseThreadQueue.
 @abstract -
 @discussion This method is used to initialise thread count and dispatch_queue.
 @param  nil.
 @result nil.
 */
- (void)initialiseThreadQueue{
    
    threadCount = 0;
    threadQueue = dispatch_queue_create("com.ameri100.saop", DISPATCH_QUEUE_CONCURRENT);
}

/*!
 @function sendNotificationToLoadHomeScreen:
 @abstract -
 @discussion This method is used to load home screen when thread count meet the condition.
 @param  arg_threadCount - thread count.
 @result nil.
 */
- (void)sendNotificationToLoadHomeScreen:(NSInteger)arg_threadCount{
    
    if([[NSUserDefaults standardUserDefaults] boolForKey:kLoadHomeView]){
        // From setting screen if done button pressed then load home view.
        if(arg_threadCount == kThreadCount){
            DLog(@"load homeVC.");
            [[NSNotificationCenter defaultCenter] postNotificationName:kGetAllODataWithDispatchAsyncKey
                                                                object:self];
        }
    }else{
        // Only refresh the home view not load the home view.
        if(arg_threadCount == kThreadCount){
            DLog(@"refresh homeVC.");
            [[NSNotificationCenter defaultCenter] postNotificationName:kRefreshHomeView
                                                                object:self];
        }
    }
}

/*!
 @function getReportsForDefaultPlanningArea:
 @abstract -
 @discussion This method is used to get Reports data for default planning area.
 @param  arg_planningAreaString - default planning area name.
 @result Report model.
 */
- (Report *)getReportsForDefaultPlanningArea:(NSString *)arg_planningAreaString {
    
    if([_reportsArray count]) {
        
        for(Report* report in _reportsArray) {
            
            if([report.reportName isEqualToString:arg_planningAreaString]) {
                
                return report;
            }
        }
        return [_reportsArray objectAtIndex:0];
    }
    
    return nil;
}

/*!
 @function getChartsForSelectedPlanningArea:
 @abstract -
 @discussion This method is used to get Charts(Report Views) for seleted planning area.
 @param  arg_report - Report model.
 @result NSMutableArray with charts data.
 */
- (NSMutableArray *)getChartsForSelectedPlanningArea:(Report *)arg_report {
    
    NSMutableArray* filterChartsArray=[[NSMutableArray alloc] init];
    
    if([_reportViewsArray count]) {
        
        for(ReportView* reportView in _reportViewsArray) {
            
            if([reportView.reportId isEqualToString:arg_report.reportId]) {
                
                [filterChartsArray addObject:reportView];
            }
        }
    }
    return filterChartsArray;
}

/*!
 @function setBaseUrlFromTextField:
 @abstract -
 @discussion This method is used to get Charts(Report Views) for seleted planning area.
 @param  arg_serverText - Server textfield text from ConfigureViewController.
 @result nil.
 */
- (void)setBaseUrlFromServerTextField:(NSString *)arg_serverText{
    
    [[sapsopaRequestHandler uniqueInstance] setBaseServerURL:arg_serverText];
}

/*!
 @function sortInAscendingOrder:
 @abstract -
 @discussion This method is used to sort array in Ascending order.
 @param  arg_array - Main ReportPage Array.
 @result nil.
 */
- (NSArray *)sortInAscendingOrder:(NSMutableArray *)arg_array{
    
    NSArray *sortedArray;
    sortedArray = [arg_array sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        NSString *first = [(ReportPage*)a reportPageName];
        NSString *second = [(ReportPage*)b reportPageName];
        return [first compare:second];
    }];
    return sortedArray;
}

/*!
 @function sortInAlphabeticallyOrder:
 @abstract -
 @discussion This method is used to sort array in Alphabetical order.
 @param  arg_array - Main ReportView Array.
 @result nil.
 */
- (NSArray *)sortInAlphabeticallyOrder:(NSMutableArray *)arg_array{
    
    NSArray *sortedArray;
    
    sortedArray = [arg_array sortedArrayUsingComparator:^NSComparisonResult(id reportName1,id reportName2) {
        NSString *first = [(ReportView*)reportName1 reportViewName];
        NSString *second = [(ReportView*)reportName2 reportViewName];
        //return [first localizedCaseInsensitiveCompare:second];
        return [first compare:second];
    }];
    return sortedArray;
}

// rft
/*!
 @function sortDictInAlphabeticalOrder:
 @abstract -
 @discussion This method is used to sort array in Alphabetical order based on string stored unde "keyKey" key.
 @param  arg_array - Main ReportView Array.
 @result nil.
 */
- (NSArray *)sortDictInAlphabeticalOrder:(NSMutableArray *)arg_array{
    
    NSArray *sortedArray;
    
    sortedArray = [arg_array sortedArrayUsingComparator:^NSComparisonResult(id keyKey1,id keyKey2) {
        NSString *first = [(NSMutableDictionary *) keyKey1 objectForKey:@"keyKey"];
        NSString *second = [(NSMutableDictionary *) keyKey2 objectForKey:@"keyKey"];
        //return [first localizedCaseInsensitiveCompare:second];
        return [first compare:second];
    }];
    return sortedArray;
}

/*!
 @function sortDictInReverseAlphabeticalOrder:
 @abstract -
 @discussion This method is used to sort array in Reverse Alphabetical order based on string stored unde "keyKey" key.
 @param  arg_array - Main ReportView Array.
 @result nil.
 */
- (NSArray *)sortDictInReverseAlphabeticalOrder:(NSMutableArray *)arg_array{
    
    NSArray *sortedArray;
    
    sortedArray = [arg_array sortedArrayUsingComparator:^NSComparisonResult(id keyKey1,id keyKey2) {
        NSString *first = [(NSMutableDictionary *) keyKey1 objectForKey:@"keyKey"];
        NSString *second = [(NSMutableDictionary *) keyKey2 objectForKey:@"keyKey"];
        //return [second localizedCaseInsensitiveCompare:first];
        return [second compare:first];
    }];
    return sortedArray;
}

// rft
/*!
 @function sortDictInAlphabeticalOrder:criteriaArray:
 @abstract -
 @discussion This method is used to sort array in Alphabetical order based on 2 parameters passed in criteriaArray.
 @param  arg_array - Main ReportView Array.
 @result nil.
 */
- (NSArray *)sortDictInAlphabeticalOrder:(NSMutableArray *)arg_array criteriaArray:(NSMutableArray *) criteriaArray{
    
    NSArray *sortedArray;
    
    // changing from localizedCaseInsensitiveCompare to compare
    sortedArray = [arg_array sortedArrayUsingComparator:^NSComparisonResult(id keyKey1,id keyKey2) {
        NSString *first = [(NSMutableDictionary *) keyKey1 objectForKey:[criteriaArray objectAtIndex:0]];
        NSString *second = [(NSMutableDictionary *) keyKey2 objectForKey:[criteriaArray objectAtIndex:0]];
        if ([first compare:second] == NSOrderedSame &&
            [(NSMutableArray *) criteriaArray count] > 1 ) {
            NSString *first = [(NSMutableDictionary *) keyKey1 objectForKey:[criteriaArray objectAtIndex:1]];
            NSString *second = [(NSMutableDictionary *) keyKey2 objectForKey:[criteriaArray objectAtIndex:1]];
            return [first compare:second];
        } else
            return [first compare:second];
    }];
    return sortedArray;
}

/*!
 @function sortDictInReverseAlphabeticalOrder:criteriaArray:
 @abstract -
 @discussion This method is used to sort array in reverse Alphabetical order based on 2 parameters passed in criteriaArray.
 @param  arg_array - Main ReportView Array.
 @result nil.
 */
- (NSArray *)sortDictInReverseAlphabeticalOrder:(NSMutableArray *)arg_array criteriaArray:(NSMutableArray *) criteriaArray{
    
    NSArray *sortedArray;
    
    // changing from localizedCaseInsensitiveCompare to compare
    sortedArray = [arg_array sortedArrayUsingComparator:^NSComparisonResult(id keyKey1,id keyKey2) {
        NSString *first = [(NSMutableDictionary *) keyKey1 objectForKey:[criteriaArray objectAtIndex:0]];
        NSString *second = [(NSMutableDictionary *) keyKey2 objectForKey:[criteriaArray objectAtIndex:0]];
        if ([first compare:second] == NSOrderedSame &&
            [(NSMutableArray *) criteriaArray count] > 1) {
            NSString *first = [(NSMutableDictionary *) keyKey1 objectForKey:[criteriaArray objectAtIndex:1]];
            NSString *second = [(NSMutableDictionary *) keyKey2 objectForKey:[criteriaArray objectAtIndex:1]];
            return [second compare:first];
        } else
            return [second compare:first];
    }];
    return sortedArray;
}

#pragma mark - RequestHandler Notifications Handling

- (void)loadReportsCompleted:(NSNotification *)notification{
    
	// Handle reports response data and display the collection items in the view.
   	NSDictionary *userInfoDict = [notification userInfo];
    NSError *error = userInfoDict[kServerResponseError] ? userInfoDict[kServerResponseError]
    : userInfoDict[kParsingError];
    if (!error) {
        
        // Alloc the reportsArray for adding Reports data.
        self.reportsArray = [[NSMutableArray alloc] init];
        
        dispatch_async(threadQueue, ^{
            
            // Display the collection items.
            NSMutableArray *responseItems = userInfoDict[kResponseItems];
            
            for (reportsType *reportsTypeItem in responseItems) {
                
                // Add Reports parameters to Report model.
                Report *report = [[Report alloc] initWithODataObject:reportsTypeItem];
                [self.reportsArray addObject:report];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                // Post notification when get reportView array.
                if([self.reportsArray count]){
                    [[NSNotificationCenter defaultCenter] postNotificationName:kGetReportViewsArray
                                                                        object:nil];
                }
                threadCount++;
                [self sendNotificationToLoadHomeScreen:threadCount];
            });
        });
    }else{
        DLog(@"Error - %@",[error description]);
	}
}

- (void)loadReportviewsCompleted:(NSNotification *)notification{
    
	// Handle reportviews response data and display the collection items in the view.
   	NSDictionary *userInfoDict = [notification userInfo];
    NSError *error = userInfoDict[kServerResponseError] ? userInfoDict[kServerResponseError] : userInfoDict[kParsingError];
    if (!error) {
        
        // Alloc the reportViewsArray for adding ReportViews data.
        self.reportViewsArray = [[NSMutableArray alloc] init];
        
        dispatch_async(threadQueue, ^{
            
            // Display the collection items.
            NSMutableArray *responseItems = userInfoDict[kResponseItems];
            
            for (reportviewsType *reportviewsTypeItem in responseItems) {
                //if ([reportviewsTypeItem.REPORTVIEWTYPE isEqualToString:@"PROCESS"])
                  //  continue;
                
                // Add ReportViews parameters to ReportView model.
                ReportView *reportViews = [[ReportView alloc] initWithOdataObject:reportviewsTypeItem];
                [self.reportViewsArray addObject:reportViews];
            }
            
            // Sort array in alphabetical order.
            self.reportViewsArray = (NSMutableArray *)[self sortInAlphabeticallyOrder:self.reportViewsArray];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                threadCount++;
                [self sendNotificationToLoadHomeScreen:threadCount];
            });
        });
    }else{
        DLog(@"Error - %@",[error description]);
	}
}

- (void)loadReportviewCompleted:(NSNotification *)notification
{
	// Handle reportview response data and display the collection items in the view
	
   	NSDictionary *userInfoDict = [notification userInfo];
    NSError *error = userInfoDict[kServerResponseError] ? userInfoDict[kServerResponseError] : userInfoDict[kParsingError];
    if (!error) {
        
        // Alloc the reportViewsAttrArray for adding ReportViews data.
        self.reportViewsAttrArray = [[NSMutableArray alloc] init];
        
        dispatch_async(threadQueue, ^{
            
            // Display the collection items
            NSMutableArray *responseItems = userInfoDict[kResponseItems];
            
            for (reportviewType *reportviewTypeItem in responseItems) {
                
                // Add reportview attr to the Model
                ReportViewAttr *reportViewAttr=[[ReportViewAttr alloc] initWithOdataObject:reportviewTypeItem];
                
                [self.reportViewsAttrArray addObject:reportViewAttr];
                
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                threadCount++;
                [self sendNotificationToLoadHomeScreen:threadCount];
            });
        });
    }else{
        DLog(@"Error - %@",[error description]);
	}
}

- (void)loadReportpagesCompleted:(NSNotification *)notification{
    
	// Handle reportpages response data and display the collection items in the view.
   	NSDictionary *userInfoDict = [notification userInfo];
    NSError *error = userInfoDict[kServerResponseError] ? userInfoDict[kServerResponseError] : userInfoDict[kParsingError];
    if (!error) {
        // Alloc the reportPagesArray for adding ReportPages data.
        self.reportPagesArray = [[NSMutableArray alloc] init];
        
        dispatch_async(threadQueue, ^{
            
            // Display the collection items.
            NSMutableArray *responseItems = userInfoDict[kResponseItems];
            
            for (reportpagesType *reportpagesTypeItem in responseItems) {
                // IBP 4.0 required check to filter out unsupported dashboard types
                if (![reportpagesTypeItem.REPORTPAGETYPE isEqualToString:@"S"])
                    continue;
                // Add ReportPages parameters to ReportPage model.
                ReportPage *reportPage = [[ReportPage alloc] initWithOdataObject:reportpagesTypeItem];
                
                [self.reportPagesArray addObject:reportPage];
                
            }
            
            // Sort ReportPage array.
            self.reportPagesArray = (NSMutableArray *)[self sortInAscendingOrder:self.reportPagesArray];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                threadCount++;
                [self sendNotificationToLoadHomeScreen:threadCount];
            });
        });
    }
	else {
        DLog(@"Error - %@",[error description]);
	}
}

- (void)loadReportpagelayoutCompleted:(NSNotification *)notification{
    
	// Handle reportpagelayout response data and display the collection items in the view.
   	NSDictionary *userInfoDict = [notification userInfo];
    NSError *error = userInfoDict[kServerResponseError] ? userInfoDict[kServerResponseError] : userInfoDict[kParsingError];
    if (!error) {
        // Alloc the reportPageLayoutArray for adding ReportPageLayout data.
        self.reportPageLayoutArray = [[NSMutableArray alloc] init];
        
        dispatch_async(threadQueue, ^{
            
            // Display the collection items.
            NSMutableArray *responseItems = userInfoDict[kResponseItems];
            
            for (reportpagelayoutType *reportpagelayoutTypeItem in responseItems) {
                //if ([reportpagelayoutTypeItem.REPORTVIEWTYPE isEqualToString:@"PROCESS"] || [reportpagelayoutTypeItem.IS_KPI isEqualToString:@"TRUE"])
                  //  continue;
                // Add ReportPageLayout parameters to ReportPageLayout model.
                ReportPageLayout *reportPageLayout = [[ReportPageLayout alloc]
                                                      initWithOdataObject:reportpagelayoutTypeItem];
                [self.reportPageLayoutArray addObject:reportPageLayout];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                threadCount++;
                [self sendNotificationToLoadHomeScreen:threadCount];
            });
        });
    }
	else {
        DLog(@"Error - %@",[error description]);
	}
}

/*!
 @function setLoginUserName:
 @abstract -
 @discussion This method is used to validate username and password.
 @param  username
 @param  password
 @result nil.
 */
- (void)setLoginUserName:(NSString *)username andPassword:(NSString *)password {
    
    // Change in login user, will reset the default/selected Dashboard/Chart
    if(_loginUser){
        
        if(![_loginUser.userName
             isEqualToString:username] ||
           ![_loginUser.password
             isEqualToString:password]) {
               
               self.defaultReportPageModel = nil;
           }
    }
    else {
        
        self.defaultReportPageModel = nil;
    }
    
    // Create new instance of the login user
    _loginUser=nil;
    _loginUser=[[User alloc] init];
    [_loginUser setUserName:username];
    [_loginUser setPassword:password];
}

#pragma mark- MAKIT
#pragma mark- MetaData_Generator Dashboard DataSource

/*!
 @function loadSelectedDashboard:
 @abstract -
 @discussion This method is used to generated MetaData Xml and Dictionary
 for MAKIT framework on the selection of Dashboard
 @param  reportPage.
 @result nil.
 */
- (void)loadSelectedDashboard:(ReportPage *)reportPage {
    
    // Create new instance of Meta Data Generator
    /**
    if(_mdGenerator) {
        
        _mdGenerator=nil;
    }
    _mdGenerator=[[MDGenerator sharedMDGeneratorInstance] initWithReportPage:reportPage];
    **/
    // Get the list of Charts (Chart-Page layouts), like How many charts you want to draw
    // inside the dashboard
    //_mdGenerator.reportPageLayoutArray=[self getListOfReportPageLayoutForReportPage:reportPage];
    
    // This method loads Dashboard/Charts Data For View
    //[self loadMDGeneratorWithData];
    
}

/*!
 @function assignValuesToTheReportViewAttributes:
 @abstract -
 @discussion This method is used to get the value array for Attribute Columns
 in ReportView (Chart)
 @param  reportViewArray.
 @result reportViewArray.
 */
- (NSMutableArray *) assignValuesToTheReportViewAttributes:(NSMutableArray *) reportViewArray {
    
    // Applying null value object to valueData- 0.0, we may recieved attribute value as null
    for(ReportView *reportView in reportViewArray) {
        
        for(ReportViewAttr* reportViewAttr in reportView.reportViewAttrArray) {
            
            // If we are loading first time then only check for null value
            if(![reportViewAttr.valuesArray count]) {
                
                reportViewAttr.valuesArray=[[NSMutableArray alloc] init];
                
                // Get the attributes value from each dictionary and add into valueArray
                // So we can generate MAKIT understandable Array-Dictionary from the values and
                // keys as Attr-Id
                for(NSDictionary* chartDictionary in reportView.chartsDictionary) {
                    
                    NSString* valueData=[chartDictionary objectForKey:reportViewAttr.attr_Id];
                    
                    // Check for empty string value. rft
                    /**
                    if([valueData isKindOfClass:[NSNull class]]) {
                        valueData=@"0.0";
                        [chartDictionary setValue:[NSNumber numberWithDouble:0.0] forKey:reportViewAttr.attr_Id];
                    }
                    **/
                    //  Check for null C-type attribute values to avoid crash
                    if ([reportViewAttr.attr_type isEqualToString:@"C"]) {
                        if([valueData isKindOfClass:[NSNull class]])
                            valueData = @"";
                    }
                    
                    [reportViewAttr.valuesArray addObject:valueData];
                }
            }
        }
    }
    
    
    
    return reportViewArray;
}

/*!
 @function generateChartDataIntoMAKITFormat:
 @abstract -
 @discussion This method generates Charts data into Dictionaries-Array
 which is understand by MAKIT framework for every Chart which belongs to Dashboard
 @param  reportViewArray.
 @result reportViewArray.
 */
- (NSMutableArray *) generateChartDataIntoMAKITFormat:(NSMutableArray *) reportViewArray {
    
    NSLog(@"Inside generateChartDataIntoMAKITFormat method.");
    // For every chart in a Dashboard creating Dictionary for it
    for(ReportView* reportView in reportViewArray) {
        
        // Retriving attribute with sequence number 2 for its Data type
        //ReportViewAttr *reportViewAttr1=[reportView.reportViewAttrArray objectAtIndex:0];
        ReportViewAttr *reportViewAttr2=[reportView.reportViewAttrArray objectAtIndex:1];
        
        // We need chart type for creating different dictionary structure
        // For some of the exception like, Combination, Donut, Pie or Stacked Column
        NSString* chartType=[reportView.reportViewType lowercaseString];
        NSLog(@" chart type:  %@", chartType);
        
        //  Chart type 1
        // We are writing Generic algorithm to create the MAKIT data Dictionary for any Charttype
        // but for Combination chart we are writing slightly different Dictionary
        // rft
        if ([[reportView MAKitChartFunction] isEqualToString:@"DrillDown"]) {
            DLog(@"generateChartDataIntoMAKITFormat:  Inside drilldown section.");
            //  Need to build data for drilldown queries
            //
            DLog(@"CAttrCount:  %d, KAttrCount: %d, SCNID_Flag: %d, Period_Flag: %d", [reportView CAttrCount], [reportView KAttrCount], [reportView SCNIDFlag], [reportView PERIODFlag]);
            /**
            //  Identify first C-attribute pair
            ReportViewAttr *reportViewCAttr1=[reportView.reportViewAttrArray objectAtIndex:0];
            ReportViewAttr *reportViewCAttr2=[reportView.reportViewAttrArray objectAtIndex:1];
            NSString *CAttrKey1 = reportViewCAttr1.attr_Id;
            NSString *CAttrKey2 = reportViewCAttr2.attr_Id;
            
            NSLog(@"attrId1: %@, AttrId2: %@", CAttrKey1, CAttrKey2);
            NSMutableArray *tChartsDict = reportView.chartsDictionary;
            
            // Find unique occurences of first two c-type attributes in dictionary array
            NSString *tString = [NSString stringWithFormat:@"@distinctUnionOfObjects.%@", CAttrKey1];
            NSArray *C1 = [tChartsDict valueForKeyPath:tString];
            tString = [NSString stringWithFormat:@"@distinctUnionOfObjects.%@", CAttrKey2];
            NSArray *C2 = [tChartsDict valueForKeyPath:tString];

            NSLog(@"union array 1:  %@", C1);
            NSLog(@"union array 2:  %@", C2);
            
            //  Identify K-attribute of interest
            ReportViewAttr *reportViewKAttr1 = [reportView.reportViewAttrArray objectAtIndex:[reportView CAttrCount]];
            NSString *KAttr1Key = reportViewKAttr1.attr_Id;
            
            //  Loop through C1 values to creat sub-dictionaries dictionary for each value
            for (NSString *tCAttrValue1 in C1) {
                        
                for (NSString *tCAttrValue2 in C2) {
                    NSPredicate *filter = [NSPredicate predicateWithFormat:@"%K = %@ && %K = %@", CAttrKey1, tCAttrValue1, CAttrKey2, tCAttrValue2];
                    NSArray *filteredArray = [reportView.chartsDictionary filteredArrayUsingPredicate:filter];
                    NSLog(@"Filtered array: %@", filteredArray);
                    tString = [NSString stringWithFormat:@"@sum.%@", KAttr1Key];
                    NSNumber *sum = [filteredArray valueForKeyPath:tString];  //  How to identify K-type attribute?
                    NSLog(@"Sum:  %@", sum);
                    NSMutableDictionary *newDict = [NSMutableDictionary dictionary];
                    [newDict setValue:tCAttrValue1 forKey:CAttrKey1];
                    [newDict setValue:tCAttrValue2 forKey:CAttrKey2];
                    [newDict setValue:sum forKey:KAttr1Key];
                    NSLog(@"NewDict: %@", newDict);
                    [reportView.chartsDictionaryL1 addObject:newDict];
                }
            }
            // Once were done with iteration adding the same array
            // into the chartDictionary which is render by MAKIT
            NSLog(@"chartsDictionaryL1: %@", reportView.chartsDictionaryL1);
            
            //  Add 2nd level for drilldown
            if (reportView.CAttrCount >2) {
                //  Identify first C-attribute pair
                ReportViewAttr *reportViewCAttr1=[reportView.reportViewAttrArray objectAtIndex:1];
                ReportViewAttr *reportViewCAttr2=[reportView.reportViewAttrArray objectAtIndex:2];
                NSString *CAttrKey1 = reportViewCAttr1.attr_Id;
                NSString *CAttrKey2 = reportViewCAttr2.attr_Id;
                
                NSLog(@"attrId1: %@, AttrId2: %@", CAttrKey1, CAttrKey2);
                NSMutableArray *tChartsDict = reportView.chartsDictionary;
                
                // Find unique occurences of first two c-type attributes in dictionary array
                NSString *tString = [NSString stringWithFormat:@"@distinctUnionOfObjects.%@", CAttrKey1];
                NSArray *C1 = [tChartsDict valueForKeyPath:tString];
                tString = [NSString stringWithFormat:@"@distinctUnionOfObjects.%@", CAttrKey2];
                NSArray *C2 = [tChartsDict valueForKeyPath:tString];
                
                NSLog(@"union array 1:  %@", C1);
                NSLog(@"union array 2:  %@", C2);
                
                //  Identify K-attribute of interest
                ReportViewAttr *reportViewKAttr1 = [reportView.reportViewAttrArray objectAtIndex:[reportView CAttrCount]];
                NSString *KAttr1Key = reportViewKAttr1.attr_Id;
                
                //  Loop through C1 values to creat sub-dictionaries dictionary for each value
                for (NSString *tCAttrValue1 in C1) {
                    
                    for (NSString *tCAttrValue2 in C2) {
                        NSPredicate *filter = [NSPredicate predicateWithFormat:@"%K = %@ && %K = %@", CAttrKey1, tCAttrValue1, CAttrKey2, tCAttrValue2];
                        NSArray *filteredArray = [reportView.chartsDictionary filteredArrayUsingPredicate:filter];
                        NSLog(@"Filtered array: %@", filteredArray);
                        DLog(@"Prior to tString call.");
                        tString = [NSString stringWithFormat:@"@sum.%@", KAttr1Key];
                        DLog(@"tstring: %@", tString);
                        DLog(@"Calculating sum...");
                        NSNumber *sum = [filteredArray valueForKeyPath:tString];  //  How to identify K-type attribute?
                        NSLog(@"Sum:  %@", sum);
                        NSMutableDictionary *newDict = [NSMutableDictionary dictionary];
                        [newDict setValue:tCAttrValue1 forKey:CAttrKey1];
                        [newDict setValue:tCAttrValue2 forKey:CAttrKey2];
                        [newDict setValue:sum forKey:KAttr1Key];
                        NSLog(@"NewDict: %@", newDict);
                        [reportView.chartsDictionaryL2 addObject:newDict];
                    }
                }
                // Once were done with iteration adding the same array
                // into the chartDictionary which is render by MAKIT
                NSLog(@"chartsDictionaryL2: %@", reportView.chartsDictionaryL2);
            }
            
            //  Add 3rd level for drilldown
            if (reportView.CAttrCount >3) {
                //  Identify first C-attribute pair
                ReportViewAttr *reportViewCAttr1=[reportView.reportViewAttrArray objectAtIndex:2];
                ReportViewAttr *reportViewCAttr2=[reportView.reportViewAttrArray objectAtIndex:3];
                NSString *CAttrKey1 = reportViewCAttr1.attr_Id;
                NSString *CAttrKey2 = reportViewCAttr2.attr_Id;
                
                NSLog(@"attrId1: %@, AttrId2: %@", CAttrKey1, CAttrKey2);
                NSMutableArray *tChartsDict = reportView.chartsDictionary;
                
                // Find unique occurences of first two c-type attributes in dictionary array
                NSString *tString = [NSString stringWithFormat:@"@distinctUnionOfObjects.%@", CAttrKey1];
                NSArray *C1 = [tChartsDict valueForKeyPath:tString];
                tString = [NSString stringWithFormat:@"@distinctUnionOfObjects.%@", CAttrKey2];
                NSArray *C2 = [tChartsDict valueForKeyPath:tString];
                
                NSLog(@"union array 1:  %@", C1);
                NSLog(@"union array 2:  %@", C2);
                
                //  Identify K-attribute of interest
                ReportViewAttr *reportViewKAttr1 = [reportView.reportViewAttrArray objectAtIndex:[reportView CAttrCount]];
                NSString *KAttr1Key = reportViewKAttr1.attr_Id;
                
                //  Loop through C1 values to creat sub-dictionaries dictionary for each value
                for (NSString *tCAttrValue1 in C1) {
                    
                    for (NSString *tCAttrValue2 in C2) {
                        NSPredicate *filter = [NSPredicate predicateWithFormat:@"%K = %@ && %K = %@", CAttrKey1, tCAttrValue1, CAttrKey2, tCAttrValue2];
                        NSArray *filteredArray = [reportView.chartsDictionary filteredArrayUsingPredicate:filter];
                        NSLog(@"Filtered array: %@", filteredArray);
                        tString = [NSString stringWithFormat:@"@sum.%@", KAttr1Key];
                        NSNumber *sum = [filteredArray valueForKeyPath:tString];  //  How to identify K-type attribute?
                        NSLog(@"Sum:  %@", sum);
                        NSMutableDictionary *newDict = [NSMutableDictionary dictionary];
                        [newDict setValue:tCAttrValue1 forKey:CAttrKey1];
                        [newDict setValue:tCAttrValue2 forKey:CAttrKey2];
                        [newDict setValue:sum forKey:KAttr1Key];
                        NSLog(@"NewDict: %@", newDict);
                        [reportView.chartsDictionaryL3 addObject:newDict];
                    }
                }
                // Once were done with iteration adding the same array
                // into the chartDictionary which is render by MAKIT
                NSLog(@"chartsDictionaryL3: %@", reportView.chartsDictionaryL3);
            }
            **/
        }  // End drilldown section
        
        else if((![chartType isEqualToString:@"combination"] && ![chartType isEqualToString:@"table"] &&
            ![reportViewAttr2.attr_type isEqualToString:@"C"]) ||
           [chartType isEqualToString:@"donut"] ||
           [chartType isEqualToString:@"pie"]) {
            
            DLog(@"generateChartDataIntoMAKITFormat:  chart type 1");
            
            // Pie, Donut, Line, Column, Bar get there dictionary here
            // (Line, Column, Bar with Attr-2 has type K-Number)
            
            // Array to represent points to draw on chart
            NSMutableArray* generatedChartArray=[[NSMutableArray alloc] init];
            
            // Always Catergory attributes- represents X-Axis
            ReportViewAttr *reportViewAttr1=[reportView.reportViewAttrArray objectAtIndex:0];
            
            // In previous method we got all the values in Column Attr array
            // We are iterating through it so to create those many dictionaries
            for(int i=0; i<[reportViewAttr1.valuesArray count]; i++) {
                
                
                // Rest other are values except attr-2 with datatype C(its represent Series)
                for(ReportViewAttr *reportViewAttr in reportView.reportViewAttrArray) {
                    // Loop iteration so Applying values only with the
                    // data type K- Number
                    if([reportViewAttr.attr_type isEqualToString:@"K"]) {
                        
                        // Attribute 1- Category X axis
                        NSString* periodValue=[reportViewAttr1.valuesArray objectAtIndex:i];
                        // Other Attribute K are values
                        NSString* value = [reportViewAttr.valuesArray objectAtIndex:i];
                        
                        // Rest other are values which are handle by
                        // keykey and valuekey reference respectively
                        NSNumber *numberValue = [[NSNumber alloc] init];
                        NSMutableDictionary* dict=[NSMutableDictionary dictionary];
                        
                        if (![value isKindOfClass:[NSNull class]] || i == 0) {
                            if ([value isKindOfClass:[NSNull class]])
                                value = @"0.0";
                            numberValue=[NSNumber numberWithDouble:[value doubleValue]];
                            [dict setValue:periodValue forKey:reportViewAttr1.attr_Id];
                            [dict setValue:reportViewAttr.attr_name forKey:@"keyKey"];
                            [dict setValue:numberValue forKey:@"valueKey"];
                            // Adding dictionary into MD-Query Array
                            [generatedChartArray addObject:dict];
                        } else {
                            
                            // Do not add null values to chart data
 
                        }
                        
                    }
                }  
            }
            // Sort reverse alphabetically by category to match web interface
            //  Define primary and secondary sort keys
            if ([chartType isEqualToString:@"horizontal bar"] && [reportView PERIODFlag] ==0) {
                NSMutableArray *sortCriteria = [[NSMutableArray alloc] init];
                [sortCriteria addObject:reportViewAttr1.attr_Id];
                
                NSArray *sortedChartArray = [self sortDictInAlphabeticalOrder:generatedChartArray criteriaArray:sortCriteria];
                
                // Once we done with iteration adding the same array
                // into the chartDictionary which is render by MAKIT
                [reportView.chartsDictionary removeAllObjects];
                [reportView.chartsDictionary addObjectsFromArray:sortedChartArray];
                
                generatedChartArray=nil;
                sortedChartArray = nil;
            } else {
                // Once we done with iteration adding the same array
                // into the chartDictionary which is render by MAKIT
                [reportView.chartsDictionary removeAllObjects];
                [reportView.chartsDictionary addObjectsFromArray:generatedChartArray];
                
                generatedChartArray=nil;
            }
            /**
            NSLog(@"generatedChartArray: %@", reportView.chartsDictionary);
            for (ReportViewAttr *tReportViewAttr in reportView.reportViewAttrArray) {
                NSLog(@"attr name: %@, sequence: %@", tReportViewAttr.attr_name, tReportViewAttr.sequence);
            }
             **/
        }
        //  rft
        else if ([chartType isEqualToString:@"table"]) {
            // Chart type 2
            // For table we need to format numeric values.  ('K' type attributes)
            
            DLog(@"generateChartDataIntoMAKITFormat:  chart type 2");
            
            // Setup numberFormatter object
            NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
            [numberFormatter setUsesGroupingSeparator:YES];
            [numberFormatter setGroupingSeparator:@","];
            [numberFormatter setGroupingSize:3];
            
            //int rowCount = [reportView.chartsDictionary count];
            ReportViewAttr *treportViewAttr = [reportView.reportViewAttrArray objectAtIndex:0];
            int rowCount = [treportViewAttr.valuesArray count];
            
            //int columnCount = [(NSDictionary *) [reportView.chartsDictionary objectAtIndex:0] count];
            int columnCount = [reportView.reportViewAttrArray count];
            
            NSLog(@"rows: %d, columns: %d", rowCount, columnCount);
            
            NSMutableArray* generatedChartArray=[[NSMutableArray alloc] init];
            
            ReportViewAttr *tReportViewAttrArray = [[ReportViewAttr alloc] init];
            NSString *tValue = [[NSString alloc] init];
            
            //  Loop through rows - dictionaries
            for (int i=0; i<rowCount; i++) {
                //treportViewAttr = [reportView.reportViewAttrArray objectAtIndex:i];
                NSMutableDictionary *tDict = [NSMutableDictionary dictionary];
                [tDict setValue:[NSNumber numberWithInt:(i+1)] forKey:@"Index"];
                //  Loop through columns - attributes
                for (int j=0; j<columnCount; j++) {
                    tReportViewAttrArray = [reportView.reportViewAttrArray objectAtIndex:j];
                    tValue = [tReportViewAttrArray.valuesArray objectAtIndex:i];
                    NSLog(@"attr_id: %@, value: %@", tReportViewAttrArray.attr_Id, tValue);
                    
                    //  If value is numeric (type "K") then format, else don't bother
                    // First check for nulls
                    if ([tValue isKindOfClass:[NSNull class]]) {
                        [tDict setValue:@" " forKey:tReportViewAttrArray.attr_Id];
                    } else {
                        if([tReportViewAttrArray.attr_type isEqualToString:@"K"]) {
                            [tDict setValue:[numberFormatter numberFromString:tValue] forKey:tReportViewAttrArray.attr_Id];
                        
                        } else {
                            [tDict setValue:tValue forKey:tReportViewAttrArray.attr_Id];
                        }
                    }
                }
                [generatedChartArray addObject:tDict];
                
            }
            // Once were done with iteration adding the same array
            // into the chartDictionary which is render by MAKIT
            [reportView.chartsDictionary removeAllObjects];
            [reportView.chartsDictionary addObjectsFromArray:generatedChartArray];
            NSLog(@"new chartsDictionary: %@", reportView.chartsDictionary);
            generatedChartArray=nil;
        }
        // Chart type 3
        //  Two 'C'haracteristics with at least one being of type SCNID
        //  rft
        else if ([reportView CAttrCount] > 1 && [reportView SCNIDFlag] > 0) {
            DLog(@"generateChartDataIntoMAKITFormat:  chart type 3");
            NSLog(@"Inside SCNID type check.");
            
            NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
            [numberFormatter setUsesGroupingSeparator:YES];
            [numberFormatter setGroupingSeparator:@","];
            [numberFormatter setGroupingSize:3];
            
            //  Two ways to determine hierarchy of 'C'ategories:
            // 1 - SCNID is always top
            //  2- Determined by sequence number - first C is top
            //  Limit to two categories
            //  Must merge 2nd C with KFs
            //NSMutableDictionary *tDict = [NSMutableDictionary dictionary];
            
            ReportViewAttr *treportViewAttr = [reportView.reportViewAttrArray objectAtIndex:0];
            int rowCount = [treportViewAttr.valuesArray count];
            
            //int columnCount = [(NSDictionary *) [reportView.chartsDictionary objectAtIndex:0] count];
            int columnCount = [reportView.reportViewAttrArray count];
            
            NSLog(@"rows: %d, columns: %d", rowCount, columnCount);
            
            NSMutableArray* generatedChartArray=[[NSMutableArray alloc] init];
            
            ReportViewAttr *kReportViewAttrArray = [[ReportViewAttr alloc] init];
            NSString *kValue = [[NSString alloc] init];
            NSString *tScenarioName = [[NSString alloc] init];
            
            
            // Loop through rows - descending through valuesArray
            for (int i=0; i<rowCount; i++) {
                
                //  Loop through attributes - through reportViewAttrArrays
                for (int j=0; j<columnCount; j++) {
                    kReportViewAttrArray = [reportView.reportViewAttrArray objectAtIndex:j];
                    
                    if([kReportViewAttrArray.attr_type isEqualToString:@"K"]) {
                        NSMutableDictionary *tDict = [NSMutableDictionary dictionary];
                        //  Loop through C-type attributes
                        for (int c=0; c<[reportView CAttrCount]; c++) {
                            //add all c attr to dict, not SCID
                            //if ([kReportViewAttrArray.attr_Id isEqualToString:@"SCNID"]) {
                                //continue;
                            //}
                            ReportViewAttr *cReportViewAttrArray = [reportView.reportViewAttrArray objectAtIndex:c];
                            NSString *Cvalue = [cReportViewAttrArray.valuesArray objectAtIndex:i];
                            NSString *Cattr_Id = cReportViewAttrArray.attr_Id;
                            [tDict setValue:Cvalue forKey:Cattr_Id];
                        }
                        //  Add k attr to dict
                        kValue = [kReportViewAttrArray.valuesArray objectAtIndex:i];
                        
                        
                        NSNumber* numberValue=[NSNumber numberWithDouble:[kValue doubleValue]];
                        //[tDict setValue:[numberFormatter numberFromString:kValue] forKey:kReportViewAttrArray.attr_Id];
                        [tDict setValue:[NSString stringWithFormat:@"%@-%@", kReportViewAttrArray.attr_name, tScenarioName] forKey:@"keyKey"];
                        //[tDict setValue:kReportViewAttrArray.attr_name forKey:@"keyKey"];
                        [tDict setValue:numberValue forKey:@"valueKey"];
                        [generatedChartArray addObject:tDict];
                    } else if ([kReportViewAttrArray.attr_Id isEqualToString:@"SCNID"])
                        tScenarioName = [kReportViewAttrArray.valuesArray objectAtIndex:i];
  
                }
            
                NSLog(@"generatedChartArray: %@", generatedChartArray);
                
            }
            //  Order the dictionary
            // First sort by first C-type
            //  Next sort by keyKey
            //NSArray *sortedChartArray = [self sortDictInAlphabeticalOrder:generatedChartArray];
            //NSMutableArray *sortedChartArrayM = [[NSMutableArray alloc] init];
            //[sortedChartArrayM addObjectsFromArray:sortedChartArray];
            //NSMutableArray *uniqueCharValues1 = [[NSMutableArray alloc] init];
            ReportViewAttr *tReportViewAttr0 = [reportView.reportViewAttrArray objectAtIndex:0];
            //ReportViewAttr *tReportViewAttr1 = [reportView.reportViewAttrArray objectAtIndex:1];
            
            //  Define primary and secondary sort keys
            NSMutableArray *sortCriteria = [[NSMutableArray alloc] init];
            //[sortCriteria addObject:tReportViewAttr0.attr_Id];
            [sortCriteria addObject:@"keyKey"];
            
            NSArray *sortedChartArray = [self sortDictInAlphabeticalOrder:generatedChartArray criteriaArray:sortCriteria];
            
            [sortCriteria removeAllObjects];
            [sortCriteria addObject:tReportViewAttr0.attr_Id];
            NSMutableArray *sortedChartArrayM = [[NSMutableArray alloc] init];
            [sortedChartArrayM addObjectsFromArray:sortedChartArray];
            
            NSArray *sortedChartArray2 = [self sortDictInReverseAlphabeticalOrder:sortedChartArrayM criteriaArray:sortCriteria];
            
            NSLog(@"sortedArray:  %@", sortedChartArray2);
            
            // Once we done with iteration adding the same array
            // into the chartDictionary which is render by MAKIT
            [reportView.chartsDictionary removeAllObjects];
            [reportView.chartsDictionary addObjectsFromArray:sortedChartArray2];
            generatedChartArray=nil;
            
        }
        // Chart type 4
        // If Chart is Combination chart OR
        // If Chart is Line, Bar, Column and their second attribute is 'C'haracter (Sequence)
        else {
            DLog(@"generateChartDataIntoMAKITFormat:  chart type 4");
            // If Attributes count is less than or equal to 3
            // then we have Category, Series and only 1 value
            
            if([reportView.reportViewAttrArray count] >3) {
                
                // Array to represent, points to draw on chart
                NSMutableArray* generatedChartArray=[[NSMutableArray alloc] init];
                
                // Always Catergory attributes- represents X-Axies
                ReportViewAttr *reportViewAttr01=[reportView.reportViewAttrArray objectAtIndex:0];
                
                // As Attr-2 is C or its combination chart, represents Y-Axies as Series
                ReportViewAttr *reportViewAttr02=[reportView.reportViewAttrArray objectAtIndex:1];
                
                // As we have more than 3 attrbute all will be K-Number
                // Here we will iterate with all the values
                for(int i=0; i<[reportViewAttr01.valuesArray count]; i++) {
                    
                    for(ReportViewAttr *reportViewAttr in reportView.reportViewAttrArray) {
                        // Checking if it is K or not
                        if([reportViewAttr.attr_type isEqualToString:@"K"] && reportViewAttr!=reportViewAttr02) {
                            
                            // Attr 1 X axis
                            NSString* periodValue=[reportViewAttr01.valuesArray objectAtIndex:i];
                            // Attr 2 Series Y axis, we can say layer for combination chart
                            NSString* layer1Value=[reportViewAttr02.valuesArray objectAtIndex:i];
                            // Attr 3 K Values
                            NSString* value = [reportViewAttr.valuesArray objectAtIndex:i];
                            NSNumber* numberValue=[[NSNumber alloc] init];
                            NSMutableDictionary* dict=[NSMutableDictionary dictionary];
                            
                            
                            if (![value isKindOfClass:[NSNull class]] || i ==0) {
                                if ([value isKindOfClass:[NSNull class]])
                                    value = @"0.0";
                                numberValue=[NSNumber numberWithDouble:[value doubleValue]];
                                [dict setValue:periodValue forKey:reportViewAttr01.attr_Id];
                                [dict setValue:[NSNumber numberWithDouble:[layer1Value doubleValue]] forKey:reportViewAttr02.attr_Id];
                                [dict setValue:reportViewAttr.attr_name forKey:@"keyKey"];
                                [dict setValue:numberValue forKey:@"valueKey"];
                                // Adding dictionary into MD-Query Array
                                [generatedChartArray addObject:dict];
                            } else {
                                
                                    
                                // Do not add null values to chart data
                                //numberValue = ;
                                //[dict setValue:periodValue forKey:reportViewAttr1.attr_Id];
                                //[dict setValue:reportViewAttr.attr_name forKey:@"keyKey"];
                                //[dict setValue:numberValue forKey:@"valueKey"];
                            }

                        }
                    }
                }
                
                // Sort reverse alphabetically by category to match web interface
                //  Define primary and secondary sort keys
                if ([chartType isEqualToString:@"horizontal bar"] && [reportView PERIODFlag] ==0) {
                    NSMutableArray *sortCriteria = [[NSMutableArray alloc] init];
                    [sortCriteria addObject:reportViewAttr01.attr_Id];
                    
                    NSArray *sortedChartArray = [self sortDictInAlphabeticalOrder:generatedChartArray criteriaArray:sortCriteria];
                    
                    // Once we done with iteration adding the same array
                    // into the chartDictionary which is render by MAKIT
                    [reportView.chartsDictionary removeAllObjects];
                    [reportView.chartsDictionary addObjectsFromArray:sortedChartArray];
                    
                    generatedChartArray=nil;
                    sortedChartArray = nil;
                } else {
                    // Once we done with iteration adding the same array
                    // into the chartDictionary which is render by MAKIT
                    [reportView.chartsDictionary removeAllObjects];
                    [reportView.chartsDictionary addObjectsFromArray:generatedChartArray];
                    
                    generatedChartArray=nil;
                }

                // Once we done with iteration adding the same array
                // into the chartDictionary which is render by MAKIT
                //[reportView.chartsDictionary removeAllObjects];
                //[reportView.chartsDictionary addObjectsFromArray:generatedChartArray];
                //generatedChartArray=nil;
            
            }
            // If Attributes count more than 3
            // then we can reused Dictionary sent by the OData service as it is
            // Just one more exception, string which holds value number
            // We must convert their data type to Number because all the datatype
            // in JSON service response are strings
            else {
            
                // For all the dictionaries
                for(NSDictionary *dictionary in reportView.chartsDictionary) {
                    // Get their all keys
                    for(NSString* string in [dictionary allKeys]) {
                        
                        // Check class type
                        if([[dictionary valueForKey:string] isKindOfClass:[NSString class]]) {
                            if([[dictionary valueForKey:string] doubleValue]) {
                                
                                // Convert string value with number data into NSNumber
                                NSNumber* numberValue=[NSNumber numberWithFloat:[[dictionary valueForKey:string] doubleValue]];
                                [dictionary setValue:numberValue forKey:string];
                            }
                        } else {
                            //  Assuming this means a null value for K type attribute
                            NSString *tvalue = @"0.0";
                            NSNumber* numberValue=[NSNumber numberWithFloat:[tvalue doubleValue]];
                            [dictionary setValue:numberValue forKey:string];

                        }
                    }
                }
            }
        
        }  //  End of chart type 4
    }  // end of loop through charts
    
    NSLog(@"Exiting generateChartDataIntoMAKITFormat.");
    // returning the processed ReportView Array
    return reportViewArray;
}

/*!
 @function getListOfReportPageLayoutForReportPage:
 @abstract -
 @discussion To show charts in a Dashboard, we need its Layout information,
 We are gating that from Data _reportPageLayoutArray
 @param  reportPage
 @result chartsInLayoutArray
 */
- (NSMutableArray *)getListOfReportPageLayoutForReportPage:(ReportPage *)reportPage {
    
    NSMutableArray* chartsInLayoutArray=[[NSMutableArray alloc] init];
    
    for(ReportPageLayout* reportPageLayout in _reportPageLayoutArray) {
        
        // Get list of layouts for selected ReportPage (Dashboard)
        if([reportPageLayout.reportPageId isEqualToString:reportPage.reportPageId]) {
            [chartsInLayoutArray addObject:reportPageLayout];
        }
    }
    
    return chartsInLayoutArray;
}

/*!
 @function getListOFJSONDataForCharts:
 @abstract -
 @discussion This method is used to get Attributes which are belongs to
 list of ReportViews (Charts), as we have list of layout info for
 selected Dashboard
 @param  pageLayoutArray
 @result chartsDataArray.
 */
- (NSMutableArray *)getListOFJSONDataForCharts:(NSMutableArray *)pageLayoutArray {
    
    NSMutableArray* chartsDataArray = [[NSMutableArray alloc] init];
    
    // For every Layout, we exporting its chart details, and data
    for(ReportPageLayout* reportPageLayout in pageLayoutArray) {
        
        ReportView* reportView = [self getReportView:reportPageLayout];
        if(reportView) {
            // If attribute array and Created Charts Dictionary are null then only
            // we request for JSON data and filtering attributes by sequence
            if(![reportView.reportViewAttrArray count] &&
               !reportView.chartsDictionary) {
                
                // Get the json data for chart
                NSError* error=nil;
                reportView.chartsDictionary = (NSMutableArray *)[self getReportJsonSyncFromDataControllerWithReportview:reportView.reportViewId andReturnError:&error];
                DLog(@"Error for JSON Data- %@",[error description]);
                
                reportView.reportViewAttrArray = [[NSMutableArray alloc] init];
                
                // Get the list of Attributes which belongs to ReportView (Chart)
                for (ReportViewAttr* reportViewAttr in _reportViewsAttrArray) {
                    
                    if([reportViewAttr.reportViewId isEqualToString:reportView.reportViewId]) {
                        [reportView.reportViewAttrArray addObject:reportViewAttr];
                    }
                }
                NSArray* attrArray=[NSMutableArray arrayWithArray:reportView.reportViewAttrArray];
                [reportView.reportViewAttrArray removeAllObjects];
                // Get sorted by Sequence
                [reportView.reportViewAttrArray addObjectsFromArray:[self sortInAscendingOrderReportViewAttr:attrArray]];

                
                // For Combination chart if we are getting 4 attributes and 2nd Attribute is Character
                // then we have to remove it from Attributes array becuase Combination chart has 2 layers
                // layer 1 is Column chart and layer 2 is Line chart
                // According to MAKIT, we need to pass 1 value to Column chart and rest other to Line
                // chart if sequence 2nd is Char, we have to skip it draw the Combination chart which
                // match with Website
                if([reportView.reportViewAttrArray count]==4) {
                    
                    if([[[reportView.reportViewAttrArray objectAtIndex:1] attr_type] isEqualToString:@"C"] &&
                       [[reportView.reportViewType lowercaseString] isEqualToString:@"combination"]) {
                        [reportView.reportViewAttrArray removeObject:[reportView.reportViewAttrArray objectAtIndex:1]];
                        
                    }
                }
            }
            //  Set timestamp
            reportView.timeStamp = [NSDate date];
            
            // Adding processed or already processed ReportView into the ChartsDataArray
            [chartsDataArray addObject:reportView];
            [reportView initAdditionalParams];
        }
    }
    return chartsDataArray;
}

#pragma mark- MetaData_Generator Chart DataSource

/*!
 @function loadSelectedChart:
 @abstract -
 @discussion This method is used to generated MetaData xml and Dictionary
 for MAKit framework on the selection of Chart
 @param  reportPage.
 @result nil.
 */
- (void)loadSelectedChart:(ReportView *)reportView {
    
    NSError *returnError = nil;
    
    reportView.chartsDictionary = (NSMutableArray *) [self getReportJsonSyncFromDataControllerWithReportview:reportView.reportViewId andReturnError:&returnError];
    
    // Get the list of Attributes which belongs to ReportView (Chart)
    reportView.reportViewAttrArray = [[NSMutableArray alloc] init];
    
    for (ReportViewAttr* reportViewAttr in _reportViewsAttrArray) {
        
        if([reportViewAttr.reportViewId isEqualToString:reportView.reportViewId]) {
            [reportView.reportViewAttrArray addObject:reportViewAttr];
        }
    }
    NSArray* attrArray=[NSMutableArray arrayWithArray:reportView.reportViewAttrArray];
    [reportView.reportViewAttrArray removeAllObjects];
    // Get sorted by Sequence
    [reportView.reportViewAttrArray addObjectsFromArray:[self sortInAscendingOrderReportViewAttr:attrArray]];
    
    NSMutableArray *reportviewsArray = [[NSMutableArray alloc] initWithObjects:reportView, nil];
    [self assignValuesToTheReportViewAttributes: reportviewsArray];
    
    timeStamp = [NSDate date];
    
}

/*!
 @function loadMDGeneratorWithData:
 @abstract This method is loads data from OData service control
 @discussion Method to generated Service Data into the MAKIT understandable
 format like having MetaData.xml, Charts Query Dictionary etc
 @param  nil.
 @result nil.
 */
- (void) loadMDGeneratorWithData {
    
    // Get list of ReportViews (Chart) with their JSON Data (Chart Data) which belongs to
    // selected Dashboard
    //NSMutableArray* chartDataArray = [self getListOFJSONDataForCharts:_mdGenerator.reportPageLayoutArray];
    
    // Here we are stored values belongs to each chart into there indivisual Attributes value array
    //NSMutableArray* valueAssignArray = [self assignValuesToTheReportViewAttributes: chartDataArray];
    
    // Here we generate ReportViews data into the format of MAKIT understandable Dictionaries
    //_mdGenerator.chartDataArray=[self generateChartDataIntoMAKITFormat:valueAssignArray];
    
    // This method generates Meta Data xml which render layouts for Dashboard and Charts
    //[_mdGenerator generateMetaDataXML];
    
}

/*!
 @function getListOfReportPageLayoutForReportView:
 @abstract -
 @discussion To show charts in a Dashboard, we need its Layout information,
 We are gating that from Data _reportPageLayoutArray
 @param  reportView.
 @result chartsInLayoutArray.
 */
- (NSMutableArray *)getListOfReportPageLayoutForReportView:(ReportView *)reportView {
    
    NSMutableArray* chartsInLayoutArray=[[NSMutableArray alloc] init];
    
    // Get the exact match, We are putting first match only,
    // becuase this method get calls for showing single chart
    for(ReportPageLayout* reportPageLayout in _reportPageLayoutArray) {
        
        if([reportPageLayout.reportViewId isEqualToString:reportView.reportViewId]) {
            // We need only one page layout in case of chart
            [chartsInLayoutArray addObject:reportPageLayout];
            break;
        }
    }
    
    return chartsInLayoutArray;
}

/*!
 @function getReportView
 @abstract -
 @discussion This method get the ReportView which belongs to prefer PageLayout.
 @param  nil.
 @result nil.
 */
- (ReportView *)getReportView:(ReportPageLayout *)reportPageLayout {
    
    ReportView* matchReportView=nil;
    for(ReportView* reportView in _reportViewsArray) {
        
        if([reportView.reportViewId isEqualToString:reportPageLayout.reportViewId]) {
            matchReportView = reportView;
            break;
        }
    }
    return matchReportView;
}

/*!
 @function sortInAscendingOrderReportViewAttr:
 @abstract -
 @discussion This method is used to sort array in Ascending order.
 @param  arg_array - Main ReportViewAttr Array.
 @result nil.
 */
- (NSArray *)sortInAscendingOrderReportViewAttr:(NSArray *)arg_array{
    // Sorting Attribute array with respective their sequence in a Chart
    NSArray *sortedArray = [arg_array sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        NSNumber *first = [(ReportViewAttr*)a sequence];
        NSNumber *second = [(ReportViewAttr*)b sequence];

        return [first compare:second];
    }];
    return sortedArray;
}

#pragma mark- Sqlite Database Manager

/*!
 @function insertAllDataModelsInSqliteDatabase
 @abstract
 @discussion This method is used to save model information in database like
 Report, ReportPage, ReportView, ReportViewAttr and ReportPageLayout.
 @result nil.
 */
-(void)insertAllDataModelsInSqliteDatabase {
    
    if([_reportsArray count]) {
        DBManager* database = [[DBManager alloc] init];
        
        [database setupDatabase];
        
        [database insertReports:_reportsArray];
        [database insertReportPages:_reportPagesArray];
        [database insertReportPageLayouts:_reportPageLayoutArray];
        [database insertReportViews:_reportViewsArray];
        [database insertReportViewAttributes:_reportViewsArray];
    }
}

/*!
 @function loadsAllDataModelsFromSqliteDatabase
 @abstract
 @discussion This method is used to load model information in Data Controller like
 Report, ReportPage, ReportView, ReportViewAttr and ReportPageLayout.
 @result nil.
 */
-(void)loadsAllDataModelsFromSqliteDatabase {
    
    DBManager* database = [[DBManager alloc] init];
    
    [database setupDatabase];
    
    // Alloc the reportsArray for adding Reports data.
    _reportsArray = [[NSMutableArray alloc] init];
    // Alloc the reportPageArray for adding ReportPages data.
    _reportPagesArray = [[NSMutableArray alloc] init];
    // Alloc the reportpage layout for adding ReportPagesLayout data.
    _reportPageLayoutArray = [[NSMutableArray alloc] init];
    // Alloc the reportViewsArray for adding ReportViews data.
    _reportViewsArray = [[NSMutableArray alloc] init];
    // Alloc the reportview Attribute Array for adding Report Views Attribute data.
    _reportViewsAttrArray = [[NSMutableArray alloc] init];
    
    
    [_reportsArray addObjectsFromArray:[database getReportList]];
    [_reportPagesArray addObjectsFromArray:[database getReportPageList]];
    [_reportPageLayoutArray addObjectsFromArray:[database getReportPageLayoutList]];
    [_reportViewsArray addObjectsFromArray:[database getReportViewsList]];
    [_reportViewsAttrArray addObjectsFromArray:[database getReportviewAttributeList]];
    
    for(ReportView* reportView in _reportViewsArray) {
        reportView.reportViewAttrArray = [[NSMutableArray alloc] init];
        
        // Get the list of Attributes which belongs to ReportView (Chart)
        for (ReportViewAttr* reportViewAttr in _reportViewsAttrArray) {
            
            if([reportViewAttr.reportViewId isEqualToString:reportView.reportViewId]) {
                [reportView.reportViewAttrArray addObject:reportViewAttr];
            }
        }
        NSArray* attrArray=[NSMutableArray arrayWithArray:reportView.reportViewAttrArray];
        [reportView.reportViewAttrArray removeAllObjects];
        // Get sorted by Sequence
        [reportView.reportViewAttrArray addObjectsFromArray:[self sortInAscendingOrderReportViewAttr:attrArray]];
        
    }
    
    // default Report in offline case is always first Report in the list
    self.defaultReport = [_reportsArray objectAtIndex:0];
    
    // Load All Chart dictionary in ReportView
    for(ReportView *reportView in _reportViewsArray) {
        
        reportView.chartsDictionary = [[NSMutableArray alloc] init];
        
        if([reportView.reportViewAttrArray count]) {
        for(int i=0; i < [[(ReportViewAttr *)[reportView.reportViewAttrArray objectAtIndex:0] valuesArray] count]; i++) {
            
            NSMutableDictionary* dictionary = [NSMutableDictionary dictionary];
            
            for(ReportViewAttr* reportViewAttr in reportView.reportViewAttrArray) {
                
                if([reportViewAttr.valuesArray count])
                [dictionary setValue:[reportViewAttr.valuesArray objectAtIndex:i] forKey:reportViewAttr.attr_Id];
               
                    
            }
            
            [reportView.chartsDictionary addObject:dictionary];
        }
        }
    }
    
}


@end
