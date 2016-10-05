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
//  MAChartViewDataSource.h
//  MAKit
//
//  Created by Zhang Jie on 1/26/11.
//  Copyright 2011 SAP AG. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MAChartView;

/**
 @ingroup MAKit
 @brief Protocol of chart view datasource. 

 This protocol defines methods and properties that needs to be implemented by a chart view datasource. 
 */
@protocol MAChartViewDataSource <NSObject>

#pragma mark - Required

@required

/**	
 @brief Asks the datasource to return the title of the chart view.
 
 @param chartView An object representing the chart view requesting this information.
 @returns The title of the chartView.
 */
- (NSString*)titleForChartView:(MAChartView *)chartView;

/**	
 @brief Asks the datasource to return the chart type of the series at a specific index.
 
 @param chartView An object representing the chart view requesting this information.
 @param layerIndex An index corresponding to a chart layer in the chartView.
 @returns The chart type.
 */
- (NSUInteger)chartView:(MAChartView *)chartView chartTypeForChartLayer:(NSUInteger)layerIndex;

/**	
 @brief Asks the datasource to return the number of categories in the chart view.  
 
 @param chartView An object representing the chart view requesting this information.
 @param categoryLevelIndex An index corresponding to a category level
 @returns The number of categories in chartView.
 */
- (NSUInteger)chartView:(MAChartView *)chartView numberOfCategoriesInLevel:(NSUInteger)categoryLevelIndex;

/**	
 @brief Asks the datasource to return the category at a specific index.
 
 In chart rendering, the description of the category object is used as the display string for that category.
 @param chartView An object representing the chart view requesting this information.
 @param categoryIndex An index corresponding to a category in the chartView.
 @param categoryLevelIndex An index corresponding to a category level in the chartView.
 @returns The category object.
 */
- (id)chartView:(MAChartView *)chartView categoryAtIndex:(NSUInteger)categoryIndex inCategoryLevel:(NSUInteger)categoryLevelIndex;

/**	
 @brief Asks the datasource to return the number of series in the chart view.
 
 @param chartView An object representing the chart view requesting this information.
 @returns The number of series in chartView. The default value is 1.
 */
- (NSUInteger)numberOfSeriesInChartView:(MAChartView *)chartView;

/** 
 @brief Asks the datasource to return the series at a specific index.

 In chart rendering, the description of the series object is used as the display string for that series.
 @param chartView An object representing the chart view requesting this information.
 @param seriesIndex An index corresponding to a series in the chartView.
 @returns The series object.
 */
- (id)chartView:(MAChartView *)chartView seriesAtIndex:(NSUInteger)seriesIndex;

/**	
 @brief Ask the datasource to return the value of the category and the series at their specific indexes.

 Some charts may require more than one value for each category-series pair. The valueIndex indicates the index of the value.
 @param chartView An object representing the chart view requesting this information.
 @param valueDimensionIndex An index corresponding to a value in the value dimension in the chartView. In normal single-value-dimensional charts, valueIndex is usually equal to 0.
 @param categoryIndex An index corresponding to a category in the chartView.
 @param categoryLevelIndex An index corresponding to a category level in the chartView.
 @param seriesIndex An index corresponding to a series in the chartView.
 @returns The value object.
 */
- (id)chartView:(MAChartView *)chartView valueAtDimension:(NSUInteger)valueDimensionIndex forCategory:(NSUInteger)categoryIndex inCategoryLevel:(NSUInteger)categoryLevelIndex andSeries:(NSUInteger)seriesIndex;

#pragma mark - Optional

@optional

/**	
 @brief Asks the datasource to return the number of dimensions of values in the chart view.  

 Some charts may require more than one value for each category-series pair, use this method to specify the dimensions.
 This method is optional.  If it is not implemented, a return value of 1 is assumed.
 @param chartView An object representing the chart view requesting this information.
 @returns The number of value dimensions in chartView.  Default value is 1.
 */
- (NSUInteger)numberOfValueDimensionsInChartView:(MAChartView *)chartView;

#pragma mark Formatters

/**	
 @brief Asks the datasource to return the formatter for value at a specific dimension in the chart view.  

 This method is optional.  If it is not implemented, there is no formatting on the value object. The string representation is that of [NSObject description]
 @param chartView An object representing the chart view requesting this information.
 @param valueDimensionIndex An index corresponding to a value in the value dimension in the chartView. In normal single-value-dimensional charts, valueIndex is usually equal to 0.
 @returns The NSFormatter object.
 */
- (NSFormatter*)chartView:(MAChartView *)chartView formatterForValueAtDimension:(NSUInteger)valueDimensionIndex;

/**	
 @brief Asks the datasource to return the formatter for categories in the chart view.  
 
 This method is optional.  If it is not implemented, there is no formatting on the category object.
 @param chartView An object representing the chart view requesting this information.
 @returns The NSFormatter object.
 */
- (NSFormatter*)categoryFormatterForChartView:(MAChartView *)chartView;

/**	
 @brief Asks the datasource to return the formatter for series in the chart view.  
 
 This method is optional.  If it is not implemented, there is no formatting on the series object.
 @param chartView An object representing the chart view requesting this information.
 @returns The NSFormatter object.
 */
