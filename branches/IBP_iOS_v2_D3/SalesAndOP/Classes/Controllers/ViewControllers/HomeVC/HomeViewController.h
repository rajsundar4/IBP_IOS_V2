//
//  HomeViewController.h
//  SalesAndOP
//
//  Created by Mayur Birari on 11/07/13.
//  Copyright (c) 2013 Linear Logics Corp.. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HeaderViewController.h"
#import "LeftMenuViewController.h"

/*!
 \internal
 @class HomeViewController
 @abstract This view controller is used to Display Home View.
 @discussion Home screen will display charts, dashboards, dataset and report views.
 */
@interface HomeViewController : UIViewController <LeftMenuViewDelegate>

/// Instance of the singleton Header View.
@property (weak, nonatomic) IBOutlet HeaderViewController *headerView;

/*!
 \internal
 @method leftBarButtonSwipeLeft
 @abstract Used to display left menu bar.
 @discussion This method used to display left menu bar by pressing left menu.
 @param sender - action object.
 @result nil
 */
- (IBAction)leftBarButtonSwipeLeft:(id)sender;

/*!
 \internal
 @method rightBarButtonSwipeLeft
 @abstract Used to display left menu bar.
 @discussion This method used to display right menu bar by pressing right menu.
 @param sender - action object.
 @result nil
 */
- (IBAction)rightBarButtonSwipeLeft:(id)sender;

/*!
 \internal
 @method helpButtonPressed
 @abstract Used to display Help screen.
 @discussion This method used to display Help screen for how to used Dashboard/Charts.
 @param sender - action object.
 @result nil
 */
- (IBAction)helpButtonPressed:(id)sender;

/*!
 \internal 
 @method refreshButtonPressed:
 @abstract
 @discussion Used to refresh all the data in controllers.
 @param sender - action object.
 @result nil.
 */
- (void)refreshButtonPressed:(id)sender;

- (void)logoffProcess;

@end
