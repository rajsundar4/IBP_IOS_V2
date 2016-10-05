//
//  MDGenerator.m
//  S&OP
//
//  Created by Mayur Birari on 06/08/13.
//  Copyright (c) 2013 Linear Logics Corp.. All rights reserved.
//

#import "XMLWriter.h"
#import "MDGenerator.h"
#include "Global.h"

/*!
 @class MDGenerator
 @abstract This class holds MetaData Generator workflow
 @discussion MDGenerator will represent Dashboards and Charts data
 */
@implementation MDGenerator

/*!
 @function sharedDataInstance.
 @abstract -
 @discussion This method is used to create unique instance for DataController.
 @param  nil.
 @result DataController.
 */
+ (MDGenerator *)sharedMDGeneratorInstance {
    
    static MDGenerator *mdGenerator;
    
    if(!mdGenerator){
        
        mdGenerator = [[MDGenerator alloc] init];
        
    }
    return mdGenerator;
}

/*!
 @function initWithReportPage
 @abstract -
 @discussion This method is used to generate Dashboards for ReportPage (2, 3 or 4 Charts).
 @param  reportPage.
 @result MDGenerator.
 */
- (id)initWithReportPage:(ReportPage *)reportPage
{
    if (self = [super init]) {
        _reportPageLayoutArray=[[NSMutableArray alloc] init];
        _chartDataArray=[[NSMutableArray alloc] init];
    }
    return self;
}

/*!
 @function initWithReportView
 @abstract -
 @discussion This method is used to generate Dashboards for Single Chart.
 @param  reportView.
 @result MDGenerator.
 */
- (id)initWithReportView:(ReportView *)reportView
{
    if (self = [super init]) {
        _reportPageLayoutArray=[[NSMutableArray alloc] init];
        _chartDataArray=[[NSMutableArray alloc] init];
        
    }
    return self;
}

/*!
 @function getReportView
 @abstract -
 @discussion This method get the ReportView which belongs to Dashboard.
 @param  nil.
 @result nil.
 */
- (ReportView *)getReportView:(ReportPageLayout *)reportPageLayout {
    
    ReportView* matchReportView=nil;
    for(ReportView* reportView in _chartDataArray) {
        
        if([reportView.reportViewId isEqualToString:reportPageLayout.reportViewId]) {
            matchReportView = reportView;
            break;
        }
    }
    return matchReportView;
}

/*!
 @function generateMetaDataXML
 @abstract -
 @discussion This method is used to generate MetaData xml, render by MAKIT framework.
 @param  nil.
 @result nil.
 */
