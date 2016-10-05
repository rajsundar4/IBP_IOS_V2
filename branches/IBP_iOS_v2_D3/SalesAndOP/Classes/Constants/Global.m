//
//  Global.m
//  S&OP
//
//  Created by Mayur Birari on 16/07/13.
//  Copyright (c) 2013 Linear Logics Corp.. All rights reserved.
//

#import "Global.h"
#import "ProgressHUD.h"
#import "Reachability.h"

/*!
 @class Global
 @abstract This class holds global instance
 @discussion Global will represent genral enum, constants, macros, DLogs etc
 */
@implementation Global

/*!
 @function displayAlertMessage.
 @abstract This is the static method which returns YES if email is valid else
        returns NO.
 @discussion
 @param arg_Title - alert title message.
        arg_Message - alert message description.
        arg_CancelString - cancel button title text.
        arg_OtherButtons - other button title text.
        arg_Delegate - whos delegate.
        arg_Tag - alert view tag.
 result - nil.
 */
+ (void)displayAlertTitle: (NSString *)arg_Title
         withAlertMessage: (NSString *)arg_Message
         withCancelButton: (NSString *)arg_CancelString
         withOtherButtons: (NSArray *)arg_OtherButtons
          withForDelegate: (id)arg_Delegate
          withTag: (NSInteger)arg_Tag{
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle: arg_Title
                                                   message: arg_Message
                                                  delegate: arg_Delegate
                                         cancelButtonTitle: arg_CancelString
                                         otherButtonTitles: nil];
    
    for (NSString *buttonTitle in arg_OtherButtons)
        [alert addButtonWithTitle:buttonTitle];
    
    [alert setTag:arg_Tag];
    [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
}

/*!
 @function showActivityindicator.
 @abstract Used to show the Activity indicator.
 @discussion
 @param arg_View - In which view we want to show the indicator.
 @result nil.
 */
+ (void)showProgessindicator:(UIView *)arg_View{
    
    // Start Activity Indicator.
    [ProgressHUD showInView:arg_View];
}

/*!
 @function hideActivityIndicator.
 @abstract Used to hide the Activity indicator.
 @discussion
 @param nil.
 @result nil.
 */
+ (void)hideProgessIndicator{
    
    // Stop Activity Indicator.
    [ProgressHUD dismiss];
}

/*!
 @function isNetworkReachable.
 @abstract Check internet reachabilty.
 @discussion
 @param
 @result return YES if network is available.
 */
+ (BOOL) isNetworkReachable {
    
    BOOL isReachable = YES;
    
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus reachabilityStatus = [reachability currentReachabilityStatus];
    
    if (reachabilityStatus == NotReachable)
        isReachable= NO;
    
    return isReachable;
    
}

/*!
 @function displayNoNetworkAlert.
 @abstract shows alert specifying network not present.
 @discussion
 @param
 @result
 */
+ (void) displayNoNetworkAlert{
    
    [self displayAlertTitle:nil
           withAlertMessage:kNoInternetConnectionDescr
           withCancelButton:kCancelAlertButton
           withOtherButtons:nil
            withForDelegate:nil
                    withTag:kDefaultAlertTag];
}

/*!
 @method setChartTypeImage:
 @abstract
 @discussion This method used to get UIImage for perticular ReportView type.
 @param arg_imagename - Image name
 @result UIImage.
 */
+ (UIImage *)setImage:(NSString *)arg_imagename{
    
    UIImage *imageToReturn = [[UIImage alloc] init];
    imageToReturn = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]
                                                      pathForResource:arg_imagename ofType:@"png"]];
    return imageToReturn;
}

@end
