//
//  AnalyticsTableViewCell.h
//  S&OP
//
//  Created by Mayur Birari on 18/07/13.
//  Copyright (c) 2013 Linear Logics Corp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProLightLabel.h"

/*!
 \internal
 @class AnalyticsTableViewCell
 @abstract This class is used to show custom Analytics cell.
 @discussion AnalyticsTableViewCell has item image, label, and Background View image
             information.
 */
@interface AnalyticsTableViewCell : UITableViewCell

/// analytics label string, title.
@property (weak, nonatomic) IBOutlet ProLightLabel *analyticsLabel;

/// chart type image, runtime this image will change in cell.
@property (weak, nonatomic) IBOutlet UIImageView *chartTypeImageView;

/// background image for cell, which will change on the selection state.
@property (weak, nonatomic) IBOutlet UIImageView *cellBackgroundView;

@end
