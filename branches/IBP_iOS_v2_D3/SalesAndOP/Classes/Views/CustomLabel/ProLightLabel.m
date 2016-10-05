//
//  ProLightLabel.m
//  S&OP
//
//  Created by Mayur Birari on 16/07/13.
//  Copyright (c) 2013 Linear Logics Corp.. All rights reserved.
//

#import "ProLightLabel.h"
#import "UIConfigValue.h"
#import <QuartzCore/QuartzCore.h>

/*!
 @class ProLightLabel
 @abstract This class is used to apply custom control
 @discussion ProLightLabel will apply ProLight Condensed Font to the label
 */
@implementation ProLightLabel


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
    // Set font family here
    [self setFont:[UIFont fontWithName:kProLightFontName size:self.font.pointSize]];
    
    // Set drop shadow
    self.layer.shadowOpacity = kCustomLabelOpacity;
    self.layer.shadowRadius = kCustomLabelShadowRadius;
    self.layer.shadowColor = [UIColor whiteColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(0.0, 0.5);
    
    [super drawTextInRect:rect];

}


@end
