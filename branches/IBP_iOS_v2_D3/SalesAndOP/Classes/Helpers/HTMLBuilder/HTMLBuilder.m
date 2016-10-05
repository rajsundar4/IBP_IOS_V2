//
//  HTMLBuilder.m
//  IBP
//
//  Created by Rick Thompson on 11/14/14.
//  Copyright (c) 2014 Linear Logics Corporation. All rights reserved.
//


#import "HTMLBuilder.h"
#import "sapsopaServiceDeclarations.h"
#import "Constants.h"
#import "WebviewCellVC.h"

static NSString *HTML_HEADER = @"<!DOCTYPE html>\n\
<html>\n\
<head>\n\
<meta http-equiv=\"X-UA-Compatible\" content=\"IE=edge\" />\n\
<meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\">\n";

static NSString *HTML_HEADER_CLOSE =@"</head>\n";

static NSString *PAGE_TITLE = @"<title>Dummy page title</title>\n";

static NSString *SAPUI5_BOOTSTRAP_SCRIPT = @"<script id=\"sap-ui-bootstrap\" type=\"text/javascript\"\
src=\"sapui5-static/resources/sap-ui-core.js\" data-sap-ui-libs=\"sap.ui.commons,sap.viz\">\
</script>\n";

static NSString *SAPUI5_ITEMS_PUSH_SCRIPT = @"<script type=\"text/javascript\" src=\"sapui5-static/test-resources/sap/viz/mobile/js/items_push.js\"></script>\n";

static NSString *SAPUI5_GET_LOCALE_BODY = @"<body\n<script>\nvar sCurrentLocale = sap.ui.getCore().getConfiguration().getLocale();\ndocument.write(sCurrentLocale);\n</script>\n<\body>";

static NSString *COLOR_PALETTE = @"plotArea:{\n'colorPalette' : ['#21a3f1','#ff872e','#79b51a','#f7e326','#074389','#7876e5','#d5eb7e','#488bed','#ffc145','#8a8175','#0b7c16']},\n";

static NSString *HEATMAP_COLOR_PALETTE = @"plotArea:{\ncolorPalette : ['#21a3f1','#338fb5','#457c79','#56683c','#685400']},\n";

#define VIZ_DB_HEIGHT_LANDSCAPE 225
#define VIZ_FULL_HEIGHT 600

@implementation HTMLBuilder

@synthesize chartHeight;


- (id) init
{
    if (self = [super init]) {
        _htmlpage = [[NSMutableString alloc] init];
    }
    
    return self;
}

- (NSMutableString *) buildHTMLChartWithData:(ReportView *) chart andDBFlag:(BOOL)DBFlag
{
    
    if (DBFlag == true) {
        _chartTitleFlag = @"false";
        chartHeight = [NSString stringWithFormat:@"%d",VIZ_DB_HEIGHT_LANDSCAPE];
    } else {
        _chartTitleFlag = @"true";
        chartHeight = [NSString stringWithFormat:@"%d",VIZ_FULL_HEIGHT];
    }
    
    if (([chart.reportViewType caseInsensitiveCompare:@"HORIZONTAL BAR"] == NSOrderedSame) || ([chart.reportViewType caseInsensitiveCompare:@"BAR"] == NSOrderedSame)) {
        [self buildBarChartHTMLwithChartsDictionaryData:chart andDBFlag:(BOOL)DBFlag];

    
    } else if ([chart.reportViewType caseInsensitiveCompare:@"LINE"] == NSOrderedSame) {
        [self buildLineChartHTMLwithChartsDictionaryData:chart andDBFlag:(BOOL)DBFlag];
        
    } else if (([chart.reportViewType caseInsensitiveCompare:@"COLUMN"] == NSOrderedSame) || ([chart.reportViewType caseInsensitiveCompare:@"Vertical Bar Cluster"] == NSOrderedSame)) {
        [self buildColumnChartHTMLwithChartsDictionaryData:chart andDBFlag:(BOOL)DBFlag];
    } else if ([chart.reportViewType caseInsensitiveCompare:@"HEATMAP"] == NSOrderedSame) {
        [self buildHeatmapChartHTMLwithChartsDictionaryData:chart andDBFlag:(BOOL)DBFlag];
    } else if ([chart.reportViewType caseInsensitiveCompare:@"PIE"] == NSOrderedSame) {
        [self buildPieChartHTMLwithChartsDictionaryData:chart andDBFlag:(BOOL)DBFlag];
    } else if ([chart.reportViewType caseInsensitiveCompare:@"DONUT"] == NSOrderedSame) {
        [self buildDonutChartHTMLwithChartsDictionaryData:chart andDBFlag:(BOOL)DBFlag];
    } else if ([chart.reportViewType caseInsensitiveCompare:@"COMBINATION"] == NSOrderedSame) {
        [self buildCombinationChartHTMLwithChartsDictionaryData:chart andDBFlag:(BOOL)DBFlag];
    } else if ([chart.reportViewType caseInsensitiveCompare:@"BAR STACKED"] == NSOrderedSame) {
        [self buildStackedColumnChartHTMLwithChartsDictionaryData:chart andDBFlag:(BOOL)DBFlag];
    } else if ([chart.reportViewType caseInsensitiveCompare:@"DUAL X-AXIS BAR"] == NSOrderedSame) {
        [self buildDualBarChartHTMLwithChartsDictionaryData:chart andDBFlag:(BOOL)DBFlag];
    } else {
        //  unsupported chart type message page
        [self unsupportedChartTypePage:(ReportView *) chart];
    }
    
    [self writeToFileWithFilename:[NSString stringWithFormat:@"%@.html",chart.reportViewName]];

    return _htmlpage;
}


- (void) appendSAPUI5BootstrapScript
{
    NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
    [_htmlpage appendFormat:@"<script id=\"sap-ui-bootstrap\" type=\"text/javascript\"\
     src=\"%@sapui5-static/resources/sap-ui-core.js\" data-sap-ui-libs=\"sap.ui.commons,sap.viz\">\
     </script>\n", resourcePath];
    
}