- (NSFormatter*)seriesFormatterForChartView:(MAChartView *)chartView;

#pragma mark Titles

/**	
 @brief Asks the datasource to return the label for category in the chart view.  
 
 This method is optional. If it is not implemented, there is no title.
 @param chartView An object representing the chart view requesting this information.
 @param categoryLevelIndex An index corresponding to a category level.
 @returns The label.
 */
- (NSString*)chartView:(MAChartView *)chartView categoryTitleForCategoryLevel:(NSUInteger)categoryLevelIndex;

/**	
 @brief Asks the datasource to return the label for series in the chart view.  
 
 This method is optional. If it is not implemented, there is no title.
 @param chartView An object representing the chart view requesting this information.
 @param categoryLevelIndex An index corresponding to a category level.
 @returns The label.
 */
- (NSString*)chartView:(MAChartView *)chartView seriesTitleForCategoryLevel:(NSUInteger)categoryLevelIndex;

/**	
 @brief Asks the datasource to return the title for value at a specific dimension in the chart view.  

 This method is optional. If it is not implemented, there is no title.
 @param chartView An object representing the chart view requesting this information.
 @param valueDimensionIndex An index corresponding to a value in the value dimension in the chartView. In normal single-value-dimensional charts, valueIndex is usually equal to 0.
 @param categoryLevelIndex An index corresponding to a category level.
 @returns The label.
 */
- (NSString*)chartView:(MAChartView *)chartView valueTitleAtDimension:(NSUInteger)valueDimensionIndex inCategoryLevelIndex:(NSUInteger)categoryLevelIndex;

#pragma mark - Overlay (e.g. Column plus Line chart)

/**	
 @brief Asks the datasource to return the number of layers of the chart view. 

 Chart layers enable chart overlay.
 @param chartView An object representing the chart view requesting this information.
 @returns The number of layers in chartView.
 */
- (NSUInteger)numberOfLayersInChartView:(MAChartView *)chartView;

/**
 @brief Asks the datasource to return the index of the layer that the specific series belongs to.
	
 @param chartView An object representing the chart view requesting this information.
 @param seriesIndex An index corresponding to a series in the chartView.
 @returns The index of the layer.
 */
- (NSUInteger)chartView:(MAChartView *)chartView indexOfLayerForSeries:(NSUInteger)seriesIndex;

#pragma mark - Data Items (Useful when there are multiple data items corresponding to the same category and series)

/**	
 @brief Asks the datasource to whether it provides data in the form of data items. 
	
 In some charts, such as a scatter chart, it is more efficient to get data by data items instead of traversing through all the category and series combinations.
 In this case, an optional set of datasource APIs are provided to get data in this way.  
 If getDataByDataItemsInChartView: is not implemented or returns NO, the default chartView:valueAtDimension:forCategoryAtIndex:andSeries: is used to fetch data.
 @param chartView An object representing the chart view requesting this information.
 @returns Boolean value to indicate if chart should fetch data by data items.  Default is NO.
 */
- (BOOL)getDataByDataItemsInChartView:(MAChartView *)chartView;

/**
 @brief Asks the datasource to return the number of data items in the chart view. 
	
 In some charts, such as a scatter chart, it is more efficient to get data by data items instead of traversing through all the category and series combinations.
 @param chartView An object representing the chart view requesting this information.
 @returns The number of data items in chartView.
 */
- (NSUInteger)numberOfDataItemsInChartView:(MAChartView *)chartView;

/**	
 @brief Asks the datasource to return the category index of a data item in the chart view. 
	
 In some charts, such as a scatter chart, it is more efficient to get data by data items instead of traversing through all the category and series combinations.
 @param chartView An object representing the chart view requesting this information.
 @param dataItemIndex An index corresponding to a data item in the chartView.
 @returns The index corresponding to a category in the chartView.
 */
- (NSUInteger)chartView:(MAChartView *)chartView indexOfCategoryForDataItem:(NSUInteger)dataItemIndex;

/**	
 @brief Asks the datasource to return the series index of a data item in the chart view. 
	
 In some charts, such as a scatter chart, it is more efficient to get data by data items instead of traversing through all the category and series combinations.
 @param chartView An object representing the chart view requesting this information.
 @param dataItemIndex An index corresponding to a data item in the chartView.
 @returns The index corresponding to a series in the chartView.
 */
- (NSUInteger)chartView:(MAChartView *)chartView indexOfSeriesForDataItem:(NSUInteger)dataItemIndex;

/**	
 @brief Ask the datasource to return the value of a data item at its specific index.

 Some charts may require more than one value for each data item. The valueIndex indicates the index of the value.
 @param chartView An object representing the chart view requesting this information.
 @param valueDimensionIndex An index corresponding to a value in the value dimension in the chartView. In normal single-value-dimensional charts, valueIndex is usually equal to 0.
 @param dataItemIndex An index corresponding to a data item in the chartView.
 @returns The value object.
 */
