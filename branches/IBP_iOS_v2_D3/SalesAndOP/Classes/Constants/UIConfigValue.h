//
//  UIConfigValue.h
//  S&OP
//
//  Created by Mayur Birari on 26/07/13.
//  Copyright (c) 2013 Linear Logics Corp.. All rights reserved.
//

/*!
 \internal
 @class UIConfigValue
 @abstract This class holds global instances for UI
 @discussion UIConfig will holds constants, color codes, fonts, frames etc 
             related to UI Configuration
 */

#pragma mark -Custom Fonts

#define kProFontName @"DINNextLTPro-Condensed"
#define kProFont_18 [UIFont fontWithName:@"DINNextLTPro-Condensed" size:18.0]
#define kProLightFontName @"DINNextLTPro-LightCondensed"

#pragma mark- Splash Screen

#define kSplashScreenTimeout 3.0

#define kSplashVideoURL [[NSBundle mainBundle] pathForResource:@"splash_final" ofType:@"mov"]
#define kMoviewControllerFrame CGRectMake(0, 0, 1024, 768)

#pragma mark- Home Screen

//#define kMyViewControllerFrame CGRectMake(0, 81, 1024, 712)
//  Adjust for iOS 7 status bar issue
#define kMyViewControllerFrame CGRectMake(0, 64, 1024, 704)

//Used to set the view in Portrait Mode.
//#define kMyViewControllerFramePortrait CGRectMake(0, 85, 766, 970)
#define kMyViewControllerFramePortrait CGRectMake(0, 64, 768, 960)

#pragma mark - Custom Label

#define kCustomLabelOpacity 0.87
#define kCustomLabelShadowRadius 0.0
#define kCustomLabelInSettingViewTag 878
#define kCustomLabelInDatasetViewTag 454

#pragma mark - Custom UITextField

#define kTextFieldColor [UIColor colorWithRed:100.0/255.0 green:100.0/255.0 blue:100.0/255.0 alpha:1]

#pragma mark - LeftView

#define kIsDashboard @"IsDashboard"
#define kLeftViewButtonTitleColor [UIColor colorWithRed:(100/255.0) green:(100/255.0) blue:(100/255.0) alpha:1]

#pragma mark- DataSet View

#define kCellLabelTextColor [UIColor colorWithRed:103.0/255.0 green:157.0/255.0 blue:17.0/255.0 alpha:1]
#define kSelectionViewColor [UIColor colorWithRed:(73/255.0) green:(73/255.0) blue:(73/255.0) alpha:1]
#define kCellCustomLabelFrame CGRectMake(15,9, 324, 40)
#define kCellCustomLabelFrameInLocalTimeoutTable CGRectMake(14,6, 324, 40)
#define kCellCustomViewFrame CGRectMake(20,11, 310, 36)

#pragma mark - Alert view tags

#define kDefaultAlertTag 0
#define kUsernameTextfieldTag 10
#define kPassworsTextfieldTag 20
#define kDashboardListButtonTag 501
#define kChartsListButtonTag 502
#define kFavouritesListButtonTag 503

#pragma mark - Data Controller View

#define kThreadCount 5

#pragma mark - Other

#define kUserLogoff @"UserLogoff"
#define kSandbox01 @"https://sandbox01.sop.ondemand.com"
#define kSandbox02 @"https://sandbox02.sop.ondemand.com"
#define kAnimationDuration 0.5

#define kPie @"pie"
#define kCombination @"combination"
#define kDonut @"donut"
#define kVerticalBarCluster @"vertical bar cluster"
#define kVerticalBarStacked @"vertical bar stacked"
#define kHorizontalBar @"horizontal bar"
#define kHorizontalBarStacked @"hbar stacked"
#define kLine @"line"
#define kTable @"table"

#define kSelectedDashboardName @"selecteddashboardname"
#define kSelectedChartName @"selectedchartname"
#define kLoadDashboardData @"loaddashboarddata"


