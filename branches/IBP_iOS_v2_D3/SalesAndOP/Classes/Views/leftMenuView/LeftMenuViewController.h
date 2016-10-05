//
//  LeftMenuViewController.h
//  S&OP
//
//  Created by Mayur Birari on 18/07/13.
//  Copyright (c) 2013 Linear Logics Corp.. All rights reserved.
//

#import "ReportPage.h"
#import "ReportView.h"
#import <UIKit/UIKit.h>

/*!
 \internal
 @protocol LeftMenuViewDelegate
 @abstract Used to load the dashboard and chart.
 @discussion This delegate used to notify on the event of dashboard and chart selected from the left panel, Home screen load the selected item.
 */
@protocol LeftMenuViewDelegate <NSObject>

/*!
 \internal
 @method selectDashboardToLoad
 @abstract Used to load the selected dashboard on home screen.
 */
-(void)selectDashboardToLoad:(ReportPage *)selectedReportPage;

/*!
 \internal
 @method selectChartToLoad
 @abstract Used to load the selected chart on home screen.
 */
-(void)selectChartToLoad:(ReportView *)selectedReportView;

@end

/*!
 \internal
 @class LeftMenuViewController
 @abstract This class is used to display Left Menu View.
 @discussion LeftMenuView has Dashboards, Charts, and Favorites list info 
             for login user, user can load any item by selecting it from the View.
 */
@interface LeftMenuViewController : UIViewController

//Used to set the footer image for the leftMenu view.
@property(nonatomic,retain)IBOutlet UIImageView *footerImageView;

/// LeftMenuView Dashboard/Chart item selection delegate.
@property (nonatomic, weak) id<LeftMenuViewDelegate> leftMenuViewDelegate;

/*!
 \internal
 @method refreshLeftMenu
 @discussion This method used to refill dashboard or charts array at runtime.
 */
- (void)refreshLeftMenu;

@end
