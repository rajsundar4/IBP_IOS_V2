/*
 
 Copyright (c) SAP AG. 2011  All rights reserved.                                   
 
 In addition to the license terms set out in the SAP License Agreement for 
 the SAP Mobile Platform ("Program"), the following additional or different 
 rights and accompanying obligations and restrictions shall apply to the source 
 code in this file ("Code").  SAP grants you a limited, non-exclusive, 
 non-transferable, revocable license to use, reproduce, and modify the Code 
 solely for purposes of (i) maintaining the Code as reference material to better
 understand the operation of the Program, and (ii) development and testing of 
 applications created in connection with your licensed use of the Program.  
 The Code may not be transferred, sold, assigned, sublicensed or otherwise 
 conveyed (whether by operation of law or otherwise) to another party without 
 SAP's prior written consent.  The following provisions shall apply to any 
 modifications you make to the Code: (i) SAP will not provide any maintenance
 or support for modified Code or problems that result from use of modified Code;
 (ii) SAP expressly disclaims any warranties and conditions, express or 
 implied, relating to modified Code or any problems that result from use of the 
 modified Code; (iii) SAP SHALL NOT BE LIABLE FOR ANY LOSS OR DAMAGE RELATING
 TO MODIFICATIONS MADE TO THE CODE OR FOR ANY DAMAGES RESULTING FROM USE OF THE 
 MODIFIED CODE, INCLUDING, WITHOUT LIMITATION, ANY INACCURACY OF DATA, LOSS OF 
 PROFITS OR DIRECT, INDIRECT, SPECIAL, INCIDENTAL OR CONSEQUENTIAL DAMAGES, EVEN
 IF SAP HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGES; (iv) you agree 
 to indemnify, hold harmless, and defend SAP from and against any claims or 
 lawsuits, including attorney's fees, that arise from or are related to the 
 modified Code or from use of the modified Code. 
 
 */

//
//  MAChartTheme.h
//  MAKit
//
//  Created by Zhang Jie on 10/23/10.
//  Copyright 2010 SAP AG. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MAChartSpec;
@protocol MAChartBasePainter;
@protocol MAChartSeriesPainter;

/** 
 @ingroup MAKit
 @brief Protocol of chart theme
 */
@protocol MAChartTheme <NSObject>
		
@required

/**
 @brief Returns the chart base painter based on a chart type for the current chart theme.
 @param chartType Chart type.
 @returns The base painter for the specified chart type.
 */
- (id<MAChartBasePainter>)getChartBasePainterByChartType:(NSUInteger)chartType;

/**
 @brief Returns the chart series painter based on a chart type for the current chart theme.
 @param chartType Chart type.
 @returns The series painter for the specified chart type chart type.
 */
- (id<MAChartSeriesPainter>)getChartSeriesPainterByChartType:(NSUInteger)chartType;

#pragma mark - Fonts

/**
 @brief Returns the font for chart title.
 @returns The font for title.
 */
- (UIFont*)getChartTitleFont;

/**
 @brief Returns the font for chart legend.
 @returns The font for legend.
 */
- (UIFont*)getChartLegendFont;

/**
 @brief Returns the font for chart category labels.
 @returns The font for category labels.
 */
- (UIFont*)getCategoryLabelFont;

/**
 @brief Returns the font for chart value labels.
 @returns The font for value labels.
 */
- (UIFont*)getValueLabelFont;

#pragma mark -
#pragma mark Colors

/**
 @brief Returns the background color of chart.
 */
- (UIColor*)chartBackgroundColor;

/**
 @brief Returns the border color of chart.
 */
- (UIColor*)chartBorderColor;

/**
 @brief Returns the color of chart title text.
 */
- (UIColor*)chartTitleTextColor;

/**
 @brief Returns the background color of chart legend.
 */
- (UIColor*)chartLegendBackgroundColor;

/**
 @brief Returns the border color of chart legend.
 */
- (UIColor*)chartLegendBorderColor;

/**
 @brief Returns the color of chart legend text.
 */
- (UIColor*)chartLegendTextColor;

/**
 @brief Returns the color of value axis of a cartesian chart.
 */
- (UIColor*)cartesianChartValueAxisColor;

/**
 @brief Returns the color of value axis marker text of a cartesian chart.
 */
- (UIColor*)cartesianChartValueAxisMarkerTextColor;