- (void) writeToFileWithFilename:(NSString *)filename
{
    //  Write to Documents directory
    NSString *filepath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingFormat:@"/%@",filename];
    [_htmlpage writeToFile:filepath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
}

//
//  Generates the html for a Viz Line chart
//  IBP chart type = Line
//  This method uses chartsDictionary data (not attrArray->valuesArray)

- (void) buildLineChartHTMLwithChartsDictionaryData:(ReportView *)chart andDBFlag:(BOOL)DBFlag
{
    
    NSString *dataMaximumString = [self findDataMaximum:chart];
    NSString *axisFormatString = [self formatNumberString:dataMaximumString];
    
    [self addHTMLPageTop];
    
    // first sort chartsdictionary by C-type attribute
    
    NSArray *dataDictionaryArray = chart.chartsDictionary;
    NSArray *attributesArray = chart.reportViewAttrArray;
    
    //  Loop through dictionary array
    for (NSDictionary *dataDictionary in dataDictionaryArray) {
        [_htmlpage appendString:@"{"];
        //  Loop through dictionary items (attributes)
        for (ReportViewAttr *attribute in attributesArray) {
            if ([attribute.attr_type isEqualToString:@"C"]) {
                [_htmlpage appendFormat:@"%@:\"%@\", ",attribute.attr_Id, [dataDictionary objectForKey:attribute.attr_Id]];
            }  else if ([attribute.attr_type isEqualToString:@"K"]) {
                if ([[dataDictionary objectForKey:attribute.attr_Id] isKindOfClass:[NSNull class]])
                //if ([[dataDictionary objectForKey:attribute.attr_Id] isEqualToString:@"<null>"])
                    [_htmlpage appendFormat:@"%@:null, ",attribute.attr_Id];
                else
                    [_htmlpage appendFormat:@"%@:%@, ",attribute.attr_Id, [dataDictionary objectForKey:attribute.attr_Id]];
            }
        }
        [_htmlpage deleteCharactersInRange:NSMakeRange([_htmlpage length]-2, 2)];
        [_htmlpage appendString:@"},\n"];
    }
    
    [_htmlpage appendString:@"]\n});\n"];
    [_htmlpage appendString:@"sap.ui.getCore().setModel(oModel);\n"];
    
    //  Build dataset
    
    [_htmlpage appendString:@"var dataset = new sap.viz.ui5.data.FlattenedDataset({\ndimensions : [\n"];
    
    // Dimensions
    // Loop through attribute arrays
    for(ReportViewAttr *attribute in chart.reportViewAttrArray) {
        if ([attribute.attr_type isEqualToString:@"C"] && [attribute.sequence isEqualToNumber:[NSNumber numberWithInt:1]]) {
            [_htmlpage appendFormat:@"{axis : 1, name : '%@', value: \"{%@}\"},\n",attribute.attr_name, attribute.attr_Id];
        } else if ([attribute.attr_type isEqualToString:@"C"]) {
            [_htmlpage appendFormat:@"{axis : 2, name : '%@', value: \"{%@}\"},\n",attribute.attr_name, attribute.attr_Id];
        }
    }
    //[_htmlpage deleteCharactersInRange:NSMakeRange([_htmlpage length]-2, 2)];
    [_htmlpage appendString:@"],\n"];
    
    // Measures
    // Loop through attribute arrays
    [_htmlpage appendString:@"measures : ["];
    for(ReportViewAttr *attribute in chart.reportViewAttrArray) {
        if ([attribute.attr_type isEqualToString:@"K"]) {
            [_htmlpage appendFormat:@"{name : '%@', value : \"{%@}\"},\n",attribute.attr_name, attribute.attr_Id];
        }
    }
    //[_htmlpage deleteCharactersInRange:NSMakeRange([_htmlpage length]-2, 2)];
    [_htmlpage appendString:@"],\ndata : { path : \"/data\" }\n});\n"];
    
    // Chart type
    [_htmlpage appendFormat:@"new sap.viz.ui5.Line(\"oChart\",{\nwidth : \"100%%\",\nheight : \"%@px\",\n", chartHeight];
    [_htmlpage appendString:COLOR_PALETTE];
    [_htmlpage appendFormat:@"title : { visible : %@, text :'%@' },\n", _chartTitleFlag, chart.reportViewName];
    [_htmlpage appendFormat:@"yAxis : { label : { formatString : %@ }},\n", axisFormatString];
    [_htmlpage appendString:@"dataset: dataset\n}).placeAt(\"content\");\n</script>\n</head>\n"];
    
    [self addHTMLPageBottom];
}

//
//  Generates the html for a Viz Column chart
//  IBP chart type = Vertical Bar Cluster
//  This method uses chartsDictionary data (not attrArray->valuesArray)

