//
//  HelpViewController.h
//  S&OP
//
//  Created by Mayur Birari on 17/07/13.
//  Copyright (c) 2013 Linear Logics Corp.. All rights reserved.
//

#import <UIKit/UIKit.h>

/*!
 \internal
 @class HelpViewController
 @abstract This view controller is used to Display Help View.
 @discussion Help screen will display Help screen with guidline on How to 
             used the Dashbaord/Charts.
 */
@interface HelpViewController : UIViewController {

    /// Represent instance of Help screen Image View.
    __weak IBOutlet UIImageView *helpScreenImageView;
    __weak IBOutlet UIButton *gotItButton;
    
}

/*!
 \internal
 @method removeHelpViewButtonPressed
 @abstract Used to remove Help screen.
 @discussion This method used to remove Help screen from Dashboard/Chart View.
 @param sender - action object.
 @result nil
 */
- (IBAction)removeHelpViewButtonPressed:(id)sender;


/*!
 \internal
 @method checkForOrientationOfView
 @abstract Used to set the image.
 @discussion This method used to set the image frame and its image according to the orientation.
 @param sender - none
 @result nil
 */
-(void)checkForOrientationOfView;
@end
