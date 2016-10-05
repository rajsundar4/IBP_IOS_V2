//
//  HeaderViewController.h
//  S&OP
//
//  Created by Mayur Birari on 16/07/13.
//  Copyright (c) 2013 Linear Logics Corp.. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProLightLabel.h"

/*!
 \internal
 @class HeaderViewController
 @abstract This class is used to common Header across all the views.
 @discussion HeaderViewController has header title, help, setting, Left bar, 
             dataset and about app icons.
 */
@interface HeaderViewController : UIView {

    /// Header components
    
    /// instance of xib, Header View.
    __weak IBOutlet UIView *headerView;
    /// Setting logo image.
    __weak IBOutlet UIImageView *logoImage;
    /// Home screen logo image.
    __weak IBOutlet UIImageView *logoImage2;
    /// Header's title label string.
    __weak IBOutlet ProLightLabel *titleLabel;
    
}
/// Header components, All the Bar Buttons
/// left menu bar button, show the left panel.
@property (weak, nonatomic) IBOutlet UIButton *leftBarButton;
/// left menu bar button, show the left panel.
@property (weak, nonatomic) IBOutlet UIButton *rightBarButton;
/// user information button, show the User detail view.
@property (weak, nonatomic) IBOutlet UIButton *userInfoButton;
/// data set button, show the list of plannning area view.
@property (weak, nonatomic) IBOutlet UIButton *datasetButton;
/// setting button, load the setting screen.
@property (weak, nonatomic) IBOutlet UIButton *settingsButton;
/// refresh button, refresh the data and reload the home screen.
@property (weak, nonatomic) IBOutlet UIButton *refreshButton;
/// help button, show the help screen.
@property (weak, nonatomic) IBOutlet UIButton *helpButton;

/*!
 \internal
 @method setTitleForTheHeader
 @abstract Used to display title for header.
 @discussion This method used to display dashboards, charts, settings title into
             the header section.
 @param titleString - title string for header.
 */
- (void)setTitleForTheHeader:(NSString *) titleString;

/*!
 \internal
 @method setUpHomeScreenComponent
 @abstract Used to setup Home Screen controls.
 @discussion This method used to display/setup Hom screen control on Header.
 */
- (void)setUpHomeScreenComponent;

@end
