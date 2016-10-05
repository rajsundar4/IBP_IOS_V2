//
//  RightMenuViewController.h
//  S&OP
//
//  Created by Rick Thompson on 2/11/14.
//  Copyright (c) 2014 Linear Logics Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "JAMController.h"
#import "Global.h"

@interface RightMenuViewController : UIViewController <UIWebViewDelegate>
{
    UIActivityIndicatorView *activityIndicator;
}

@property (nonatomic) IBOutlet UIWebView *jamWebView;
@end

