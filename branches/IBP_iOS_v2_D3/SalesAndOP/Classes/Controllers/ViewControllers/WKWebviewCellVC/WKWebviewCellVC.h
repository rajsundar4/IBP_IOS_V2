//
//  WKWebviewCellVC.h
//  IBP
//
//  Created by Rick Thompson on 11/25/14.
//  Copyright (c) 2014 Linear Logics Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "ReportView.h"



@interface WKWebviewCellVC : UIViewController <WKNavigationDelegate, WKUIDelegate>

@property (nonatomic,strong) NSString *cellName;
@property (nonatomic,strong) NSString *contentReference;
@property (nonatomic,strong) NSString *contentType;
@property (nonatomic,strong) NSString *titleString;
//@property (nonatomic,strong) NSMutableString *htmlString;
@property (nonatomic,strong) id chartObject;
//@property (nonatomic,strong) IBOutlet UIWebView *cellWebView;
@property (nonatomic, strong)   IBOutlet    UIView *webContainerView;
@property (nonatomic,strong) IBOutlet WKWebView *cellWKWebView;
@property (nonatomic,strong) IBOutlet UILabel *titleLabel;
@property (nonatomic,strong) IBOutlet UILabel *timestamp;
@property (nonatomic,strong) IBOutlet UIImageView *fullScreenIcon;
@property (nonatomic,strong) NSNumber *rowSpan;
@property (nonatomic,strong) NSNumber *columnSpan;
@property (nonatomic,strong) NSNumber *startRow;
@property (nonatomic,strong) NSNumber *startColumn;
@property (nonatomic,strong) ReportView *chart;
@property (nonatomic,strong) NSString *reportviewID;


@end
