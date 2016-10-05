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
//  MAChartViewDelegate.h
//  MAKit
//
//  Created by Zhang Jie on 2/8/11.
//  Copyright 2011 SAP AG. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MAChartView;
@class MAChartSelection;

/** 
 @ingroup MAKit
 @brief Protocol of chart view delegate

 This protocol defines methods and properties that needs to be implemented by a chart view delegate. 
 */
@protocol MAChartViewDelegate <NSObject>
@optional

/**
 @brief Update the title if possible
 @param chartView An object representing the chart view requesting this information.
 @param title The title to show.
 */
- (void)chartView:(MAChartView *)chartView updateTitle:(NSString*)title;

/**
 @brief Tells the delegate that data in the chart view is about to be refreshed.
 
 @param chartView An object representing the chart view requesting this information.
 @returns Return YES if you want the data refreshed; NO if you do not.
 */
- (BOOL)willRefreshDataInChartView:(MAChartView *)chartView;

/**
 @brief Tells the delegate that data in the chart view has been refreshed.
 
 @param chartView An object representing the chart view requesting this information.
 */
- (void)didRefreshDataInChartView:(MAChartView *)chartView;

#pragma mark - Managing Scrolling and zooming

/**
 @brief Tells the delegate when the chart view is about to start scrolling or zooming the plot area content.
 @param chartView An object representing the chart view requesting this information.
 */
- (void)chartViewWillBeginScrollingOrZooming:(MAChartView *)chartView;

/**
 @brief Tells the delegate when scrolling or zooming ended in the chart view.
 @param chartView An object representing the chart view requesting this information.
 */
- (void)chartViewDidEndScrollingOrZooming:(MAChartView *)chartView;

#pragma mark - Managing Range Selection

/**
 @brief Asks the delegate for the visible category indexes range when the chart is loaded.
 */
- (NSUInteger)visibleCategoryRangeOnLoadOfChartView:(MAChartView *)chartView;

/**
 @brief Tells the receiver when the horizontal range has been updated.
 
 @param chartView An object representing the chart view requesting this information.
 @param lowerBound Lower bound of the range (0 ~ 1).
 @param upperBound Upper bound of the range (0 ~ 1).
 */
- (void)chartView:(MAChartView *)chartView didUpdateHorizontalRangeWithLowerBound:(float)lowerBound andUpperBound:(float)upperBound;

/**
 @brief Tells the receiver when the vertical range has been updated.
 
 @param chartView An object representing the chart view requesting this information.
 @param lowerBound Lower bound of the range (0 ~ 1).
 @param upperBound Upper bound of the range (0 ~ 1).
 */
- (void)chartView:(MAChartView *)chartView didUpdateVerticalRangeWithLowerBound:(float)lowerBound andUpperBound:(float)upperBound;

#pragma mark - Managing Selections

/**
 @deprecated
 @brief Tells the delegate that a specified category is about to be selected.
 
 @param chartView An object representing the chart view requesting this information.
 @param categoryIndex An index corresponding to a category in chartView.
 @returns Return YES if you want the category selected; NO if you do not.
 */
- (BOOL)chartView:(MAChartView *)chartView willSelectCategory:(NSUInteger)categoryIndex;

/**
 @brief Tells the delegate that the specified category and series is now selected.
 
 @param chartView An object representing the chart view requesting this information.
 @param categoryIndex An index corresponding to a category in chartView.
 @param seriesIndex An index corresponding to a series of the selected category
 */
- (void)chartView:(MAChartView *)chartView didSelectCategory:(NSUInteger)categoryIndex atSeries:(NSUInteger)seriesIndex;

/**
 @brief Tells the delegate that the specified category is now selected.
 
 @param chartView An object representing the chart view requesting this information.
 @param categoryIndex An index corresponding to a category in chartView.
 */
- (void)chartView:(MAChartView *)chartView didSelectCategory:(NSUInteger)categoryIndex;

/**
 @brief Tells the delegate that the specified series is now selected.
 
 @param chartView An object representing the chart view requesting this information.
 @param seriesIndex An index corresponding to a series in chartView.
 */
- (void)chartView:(MAChartView *)chartView didSelectSeries:(NSUInteger)seriesIndex;
/**
 @deprecated
 @brief Tells the delegate that a specified category is about to be deselected.
 
 @param chartView An object representing the chart view requesting this information.
 @param categoryIndex An index corresponding to a category in chartView.
 @returns Return YES if you want the category deselected; NO if you do not.
 */
- (BOOL)chartView:(MAChartView *)chartView willDeselectCategory:(NSUInteger)categoryIndex;

/**
 @deprecated
 @brief Tells the delegate that the specified category is now deselected.

 @param chartView An object representing the chart view requesting this information.
 @param categoryIndex An index corresponding to a category in chartView.
 */
- (void)chartView:(MAChartView *)chartView didDeselectCategory:(NSUInteger)categoryIndex;

/**
 @deprecated
 @brief Tells the delegate that a specified series is about to be selected.

 @param chartView An object representing the chart view requesting this information.
 @param seriesIndex An index corresponding to a series in chartView.
 @returns Return YES if you want the series selected; NO if you do not.
 */
- (BOOL)chartView:(MAChartView *)chartView willSelectSeries:(NSUInteger)seriesIndex;

/**
 @brief Tells the delegate that the specified series is tapped.

 @param chartView An object representing the chart view requesting this information.
 @param seriesIndex An index corresponding to a series in chartView.
 */
- (void)chartView:(MAChartView *)chartView didTapSeries:(NSUInteger)seriesIndex;

