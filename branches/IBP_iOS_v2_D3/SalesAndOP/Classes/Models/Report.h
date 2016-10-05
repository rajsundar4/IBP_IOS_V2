//
//  Report.h
//  S&OP
//
//  Created by Mayur Birari on 02/08/13.
//  Copyright (c) 2013 Linear Logics Corp.. All rights reserved.
//

#import "sapsopaServiceV0.h"
#import <Foundation/Foundation.h>

/*!
 \internal
 @class Report.
 @abstract This class used to create instances for Report (Planning Area).
 */
@interface Report : NSObject

#pragma mark - Property Declaration

/// Attribute instance value report id.
@property (strong, nonatomic) NSString *reportId;
/// Attribute instance value report name.
@property (strong, nonatomic) NSString *reportName;
/// Attribute instance value report description.
@property (strong, nonatomic) NSString *reportDescr;
/// Attribute instance value report is mobile enabled or not.
@property (strong, nonatomic) NSString *iSMobileEnabled;
/// Attribute instance value create by whom.
@property (strong, nonatomic) NSString *createdBy;
/// Attribute instance value report created date.
@property (strong, nonatomic) NSDate *createdDate;
/// Attribute instance value report last modified date.
@property (strong, nonatomic) NSDate *lastModifiedDate;
/// Attribute instance value report last modified by whom.
@property (strong, nonatomic) NSString *lastModifiedBy;

#pragma mark - Method Declaration

/*!
 \internal
 @function initWithODataObject:
 @discussion This method is used to fill Report variables.
 @param  arg_reports - instance by odata framework.
 @result Report - Planning Area mobile business object.
 */
- (id)initWithODataObject:(reportsTypeV0 *)arg_reports;

@end
