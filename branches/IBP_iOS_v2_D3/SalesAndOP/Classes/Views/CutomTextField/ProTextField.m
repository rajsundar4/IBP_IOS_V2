//
//  ProTextField.m
//  S&OP
//
//  Created by Mayur Birari on 17/07/13.
//  Copyright (c) 2013 Linear Logics Corp.. All rights reserved.
//

#import "ProTextField.h"

/*!
 @class ProTextField
 @abstract This class is used to apply custom control
 @discussion ProTextField will apply Pro-Condensed Font to the textfields text
 and append text apperence by 15 pix
 */
@implementation ProTextField

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect{
    
    [self setFont:[UIFont fontWithName:kProFontName size:self.font.pointSize]];
    [self setTextColor:kTextFieldColor];
}

// placeholder position
// drawing and positioning overrides
- (CGRect)textRectForBounds:(CGRect)bounds {
    
    return CGRectMake(bounds.origin.x + 15, bounds.origin.y + 10,
               bounds.size.width - 25.0, bounds.size.height - 10);
}

// text position
// drawing and positioning overrides
- (CGRect)editingRectForBounds:(CGRect)bounds {
    
   bounds = CGRectMake(bounds.origin.x, bounds.origin.y - 2.0,
                             bounds.size.width - 25.0, bounds.size.height);
    
    return [self textRectForBounds:bounds];
}

@end
