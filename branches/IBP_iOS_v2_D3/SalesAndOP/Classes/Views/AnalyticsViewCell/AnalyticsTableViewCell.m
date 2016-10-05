//
//  AnalyticsTableViewCell.m
//  S&OP
//
//  Created by Mayur Birari on 18/07/13.
//  Copyright (c) 2013 Linear Logics Corp. All rights reserved.
//

#import "AnalyticsTableViewCell.h"

/*!
 @class AnalyticsTableViewCell
 @abstract This class is used to show custom Analytics cell.
 @discussion AnalyticsTableViewCell has item image, label, and Background View image
 information.
 */
@implementation AnalyticsTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    
}

@end
