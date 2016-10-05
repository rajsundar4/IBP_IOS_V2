//
//  WebviewCellVC.h
//  IBP
//
//  Created by Rick Thompson on 11/14/14.
//  Copyright (c) 2014 Linear Logics Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "DashboardCell.h"
#import "ReportView.h"



@interface WebviewCellVC : UIViewController <DashboardCell, WKNavigationDelegate>

@property (nonatomic,strong) NSString *cellName;
@property (nonatomic,strong) NSString *contentReference;
@property (nonatomic,strong) NSString *contentType;
@property (nonatomic,strong) NSString *titleString;
@property (nonatomic,strong) NSString *timeStamp;
@property (nonatomic,strong) NSString *graphDataSet;
@property (nonatomic,strong) NSMutableArray *graphDataSetArray;
@property (nonatomic,strong) NSString *timeStampString;
//@property (nonatomic,strong) NSMutableString *htmlString;
@property (nonatomic,strong) id chartObject;
@property (nonatomic,strong) IBOutlet UIWebView *cellWebView;
@property (nonatomic,strong) IBOutlet UILabel *titleLabel;
@property (nonatomic,strong) IBOutlet UILabel *timeStampLabel;
@property (nonatomic,strong) IBOutlet UIImageView *fullScreenIcon;
@property (nonatomic,strong) NSNumber *rowSpan;
@property (nonatomic,strong) NSNumber *columnSpan;
@property (nonatomic,strong) NSNumber *startRow;
@property (nonatomic,strong) NSNumber *startColumn;
@property (nonatomic,strong) NSNumber *wkWebViewHeight;
@property (nonatomic,strong) NSNumber *wkWebViewWidth;
@property (nonatomic,strong) ReportView *chart;
@property (nonatomic,strong) NSString *reportviewID;

@property (weak, nonatomic) IBOutlet UIView *graphView;


-(void) setupWebView :(NSString *) html : (NSURL *) indexURL;
- (void) displayTestChart;
- (void)loadExamplePage : (NSString *) chartType;
@end