- (void) buildColumnChartHTMLwithChartsDictionaryData:(ReportView *)chart andDBFlag:(BOOL)DBFlag
{
    NSString *dataMaximumString = [self findDataMaximum:chart];
    NSString *axisFormatString = [self formatNumberString:dataMaximumString];
    [self addHTMLPageTop];
    
    // first sort chartsdictionary by C-type attribute
    
    NSArray *dataDictionaryArray = chart.chartsDictionary;
    NSArray *attributesArray = chart.reportViewAttrArray;
    
    //  Loop through dictionary array
    for (NSDictionary *dataDictionary in dataDictionaryArray) {
        [_htmlpage appendString:@"{"];
        //  Loop through dictionary items (attributes)
        for (ReportViewAttr *attribute in attributesArray) {
            if ([attribute.attr_type isEqualToString:@"C"]) {
                [_htmlpage appendFormat:@"%@:\"%@\", ",attribute.attr_Id, [dataDictionary objectForKey:attribute.attr_Id]];
            }  else if ([attribute.attr_type isEqualToString:@"K"]) {
                if ([[dataDictionary objectForKey:attribute.attr_Id] isKindOfClass:[NSNull class]])
                //if ([[dataDictionary objectForKey:attribute.attr_Id] isEqualToString:@"<null>"])
                    [_htmlpage appendFormat:@"%@:null, ",attribute.attr_Id];
                else
                    [_htmlpage appendFormat:@"%@:%@, ",attribute.attr_Id, [dataDictionary objectForKey:attribute.attr_Id]];
            }
        }
        [_htmlpage deleteCharactersInRange:NSMakeRange([_htmlpage length]-2, 2)];
        [_htmlpage appendString:@"},\n"];
    }
    
    [_htmlpage appendString:@"]\n});\n"];
    [_htmlpage appendString:@"sap.ui.getCore().setModel(oModel);\n"];
    
    //  Build dataset
    
    [_htmlpage appendString:@"var dataset = new sap.viz.ui5.data.FlattenedDataset({\ndimensions : [\n"];
    
    // Dimensions
    // Loop through attribute arrays
    for(ReportViewAttr *attribute in chart.reportViewAttrArray) {
        if ([attribute.attr_type isEqualToString:@"C"] && [attribute.sequence isEqualToNumber:[NSNumber numberWithInt:1]]) {
            [_htmlpage appendFormat:@"{axis : 1, name : '%@', value: \"{%@}\"},\n",attribute.attr_name, attribute.attr_Id];
        } else if ([attribute.attr_type isEqualToString:@"C"]) {
            [_htmlpage appendFormat:@"{axis : 2, name : '%@', value: \"{%@}\"},\n",attribute.attr_name, attribute.attr_Id];
        }
    }
    //[_htmlpage deleteCharactersInRange:NSMakeRange([_htmlpage length]-2, 2)];
    [_htmlpage appendString:@"],\n"];
    
    // Measures
    // Loop through attribute arrays
    [_htmlpage appendString:@"measures : ["];
    for(ReportViewAttr *attribute in chart.reportViewAttrArray) {
        if ([attribute.attr_type isEqualToString:@"K"]) {
            [_htmlpage appendFormat:@"{name : '%@', value : \"{%@}\"},\n",attribute.attr_name, attribute.attr_Id];
        }
    }
    //[_htmlpage deleteCharactersInRange:NSMakeRange([_htmlpage length]-2, 2)];
    [_htmlpage appendString:@"],\ndata : { path : \"/data\" }\n});\n"];
    
    // Chart type
    [_htmlpage appendFormat:@"new sap.viz.ui5.Column(\"oChart\",{\nwidth : \"100%%\",\nheight : \"%@px\",\n", chartHeight];
    [_htmlpage appendString:COLOR_PALETTE];
    
    [_htmlpage appendFormat:@"title : { visible : %@, text :'%@' },\n", _chartTitleFlag, chart.reportViewName];
    [_htmlpage appendFormat:@"yAxis : { label : { formatString : %@ }},\n", axisFormatString];
    [_htmlpage appendString:@"dataset: dataset\n}).placeAt(\"content\");\n</script>\n</head>\n"];
    
    [self addHTMLPageBottom];
}

//
//  Generates the html for a Viz Bar chart
//  IBP chart type = Horizontal Bar
//  This method uses chartsDictionary data (not attrArray->valuesArray)
//

- (void) buildBarChartHTMLwithChartsDictionaryData:(ReportView *)chart andDBFlag:(BOOL)DBFlag
{
    NSString *dataMaximumString = [self findDataMaximum:chart];
    NSString *axisFormatString = [self formatNumberString:dataMaximumString];
    [self addHTMLPageTop];
    
    // first sort chartsdictionary by C-type attribute
    
    NSArray *dataDictionaryArray = chart.chartsDictionary;
    NSArray *attributesArray = chart.reportViewAttrArray;
    
//    NSString *pieDataSet = @"[ { x_key:\"A\", y_value: 5 },{ x_key: \"B\", y_value: 10 }]";
//    NSString *funcString = [NSString stringWithFormat:@"updateGraph(%@)", pieDataSet];
    //[_webView evaluateJavaScript:funcString completionHandler:nil];
    
    //[_htmlpage appendString:funcString];
    
    //  Loop through dictionary array
    for (NSDictionary *dataDictionary in dataDictionaryArray) {
        [_htmlpage appendString:@"{"];
        //  Loop through dictionary items (attributes)
        for (ReportViewAttr *attribute in attributesArray) {
            if ([attribute.attr_type isEqualToString:@"C"]) {
                [_htmlpage appendFormat:@"%@:\"%@\", ",attribute.attr_Id, [dataDictionary objectForKey:attribute.attr_Id]];
            }  else if ([attribute.attr_type isEqualToString:@"K"]) {
                if ([[dataDictionary objectForKey:attribute.attr_Id] isKindOfClass:[NSNull class]]) {
                //if ([[dataDictionary objectForKey:attribute.attr_Id] isEqualToString:@"<null>"] || [[dataDictionary objectForKey:attribute.attr_Id] isEqualToString:@"null"])
                    [_htmlpage appendFormat:@"%@:null, ",attribute.attr_Id];
                } else {
                    [_htmlpage appendFormat:@"%@:%@, ",attribute.attr_Id, [dataDictionary objectForKey:attribute.attr_Id]];
                }
            }
        }
        [_htmlpage deleteCharactersInRange:NSMakeRange([_htmlpage length]-2, 2)];
        [_htmlpage appendString:@"},\n"];
    }
    
    [_htmlpage appendString:@"]\n});\n"];
    [_htmlpage appendString:@"sap.ui.getCore().setModel(oModel);\n"];
    
    //  Build dataset
    
    [_htmlpage appendString:@"var dataset = new sap.viz.ui5.data.FlattenedDataset({\ndimensions : [\n"];
    
    // Dimensions
    // Loop through attribute arrays
    for(ReportViewAttr *attribute in chart.reportViewAttrArray) {
        if ([attribute.attr_type isEqualToString:@"C"] && [attribute.sequence isEqualToNumber:[NSNumber numberWithInt:1]]) {
            [_htmlpage appendFormat:@"{axis : 1, name : '%@', value: \"{%@}\"},\n",attribute.attr_name, attribute.attr_Id];
        } else if ([attribute.attr_type isEqualToString:@"C"]) {
            [_htmlpage appendFormat:@"{axis : 2, name : '%@', value: \"{%@}\"},\n",attribute.attr_name, attribute.attr_Id];
        }
    }
    //[_htmlpage deleteCharactersInRange:NSMakeRange([_htmlpage length]-2, 2)];
    [_htmlpage appendString:@"],\n"];
    
    // Measures
    // Loop through attribute arrays
    [_htmlpage appendString:@"measures : ["];
    for(ReportViewAttr *attribute in chart.reportViewAttrArray) {
        if ([attribute.attr_type isEqualToString:@"K"]) {
            [_htmlpage appendFormat:@"{name : '%@', value : \"{%@}\"},\n",attribute.attr_name, attribute.attr_Id];
        }
    }
    //[_htmlpage deleteCharactersInRange:NSMakeRange([_htmlpage length]-2, 2)];
    [_htmlpage appendString:@"],\ndata : { path : \"/data\" }\n});\n"];
    
    // Chart type
    [_htmlpage appendFormat:@"new sap.viz.ui5.Bar(\"oChart\",{\nwidth : \"100%%\",\nheight : \"%@px\",\n", chartHeight];
    [_htmlpage appendString:COLOR_PALETTE];
    [_htmlpage appendFormat:@"title : { visible : %@, text :'%@' },\n", _chartTitleFlag, chart.reportViewName];
    [_htmlpage appendString:@"toolTip : { formatString : [['#,###.##']] },\n"];
    [_htmlpage appendFormat:@"xAxis : { label : { formatString : %@ }},\n", axisFormatString];
    //toolTip : { formatString : [['#,###.##']]},
    //xAxis : { label : { formatString : [['#,###.##']] }},
    
    
    [_htmlpage appendString:@"dataset: dataset\n}).placeAt(\"content\");\n</script>\n</head>\n"];
    
    [self addHTMLPageBottom];
}

