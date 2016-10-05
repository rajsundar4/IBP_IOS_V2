//
//  ProLabel.m
//  S&OP
//
//  Created by Mayur Birari on 16/07/13.
//  Copyright (c) 2013 Linear Logics Corp.. All rights reserved.
//

#import "ProLabel.h"
#import "UIConfigValue.h"
#import <QuartzCore/QuartzCore.h>

/*!
 @class ProLabel
 @abstract This class is used to apply custom control
 @discussion ProLabel will apply Pro Condensed Font to the label
 */
@implementation ProLabel

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
    // Set font family here
    [self setFont:[UIFont fontWithName:kProFontName size:self.font.pointSize]];
    
    // Set drop shadow
    self.layer.shadowOpacity = kCustomLabelOpacity;
    self.layer.shadowRadius = kCustomLabelShadowRadius;
    self.layer.shadowColor = [UIColor whiteColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(0.0, 1);
    
    [super drawTextInRect:rect];

}


@end
