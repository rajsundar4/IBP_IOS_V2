//
//  MDGenerator.h
//  S&OP
//
//  Created by Mayur Birari on 06/08/13.
//  Copyright (c) 2013 Linear Logics Corp.. All rights reserved.
//

#import "ReportView.h"
#import "ReportPage.h"
#import "ReportViewAttr.h"
#import "ReportPageLayout.h"
#import <Foundation/Foundation.h>

/*!
 \internal
 @class MDGenerator
 @abstract This class holds MetaData Generator workflow.
 @discussion MDGenerator will represent Dashboards and Charts data.
 */
@interface MDGenerator : NSObject

/// Page layout array represents charts belongs to dashboard.
@property (nonatomic, strong) NSMutableArray* reportPageLayoutArray;
/// Hold the chart data (json), for each chart.
@property (nonatomic, strong) NSMutableArray* chartDataArray;

/*!
 \internal
 @function sharedDataInstance.
 @abstract 
 @discussion This method is used to create unique instance for MDGenerator (Singleton).
 @param  nil.
 @result MDGenerator - Static instance of MD generator.
 */
+ (MDGenerator *)sharedMDGeneratorInstance;


/*!
 \internal
 @function initWithReportPage.
 @abstract
 @discussion This method is used to generate Dashboards for ReportPage (2, 3 or 4 Charts).
 @param  reportPage - instance of Dashboard to show on center screen.
 @result MDGenerator - create instance of Meta Data Generator.
 */
- (id)initWithReportPage:(ReportPage *)reportPage;

/*!
 \internal
 @function initWithReportView.
 @abstract
 @discussion This method is used to generate Dashboards for Single Chart.
 @param  reportView - instance of Chart to show on center screen as Dashboard.
 @result MDGenerator - create instance of Meta Data Generator.
 */
- (id)initWithReportView:(ReportView *)reportView;

/*!
 \internal
 @function generateMetaDataXML
 @discussion This method is used to generate MetaData xml, render by MAKIT framework.
 */
- (void) generateMetaDataXML;

@end
