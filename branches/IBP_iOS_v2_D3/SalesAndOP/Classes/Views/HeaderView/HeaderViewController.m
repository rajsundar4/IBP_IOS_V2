//
//  HeaderViewController.m
//  S&OP
//
//  Created by Mayur Birari on 16/07/13.
//  Copyright (c) 2013 Linear Logics Corp.. All rights reserved.
//

#import "HeaderViewController.h"
#import "JAMController.h"
#import <QuartzCore/QuartzCore.h>

/*!
 @class HeaderViewController
 @abstract This class is used to common Header across all the views
 @discussion HeaderViewController has header title, help, setting, Left bar,
 dataset and about app icons
 */
@implementation HeaderViewController

#pragma mark- View lifecycle

- (void) awakeFromNib
{
    [super awakeFromNib];
    
    [[NSBundle mainBundle] loadNibNamed:@"HeaderViewController" owner:self options:nil];
    [self addSubview:headerView];
    
}

/*!
 @method setTitleForTheHeader
 @abstract Used to display title for header
 @discussion This method used to display dashboards, charts, settings title into
 the header sectino
 @param titleString
 @result nil
 */
- (void)setTitleForTheHeader:(NSString *) titleString {

    [titleLabel setText:titleString];
}

/*!
 @method setUpHomeScreenComponent
 @abstract Used to setup Home Screen controls
 @discussion This method used to display/setup Hom screen control on Header
 @param sender
 @result nil
 */
- (void)setUpHomeScreenComponent {

    [self setTitleForTheHeader:@"Dashboard"];
    // Logo image
    [logoImage setHidden:YES];
    [logoImage2 setHidden:NO];
    [self.helpButton setBackgroundImage:[Global setImage:@"icn_help@2x"] forState:UIControlStateNormal];
    
    // Bar buttons
    [self.leftBarButton setHidden:NO];
    [self.helpButton setHidden:NO];
   // [self.datasetButton setHidden:NO];
    [self.settingsButton setHidden:NO];
    
    if(connectionType == DirectConnectToSAOPView) {
        [self.userInfoButton setHidden:NO];
        [self.refreshButton setHidden:NO];
        [self.rightBarButton setHidden:NO];
    }
    
    if ([JAMController sharedInstance].available == NO)
        [self.rightBarButton setHidden:YES];
}


@end