- (void) buildHeatmapChartHTMLwithChartsDictionaryData:(ReportView *)chart andDBFlag:(BOOL)DBFlag
{
    [self addHTMLPageTop];
    
    // first sort chartsdictionary by C-type attribute
    
    NSArray *dataDictionaryArray = chart.chartsDictionary;
    NSArray *attributesArray = chart.reportViewAttrArray;
    
    //  Loop through dictionary array
    for (NSDictionary *dataDictionary in dataDictionaryArray) {
        [_htmlpage appendString:@"{"];
        //  Loop through dictionary items (attributes)
        for (ReportViewAttr *attribute in attributesArray) {
            if ([attribute.attr_type isEqualToString:@"C"]) {
                [_htmlpage appendFormat:@"%@:\"%@\", ",attribute.attr_Id, [dataDictionary objectForKey:attribute.attr_Id]];
            }  else if ([attribute.attr_type isEqualToString:@"K"]) {
                if ([[dataDictionary objectForKey:attribute.attr_Id] isKindOfClass:[NSNull class]])
                //if ([[dataDictionary objectForKey:attribute.attr_Id] isEqualToString:@"<null>"])
                    [_htmlpage appendFormat:@"%@:null, ",attribute.attr_Id];
                else
                    [_htmlpage appendFormat:@"%@:%@, ",attribute.attr_Id, [dataDictionary objectForKey:attribute.attr_Id]];
            }
        }
        [_htmlpage deleteCharactersInRange:NSMakeRange([_htmlpage length]-2, 2)];
        [_htmlpage appendString:@"},\n"];
    }
    
    [_htmlpage appendString:@"]\n});\n"];
    [_htmlpage appendString:@"sap.ui.getCore().setModel(oModel);\n"];
    
    //  Build dataset
    
    [_htmlpage appendString:@"var dataset = new sap.viz.ui5.data.FlattenedDataset({\ndimensions : [\n"];
    
    // Dimensions
    // Loop through attribute arrays
    
    for(ReportViewAttr *attribute in chart.reportViewAttrArray) {
        if ([attribute.attr_type isEqualToString:@"C"] && [attribute.sequence isEqualToNumber:[NSNumber numberWithInt:1]]) {
            [_htmlpage appendFormat:@"{axis : 1, name : '%@', value: \"{%@}\"},\n",attribute.attr_name, attribute.attr_Id];
        } else if ([attribute.attr_type isEqualToString:@"C"]) {
            [_htmlpage appendFormat:@"{axis : 2, name : '%@', value: \"{%@}\"},\n",attribute.attr_name, attribute.attr_Id];
        }
    }
        
    //[_htmlpage deleteCharactersInRange:NSMakeRange([_htmlpage length]-2, 2)];
    [_htmlpage appendString:@"],\n"];
    
    // Measures
    // Loop through attribute arrays
    [_htmlpage appendString:@"measures : ["];
    
    for(ReportViewAttr *attribute in chart.reportViewAttrArray) {
        if ([attribute.attr_type isEqualToString:@"K"]) {
            [_htmlpage appendFormat:@"{name : '%@', value : \"{%@}\"},\n",attribute.attr_name, attribute.attr_Id];
        }
    }
    
    //[_htmlpage deleteCharactersInRange:NSMakeRange([_htmlpage length]-2, 2)];
    
    [_htmlpage appendString:@"],\ndata : { path : \"/data\" }\n});\n"];
    
    // Chart type
    [_htmlpage appendFormat:@"new sap.viz.ui5.Heatmap(\"oChart\",{\nwidth : \"100%%\",\nheight : \"%@px\",\n", chartHeight];

    [_htmlpage appendFormat:@"title : { visible : %@, text :'%@' },\n", _chartTitleFlag, chart.reportViewName];
    //[_htmlpage appendString:HEATMAP_COLOR_PALETTE];
    [_htmlpage appendString:@"dataset: dataset\n}).placeAt(\"content\");\n</script>\n</head>\n"];
    
    [self addHTMLPageBottom];
}