/**
 @brief Returns the  color of value axis label text of a cartesian chart.
 */
- (UIColor*)cartesianChartValueLabelTextColor;

/**
 @brief To get the color of category axis of a cartesian chart.
 */
- (UIColor*)cartesianChartCategoryAxisColor;

/**
 @brief Returns the color of category axis marker text of a cartesian chart.
 */
- (UIColor*)cartesianChartCategoryAxisMarkerTextColor;

/**
 @brief Returns the color of category axis label text of a cartesian chart.
 */
- (UIColor*)cartesianChartCategoryLabelTextColor;

/**
 @brief Returns the color of guidelines of a cartesian chart.
 */
- (UIColor*)cartesianChartGuidelineColor;

/**
 @brief Returns the background color of category with even index value.
 Return different color from the cartesianChartOddCategoryBackgroundColor to achieve alternate background colors.
 */
- (UIColor*)cartesianChartEvenCategoryBackgroundColor;

/**
 @brief Returns the background color of category with odd index value.
 Return different color from the cartesianChartEvenCategoryBackgroundColor to achieve alternate background colors.
 */
- (UIColor*)cartesianChartOddCategoryBackgroundColor;

/**
 @brief Returns the color of highlighted area of a chart.
 */
- (UIColor*)chartHighlightColor;

/**
 @brief Returns the color of Dynamic Analytics variable description label.
 */
- (UIColor*)dynamicAnalyticsVariableDescriptionColor;

/**
 @brief Returns the color of Dynamic Analytics variable value label.
 */
- (UIColor*)dynamicAnalyticsVariableValueColor;


/**
 @brief Returns the content color of a chart series with index.
 @param seriesIndex The index of series.
 @returns Content color of the specified series.
 */
- (UIColor*)getChartSeriesContentColorForIndex:(NSUInteger)seriesIndex;

/**
 @brief Returns the border color of a chart series with index.
 @param seriesIndex The index of series.
 @returns Border color of the specified series.
 */
- (UIColor*)getChartSeriesBorderColorForIndex:(NSUInteger)seriesIndex;

#pragma mark - DataGrid

@optional

/**
 @brief Returnsthe color of datagrid lines.
 */
- (UIColor*)dataGridLinesColor;

/**
 @brief Returns the color of datagrid categeory  Text color.
 */
- (UIColor*)dataGridCatgeoryTextColor;

/**
 @brief To get the color of data grid header background color.
 */
- (UIColor*)dataGridHeaderBackgroundColor;

/**
 @brief Returns the color of data grid background color.
 */
- (UIColor*)dataGridBackgroundColor;

/**
 @brief Returns the font of datagrid.
 */
-(UIFont*)dataGridFont;

/**
 @brief Returns the datagrid horizontal line1 color.
 */ 
- (UIColor*)dataGridHorizontalLine1Color;

/**
  @brief Returns the datagrid horizontal line1 color.
 */
- (UIColor*)dataGridHorizontalLine2Color;

#pragma mark - Thresholds and Reference Line

/**
 @brief Returns color of upper threshold region.
 */
- (UIColor*)upperThresholdColor;

/**
 @brief Returns color of lower threshold region
 */
- (UIColor*)lowerThresholdColor;

/**
@brief Returns color of reference value line.
 */
- (UIColor*)referenceValueColor;

#pragma mark - 

/**
 @brief Returns the background color of category with the given index value.
 Return different color from the cartesianChartCategoryBackgroundColor to achieve different background colors for categories.
 */
- (UIColor*)cartesianChartCategoryBackgroundColorForRow:(NSUInteger)categoryIndex;

/**
 @brief Returns the font color of category with the given index value.
 Return different color from the cartesianChartCategoryLabelTextColorAt to achieve different font colors for categories.
 */
- (UIColor*)cartesianChartCategoryLabelTextColorAt:(NSUInteger)categoryIndex;

#pragma mark - Line chart

/**
 @brief Returns the width of a chart item. Currently only applicable for line chart.
 */
- (NSUInteger)chartItemWidth;

/**
 @brief Returns the tailingImage to indicate the end of the series, or to indicate a break in data points. Applicable only to line charts.
 @param seriesIndex The series index
 */
- (UIImage*)tailingImageForIndex:(NSUInteger)seriesIndex;

@end
