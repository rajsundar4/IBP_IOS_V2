//
//  ReportPage.h
//  S&OP
//
//  Created by Mayur Birari on 02/08/13.
//  Copyright (c) 2013 Linear Logics Corp.. All rights reserved.
//

#import "sapsopaServiceV0.h"
#import <Foundation/Foundation.h>

/*!
 \internal
 @class ReportPage.
 @abstract This class used to create variables for ReportPage.
 */
@interface ReportPage : NSObject

#pragma mark - Property Declaration

/// Attribute instance value reportPage id.
@property (strong, nonatomic) NSString *reportPageId;
/// Attribute instance value reportPage Name.
@property (strong, nonatomic) NSString *reportPageName;
/// Attribute instance value reportPage Description.
@property (strong, nonatomic) NSString *reportPageDescr;
/// Attribute instance value reportPageType Description. (V3)
@property (strong, nonatomic) NSString *reportPageType;
/// Attribute instance value reportPage has owner or not.
@property (strong, nonatomic) NSString *isOwner;
/// Attribute instance value reportPage has owner or not.  (V3)
@property (strong, nonatomic) NSString *isShared;
/// Attribute instance value reportPage is for mobile or not.
@property (strong, nonatomic) NSString *iSMobileEnabled;
/// Attribute instance value reportPage layout id.
@property (strong, nonatomic) NSString *layoutId;
/// Attribute instance value reportPage number of rows in Dashboard.
@property (strong, nonatomic) NSNumber *numberOfRows;
/// Attribute instance value reportPage number of Columns in Dashboard.
@property (strong, nonatomic) NSNumber *numberOfColumns;
/// Attribute instance value reportPage row Height.
@property (strong, nonatomic) NSString *rowHeight;
/// Attribute instance value reportPage column Height.
@property (strong, nonatomic) NSString *columnWidth;
/// Attribute instance value reportPage created by Whom.
@property (strong, nonatomic) NSString *createdBy;
/// Attribute instance value reportPage created Date.
@property (strong, nonatomic) NSDate *createdDate;
/// Attribute instance value reportPage last modified Date.
@property (strong, nonatomic) NSDate *lastModifiedDate;
/// Attribute instance value reportPage last modified by Whom.
@property (strong, nonatomic) NSString *lastModifiedBy;

#pragma mark - Method Declaration

/*!
 \internal
 @function initWithODataObject:
 @abstract -
 @discussion This method is used to fill ReportPage instance.
 @param  arg_reportPages - instance by odata framework.
 @result ReportPages - Dashboard mobile business object.
 */
- (id)initWithOdataObject:(reportpagesTypeV0 *)arg_reportPages;

@end