- (id)chartView:(MAChartView *)chartView valueAtDimension:(NSUInteger)valueDimensionIndex forDataItem:(NSUInteger)dataItemIndex;

#pragma mark - Hierarchical Categories

/**	
 @brief Asks the datasource to return the number of category levels in the cateogry hierarchy of the chart view. 

 In some charts, categories may be grouped in hierarchy, i.e. with supercategories.
 For example, in a chart with 6 categories: Jan, Feb, Mar, Apr, May, Jun.  
 We can define super categories Q1 and Q2 by grouping "Jan, Feb, Mar" and "Apr, May, Jun" together respectively.
 In this example, the number of category level is 2.
 The number of categories for level at index 0 is 6.
 The number of categories for level at index 1 is 2.
 The category at index 0 in level at index 0 is "Jan". The category at index 0 in level at index 1 is "Q1".
 The index of the first subcategory for the category at index 0 in level at index 1 is 0.
 The index of the last subcategory for the category at index 0 in level at index 1 is 2.
 The index of the first subcategory for the category at index 1 in level at index 1 is 3.
 The index of the last subcategory for the category at index 1 in level at index 1 is 5.
 @param chartView An object representing the chart view requesting this information.
 @returns The number of category levels in chartView.
 */
- (NSUInteger)numberOfCategoryLevelsInChartView:(MAChartView *)chartView;

/**
 @brief Asks the datasource to return the index of the first category that belongs to the super category in a specific location in a  super category level of the chart view. 
 
 In some charts, categories may be grouped in hierarchy, i.e. with supercategories.
 For example, in a chart with 6 categories: Jan, Feb, Mar, Apr, May, Jun.  
 We can define super categories Q1 and Q2 by grouping "Jan, Feb, Mar" and "Apr, May, Jun" together respectively.
 In this example, the number of category level is 2.
 The number of categories for level at index 0 is 6.
 The number of categories for level at index 1 is 2.
 The category at index 0 in level at index 0 is "Jan". The category at index 0 in level at index 1 is "Q1".
 The index of the first subcategory for the category at index 0 in level at index 1 is 0.
 The index of the last subcategory for the category at index 0 in level at index 1 is 2.
 The index of the first subcategory for the category at index 1 in level at index 1 is 3.
 The index of the last subcategory for the category at index 1 in level at index 1 is 5.
 @param chartView An object representing the chart view requesting this information.
 @param categoryIndex An index corresponding to a category.
 @param categoryLevelIndex An index corresponding to a category level.
 @returns The index of a category in chartView.
 */
- (NSUInteger)chartView:(MAChartView *)chartView indexOfFirstSubCategoryForCategory:(NSUInteger)categoryIndex inCategoryLevel:(NSUInteger)categoryLevelIndex;

/**	
 @brief Asks the datasource to return the index of the last category that belongs to the super category in a specific location in a  super category level of the chart view. 
 
 In some charts, categories may be grouped in hierarchy, i.e. with supercategories.
 For example, in a chart with 6 categories: Jan, Feb, Mar, Apr, May, Jun.  
 We can define super categories Q1 and Q2 by grouping "Jan, Feb, Mar" and "Apr, May, Jun" together respectively.
 In this example, the number of category level is 2.
 The number of categories for level at index 0 is 6.
 The number of categories for level at index 1 is 2.
 The category at index 0 in level at index 0 is "Jan". The category at index 0 in level at index 1 is "Q1".
 The index of the first subcategory for the category at index 0 in level at index 1 is 0.
 The index of the last subcategory for the category at index 0 in level at index 1 is 2.
 The index of the first subcategory for the category at index 1 in level at index 1 is 3.
 The index of the last subcategory for the category at index 1 in level at index 1 is 5.
 @param chartView An object representing the chart view requesting this information.
 @param categoryIndex An index corresponding to a category.
 @param categoryLevelIndex An index corresponding to a category level.
 @returns The index of a category in chartView.
 */
- (NSUInteger)chartView:(MAChartView *)chartView indexOfLastSubCategoryForCategory:(NSUInteger)categoryIndex inCategoryLevel:(NSUInteger)categoryLevelIndex;

#pragma mark - Extra Chart Properties

/**	
 @brief Gets chart extra properties.
 
 Currently supports upperThreshold, lowerThreshold and referenceValue for line chart.
 @param chartView An object representing the chart view requesting this information.
 @returns Extra properties for the specified chart view. 
 */
- (NSDictionary*)getExtraChartProperties:(MAChartView *)chartView;

/**	
 @brief Ask the datasource to return the accessory view of the specified category and series indexes. Currently supported only for line charts.
 
 @param chartView An object representing the chart view requesting this information.
 @param categoryIndex An index corresponding to a category in the chartView.
 @param categoryLevelIndex An index corresponding to a category level in the chartView. Applicable for semantic zooming, else 0 in most cases
 @param seriesIndex An index corresponding to a series in the chartView.
 @returns The accessory view.
 */
- (UIView*)chartView:(MAChartView *)chartView accessoryViewforCategory:(NSUInteger)categoryIndex inCategoryLevel:(NSUInteger)categoryLevelIndex andSeries:(NSUInteger)seriesIndex;

@end
