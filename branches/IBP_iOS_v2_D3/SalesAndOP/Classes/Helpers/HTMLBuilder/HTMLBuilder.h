//
//  HTMLBuilder.h
//  IBP
//
//  Created by Rick Thompson on 11/14/14.
//  Copyright (c) 2014 Linear Logics Corporation. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "ReportView.h"
#import "ReportViewAttr.h"
#import "Global.h"
#import "sapsopaServiceDeclarations.h"


#define kHTMLFileName [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingString:@"/chartfile.html"]


@interface HTMLBuilder : NSObject

@property (nonatomic,strong)  NSMutableString *htmlpage;
@property (nonatomic,strong) NSString *chartTitleFlag;
@property (nonatomic,strong) NSString *chartHeight;

//+ (HTMLBuilder *) sharedInstance;

- (NSMutableString *) buildHTMLChartWithData:(ReportView *)chart andDBFlag:(BOOL)DBFlag;
- (void) writeToFileWithFilename:(NSString *)filename;

- (void) appendSAPUI5BootstrapScript;

//  New methods using chartsDictionary
- (void) buildLineChartHTMLwithChartsDictionaryData:(ReportView *)chart andDBFlag:(BOOL)DBFlag;
- (void) buildColumnChartHTMLwithChartsDictionaryData:(ReportView *)chart andDBFlag:(BOOL)DBFlag;
- (void) buildBarChartHTMLwithChartsDictionaryData:(ReportView *)chart andDBFlag:(BOOL)DBFlag;
- (void) buildHeatmapChartHTMLwithChartsDictionaryData:(ReportView *)chart andDBFlag:(BOOL)DBFlag;
- (void) buildPieChartHTMLwithChartsDictionaryData:(ReportView *)chart andDBFlag:(BOOL)DBFlag;
- (void) buildDonutChartHTMLwithChartsDictionaryData:(ReportView *)chart andDBFlag:(BOOL)DBFlag;
- (void) buildCombinationChartHTMLwithChartsDictionaryData:(ReportView *)chart andDBFlag:(BOOL)DBFlag;
- (void) buildStackedColumnChartHTMLwithChartsDictionaryData:(ReportView *)chart andDBFlag:(BOOL)DBFlag;
- (void) buildDualBarChartHTMLwithChartsDictionaryData:(ReportView *)chart andDBFlag:(BOOL)DBFlag;



@end
