//
//  ReportView.m
//  S&OP
//
//  Created by Mayur Birari on 02/08/13.
//  Copyright (c) 2013 Linear Logics Corp.. All rights reserved.
//

#import "ReportView.h"
#import "ReportViewAttr.h"

@implementation ReportView

#pragma mark - Method Defination

/*!
 @function initWithODataObject:
 @abstract -
 @discussion This method is used to fill ReportView variables.
 @param  arg_reportViews.
 @result ReportView.
 */
- (id)initWithOdataObject:(reportviewsTypeV0 *)arg_reportViews{
    
    if(self = [super init]){
        
        // Initialise variables.
        [self setReportViewId:[arg_reportViews REPORTVIEWID]];
        [self setReportViewName:[arg_reportViews REPORTVIEWNAME]];
        [self setReportViewDescr:[arg_reportViews REPORTVIEWDESCR]];
        [self setReportViewType:[arg_reportViews REPORTVIEWTYPE]];
        
        [self setIsOwner:[arg_reportViews ISOWNER]];
        [self setIsShared:[arg_reportViews ISSHARED]];
        [self setISMobileEnabled:[arg_reportViews ISMOBILEENABLED]];
        [self setReportId:[arg_reportViews REPORTID]];
        [self setIs_kpi:[arg_reportViews IS_KPI]];
        [self setDisplayLegend:[arg_reportViews DISPLAYLEGEND]];
        [self setLegendPosition:[arg_reportViews LEGENDPOSITION]];
        [self setIs_rolling:[arg_reportViews IS_ROLLING]];
        [self setIs_geoenabled:[arg_reportViews IS_GEOENABLED]];
        [self setBenchmark:[arg_reportViews BENCHMARK]];
        [self setBenchmark_plarea:[arg_reportViews BENCHMARK_PLAREA]];
        [self setBenchmarkName:[arg_reportViews BENCHMARKNAME]];
        [self setCreatedBy:[arg_reportViews CREATEDBY]];
        [self setCreatedDate:[arg_reportViews CREATEDDATE]];
        [self setLastModifiedDate:[arg_reportViews LASTMODIFIEDDATE]];
        [self setLastModifiedBy:[arg_reportViews LASTMODIFIEDBY]];
        
    }
    
    return self;
}

- (void) initAdditionalParams {
    
    int tCAttrCount = 0, tKAttrCount = 0, tSCNIDFlag = 0, tPERIODFlag = 0;
    for (ReportViewAttr *treportViewAttrArray in self.reportViewAttrArray) {
        if ([treportViewAttrArray.attr_type isEqualToString:@"C"]) {
            tCAttrCount++;
            if ([treportViewAttrArray.attr_Id isEqualToString:@"SCNID"])
                tSCNIDFlag++;
            if ([treportViewAttrArray.attr_Id hasPrefix:@"PERIOD"])
                tPERIODFlag++;
        } else if ([treportViewAttrArray.attr_type isEqualToString:@"K"])
            tKAttrCount++;
    }
    [self setCAttrCount:tCAttrCount];
    [self setKAttrCount:tKAttrCount];
    [self setSCNIDFlag:tSCNIDFlag];
    [self setPERIODFlag:tPERIODFlag];
    //[self setMAKitChartType:[self getMAKitLibChartName: [self reportViewType]]];
    
    //DLog(@"CAttrCount: %d, KAttrCount: %d, SCNIDFlag: %d, PERIODFlag: %d, chartType: %@", [self CAttrCount], [self KAttrCount], [self SCNIDFlag], [self PERIODFlag], [self MAKitChartType]);
    
    //  && ![[self MAKitChartType] isEqualToString:@"OverlayChart"]
    /**
    if (([self CAttrCount] > 2) && ![[self MAKitChartType] isEqualToString:@"RFTable"] && ![[self MAKitChartType] isEqualToString:@"OverlayChart"]
        && ![[self MAKitChartType] isEqualToString:@"Pie"]) {
        [self setMAKitChartFunction:@"DrillDown"];
        
    }
    DLog(@"MAKitChartFunction: %@", [self MAKitChartFunction]);
    **/
}

/*!
 @function getMAKitLibChartName
 @abstract -
 @discussion This method maps the S&OP chart type to the MAKIT chart type as different
 charting libraries are used - mobile uses MAKit, S&OP web interface uses VIZ.
 @param  chartType.
 @result MAKIT chartName.
 */
- (NSString *) getMAKitLibChartName:(NSString *)chartType {
    
    chartType=[chartType lowercaseString];
    
    NSString* chartName=@"";
    
    SWITCH (chartType) {
        CASE (@"pie") {
            chartName=@"Pie";
            break;
        }
        CASE (@"combination") {
            chartName=@"OverlayChart";
            break;
        }
        CASE (@"donut") {
            chartName=@"Pie";
            break;
        }
        CASE (@"vertical bar cluster") {
            chartName=@"Column";
            break;
        }
        CASE (@"horizontal bar") {
            chartName=@"Bar";
            break;
        }
        CASE (@"line") {
            chartName=@"Line";
            break;
        }
        CASE (@"vertical bar stacked") {
            chartName=@"StackedColumn";
            break;
        }
        CASE (@"table") {       // rft
            chartName=@"RFTable";
            break;
        }
        CASE (@"hbar stacked") {       // rft
            chartName=@"StackedColumn";
            break;
        }
        DEFAULT {
            self.isMobileEnabled2 = @"NO";
            break;
        }
    }
    
    return chartName;
}

@end
