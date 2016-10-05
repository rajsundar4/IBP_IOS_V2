//
//  Global.h
//  S&OP
//
//  Created by Mayur Birari on 16/07/13.
//  Copyright (c) 2013 Linear Logics Corp.. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - Global Macros

#define kDATE_FORMAT @"MM/dd/yyyy"

//Constants for the Left Menu View
#define ANALYTICS_TABLEVIEW_FRAME_PORTRAIT                 CGRectMake(1, 118, 332, 884)
#define ANALYTICS_TABLEVIEW_FRAME_LANDSCAPE               CGRectMake(1, 118, 332, 628)

#define FOOTER_IMAGE_VIEW_PORTRAIT                                    CGRectMake(0, 889, 337, 115)
#define FOOTER_IMAGE_VIEW_LANDSCAPE                                  CGRectMake(0, 633, 337, 115)

//#define LOG_OFF_VIEW_LANDSCAPE                                               CGRectMake(802, 61, 172, 60)
#define LOG_OFF_VIEW_LANDSCAPE                                               CGRectMake(780, 51, 220, 80)
#define LOG_OFF_VIEW_PORTRAIT                                                  CGRectMake(547, 58, 172, 60)

#define GOT_IT_BUTTON_PORTRAIT                                                 CGRectMake(470, 900, 274, 79)
#define GOT_IT_BUTTON_LANDSCAPE                                                 CGRectMake(738, 655, 274, 79)


#ifdef DEBUG
#   define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define DLog(...)
#endif

// ALog always displays output regardless of the DEBUG setting
#define ALog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);

#pragma mark - MDGenerator


#define kMetaDataDashboardFileName [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingString:@"/Dashboard_ChartTypes.xml"]



#pragma mark - Enums

typedef enum ConnectionTypeForSettingView_ {
    
    DefaultDashboardButton = 1001,
    DirectConnectToSAOPButton,
    
    DefaultDashboardView = 2001,
    DirectConnectToSAOPView,
    
} ConnectionTypeForSettingView;

/// Used to check dashboard is Default or Direct
ConnectionTypeForSettingView connectionType;

typedef enum DashboardTextField_ {

    DefaultDashboardServerUrlTF = 101,
    DefaultDashboardUsernameTF,
    DefaultDashboardPasswordTF,

    DirectDashboardConnectionNameTF = 201,
    DirectDashboardServerUrlTF,
    DirectDashboardUsernameTF,
    DirectDashboardPasswordTF,
    
} DashboardTextField;

typedef enum DashboardOrCharts_ {
    
    Dashboard = 118,
    Charts,
    
} DashboardOrCharts;

typedef enum ErrorTags_ {
    
    LoginFailed = 121,
    InsufficientData,
    InvalidServerUrl,
    InvalidSession,
    SessionTimeout,
    LogoutFailed,
    NotFound,
    
} ErrorTags;

// Used for checking NSString in Switch case.
#define CASE(str)                       if ([__s__ isEqualToString:(str)])
#define SWITCH(s)                       for (NSString *__s__ = (s); ; )
#define DEFAULT

// Variable declaration for Database manager

#define kSQLITEDB_FILENAME @"SAOPData.sqlite"
#define kDOCUMENTDIRECTORY_PATH [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]

/*!
 \internal
 @class Global
 @abstract This class holds global instance
 @discussion Global will represent genral enum, constants, macros, DLogs etc
 */
@interface Global : NSObject

/*!
 \internal
 @function displayAlertMessage.
 @abstract This is the static method which shows alert with custom title, message and buttons.
 @discussion
 @param arg_Title - set the alert title.
 @param arg_Message - set the alert description message.
 @param arg_CancelString - set the cancel button title string.
 @param arg_OtherButtons - set the optional buttons title.
 @param arg_Delegate - set alertViewDelegate in object class.
 @param arg_Tag - custom tag value if in case want to show multiple alert.
 */
+ (void)displayAlertTitle: (NSString *)arg_Title
         withAlertMessage: (NSString *)arg_Message
         withCancelButton: (NSString *)arg_CancelString
         withOtherButtons: (NSArray *)arg_OtherButtons
          withForDelegate: (id)arg_Delegate
                  withTag: (NSInteger)arg_Tag;

/*!
 \internal
 @function showProgessindicator.
 @abstract Used to show the Progress Activity Indicator.
 @discussion
 @param arg_View - The view, which we want to show the Indicator.
 @result
 */
+ (void)showProgessindicator:(UIView *)arg_View;

/*!
 \internal
 @function hideProgessIndicator.
 @abstract Used to hide the Activity indicator.
 @discussion
 @param nil.
 @result nil.
 */
+ (void)hideProgessIndicator;

/*!
 \internal
 @function isNetworkReachable.
 @abstract Check the internet reachabilty.
 @discussion
 @param
 @result isReachable YES if network is available else NO.
 */
+ (BOOL) isNetworkReachable;

/*!
 \internal
 @function displayNoNetworkAlert.
 @abstract shows alert specifying network not present.
 @discussion
 @param
 @result
 */
+ (void) displayNoNetworkAlert;

/*!
 \internal
 @method setChartTypeImage:
 @abstract
 @discussion This method used to get UIImage for perticular ReportView type, we written global method for it because we are skiping imageName: method called.
 @param arg_imagename - Image name
 @result UIImage - Return the image object.
 */
+ (UIImage *)setImage:(NSString *)arg_imagename;

@end