- (void) buildPieChartHTMLwithChartsDictionaryData:(ReportView *)chart andDBFlag:(BOOL)DBFlag
{
    [self addHTMLPageTop];
    
    // first sort chartsdictionary by C-type attribute
    
    NSArray *dataDictionaryArray = chart.chartsDictionary;
    NSArray *attributesArray = chart.reportViewAttrArray;
    
    //  Loop through dictionary array
    for (NSDictionary *dataDictionary in dataDictionaryArray) {
        [_htmlpage appendString:@"{"];
        //  Loop through dictionary items (attributes)
        for (ReportViewAttr *attribute in attributesArray) {
            if ([attribute.attr_type isEqualToString:@"C"]) {
                [_htmlpage appendFormat:@"%@:\"%@\", ",attribute.attr_Id, [dataDictionary objectForKey:attribute.attr_Id]];
            }  else if ([attribute.attr_type isEqualToString:@"K"]) {
                if ([[dataDictionary objectForKey:attribute.attr_Id] isKindOfClass:[NSNull class]])
                //if ([[dataDictionary objectForKey:attribute.attr_Id] isEqualToString:@"<null>"])
                    [_htmlpage appendFormat:@"%@:null, ",attribute.attr_Id];
                else
                    [_htmlpage appendFormat:@"%@:%@, ",attribute.attr_Id, [dataDictionary objectForKey:attribute.attr_Id]];
            }
        }
        [_htmlpage deleteCharactersInRange:NSMakeRange([_htmlpage length]-2, 2)];
        [_htmlpage appendString:@"},\n"];
    }
    
    [_htmlpage appendString:@"]\n});\n"];
    [_htmlpage appendString:@"sap.ui.getCore().setModel(oModel);\n"];
    
    //  Build dataset
    
    [_htmlpage appendString:@"var dataset = new sap.viz.ui5.data.FlattenedDataset({\ndimensions : [\n"];
    
    // Dimensions
    // Loop through attribute arrays
    for(ReportViewAttr *attribute in chart.reportViewAttrArray) {
        if ([attribute.attr_type isEqualToString:@"C"] && [attribute.sequence isEqualToNumber:[NSNumber numberWithInt:1]]) {
            [_htmlpage appendFormat:@"{axis : 1, name : '%@', value: \"{%@}\"},\n",attribute.attr_name, attribute.attr_Id];
        } else if ([attribute.attr_type isEqualToString:@"C"]) {
            [_htmlpage appendFormat:@"{axis : 2, name : '%@', value: \"{%@}\"},\n",attribute.attr_name, attribute.attr_Id];
        }
    }
    //[_htmlpage deleteCharactersInRange:NSMakeRange([_htmlpage length]-2, 2)];
    [_htmlpage appendString:@"],\n"];
    
    // Measures
    // Loop through attribute arrays
    [_htmlpage appendString:@"measures : ["];
    for(ReportViewAttr *attribute in chart.reportViewAttrArray) {
        if ([attribute.attr_type isEqualToString:@"K"]) {
            [_htmlpage appendFormat:@"{name : '%@', value : \"{%@}\"},\n",attribute.attr_name, attribute.attr_Id];
        }
    }
    //[_htmlpage deleteCharactersInRange:NSMakeRange([_htmlpage length]-2, 2)];
    [_htmlpage appendString:@"],\ndata : { path : \"/data\" }\n});\n"];
    
    // Chart type
    [_htmlpage appendFormat:@"new sap.viz.ui5.Pie(\"oChart\",{\nwidth : \"100%%\",\nheight : \"%@px\",\n", chartHeight];
    [_htmlpage appendString:COLOR_PALETTE];
    [_htmlpage appendFormat:@"title : { visible : %@, text :'%@' },\n", _chartTitleFlag, chart.reportViewName];
    [_htmlpage appendString:@"dataset: dataset\n}).placeAt(\"content\");\n</script>\n</head>\n"];
    
    [self addHTMLPageBottom];
}


- (void) buildDonutChartHTMLwithChartsDictionaryData:(ReportView *)chart andDBFlag:(BOOL)DBFlag
{
    [self addHTMLPageTop];
    
    // first sort chartsdictionary by C-type attribute
    
    NSArray *dataDictionaryArray = chart.chartsDictionary;
    NSArray *attributesArray = chart.reportViewAttrArray;
    
    //  Loop through dictionary array
    for (NSDictionary *dataDictionary in dataDictionaryArray) {
        [_htmlpage appendString:@"{"];
        //  Loop through dictionary items (attributes)
        for (ReportViewAttr *attribute in attributesArray) {
            if ([attribute.attr_type isEqualToString:@"C"]) {
                [_htmlpage appendFormat:@"%@:\"%@\", ",attribute.attr_Id, [dataDictionary objectForKey:attribute.attr_Id]];
            }  else if ([attribute.attr_type isEqualToString:@"K"]) {
                if ([[dataDictionary objectForKey:attribute.attr_Id] isKindOfClass:[NSNull class]])
                //if ([[dataDictionary objectForKey:attribute.attr_Id] isEqualToString:@"<null>"])
                    [_htmlpage appendFormat:@"%@:null, ",attribute.attr_Id];
                else
                    [_htmlpage appendFormat:@"%@:%@, ",attribute.attr_Id, [dataDictionary objectForKey:attribute.attr_Id]];
            }
        }
        [_htmlpage deleteCharactersInRange:NSMakeRange([_htmlpage length]-2, 2)];
        [_htmlpage appendString:@"},\n"];
    }
    
    [_htmlpage appendString:@"]\n});\n"];
    [_htmlpage appendString:@"sap.ui.getCore().setModel(oModel);\n"];
    
    //  Build dataset
    
    [_htmlpage appendString:@"var dataset = new sap.viz.ui5.data.FlattenedDataset({\ndimensions : [\n"];
    
    // Dimensions
    // Loop through attribute arrays
    for(ReportViewAttr *attribute in chart.reportViewAttrArray) {
        if ([attribute.attr_type isEqualToString:@"C"] && [attribute.sequence isEqualToNumber:[NSNumber numberWithInt:1]]) {
            [_htmlpage appendFormat:@"{axis : 1, name : '%@', value: \"{%@}\"},\n",attribute.attr_name, attribute.attr_Id];
        } else if ([attribute.attr_type isEqualToString:@"C"]) {
            [_htmlpage appendFormat:@"{axis : 2, name : '%@', value: \"{%@}\"},\n",attribute.attr_name, attribute.attr_Id];
        }
    }
    //[_htmlpage deleteCharactersInRange:NSMakeRange([_htmlpage length]-2, 2)];
    [_htmlpage appendString:@"],\n"];
    
    // Measures
    // Loop through attribute arrays
    [_htmlpage appendString:@"measures : ["];
    for(ReportViewAttr *attribute in chart.reportViewAttrArray) {
        if ([attribute.attr_type isEqualToString:@"K"]) {
            [_htmlpage appendFormat:@"{name : '%@', value : \"{%@}\"},\n",attribute.attr_name, attribute.attr_Id];
        }
    }
    //[_htmlpage deleteCharactersInRange:NSMakeRange([_htmlpage length]-2, 2)];
    [_htmlpage appendString:@"],\ndata : { path : \"/data\" }\n});\n"];
    
    // Chart type
    [_htmlpage appendFormat:@"new sap.viz.ui5.Donut(\"oChart\",{\nwidth : \"100%%\",\nheight : \"%@px\",\n", chartHeight];
    [_htmlpage appendString:COLOR_PALETTE];
    [_htmlpage appendFormat:@"title : { visible : %@, text :'%@' },\n", _chartTitleFlag, chart.reportViewName];
    [_htmlpage appendString:@"dataset: dataset\n}).placeAt(\"content\");\n</script>\n</head>\n"];
    
    [self addHTMLPageBottom];
}


