//
//  FullWebviewVC.h
//  IBP
//
//  Created by Rick Thompson on 11/14/14.
//  Copyright (c) 2014 Linear Logics Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "ReportView.h"

@interface FullWebviewVC : UIViewController


@property (nonatomic) NSString *contentReference;
@property (nonatomic) IBOutlet UIWebView *cellWebView;
@property (nonatomic) IBOutlet UIButton *dismissButton;
@property (nonatomic,strong) ReportView *chart;
@property (nonatomic,strong) NSString *reportviewID;
@property (nonatomic) BOOL chartFromDashboard;

- (void) displayTestChart;
- (IBAction) dismissButtonPressed:(id)sender;

@end