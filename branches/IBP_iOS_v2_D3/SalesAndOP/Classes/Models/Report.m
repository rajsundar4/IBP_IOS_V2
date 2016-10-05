//
//  Report.m
//  S&OP
//
//  Created by Mayur Birari on 02/08/13.
//  Copyright (c) 2013 Linear Logics Corp.. All rights reserved.
//

#import "Report.h"

@implementation Report

#pragma mark - Method Defination

/*!
 @function initWithODataObject:
 @abstract -
 @discussion This method is used to fill Report variables.
 @param  arg_reports.
 @result Report.
 */
- (id)initWithODataObject:(reportsTypeV0 *)arg_reports{
    
    if(self = [super init]){
        
        // Initialise variables.
        [self setReportId:[arg_reports REPORTID]];
        [self setReportName:[arg_reports REPORTNAME]];
        [self setReportDescr:[arg_reports REPORTDESCR]];
        [self setISMobileEnabled:[arg_reports ISMOBILEENABLED]];
        [self setCreatedBy:[arg_reports CREATEDBY]];
        [self setCreatedDate:[arg_reports CREATEDDATE]];
        [self setLastModifiedDate:[arg_reports LASTMODIFIEDDATE]];
        [self setLastModifiedBy:[arg_reports LASTMODIFIEDBY]];

    }
    return self;
}

@end
