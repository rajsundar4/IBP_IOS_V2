//
//  ReportPage.m
//  S&OP
//
//  Created by Mayur Birari on 02/08/13.
//  Copyright (c) 2013 Linear Logics Corp.. All rights reserved.
//

#import "ReportPage.h"

@implementation ReportPage

#pragma mark - Method Defination

/*!
 @function initWithODataObject:
 @abstract -
 @discussion This method is used to fill ReportPage variables.
 @param  arg_reportPages.
 @result ReportPages.
 */
- (id)initWithOdataObject:(reportpagesTypeV0 *)arg_reportPages{
    
    if(self = [super init]){
    
        // Initialise variables.
        [self setReportPageId:[arg_reportPages REPORTPAGEID]];
        [self setReportPageName:[arg_reportPages REPORTPAGENAME]];
        [self setReportPageDescr:[arg_reportPages REPORTPAGEDESCR]];
        [self setReportPageType:[arg_reportPages REPORTPAGETYPE]];
        [self setIsOwner:[arg_reportPages ISOWNER]];
        [self setIsShared: [arg_reportPages ISSHARED]];
        [self setISMobileEnabled:[arg_reportPages ISMOBILEENABLED]];
        [self setLayoutId:[arg_reportPages LAYOUTID]];
        [self setNumberOfRows:[arg_reportPages NUMBEROFROWS]];
        [self setNumberOfColumns:[arg_reportPages NUMBEROFCOLUMNS]];
        [self setRowHeight:[arg_reportPages ROWHEIGHT]];
        [self setColumnWidth:[arg_reportPages COLUMNWIDTH]];
        [self setCreatedBy:[arg_reportPages CREATEDBY]];
        [self setCreatedDate:[arg_reportPages CREATEDDATE]];
        [self setLastModifiedDate:[arg_reportPages LASTMODIFIEDDATE]];
        [self setLastModifiedBy:[arg_reportPages LASTMODIFIEDBY]];

    }
    
    return self;
}

@end