- (void) buildCombinationChartHTMLwithChartsDictionaryData:(ReportView *)chart andDBFlag:(BOOL)DBFlag
{
    NSString *dataMaximumString = [self findDataMaximum:chart];
    NSString *axisFormatString = [self formatNumberString:dataMaximumString];
    [self addHTMLPageTop];
    
    // first sort chartsdictionary by C-type attribute
    
    NSArray *dataDictionaryArray = chart.chartsDictionary;
    NSArray *attributesArray = chart.reportViewAttrArray;
    
    //  Loop through dictionary array
    for (NSDictionary *dataDictionary in dataDictionaryArray) {
        [_htmlpage appendString:@"{"];
        //  Loop through dictionary items (attributes)
        for (ReportViewAttr *attribute in attributesArray) {
            if ([attribute.attr_type isEqualToString:@"C"]) {
                [_htmlpage appendFormat:@"%@:\"%@\", ",attribute.attr_Id, [dataDictionary objectForKey:attribute.attr_Id]];
            }  else if ([attribute.attr_type isEqualToString:@"K"]) {
                if ([[dataDictionary objectForKey:attribute.attr_Id] isKindOfClass:[NSNull class]])
                //if ([[dataDictionary objectForKey:attribute.attr_Id] isEqualToString:@"<null>"])
                    [_htmlpage appendFormat:@"%@:null, ",attribute.attr_Id];
                else
                    [_htmlpage appendFormat:@"%@:%@, ",attribute.attr_Id, [dataDictionary objectForKey:attribute.attr_Id]];
            }
        }
        [_htmlpage deleteCharactersInRange:NSMakeRange([_htmlpage length]-2, 2)];
        [_htmlpage appendString:@"},\n"];
    }
    
    [_htmlpage appendString:@"]\n});\n"];
    [_htmlpage appendString:@"sap.ui.getCore().setModel(oModel);\n"];
    
    //  Build dataset
    
    [_htmlpage appendString:@"var dataset = new sap.viz.ui5.data.FlattenedDataset({\ndimensions : [\n"];
    
    // Dimensions
    // Loop through attribute arrays
    for(ReportViewAttr *attribute in chart.reportViewAttrArray) {
        if ([attribute.attr_type isEqualToString:@"C"] && [attribute.sequence isEqualToNumber:[NSNumber numberWithInt:1]]) {
            [_htmlpage appendFormat:@"{axis : 1, name : '%@', value: \"{%@}\"},\n",attribute.attr_name, attribute.attr_Id];
        } else if ([attribute.attr_type isEqualToString:@"C"]) {
            [_htmlpage appendFormat:@"{axis : 2, name : '%@', value: \"{%@}\"},\n",attribute.attr_name, attribute.attr_Id];
        }
    }
    //[_htmlpage deleteCharactersInRange:NSMakeRange([_htmlpage length]-2, 2)];
    [_htmlpage appendString:@"],\n"];
    
    // Measures
    // Loop through attribute arrays
    [_htmlpage appendString:@"measures : ["];
    for(ReportViewAttr *attribute in chart.reportViewAttrArray) {
        if ([attribute.attr_type isEqualToString:@"K"]) {
            [_htmlpage appendFormat:@"{name : '%@', value : \"{%@}\"},\n",attribute.attr_name, attribute.attr_Id];
        }
    }
    //[_htmlpage deleteCharactersInRange:NSMakeRange([_htmlpage length]-2, 2)];
    [_htmlpage appendString:@"],\ndata : { path : \"/data\" }\n});\n"];
    
    // Chart type
    [_htmlpage appendFormat:@"new sap.viz.ui5.Combination(\"oChart\",{\nwidth : \"100%%\",\nheight : \"%@px\",\n", chartHeight];
    [_htmlpage appendString:COLOR_PALETTE];
    [_htmlpage appendFormat:@"title : { visible : %@, text :'%@' },\n", _chartTitleFlag, chart.reportViewName];
    [_htmlpage appendFormat:@"yAxis : { label : { formatString : %@ }},\n", axisFormatString];
    [_htmlpage appendString:@"dataset: dataset\n}).placeAt(\"content\");\n</script>\n</head>\n"];
    
    [self addHTMLPageBottom];
}

