//
//  ReportViewAttr.h
//  S&OP
//
//  Created by Mayur Birari on 10/08/13.
//  Copyright (c) 2013 Linear Logics Corp.. All rights reserved.
//

#import "sapsopaServiceV0.h"
#import <Foundation/Foundation.h>

/*!
 \internal
 @class ReportViewAttr.
 @abstract This class used to create instace for ReportViewAttr.  Corresponds to reportViews Odata entity.
 */
@interface ReportViewAttr : NSObject

#pragma property delcaration
/// Attribute instance value report id for the Attributes.
@property (strong, nonatomic) NSString *reportId; 
/// Attribute instance value reportView id for the Attributes.
@property (strong, nonatomic) NSString *reportViewId;
/// Attribute instance value reportviewAtrr id.
@property (strong, nonatomic) NSString *attr_Id;
/// Attribute instance value reportviewAtrr name.
@property (strong, nonatomic) NSString *attr_name;
/// Attribute instance value reportviewAtrr type char or number.
@property (strong, nonatomic) NSString *attr_type;
/// Attribute instance value reportviewAtrr sequence.
@property (strong, nonatomic) NSNumber *sequence;
/// Attribute instance value reportviewAtrr chart value array for perticular attr.
// This is an array of dictionaries holding chart dat derived from reportview.chartsDictionary.
@property (strong, nonatomic) NSMutableArray *valuesArray;

#pragma mark - Method Declaration

/*!
 \internal
 @function initWithODataObject:
 @discussion This method is used to fill ReportviewAttr instance.
 @param  arg_reportView - odata object genereted by its framework.
 @result ReportViewAttr - Chart's Attribute MBO.
 */
- (id)initWithOdataObject:(reportviewTypeV0 *)arg_reportView;

@end
