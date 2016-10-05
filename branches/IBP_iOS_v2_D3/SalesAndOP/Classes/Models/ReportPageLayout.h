//
//  ReportPageLayout.h
//  S&OP
//
//  Created by Mayur Birari on 02/08/13.
//  Copyright (c) 2013 Linear Logics Corp.. All rights reserved.
//

#import "sapsopaServiceV0.h"
#import <Foundation/Foundation.h>

/*!
 \internal
 @class ReportPageLayout.
 @abstract This class used to create variables for ReportPageLayout.
 */
@interface ReportPageLayout : NSObject

#pragma mark - Property Declaration

/// Attribute instance value reportPageLayout id.
@property (strong, nonatomic) NSString *reportPageId;
/// Attribute instance value reportPageLayout row number.
@property (strong, nonatomic) NSNumber *rowNumber;
/// Attribute instance value reportPageLayout column number.
@property (strong, nonatomic) NSNumber *columnNumber;
/// Attribute instance value reportPageLayout's report id.
@property (strong, nonatomic) NSString *reportId;
/// Attribute instance value reportPageLayout's Chart name.
@property (strong, nonatomic) NSString *reportViewName;
/// Attribute instance value reportPageLayout's Chart id.
@property (strong, nonatomic) NSString *reportViewId;
/// Attribute instance value reportPageLayout's Chart type.
@property (strong, nonatomic) NSString *reportViewType;
/// Attribute instance value reportPageLayout row span.
@property (strong, nonatomic) NSNumber *rowSpan;
/// Attribute instance value reportPageLayout column span.
@property (strong, nonatomic) NSNumber *columnSpan;
/// Attribute instance value reportPageLayout legend position.
@property (strong, nonatomic) NSString *legendPosition;
/// Attribute instance value reportPageLayout navigation ID.  (V3)
@property (strong, nonatomic) NSString *navigationId;
/// Attribute instance value reportPageLayout display legend or not.
@property (strong, nonatomic) NSString *displayLegend;
/// Attribute instance value reportView's belongs to is_kpi.  (V3)
@property (strong, nonatomic) NSString *is_kpi;
/// Attribute instance value reportView is_geoenabled. (V3)
@property (strong, nonatomic) NSString *is_geoenabled;
/// Attribute instance value reportView ispageowner. (V3)
@property (strong, nonatomic) NSString *is_pageOwner;
/// Attribute instance value reportView isviewowner. (V3)
@property (strong, nonatomic) NSString *is_viewOwner;


#pragma mark - Method Declaration

/*!
 \internal
 @function initWithODataObject:
 @discussion This method is used to fill ReportPageLayout variables.
 @param  arg_reportPageLayout - odata generated Object.
 @result ReportPageLayout - Layout instance for MBO.
 */
- (id)initWithOdataObject:(reportpagelayoutTypeV0 *)arg_reportPageLayout;

@end