- (void)generateMetaDataXML {
    
    // Check whether, do we have Dashbaord layout info to draw MD XML
    if([_reportPageLayoutArray count]) {
        int DrilldownFlag = 0;
        
        for(ReportPageLayout *reportPageLayout in _reportPageLayoutArray) {
            ReportView* reportView=[self getReportView:reportPageLayout];
            //if ([reportView.MAKitChartFunction  isEqual: @"DrillDown"])
              //  DrilldownFlag = 1;
        }
        
        // Create instance of the XML Writer
        XMLWriter* xmlWriter = [[XMLWriter alloc] init];
        
        // Start Document
        [xmlWriter writeStartDocumentWithEncodingAndVersion:@"utf-8" version:@"1.0"];
        
        // Start MobileAnalytic
        [xmlWriter writeStartElement:@"MobileAnalytic"];
        [xmlWriter writeNamespace:@"xsi" namespaceURI:@"http://www.w3.org/2001/XMLSchema-instance"];
        
        // Start Dashboard
        [xmlWriter writeStartElement:@"Dashboard"];
        
        // Creates Charts
        for(ReportPageLayout *reportPageLayout in _reportPageLayoutArray) {
            
            ReportView* reportView=[self getReportView:reportPageLayout];
            
            //NSString* chartName=[self getMAKitLibChartName:reportView.reportViewType];
            NSString* chartName=[reportView MAKitChartType];
            
            //Check for new tile dashboard options in IBP 4.0
            // We don't support these yet.
            //if ([chartName isEqualToString:@"PROCESS"]) {
            //    DLog(@"Unsupported chart type.! : %@", chartName);
            //}
            
            // For showing Combination chart, we have tags different elements in MetaData xml,
            // This condition will validate charttype
            
            // rft
            //  Retrieve attr_types to make future decisions
            ReportViewAttr* reportViewCAttr01=[reportView.reportViewAttrArray objectAtIndex:0];
            ReportViewAttr* reportViewCAttr02=[reportView.reportViewAttrArray objectAtIndex:1];    
            
            //  *******
            //  Drilldown type chart/dashboard
            //  *******
            
            if ([reportView.MAKitChartFunction isEqualToString:@"DrillDown"]) {
                [xmlWriter writeStartElement:@"DrillDownGroup"];
                [xmlWriter writeAttribute:@"Name" value:[NSString stringWithFormat:@"Name%d-%@",[_reportPageLayoutArray indexOfObject:reportPageLayout],reportPageLayout.reportViewId]];
                [xmlWriter writeAttribute:@"Title" value:@""];
                
                [xmlWriter writeStartElement:@"Chart"];
                [xmlWriter writeAttribute:@"Name"
                                value:[NSString stringWithFormat:@"Name%d-%@",[_reportPageLayoutArray indexOfObject:reportPageLayout],reportPageLayout.reportViewId]];
                
                if([[reportView chartsDictionary] count] == 0)
                    [xmlWriter writeAttribute:@"Title" value:[NSString stringWithFormat:@"%@-No data available!",reportPageLayout.reportViewName]];
                else
                    [xmlWriter writeAttribute:@"Title" value:[NSString stringWithFormat:@"%@ (Select full screen then double tap data for drill down.)",reportPageLayout.reportViewName]];

                [xmlWriter writeAttribute:@"ChartType" value:chartName];
                [xmlWriter writeAttribute:@"ChartSequence" value:@"1"];
                [xmlWriter writeAttribute:@"Query" value:[NSString stringWithFormat:@"Query%d-%@-L1",[_reportPageLayoutArray indexOfObject:reportPageLayout],reportPageLayout.reportViewId]];
                
                [xmlWriter writeStartElement:@"Category"];
                [xmlWriter writeAttribute:@"Format" value:@""];
                [xmlWriter writeAttribute:@"Column" value:reportViewCAttr01.attr_Id];
                [xmlWriter writeAttribute:@"DisplayName" value:reportViewCAttr01.attr_name];
                [xmlWriter writeEndElement];
                
                [xmlWriter writeStartElement:@"Series"];
                [xmlWriter writeAttribute:@"Format" value:@""];
                [xmlWriter writeAttribute:@"Column" value:reportViewCAttr02.attr_Id];
                [xmlWriter writeAttribute:@"DisplayName" value:reportViewCAttr02.attr_name];
                [xmlWriter writeEndElement];
                
                int KAttrIndex = reportView.CAttrCount;
                ReportViewAttr* reportViewKAttr01=[reportView.reportViewAttrArray objectAtIndex:KAttrIndex];
                
                //  Values
                [xmlWriter writeStartElement:@"Values"];
                
                for (int i=reportView.CAttrCount; i<(reportView.CAttrCount +reportView.KAttrCount); i++) {
                    ReportViewAttr* reportViewKAttr=[reportView.reportViewAttrArray objectAtIndex:i];
                    [xmlWriter writeStartElement:@"Value"];
                    [xmlWriter writeAttribute:@"Format" value:@""];
                    [xmlWriter writeAttribute:@"Expression" value:reportViewKAttr.attr_Id];
                    NSString *valueSequence = [NSString stringWithFormat:@"%d", (i - reportView.CAttrCount+1)];
                    [xmlWriter writeAttribute:@"ValueSequence" value:valueSequence];
                    [xmlWriter writeAttribute:@"DisplayName" value:reportViewKAttr.attr_name];
                    [xmlWriter writeEndElement];
                }
                
                // End of Values
                [xmlWriter writeEndElement];
                
                // End of General Chart
                [xmlWriter writeEndElement];
                
                if (reportView.CAttrCount > 2) {
                    // Start Chart level 2
                    ReportViewAttr* reportViewCAttr03=[reportView.reportViewAttrArray objectAtIndex:2];
                    
                    [xmlWriter writeStartElement:@"Chart"];
                    [xmlWriter writeAttribute:@"Name" value:[NSString stringWithFormat:@"Name%d-%@",[_reportPageLayoutArray indexOfObject:reportPageLayout],reportPageLayout.reportViewId]];
                    
                    if([[reportView chartsDictionary] count] == 0)
                        [xmlWriter writeAttribute:@"Title" value:[NSString stringWithFormat:@"%@-No data available!",reportPageLayout.reportViewName]];
                    else if (reportView.CAttrCount >3)
                        [xmlWriter writeAttribute:@"Title" value:[NSString stringWithFormat:@"%@-(Double tap data for drill down)",reportPageLayout.reportViewName]];
                    else
                        [xmlWriter writeAttribute:@"Title" value:reportPageLayout.reportViewName];
                    
                    [xmlWriter writeAttribute:@"ChartType" value:chartName];
                    [xmlWriter writeAttribute:@"ChartSequence" value:@"2"];
                    [xmlWriter writeAttribute:@"Query" value:[NSString stringWithFormat:@"Query%d-%@-L2",[_reportPageLayoutArray indexOfObject:reportPageLayout],reportPageLayout.reportViewId]];
                    
                    [xmlWriter writeStartElement:@"Category"];
                    [xmlWriter writeAttribute:@"Format" value:@""];
                    [xmlWriter writeAttribute:@"Column" value:reportViewCAttr02.attr_Id];
                    [xmlWriter writeAttribute:@"DisplayName" value:reportViewCAttr02.attr_name];
                    [xmlWriter writeEndElement];
                    
                    [xmlWriter writeStartElement:@"Series"];
                    [xmlWriter writeAttribute:@"Format" value:@""];
                    [xmlWriter writeAttribute:@"Column" value:reportViewCAttr03.attr_Id];
                    [xmlWriter writeAttribute:@"DisplayName" value:reportViewCAttr03.attr_name];
                    [xmlWriter writeEndElement];
                    
                    //int KAttrIndex = reportView.CAttrCount;
                    //ReportViewAttr* reportViewKAttr01=[reportView.reportViewAttrArray objectAtIndex:KAttrIndex];
                    
                    //  Values
                    [xmlWriter writeStartElement:@"Values"];
                    
                    [xmlWriter writeStartElement:@"Value"];
                    [xmlWriter writeAttribute:@"Format" value:@""];
                    [xmlWriter writeAttribute:@"Expression" value:reportViewKAttr01.attr_Id];
                    [xmlWriter writeAttribute:@"ValueSequence" value:@"1"];
                    [xmlWriter writeAttribute:@"DisplayName" value:reportViewKAttr01.attr_name];
                    [xmlWriter writeEndElement];
                    
                    // End of Values
                    [xmlWriter writeEndElement];
                    
                    // End of General Chart
                    [xmlWriter writeEndElement];
                } //  End drilldown level 2
            
                if (reportView.CAttrCount > 3) {
                    // Start Chart level 3
                    ReportViewAttr* reportViewCAttr03=[reportView.reportViewAttrArray objectAtIndex:2];
                    ReportViewAttr* reportViewCAttr04=[reportView.reportViewAttrArray objectAtIndex:3];
                    
                    [xmlWriter writeStartElement:@"Chart"];
                    [xmlWriter writeAttribute:@"Name" value:[NSString stringWithFormat:@"Name%d-%@",[_reportPageLayoutArray indexOfObject:reportPageLayout],reportPageLayout.reportViewId]];
                    
                    if([[reportView chartsDictionary] count] == 0)
                        [xmlWriter writeAttribute:@"Title" value:[NSString stringWithFormat:@"%@-No data available!",reportPageLayout.reportViewName]];
                    else if (reportView.CAttrCount > 4)
                        [xmlWriter writeAttribute:@"Title" value:[NSString stringWithFormat:@"%@-(Double tap data for drill down)",reportPageLayout.reportViewName]];
                    else
                        [xmlWriter writeAttribute:@"Title" value:reportPageLayout.reportViewName];

                    
                    [xmlWriter writeAttribute:@"ChartType" value:chartName];
                    [xmlWriter writeAttribute:@"ChartSequence" value:@"3"];
                    [xmlWriter writeAttribute:@"Query" value:[NSString stringWithFormat:@"Query%d-%@-L3",[_reportPageLayoutArray indexOfObject:reportPageLayout],reportPageLayout.reportViewId]];
                    
                    [xmlWriter writeStartElement:@"Category"];
                    [xmlWriter writeAttribute:@"Format" value:@""];
                    [xmlWriter writeAttribute:@"Column" value:reportViewCAttr03.attr_Id];
                    [xmlWriter writeAttribute:@"DisplayName" value:reportViewCAttr03.attr_name];
                    [xmlWriter writeEndElement];
                    
                    [xmlWriter writeStartElement:@"Series"];
                    [xmlWriter writeAttribute:@"Format" value:@""];
                    [xmlWriter writeAttribute:@"Column" value:reportViewCAttr04.attr_Id];
                    [xmlWriter writeAttribute:@"DisplayName" value:reportViewCAttr04.attr_name];
                    [xmlWriter writeEndElement];
                    
                    //int KAttrIndex = reportView.CAttrCount;
                    //ReportViewAttr* reportViewKAttr01=[reportView.reportViewAttrArray objectAtIndex:KAttrIndex];
                    
                    //  Values
                    [xmlWriter writeStartElement:@"Values"];
                    
                    [xmlWriter writeStartElement:@"Value"];
                    [xmlWriter writeAttribute:@"Format" value:@""];
                    [xmlWriter writeAttribute:@"Expression" value:reportViewKAttr01.attr_Id];
                    [xmlWriter writeAttribute:@"ValueSequence" value:@"1"];
                    [xmlWriter writeAttribute:@"DisplayName" value:reportViewKAttr01.attr_name];
                    [xmlWriter writeEndElement];
                    
                    // End of Values
                    [xmlWriter writeEndElement];

                    // End of General Chart
                    [xmlWriter writeEndElement];
                    
                }  // End of drilldown level 3 section
                if (reportView.CAttrCount > 4) {
                    // Start Chart level 4
                    
                    if (DrilldownFlag == 1) {
                        [xmlWriter writeStartElement:@"DrillDownGroup"];
                        [xmlWriter writeAttribute:@"Name" value:reportPageLayout.reportViewName];
                        [xmlWriter writeAttribute:@"Title" value:reportPageLayout.reportViewName];
                    }

                    ReportViewAttr* reportViewCAttr04=[reportView.reportViewAttrArray objectAtIndex:3];
                    ReportViewAttr* reportViewCAttr05=[reportView.reportViewAttrArray objectAtIndex:4];
                    
                    [xmlWriter writeStartElement:@"Chart"];
                    [xmlWriter writeAttribute:@"Name" value:[NSString stringWithFormat:@"Name%d-%@",[_reportPageLayoutArray indexOfObject:reportPageLayout],reportPageLayout.reportViewId]];
                    
                    if([[reportView chartsDictionary] count] == 0)
                        [xmlWriter writeAttribute:@"Title" value:[NSString stringWithFormat:@"%@-No data available!",reportPageLayout.reportViewName]];
                    else if (reportView.CAttrCount > 5)
                        [xmlWriter writeAttribute:@"Title" value:[NSString stringWithFormat:@"%@-(Double tap data for drill down)",reportPageLayout.reportViewName]];
                    else
                        [xmlWriter writeAttribute:@"Title" value:reportPageLayout.reportViewName];

                    
                    [xmlWriter writeAttribute:@"ChartType" value:chartName];
                    [xmlWriter writeAttribute:@"ChartSequence" value:@"4"];
                    [xmlWriter writeAttribute:@"Query" value:[NSString stringWithFormat:@"Query%d-%@-L4",[_reportPageLayoutArray indexOfObject:reportPageLayout],reportPageLayout.reportViewId]];
                    
                    [xmlWriter writeStartElement:@"Category"];
                    [xmlWriter writeAttribute:@"Format" value:@""];
                    [xmlWriter writeAttribute:@"Column" value:reportViewCAttr04.attr_Id];
                    [xmlWriter writeAttribute:@"DisplayName" value:reportViewCAttr04.attr_name];
                    [xmlWriter writeEndElement];
                    
                    [xmlWriter writeStartElement:@"Series"];
                    [xmlWriter writeAttribute:@"Format" value:@""];
                    [xmlWriter writeAttribute:@"Column" value:reportViewCAttr05.attr_Id];
                    [xmlWriter writeAttribute:@"DisplayName" value:reportViewCAttr05.attr_name];
                    [xmlWriter writeEndElement];
                    
                    //int KAttrIndex = reportView.CAttrCount;
                    //ReportViewAttr* reportViewKAttr01=[reportView.reportViewAttrArray objectAtIndex:KAttrIndex];
                    
                    //  Values
                    [xmlWriter writeStartElement:@"Values"];
                    
                    [xmlWriter writeStartElement:@"Value"];
                    [xmlWriter writeAttribute:@"Format" value:@""];
                    [xmlWriter writeAttribute:@"Expression" value:reportViewKAttr01.attr_Id];
                    [xmlWriter writeAttribute:@"ValueSequence" value:@"1"];
                    [xmlWriter writeAttribute:@"DisplayName" value:reportViewKAttr01.attr_name];
                    [xmlWriter writeEndElement];
                    
                    // End of Values
                    [xmlWriter writeEndElement];
                    
                    // End of General Chart
                    [xmlWriter writeEndElement];
                    
                }  // End of drilldown level 4 section
                // End DrillDownGroup
                [xmlWriter writeEndElement];

                //  *******
                //  Table type chart/dashboard using MAKit's RFTable
                //  *******
            } else if ([chartName isEqualToString:@"RFTable"]) {
                
                [xmlWriter writeStartElement:@"DataGrid"];
                [xmlWriter writeAttribute:@"Name" value:[NSString stringWithFormat:@"Name%d-%@",[_reportPageLayoutArray indexOfObject:reportPageLayout],reportPageLayout.reportViewId]];
                
                if([[reportView chartsDictionary] count] == 0)
                    [xmlWriter writeAttribute:@"Title" value:[NSString stringWithFormat:@"%@-No data available!",reportPageLayout.reportViewName]];
                else
                    [xmlWriter writeAttribute:@"Title" value:reportPageLayout.reportViewName];
                
                [xmlWriter writeAttribute:@"Query" value:[NSString stringWithFormat:@"Query%d-%@",[_reportPageLayoutArray indexOfObject:reportPageLayout],reportPageLayout.reportViewId]];
                
                //ReportViewAttr* treportViewAttr=[reportView.reportViewAttrArray objectAtIndex:0];
                //int columnCount = [(NSDictionary *) [reportView.chartsDictionary objectAtIndex:0] count];  //  This is where it crashes!
                //int columnCount = CAttrCount + KAttrCount + 1;  // C+K+Index
                int columnCount = [reportView CAttrCount] + [reportView KAttrCount] + 1;  // C+K+Index
                NSLog(@"column count: %d", columnCount);
                
                [xmlWriter writeStartElement:@"Columns"];
                
                [xmlWriter writeStartElement:@"Column"];
                [xmlWriter writeAttribute:@"Type" value:@"Data"];
                [xmlWriter writeAttribute:@"Value" value:@"Index"];
                [xmlWriter writeAttribute:@"Header" value:@"Index"];
                [xmlWriter writeAttribute:@"IsHeaderColumn" value:[NSString stringWithFormat:@"%d",(1)]];
                [xmlWriter writeEndElement];
                 
                
                //  Loop through table columns
                for (int i = 1; i<columnCount; i++) {
                    //ReportViewAttr* treportViewAttr=[reportView.reportViewAttrArray objectAtIndex:i];
                    /**
                    if (i == 0) {
                        [xmlWriter writeStartElement:@"Column"];
                        [xmlWriter writeAttribute:@"Type" value:@"Data"];
                        [xmlWriter writeAttribute:@"Value" value:treportViewAttr.attr_Id];
                        [xmlWriter writeAttribute:@"Header" value:treportViewAttr.attr_name];
                        [xmlWriter writeAttribute:@"IsHeaderColumn" value:[NSString stringWithFormat:@"%d",(i+1)]];
                        [xmlWriter writeEndElement];

                    } else {
                     **/
                        ReportViewAttr* treportViewAttr=[reportView.reportViewAttrArray objectAtIndex:(i-1)];
                        [xmlWriter writeStartElement:@"Column"];
                        [xmlWriter writeAttribute:@"Type" value:@"Data"];
                        [xmlWriter writeAttribute:@"Value" value:treportViewAttr.attr_Id];
                        //[xmlWriter writeAttribute:@"Format" value:@"Rounded0"];
                        [xmlWriter writeAttribute:@"Header" value:treportViewAttr.attr_name];
                        [xmlWriter writeAttribute:@"ColumnSequence" value:[NSString stringWithFormat:@"%d", i]];
                        [xmlWriter writeEndElement];
                    //}
                }
                // End columns
                [xmlWriter writeEndElement];
                // End DataGrid
                [xmlWriter writeEndElement];
                
            
            } else if ([reportView CAttrCount] > 1 && [reportView SCNIDFlag] > 0) {
            //  *******
            //  Chart definition with more than 1 group-by with one being SCNID
            //  *******

                NSLog(@"MAKit xml gen - inside new check section.");
                
                // Chart with 2 or more C attributes including SCNID
                // General Charts
                [xmlWriter writeStartElement:@"Chart"];
                [xmlWriter writeAttribute:@"Name" value:[NSString stringWithFormat:@"Name%d-%@",[_reportPageLayoutArray indexOfObject:reportPageLayout],reportPageLayout.reportViewId]];
                
                if([[reportView chartsDictionary] count] == 0)
                    [xmlWriter writeAttribute:@"Title" value:[NSString stringWithFormat:@"%@-No data available!",reportPageLayout.reportViewName]];
                else if ([reportView CAttrCount] > 2 ) {
                    [xmlWriter writeAttribute:@"Title" value:[NSString stringWithFormat:@"%@-Unsupported mobile chart configuration!", reportPageLayout.reportViewName]];
                    reportView.isMobileEnabled2 = @"NO";
                } else
                    [xmlWriter writeAttribute:@"Title" value:reportPageLayout.reportViewName];
                
                [xmlWriter writeAttribute:@"ChartType" value:chartName];
                [xmlWriter writeAttribute:@"Query" value:[NSString stringWithFormat:@"Query%d-%@",[_reportPageLayoutArray indexOfObject:reportPageLayout],reportPageLayout.reportViewId]];
                
                [xmlWriter writeStartElement:@"Category"];
                [xmlWriter writeAttribute:@"Format" value:@""];
                [xmlWriter writeAttribute:@"Column" value:reportViewCAttr01.attr_Id];
                [xmlWriter writeAttribute:@"DisplayName" value:reportViewCAttr01.attr_name];
                [xmlWriter writeEndElement];
                
                [xmlWriter writeStartElement:@"Series"];
                [xmlWriter writeAttribute:@"Format" value:@""];
                [xmlWriter writeAttribute:@"Column" value:@"keyKey"];
                [xmlWriter writeAttribute:@"DisplayName" value:reportViewCAttr02.attr_name];
                [xmlWriter writeEndElement];
                
                //  Values
                [xmlWriter writeStartElement:@"Values"];
                
                [xmlWriter writeStartElement:@"Value"];
                [xmlWriter writeAttribute:@"Format" value:@""];
                [xmlWriter writeAttribute:@"Expression" value:@"valueKey"];
                [xmlWriter writeAttribute:@"ValueSequence" value:@"1"];
                [xmlWriter writeAttribute:@"DisplayName" value:@""];
                [xmlWriter writeEndElement];
             
                // End of Values
                [xmlWriter writeEndElement];
                
                // End of General Chart
                [xmlWriter writeEndElement];
                
            
            } else if(![chartName isEqualToString:@"OverlayChart"]){
            //  *******
            //  General charts
            //  *******
                
                [xmlWriter writeStartElement:@"Chart"];
                [xmlWriter writeAttribute:@"Name" value:[NSString stringWithFormat:@"Name%d-%@",[_reportPageLayoutArray indexOfObject:reportPageLayout],reportPageLayout.reportViewId]];
                
                if([[reportView chartsDictionary] count] == 0)
                    [xmlWriter writeAttribute:@"Title" value:[NSString stringWithFormat:@"%@-\nNo data available!",reportPageLayout.reportViewName]];
                else if ([reportView CAttrCount] > 2 ) {
                    [xmlWriter writeAttribute:@"Title" value:[NSString stringWithFormat:@"%@-Unsupported mobile chart configuration!", reportPageLayout.reportViewName]];
                    reportView.isMobileEnabled2 = @"NO";
                } else
                    [xmlWriter writeAttribute:@"Title" value:reportPageLayout.reportViewName];
                
                [xmlWriter writeAttribute:@"ChartType" value:chartName];
                [xmlWriter writeAttribute:@"Query" value:[NSString stringWithFormat:@"Query%d-%@",[_reportPageLayoutArray indexOfObject:reportPageLayout],reportPageLayout.reportViewId]];
                
                // Import all time a 'Category' Attribute except for Pie chart (represent by Sequence 1)
                ReportViewAttr* reportViewAttr01=[reportView.reportViewAttrArray objectAtIndex:0];
                
                if(![chartName isEqualToString:@"Pie"]){ // if the chart type is not Pie
                    // Category
                    if(reportViewAttr01) {
                        [xmlWriter writeStartElement:@"Category"];
                        [xmlWriter writeAttribute:@"Format" value:@""];
                        [xmlWriter writeAttribute:@"Column" value:reportViewAttr01.attr_Id];
                        [xmlWriter writeAttribute:@"DisplayName" value:reportViewAttr01.attr_name];
                        [xmlWriter writeEndElement];
                    }
                    
                    // Import 'Series' attribute with Type C (represent by Sequence 2 only if it is Character)
                    ReportViewAttr* reportViewAttr02=[reportView.reportViewAttrArray objectAtIndex:1];
                    if([reportViewAttr02.attr_type isEqualToString:@"C"]) {
                        // Series
                        [xmlWriter writeStartElement:@"Series"];
                        [xmlWriter writeAttribute:@"Format" value:@""];
                        [xmlWriter writeAttribute:@"Column" value:reportViewAttr02.attr_Id];
                        [xmlWriter writeAttribute:@"DisplayName" value:reportViewAttr02.attr_name];
                        [xmlWriter writeEndElement];
                    }
                    // If sequence 2 has attr_type K (i e Number) then we have to write Series tag with out custom key
                    // called keyKey because sequence 2 is number it belongs to be part of Values tag
                    else {
                        // Series
                        [xmlWriter writeStartElement:@"Series"];
                        [xmlWriter writeAttribute:@"Format" value:@""];
                        [xmlWriter writeAttribute:@"Column" value:@"keyKey"];
                        [xmlWriter writeAttribute:@"DisplayName" value:@"Attributes"];
                        [xmlWriter writeEndElement];
                    }
                }
                else {
                    // If chart type is Pie, we must include Series tag in xml file
                    // and Yes only series, no Category tag
                    if(reportViewAttr01) {
                        [xmlWriter writeStartElement:@"Series"];
                        [xmlWriter writeAttribute:@"Format" value:@""];
                        [xmlWriter writeAttribute:@"Column" value:reportViewAttr01.attr_Id];
                        [xmlWriter writeAttribute:@"DisplayName" value:reportViewAttr01.attr_name];
                        [xmlWriter writeEndElement];
                    }
                    
                }
            
                // Values
                [xmlWriter writeStartElement:@"Values"];
                
                ReportViewAttr* reportViewAttr02=[reportView.reportViewAttrArray objectAtIndex:1];
                //reportViewAttr02=[reportView.reportViewAttrArray objectAtIndex:1];
                
                // If Sequence 2 is character (C), and we only have 3 Attributes and Chart Type is not Pie
                // then we have to consider 3rd Attribute as all time Value tag
                if([reportViewAttr02.attr_type isEqualToString:@"C"] &&
                   [reportView.reportViewAttrArray count]==3 &&
                   ![chartName isEqualToString:@"Pie"]) {
                    
                    // Value 1
                    ReportViewAttr* reportViewAttr03=[reportView.reportViewAttrArray objectAtIndex:2];
                    [xmlWriter writeStartElement:@"Value"];
                    [xmlWriter writeAttribute:@"Format" value:@"Rounded2"];
                    [xmlWriter writeAttribute:@"Expression" value:reportViewAttr03.attr_Id];
                    [xmlWriter writeAttribute:@"ValueSequence" value:@"1"];
                    [xmlWriter writeAttribute:@"DisplayName" value:reportViewAttr03.attr_name];
                    [xmlWriter writeEndElement];
                }
                else {
                    // If sequence 2 has attr_type K (i e Number) then we have to write Value tag with out custom key
                    // called valueKey because sequence 2 is number it belongs to be part of Values tag
                    // Value 1
                    [xmlWriter writeStartElement:@"Value"];
                    [xmlWriter writeAttribute:@"Format" value:@"Rounded2"];
                    [xmlWriter writeAttribute:@"Expression" value:@"valueKey"];
                    [xmlWriter writeAttribute:@"ValueSequence" value:@"1"];
                    [xmlWriter writeAttribute:@"DisplayName" value:@"Values"];
                    [xmlWriter writeEndElement];
                }
                
                // End of Values
                [xmlWriter writeEndElement];
                
                // End of General Chart
                [xmlWriter writeEndElement];

            }
            // For chart with the combination type, we will maintain Column chart for layer 1
            // And Line chart for layer 2
            else {
            //  *******
            // Combination Charts
            //  *******

                [xmlWriter writeStartElement:@"OverlayGroup"];
                [xmlWriter writeAttribute:@"Name" value:[NSString stringWithFormat:@"Name%d-%@",[_reportPageLayoutArray indexOfObject:reportPageLayout],reportPageLayout.reportViewId]];
                //[xmlWriter writeAttribute:@"Title" value:reportPageLayout.reportViewName];
                
                if([[reportView chartsDictionary] count] == 0)
                    [xmlWriter writeAttribute:@"Title" value:[NSString stringWithFormat:@"%@-No data available!",reportPageLayout.reportViewName]];
                else if ([reportView CAttrCount] > 2 || ([reportView SCNIDFlag] > 0 && [reportView CAttrCount] > 1)) {
                    [xmlWriter writeAttribute:@"Title" value:[NSString stringWithFormat:@"%@-Unsupported mobile chart configuration!", reportPageLayout.reportViewName]];
                    reportView.isMobileEnabled2 = @"NO";
                } else
                    [xmlWriter writeAttribute:@"Title" value:reportPageLayout.reportViewName];
                
                // Import all time a 'Category' Attribute except for Pie chart (represent by Sequence 1)
                ReportViewAttr* reportViewAttr01=[reportView.reportViewAttrArray objectAtIndex:0];
                
                // Category
                if(reportViewAttr01) {
                    
                    [xmlWriter writeStartElement:@"Category"];
                    [xmlWriter writeAttribute:@"Format" value:@""];
                    [xmlWriter writeAttribute:@"Column" value:reportViewAttr01.attr_Id];
                    [xmlWriter writeAttribute:@"DisplayName" value:reportViewAttr01.attr_name];
                    [xmlWriter writeEndElement];
                }
                
                // Sequence 1 is Category so Rest other Sequences can be represent as Layers for Combination chart
                for(ReportViewAttr* reportViewAttr in reportView.reportViewAttrArray){
                    
                    // Skiping sequence 1 only
                    if(reportViewAttr!=reportViewAttr01) {
                        
                        // We will need chart sequence to represent unique Query for evry chart layer
                        int chartSequence=[reportView.reportViewAttrArray indexOfObject:reportViewAttr];
                        
                        // Position 1 in array represent Sequnce number 2 so it will consider as Column chart
                        // For rest of the sequence it is consider as Line chart
                        NSString *chartName=(chartSequence==1)?@"Column":@"Line";
                        
                        // Layer
                        [xmlWriter writeStartElement:@"Layer"];
                        [xmlWriter writeAttribute:@"Name" value:reportViewAttr.attr_Id];
                        [xmlWriter writeAttribute:@"Title" value:reportViewAttr.attr_name];
                        [xmlWriter writeAttribute:@"ChartType" value:chartName];
                        [xmlWriter writeAttribute:@"ChartSequence" value:[NSString stringWithFormat:@"%d",chartSequence]];
                        [xmlWriter writeAttribute:@"Query" value:[NSString stringWithFormat:@"%@-%d",reportPageLayout.reportViewId, [reportViewAttr.sequence intValue]-1]];
                        
                        // For Column chart or if all attributes count is 3 (layer 2 can be line chart), we will make reused of all 3 attributes as part of value inside the layer tag
                        
                        if([chartName isEqualToString:@"Column"] || [reportView.reportViewAttrArray count] == 3) {
                            
                            // Values
                            [xmlWriter writeStartElement:@"Values"];
                            
                            // Value 1
                            [xmlWriter writeStartElement:@"Value"];
                            [xmlWriter writeAttribute:@"Format" value:@"Rounded2"];
                            [xmlWriter writeAttribute:@"Expression" value:reportViewAttr.attr_Id];
                            [xmlWriter writeAttribute:@"ValueSequence" value:@"1"];
                            [xmlWriter writeAttribute:@"DisplayName" value:reportViewAttr.attr_name];
                            [xmlWriter writeEndElement];
                            
                            // End of Values
                            [xmlWriter writeEndElement];
                        }
                        // For Line chart and if all attributes count is greater than 3,
                        // then  we have to write Series tag with out custom key
                        // called keyKey as greater than 3 means all other Attributes are Numbers (K)

                        else {
                            
                            // Series
                            [xmlWriter writeStartElement:@"Series"];
                            [xmlWriter writeAttribute:@"Format" value:@""];
                            [xmlWriter writeAttribute:@"Column" value:@"keyKey"];
                            [xmlWriter writeAttribute:@"DisplayName" value:@"Attributes"];
                            [xmlWriter writeEndElement];
                            
                            // Values
                            [xmlWriter writeStartElement:@"Values"];
                            
                            // As we have more than 3 attributes then we have to write Value tag with out custom key
                            // called valueKey
                            // Value 1
                            [xmlWriter writeStartElement:@"Value"];
                            [xmlWriter writeAttribute:@"Format" value:@"Rounded2"];
                            [xmlWriter writeAttribute:@"Expression" value:@"valueKey"];
                            [xmlWriter writeAttribute:@"ValueSequence" value:@"1"];
                            [xmlWriter writeAttribute:@"DisplayName" value:@"Values"];
                            [xmlWriter writeEndElement];
                            
                            // End of Values
                            [xmlWriter writeEndElement];
                            
                            // End of Layer
                            [xmlWriter writeEndElement];
                            break;
                            
                        }
                        
                        // End of Layer
                        [xmlWriter writeEndElement];
                    }// End of if -skiping sequence 1
                }// End of for loop for drawing multiple layers inside Overlay Chart
                
                // End of Overlaygroup
                [xmlWriter writeEndElement];
                
            }// end of else
        }
        
        // End of Dashboard
        [xmlWriter writeEndElement];
        
        // We will write layout only if dashboard has 2 more charts max 4
        if([_chartDataArray count] >1) {
            
            // DashboardLayout
            [xmlWriter writeStartElement:@"DashboardLayout"];
            
            // Landscape
            [xmlWriter writeStartElement:@"Landscape"];
            
            
            for(int i = 1 ; i <= [_reportPageLayoutArray count]; i++) {
                
                // Get Page Layout instance for each chart to get charts position
                ReportPageLayout* reportPageLayout=[_reportPageLayoutArray objectAtIndex:i-1];
                
                // Intial value for frames
                int top=1, left=1, width=48, height=48;
                
                // If 2 charts are there, width will change
                if([_chartDataArray count]==2) {
                    
                    width=98;
                    if(i==2) {
                        //For second chart in Dashboard top will change
                        top=50;
                    }
                }
                // If 3 charts are there then for 2nd chart left will change
                // for 3rd chard top and width will change
                else if([_chartDataArray count]==3) {
                    
                    if(i==2) {
                        left=51;
                    }
                    else if(i==3) {
                        top=50;
                        width=98;
                    }
                }
                // If 4 charts are there then for 2nd chart left will change
                // for 3rd chard top will change and 4th, top and left will change
                else if([_chartDataArray count]==4)  {
                    
                    if(i==2) {
                        left=51;
                    }
                    else if(i==3) {
                        top=50;
                    }
                    else if(i==4) {
                        top=50;
                        left=51;
                    }
                }
                
                // Layout
                [xmlWriter writeStartElement:@"Layout"];
                
                [xmlWriter writeAttribute:@"Name" value:[NSString stringWithFormat:@"Name%d-%@",[_reportPageLayoutArray indexOfObject:reportPageLayout],reportPageLayout.reportViewId]];
                [xmlWriter writeAttribute:@"Top" value:[NSString stringWithFormat:@"%d",top]];
                [xmlWriter writeAttribute:@"Left" value:[NSString stringWithFormat:@"%d",left]];
                [xmlWriter writeAttribute:@"Width" value:[NSString stringWithFormat:@"%d",width]];
                [xmlWriter writeAttribute:@"Height" value:[NSString stringWithFormat:@"%d",height]];
                
                // end of Layout
                [xmlWriter writeEndElement];
            }
            
            // end of Landscape
            [xmlWriter writeEndElement];
            
            //If we want only landscape mode.
            // end of Dashboard Layout
            //[xmlWriter writeEndElement];
            
            ///For Portrait Mode
            // We will write layout only if dashboard has 2 more charts max 4
                
                // Portrait
                [xmlWriter writeStartElement:@"Portrait"];
                
                
                for(int i = 1 ; i <= [_reportPageLayoutArray count]; i++) {
                    
                    // Get Page Layout instance for each chart to get charts position
                    ReportPageLayout* reportPageLayout=[_reportPageLayoutArray objectAtIndex:i-1];
                    
                    // Intial value for frames
                    int top=1, left=1, width=48, height=48;
                    
                    // If 2 charts are there, width will change
                    if([_chartDataArray count]==2) {
                        
                        width=98;
                        if(i==2) {
                            //For second chart in Dashboard top will change
                            top=50;
                        }
                    }
                    // If 3 charts are there then for 2nd chart left will change
                    // for 3rd chard top and width will change
                    else if([_chartDataArray count]==3) {
                        
                        if(i==2) {
                            left=51;
                        }
                        else if(i==3) {
                            top=50;
                            width=98;
                        }
                    }
                    // If 4 charts are there then for 2nd chart left will change
                    // for 3rd chard top will change and 4th, top and left will change
                    else if([_chartDataArray count]==4)  {
                        
                        if(i==2) {
                            left=51;
                        }
                        else if(i==3) {
                            top=50;
                        }
                        else if(i==4) {
                            top=50;
                            left=51;
                        }
                    }
                    
                    // Layout
                    [xmlWriter writeStartElement:@"Layout"];
                    
                    [xmlWriter writeAttribute:@"Name" value:[NSString stringWithFormat:@"Name%d-%@",[_reportPageLayoutArray indexOfObject:reportPageLayout],reportPageLayout.reportViewId]];
                    [xmlWriter writeAttribute:@"Top" value:[NSString stringWithFormat:@"%d",top]];
                    [xmlWriter writeAttribute:@"Left" value:[NSString stringWithFormat:@"%d",left]];
                    [xmlWriter writeAttribute:@"Width" value:[NSString stringWithFormat:@"%d",width]];
                    [xmlWriter writeAttribute:@"Height" value:[NSString stringWithFormat:@"%d",height]];
                    
                    // end of Layout
                    [xmlWriter writeEndElement];
                }
                
                // end of Portrait
                [xmlWriter writeEndElement];
                
                // end of Dashboard Layout
                [xmlWriter writeEndElement];
                
                ///End of portrait Mode
        }
        // End of MobileAnalytic
        [xmlWriter writeEndElement];
        
        // End of document
        [xmlWriter writeEndDocument];
        
        [[xmlWriter toString] writeToFile:kMetaDataDashboardFileName atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }
}

/*!
 @function getMAKitLibChartName
 @abstract -
 @discussion This method is used to get the name of Chart, which is understand by MAKIT
             becuase the response we got from OData Call has different charts name.
 @param  chartType.
 @result MAKIT chartName.
 */
-(NSString *)getMAKitLibChartName:(NSString *)chartType {
    
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
        CASE (@"hbar stacked") {
            chartName=@"StackedColumn";
            break;
        }
        CASE (@"table") {       // rft
            chartName=@"RFTable";
        }
        DEFAULT {
            break;
        }
    }
    
    
    return chartName;
}

@end
