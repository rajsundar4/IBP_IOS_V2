//
//  ReportPageLayout.m
//  S&OP
//
//  Created by Mayur Birari on 02/08/13.
//  Copyright (c) 2013 Linear Logics Corp.. All rights reserved.
//

#import "ReportPageLayout.h"

@implementation ReportPageLayout

#pragma mark - Method Defination

/*!
 @function initWithODataObject:
 @abstract -
 @discussion This method is used to fill ReportPageLayout variables.
 @param  arg_reportPageLayout.
 @result ReportPageLayout.
 */
- (id)initWithOdataObject:(reportpagelayoutTypeV0 *)arg_reportPageLayout{
    
    if(self = [super init]){
     
        //Initialise variables.
        [self setReportPageId:[arg_reportPageLayout REPORTPAGEID]];
        [self setRowNumber:[arg_reportPageLayout ROWNUMBER]];
        [self setColumnNumber:[arg_reportPageLayout COLUMNNUMBER]];
        [self setReportId:[arg_reportPageLayout REPORTID]];
        [self setReportViewName:[arg_reportPageLayout REPORTVIEWNAME]];
        [self setReportViewId:[arg_reportPageLayout REPORTVIEWID]];
        [self setReportViewType:[arg_reportPageLayout REPORTVIEWTYPE]];
        [self setRowSpan:[arg_reportPageLayout ROWSPAN]];
        [self setColumnSpan:[arg_reportPageLayout COLUMNSPAN]];
        [self setLegendPosition:[arg_reportPageLayout LEGENDPOSITION]];
        [self setNavigationId:[arg_reportPageLayout NAVIGATIONID]];
        [self setDisplayLegend:[arg_reportPageLayout DISPLAYLEGEND]];
        [self setIs_kpi:[arg_reportPageLayout IS_KPI]];
        [self setIs_geoenabled:[arg_reportPageLayout IS_GEOENABLED]];
        [self setIs_pageOwner:[arg_reportPageLayout ISPAGEOWNER]];
        [self setIs_viewOwner:[arg_reportPageLayout ISVIEWOWNER]];
    }
    
    return self;
}


@end