- (void) buildStackedColumnChartHTMLwithChartsDictionaryData:(ReportView *)chart andDBFlag:(BOOL)DBFlag
{
    NSString *dataMaximumString = [self findDataMaximum:chart];
    NSString *axisFormatString = [self formatNumberString:dataMaximumString];
    [self addHTMLPageTop];
    
    // first sort chartsdictionary by C-type attribute
    
    NSArray *dataDictionaryArray = chart.chartsDictionary;
    NSArray *attributesArray = chart.reportViewAttrArray;
    
    //  Loop through dictionary array
    for (NSDictionary *dataDictionary in dataDictionaryArray) {
        [_htmlpage appendString:@"{"];
        //  Loop through dictionary items (attributes)
        for (ReportViewAttr *attribute in attributesArray) {
            if ([attribute.attr_type isEqualToString:@"C"]) {
                [_htmlpage appendFormat:@"%@:\"%@\", ",attribute.attr_Id, [dataDictionary objectForKey:attribute.attr_Id]];
            }  else if ([attribute.attr_type isEqualToString:@"K"]) {
                if ([[dataDictionary objectForKey:attribute.attr_Id] isKindOfClass:[NSNull class]])
                //if ([[dataDictionary objectForKey:attribute.attr_Id] isEqualToString:@"<null>"])
                    [_htmlpage appendFormat:@"%@:null, ",attribute.attr_Id];
                else
                    [_htmlpage appendFormat:@"%@:%@, ",attribute.attr_Id, [dataDictionary objectForKey:attribute.attr_Id]];
            }
        }
        [_htmlpage deleteCharactersInRange:NSMakeRange([_htmlpage length]-2, 2)];
        [_htmlpage appendString:@"},\n"];
    }
    
    [_htmlpage appendString:@"]\n});\n"];
    [_htmlpage appendString:@"sap.ui.getCore().setModel(oModel);\n"];
    
    //  Build dataset
    
    [_htmlpage appendString:@"var dataset = new sap.viz.ui5.data.FlattenedDataset({\ndimensions : [\n"];
    
    // Dimensions
    // Loop through attribute arrays
    for(ReportViewAttr *attribute in chart.reportViewAttrArray) {
        if ([attribute.attr_type isEqualToString:@"C"] && [attribute.sequence isEqualToNumber:[NSNumber numberWithInt:1]]) {
            [_htmlpage appendFormat:@"{axis : 1, name : '%@', value: \"{%@}\"},\n",attribute.attr_name, attribute.attr_Id];
        } else if ([attribute.attr_type isEqualToString:@"C"]) {
            [_htmlpage appendFormat:@"{axis : 2, name : '%@', value: \"{%@}\"},\n",attribute.attr_name, attribute.attr_Id];
        }
    }
    //[_htmlpage deleteCharactersInRange:NSMakeRange([_htmlpage length]-2, 2)];
    [_htmlpage appendString:@"],\n"];
    
    // Measures
    // Loop through attribute arrays
    [_htmlpage appendString:@"measures : ["];
    for(ReportViewAttr *attribute in chart.reportViewAttrArray) {
        if ([attribute.attr_type isEqualToString:@"K"]) {
            [_htmlpage appendFormat:@"{name : '%@', value : \"{%@}\"},\n",attribute.attr_name, attribute.attr_Id];
        }
    }
    //[_htmlpage deleteCharactersInRange:NSMakeRange([_htmlpage length]-2, 2)];
    [_htmlpage appendString:@"],\ndata : { path : \"/data\" }\n});\n"];
    
    // Chart type
    [_htmlpage appendFormat:@"new sap.viz.ui5.StackedColumn(\"oChart\",{\nwidth : \"100%%\",\nheight : \"%@px\",\n", chartHeight];
    [_htmlpage appendString:COLOR_PALETTE];
    [_htmlpage appendFormat:@"title : { visible : %@, text :'%@' },\n", _chartTitleFlag, chart.reportViewName];
    [_htmlpage appendFormat:@"yAxis : { label : { formatString : %@ }},\n", axisFormatString];
    [_htmlpage appendString:@"dataset: dataset\n}).placeAt(\"content\");\n</script>\n</head>\n"];
    
    [self addHTMLPageBottom];
}

