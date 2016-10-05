//
//  AboutViewController.h
//  S&OP
//
//  Created by Mayur Birari on 25/07/13.
//  Copyright (c) 2013 Linear Logics Corp.  All rights reserved.
//

#import <UIKit/UIKit.h>

/*!
 \internal
 @class AboutViewController
 @abstract This view controller is used to Display About app information.
 @discussion From Setting screen, user can called About Screen by pressing info icon.
 */
@interface AboutViewController : UIViewController

@property(weak,nonatomic)IBOutlet UILabel*versionLabel;

@end
