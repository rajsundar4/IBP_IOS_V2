//
//  ReportView.h
//  S&OP
//
//  Created by Mayur Birari on 02/08/13.
//  Copyright (c) 2013 Linear Logics Corp.. All rights reserved.
//


#import "sapsopaServiceV0.h"
#import <Foundation/Foundation.h>

/*!
 \internal
 @class ReportView.
 @abstract This class used to create instances for ReportView (Chart).
 */
@interface ReportView : NSObject


#pragma mark - Property Declaration

/// Attribute instance value reportView id.
@property (strong, nonatomic) NSString *reportViewId;
/// Attribute instance value reportView name.
@property (strong, nonatomic) NSString *reportViewName;
/// Attribute instance value reportView description.
@property (strong, nonatomic) NSString *reportViewDescr;
/// Attribute instance value reportView type (chart type).
@property (strong, nonatomic) NSString *reportViewType;
/// Attribute instance value reportView type hints (V4).
@property (strong, nonatomic) NSString *reportViewTypeHints;
/// Attribute instance value reportView has owner.
@property (strong, nonatomic) NSString *isOwner;
//  Attribute instance value isShared.  (V3)
@property (strong, nonatomic) NSString *isShared;
/// Attribute instance value reportView is belongs to Mobile Analytics or not.
@property (strong, nonatomic) NSString *iSMobileEnabled;
/// Attribute instance value reportView is belongs to Mobile Analytics or not.
@property (strong, nonatomic) NSString *isMobileEnabled2;
/// Attribute instance value reportView's belongs to report id.
@property (strong, nonatomic) NSString *reportId;
/// Attribute instance value reportView's belongs to is_kpi.  (V3)
@property (strong, nonatomic) NSString *is_kpi;
// Attribute instance value reportView's belongs to is_groupby.  (V4)
@property (strong, nonatomic) NSString *is_groupBy;
/// Attribute instance value reportView display legend yes or no.
@property (strong, nonatomic) NSString *displayLegend;
/// Attribute instance value reportView legend position.
@property (strong, nonatomic) NSString *legendPosition;
/// Attribute instance value reportView is_rolling.  (V3)
@property (strong, nonatomic) NSString *is_rolling;
/// Attribute instance value reportView is_geoenabled. (V3)
@property (strong, nonatomic) NSString *is_geoenabled;
// (V4)
@property (strong,nonatomic) NSString *orderBy;
// (V4)
@property (strong,nonatomic) NSString *orderBy_desc;
/// Attribute instance value reportView benchmark.  (V3)
@property (strong, nonatomic) NSString *benchmark;
/// Attribute instance value reportView benchmark planning area.  (V3)
@property (strong, nonatomic) NSString *benchmark_plarea;
/// Attribute instance value reportView benchmark name.  (V3)
@property (strong, nonatomic) NSString *benchmarkName;
/// Attribute instance value reportView created by whom.
@property (strong, nonatomic) NSString *createdBy;
/// Attribute instance value reportView created Date.
@property (strong, nonatomic) NSDate *createdDate;
/// Attribute instance value reportView last modified Date.
@property (strong, nonatomic) NSDate *lastModifiedDate;
/// Attribute instance value reportView last modified by whom.
@property (strong, nonatomic) NSString *lastModifiedBy;
// (V4)
@property (strong, nonatomic) NSString *reportViewCategory;
/// Attribute instance value reportView's Attribute array, x and y axis attributes.
//  This is an array of reportViewAttr objects
@property (strong, nonatomic) NSMutableArray *reportViewAttrArray;
/// Attribute instance value reportView's data array, x and y axis values.
// This is the array of dictionaries returned by JSON call to retrieve chart data.
@property (strong, nonatomic) NSMutableArray *chartsDictionary;

@property (nonatomic,strong) NSDate *timeStamp;

@property (strong, nonatomic) NSString *MAKitChartType;
@property (strong, nonatomic) NSString *MAKitChartFunction;
@property int CAttrCount;
@property int KAttrCount;
@property int SCNIDFlag;
@property int PERIODFlag;

#pragma mark - Method Declaration

/*!
 \internal
 @function initWithODataObject:
 @discussion This method is used to fill ReportView variables.
 @param  arg_reportViews - instance by odata framework.
 @result ReportView - Chart mobile business object.
 */
- (id)initWithOdataObject:(reportviewsTypeV0 *)arg_reportViews;
- (void) initAdditionalParams;
//- (NSString *) getMAKitLibChartName:(NSString *)chartType;

@end

typedef enum  {
    Pie,
    OverlayChart,
    Column,
    Bar,
    Line,
    StackedColumn,
    RFTable
} MAKitChartType;

typedef enum  {
    DrillDown
} MAKitChartFunction;

typedef enum {
    HorizontalBar,
    HorizontalStackedBar,
    sPie,
    Donut,
    VerticalBarStacked,
    VerticalBarCluster,
    LINE_MAXCombination,
    Table
} SOPChartType;