- (void) buildDualBarChartHTMLwithChartsDictionaryData:(ReportView *)chart andDBFlag:(BOOL)DBFlag
{
    NSString *dataMaximumString = [self findDataMaximum:chart];
    NSString *axisFormatString = [self formatNumberString:dataMaximumString];
    [self addHTMLPageTop];
    
    // first sort chartsdictionary by C-type attribute
    
    NSArray *dataDictionaryArray = chart.chartsDictionary;
    NSArray *attributesArray = chart.reportViewAttrArray;
    
    //  Loop through dictionary array
    for (NSDictionary *dataDictionary in dataDictionaryArray) {
        [_htmlpage appendString:@"{"];
        //  Loop through dictionary items (attributes)
        for (ReportViewAttr *attribute in attributesArray) {
            if ([attribute.attr_type isEqualToString:@"C"]) {
                [_htmlpage appendFormat:@"%@:\"%@\", ",attribute.attr_Id, [dataDictionary objectForKey:attribute.attr_Id]];
            }  else if ([attribute.attr_type isEqualToString:@"K"]) {
                if ([[dataDictionary objectForKey:attribute.attr_Id] isKindOfClass:[NSNull class]])
                //if ([[dataDictionary objectForKey:attribute.attr_Id] isEqualToString:@"<null>"])
                    [_htmlpage appendFormat:@"%@:null, ",attribute.attr_Id];
                else
                    [_htmlpage appendFormat:@"%@:%@, ",attribute.attr_Id, [dataDictionary objectForKey:attribute.attr_Id]];
            }
        }
        [_htmlpage deleteCharactersInRange:NSMakeRange([_htmlpage length]-2, 2)];
        [_htmlpage appendString:@"},\n"];
    }
    
    [_htmlpage appendString:@"]\n});\n"];
    [_htmlpage appendString:@"sap.ui.getCore().setModel(oModel);\n"];
    
    //  Build dataset
    
    [_htmlpage appendString:@"var dataset = new sap.viz.ui5.data.FlattenedDataset({\ndimensions : [\n"];
    
    // Dimensions
    // Loop through attribute arrays
    for(ReportViewAttr *attribute in chart.reportViewAttrArray) {
        if ([attribute.attr_type isEqualToString:@"C"] && [attribute.sequence isEqualToNumber:[NSNumber numberWithInt:1]]) {
            [_htmlpage appendFormat:@"{axis : 1, name : '%@', value: \"{%@}\"},\n",attribute.attr_name, attribute.attr_Id];
        } else if ([attribute.attr_type isEqualToString:@"C"]) {
            [_htmlpage appendFormat:@"{axis : 2, name : '%@', value: \"{%@}\"},\n",attribute.attr_name, attribute.attr_Id];
        }
    }
    //[_htmlpage deleteCharactersInRange:NSMakeRange([_htmlpage length]-2, 2)];
    [_htmlpage appendString:@"],\n"];
    
    // Measures
    // Loop through attribute arrays
    [_htmlpage appendString:@"measures : ["];
    int i = 1;
    for(ReportViewAttr *attribute in chart.reportViewAttrArray) {
        if ([attribute.attr_type isEqualToString:@"K"]) {
            [_htmlpage appendFormat:@"{group:%d, name : '%@', value : \"{%@}\"},\n",i,attribute.attr_name, attribute.attr_Id];
        }
        i++;
    }
    //[_htmlpage deleteCharactersInRange:NSMakeRange([_htmlpage length]-2, 2)];
    [_htmlpage appendString:@"],\ndata : { path : \"/data\" }\n});\n"];
    
    // Chart type
    [_htmlpage appendFormat:@"new sap.viz.ui5.DualBar(\"oChart\",{\nwidth : \"100%%\",\nheight : \"%@px\",\n", chartHeight];
    [_htmlpage appendString:COLOR_PALETTE];
    [_htmlpage appendFormat:@"title : { visible : %@, text :'%@' },\n", _chartTitleFlag, chart.reportViewName];
    [_htmlpage appendFormat:@"xAxis : { label : { formatString : %@ }},\n", axisFormatString];
    [_htmlpage appendString:@"dataset: dataset\n}).placeAt(\"content\");\n</script>\n</head>\n"];
    
    [self addHTMLPageBottom];
}


- (void) addHTMLPageTop
{
    //  Add the html page header
    [_htmlpage appendString:@"<!DOCTYPE html>\n\
     <html>\n\
     <head>\n\
     <meta http-equiv=\"X-UA-Compatible\" content=\"IE=edge\" />\n\
     <meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\">\n</head>\n"];
    
    //  Add the title
    [_htmlpage appendString:@"<title>Dummy page title</title>\n"];
    //  Add the sapui5 boot script
    [_htmlpage appendString:@"<script id=\"sap-ui-bootstrap\" type=\"text/javascript\"\
     src=\"sapui5-static/resources/sap-ui-core.js\" data-sap-ui-libs=\"sap.ui.commons,sap.viz\" data-sap-ui-language=\"en\">\
     </script>\n"];
    
    //  Build oModel
    [_htmlpage appendString:@"<script>\nvar oModel = new sap.ui.model.json.JSONModel({\ndata : [\n"];
}


- (void) addHTMLPageBottom
{
    //  body
    [_htmlpage appendString:@"<body class=\"sapUiBody\">\n<div id=\"content\"></div>\n</body>\n</html>\n"];
    
    //  Used to check language and locale settings
    //  [_htmlpage appendString:@"<body class=\"sapUiBody\">\r<div id=\"content\"></div>\r<script>\rvar sCurrentLang = sap.ui.getCore().getConfiguration().getLanguage();\rdocument.write(sCurrentLang);\rvar sCurrentLocale = sap.ui.getCore().getConfiguration().getLocale();\rdocument.write(sCurrentLocale);\r</script>\r</body>\r</html>\r"];
}

- (NSString *)findDataMaximum:(ReportView *)chart
{
    double dataMaximum = 0;
    
    NSArray *reportviewAttrArray = chart.reportViewAttrArray;
    
    for (ReportViewAttr *attribute in reportviewAttrArray) {
        if ([attribute.attr_type isEqualToString:@"K"]) {
            NSArray *valuesArray = attribute.valuesArray;
            for (NSString *value in valuesArray) {
                if (![value isKindOfClass:[NSNull class]]) {
                    dataMaximum = MAX(dataMaximum,[value doubleValue]);
                }
            }
        }
    }
    
    return [NSString stringWithFormat:@"%f",dataMaximum];
    
}

- (NSString *)formatNumberString:(NSString *)numberString
{
    double tempNumber;
    NSString *formatString;
    
    if (![numberString isKindOfClass:[NSNull class]]) {
        tempNumber = [numberString doubleValue];
        
        if (tempNumber >= 1000000000.0 || tempNumber <= -1000000000.0) {
            formatString = @"[['0.0,,,\"B\"']]";
            
        } else if (tempNumber >= 1000000.0 || tempNumber <= -1000000.0) {
            //  [['0.0,,\"M\"']]
            formatString = @"[['0.0,,\"M\"']]";
            
        } else if (tempNumber >= 1000.0 || tempNumber <= -1000.0) {
            //  format as xxx.x K
            formatString = @"[['0.0,\"K\"']]";
        } else  {
            //  format as xxx.xx
            formatString = @"[['0.0']]";
        }
    }
    
    return formatString;
}

- (void)unsupportedChartTypePage:(ReportView *) chart
{
    //  Add the html page header
    [_htmlpage appendString:@"<!DOCTYPE html>\n\
     <html>\n\
     <head>\n\
     <meta http-equiv=\"X-UA-Compatible\" content=\"IE=edge\" />\n\
     <meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\">\n</head>\n"];
    
    [_htmlpage appendFormat:@"</head><body><div>Unsupported mobile chart type (%@).</div></body></html>",chart.reportViewType];
}


@end