/**
 @deprecated
 @brief Tells the delegate that a specified series is about to be deselected.

 @param chartView An object representing the chart view requesting this information.
 @param seriesIndex An index corresponding to a series in chartView.
 @returns Return YES if you want the series deselected; NO if you do not.
 */
- (BOOL)chartView:(MAChartView *)chartView willDeselectSeries:(NSUInteger)seriesIndex;

/**
 @brief Tells the delegate that the specified series is now deselected.

 @param chartView An object representing the chart view requesting this information.
 @param seriesIndex An index corresponding to a series in chartView.
 */
- (void)chartView:(MAChartView *)chartView didDeselectSeries:(NSUInteger)seriesIndex;

/**
 @deprecated
 @brief Queries whether to select data item.
 
 @param chartView An object representing the chart view requesting this information.
 @param dataItemIndex An index corresponding to a data item within the series.
 @param seriesIndex An index corresponding to a a series based on all chart layers
 @returns YES to select. NO otherwise
 */
- (BOOL)chartView:(MAChartView *)chartView willSelectDataItem:(NSUInteger)dataItemIndex ofSeries:(NSUInteger)seriesIndex;

/**	
 @brief Informs the receiver that the data item is selected.
 
 @param chartView An object representing the chart view requesting this information.
 @param dataItemIndex An index corresponding to a data item within the series.
 @param seriesIndex An index corresponding to a a series based on all chart layers
 */
- (void)chartView:(MAChartView *)chartView didSelectDataItem:(NSUInteger)dataItemIndex ofSeries:(NSUInteger)seriesIndex;

/**	
 @brief Informs the receiver that the data item is selected.
 
 @param chartView An object representing the chart view requesting this information.
 @param dataItemIndex An index corresponding to a data item within the series.
 */
- (void)chartView:(MAChartView *)chartView didSelectDataItem:(NSUInteger)dataItemIndex;

/**	
 @deprecated
 @brief Queries whether to deselect data item.
 
 @param chartView An object representing the chart view requesting this information.
 @param dataItemIndex An index corresponding to a data item within the series.
 @param seriesIndex An index corresponding to a a series based on all chart layers
 @returns YES to deselect. NO otherwise
 */
- (BOOL)chartView:(MAChartView *)chartView willDeselectDataItem:(NSUInteger)dataItemIndex ofSeries:(NSUInteger)seriesIndex;

/**
 @deprecated
 @brief Informs the receiver that the data item is deselected.
 
 @param chartView An object representing the chart view requesting this information.
 @param dataItemIndex An index corresponding to a data item within the series.
 @param seriesIndex An index corresponding to a a series based on all chart layers
 @returns YES to deselect. NO otherwise
 */
- (void)chartView:(MAChartView *)chartView didDeselectDataItem:(NSUInteger)dataItemIndex ofSeries:(NSUInteger)seriesIndex;

/**
 @brief Queries the receiver whether multiple items selection should be enabled
 
 @param chartView An object representing the chart view requesting this information.
 @return YES to enable mutiple items selection; NO otherwise.
 */
- (BOOL)willSelectItems:(MAChartView *)chartView;

/**
 @brief Informs the receiver that multiple items have been selected.
 
 @param chartView An object representing the chart view requesting this information.
 @param selection An object representing the selected items.
 */
- (void)chartView:(MAChartView *)chartView didSelectItems:(MAChartSelection*)selection;

/**
 @brief Tells the delegate that the treemap level has changed.
 
 @param chartView An object representing the chart view requesting this information.
 */
- (void)categoryLevelChanged:(MAChartView *)chartView;

#pragma mark - Managing Touch Events

/**
 @brief Tells the delegate that the specified category has been double-tapped.
 
 @param chartView An object representing the chart view requesting this information.
 @param categoryIndex An index corresponding to a category in chartView.
 @return YES if the double tap gesture has been processed
 */
- (BOOL)chartView:(MAChartView *)chartView didDoubleTapOnCategory:(NSUInteger)categoryIndex;

/**
 @brief Tells the delegate that the specified series has been doubled-tapped.
 
 @param chartView An object representing the chart view requesting this information.
 @param seriesIndex An index corresponding to a series in chartView.
 */
- (BOOL)chartView:(MAChartView *)chartView didDoubleTapOnSeries:(NSUInteger)seriesIndex;

/**
 @brief Tells the delegate that the specified category has been doubled-tapped.
 
 @param chartView An object representing the chart view requesting this information.
 @param categoryIndex An index corresponding to a category in chartView.
 @param seriesIndex An index corresponding to a series in chartView.
 */
- (BOOL)chartView:(MAChartView *)chartView didDoubleTapOnCategory:(NSUInteger)categoryIndex andSeries:(NSUInteger)seriesIndex;

/**
 @brief Tells the delegate that sort the specified series values.
 
 @param chartView An object representing the chart view requesting this information.
 @param seriesIndex An index corresponding to a series in chartView.
 */
- (void)chartView:(MAChartView *)chartView sortBySeries:(NSUInteger)seriesIndex;
- (void)chartView:(MAChartView *)chartView sortBySeries:(NSUInteger)seriesIndex byOrder:(int)ascOrder;
/**
 @brief Tells the delegate that sort the series by name.
 */
- (void)chartView:(MAChartView *)chartView sortBySeriesName:(BOOL)sortByName;

/**
 @brief Tells the delegate asceding or desceding sort the series by name.
 */
- (void)chartView:(MAChartView *)chartView sortAscedingBySerieName:(BOOL)asceding;

/**
 @brief Tells the delegate a row of RFTable is tapped.
 */
- (void)chartView:(MAChartView *)chartView singleTapRow:(NSUInteger)rowIndex column:(NSUInteger)columnIndex;

@end
