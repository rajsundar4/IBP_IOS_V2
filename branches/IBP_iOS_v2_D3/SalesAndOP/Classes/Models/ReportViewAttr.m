//
//  ReportViewAttr.m
//  S&OP
//
//  Created by Mayur Birari on 10/08/13.
//  Copyright (c) 2013 Linear Logics Corp.. All rights reserved.
//

#import "ReportViewAttr.h"

@implementation ReportViewAttr

/*!
 @function initWithODataObject:
 @abstract -
 @discussion This method is used to fill ReportviewAttr variables.
 @param  arg_reportView.
 @result ReportViewAttr.
 */
- (id)initWithOdataObject:(reportviewTypeV0 *)arg_reportView {

    // Intialise object
    if(self = [self init]) {
    
        [self setReportId:arg_reportView.REPORTID];
        [self setReportViewId:arg_reportView.REPORTVIEWID];
        [self setAttr_Id:arg_reportView.ATTR_ID];
        [self setAttr_name:arg_reportView.ATTR_NAME];
        [self setAttr_type:arg_reportView.ATTR_TYPE];
        [self setSequence:arg_reportView.SEQUENCE];
    }
    return self;
}


@end
