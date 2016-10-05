//
//  ProButton.m
//  S&OP
//
//  Created by Mayur Birari on 16/07/13.
//  Copyright (c) 2013 Linear Logics Corp.. All rights reserved.
//

#import "ProButton.h"
#import "UIConfigValue.h"

/*!
 @class ProButton
 @abstract This class is used to apply custom control
 @discussion ProButton will apply Pro-Condensed Font to the Button's title label
 */
@implementation ProButton

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    // Set font family here
    [self.titleLabel setFont:[UIFont fontWithName:kProFontName size:self.titleLabel.font.pointSize]];
    
    self.titleLabel.textAlignment = NSTextAlignmentCenter;

}


@end
