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
//  MAChartView.h
//
//  Created by Zhang Jie on 4/17/09.
//  Copyright 2009 SAP Inc.. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MAChartViewDataSource.h"
#import "MAChartViewDelegate.h"
#import "MAChartDataModel.h"
#import "MAChartLayerModel.h"
#import "MAChartTheme.h"
#import <dispatch/dispatch.h>

typedef enum 
{
    MARangeSelectorBehaviourAuto,    // Auto enable range selector if touch point of each chart element is too small. Disabled otherwise
    MARangeSelectorBehaviourEnabled, // Always enable range selector
    MARangeSelectorBehaviourDisabled, // Always disable range selector
} MARangeSelectorBehavior;

typedef enum
{
	MAChartAscending = 0,
	MAChartDscending = 1,
	MAChartUnsorted = 2,
    MAChartReverse = 3,
} 
MAChartSortingOrder; 

typedef enum 
{
    MAHierarchialCategoryLabelDisplayTopLevel,    // Display only the labels of top category level
    MAHierarchialCategoryLabelDisplayBottomLevel, // Display labels of the bottom category level
    MAHierarchialCategoryLabelDisplayTopAndBottomLevels, // Display labels of the top and bottom category levels
    MAHierarchialCategoryLabelDisplayAllLevels, // Display labels of all category levels
} MAHierarchialCategoryLabelDisplay;

//typedef enum 
//{
//    MAChartViewScrollPositionNone, // The chart view scrolls so that the item of interest is fully visible with a minimum of movement. If the item is already fully visible, no scrolling occurs to reveal the selected item. This is the default behaviour
//    MAChartViewScrollPositionTopLeft, // The chart view scrolls so that the item of interest is located at the top/left of the visble chart view.
//    MAChartViewScrollPositionMiddle, // The chart view scrolls so that the item of interest is located at the middle of the visble chart view.
//    MAChartViewScrollPositionBottomRight, // The chart view scrolls so that the item of interest is located at the bottom/right of the visble chart view.
//} MAChartViewScrollPosition;


/** 
 * @ingroup MAKit
 * @brief Class of a chart view with contents constructed from a chart data source
 *  A Chart View is a view for displaying a chart. It is similar to the UITableView which displays a table. A chart view object must have an object that acts as a data source and optionally, an object that acts as a delegate. The data source provides information that the chart view needs to construct the view. The delegate performs  tasks such as managing selections.
 */
@interface MAChartView : UIView <MAChartDataModel, MAChartLayerModel>
{
    /**
     * Chart view internal rendering flags
     */
    @package
    struct {
        unsigned int showsTitle:1;
        unsigned int showsLegend:1;
        unsigned int showsLegendDefault:1;
        unsigned int showsHorizontalAxisTitle:1;
        unsigned int showsVerticalAxisTitle:1;
        unsigned int showsHorizontalAxis:1;
        unsigned int showsVerticalAxis:1;
        unsigned int showsSeriesLabels:1;
        unsigned int showsSelectedDataLabel:1;
        unsigned int hierarchialCategoryLabelDisplay;
        unsigned int rangeSelectorBehavior;
        unsigned int showsGridLabel:1;
        unsigned int showsXAxisAtTop:1;
        unsigned int horizontalZoomEnabled:1;
        unsigned int verticalZoomEnabled:1;
        unsigned int dualAxisEnabled:1;
    } _chartViewFlags;
}

#pragma mark - Properties
/**
 When disableSorting is true, all sorting relevant properties are ignored.
 */
@property(nonatomic) BOOL disableSorting;
@property(nonatomic) BOOL sortBySeries;
@property(nonatomic) MASeriesSoringOrder sortOrder;
@property(nonatomic) NSUInteger sortSeriesIndex;
/**
 A string that serves as the identifier to the chart view if necessary.
 */
@property(nonatomic, copy) NSString *identifier;

/**
 The object that acts as the data source of the receiving chart view.
 */
@property(nonatomic, assign) id<MAChartViewDataSource> dataSource;

/**
 The object that acts as the delegate of the receiving chart view.
 */
@property(nonatomic, assign) id<MAChartViewDelegate> delegate;

/**
 The chart model of the receiving chart view.
 */
@property(retain) id<MAChartDataModel> dataModel;

/**
 The chart layer model of the receiving chart view.
 */
@property(retain) id<MAChartLayerModel> layerModel;

/**
 The object that acts as the theme of the receiving chart view.
 */
@property(nonatomic, retain) id<MAChartTheme> theme;

#pragma mark - Managing Layout

/**
 A Boolean value that determines whether chart view is in thumbnail mode.
 
 Default is NO.
 */
@property(nonatomic) BOOL isThumbnailMode;

/**
 A Boolean value that determines whether chart view title is hidden.
 
 Default is NO.
 */
@property(nonatomic) BOOL isTitleHidden;

/**
 A Boolean value that determines whether chart legend view is hidden.
 
 The default value depends on the chart type. The legend is shown only if it is applicable to the specified chart type. and there are multiple series.
 */
@property(nonatomic) BOOL isLegendHidden;

/**
 A Boolean value that controls whether to show the horizontal axis title.
 
 The default value is NO. The axis title is shown only if it is applicable to the specified chart type, and the dataSource implements the related title retrival method.  A layout event is triggered after setting this property.
 */
@property(nonatomic) BOOL showsHorizontalAxisTitle; 

/**
 A Boolean value that controls whether to show the vertical axis title.
 
 The default value is NO. The axis title is shown only if it is applicable to the specified chart type, and the dataSource implements the related title retrival method. A layout event is triggered after setting this property. */
@property(nonatomic) BOOL showsVerticalAxisTitle;   

/**
 A Boolean value that controls whether to show the horizontal axis with labels and tick marks.
 
 The default value is YES. The axis is shown only if it is applicable to for the specified chart type. A layout event is triggered after setting this property.
 */
@property(nonatomic) BOOL showsHorizontalAxis; 

/**
 A Boolean value that controls whether to show the vertical axis with labels and tick marks.
 
 The default value is YES. The axis is shown only if it is applicable to the specified chart type. A layout event is triggered after setting this property.
 */
@property(nonatomic) BOOL showsVerticalAxis;  

/**
 A Boolean value that controls whether to show the series labels.
 
 The default value is YES. Series labels are applicable only to pie charts. A layout event is triggered after setting this property.
 */
@property(nonatomic) BOOL showsSeriesLabels;  

/**
 A Boolean value that controls whether to show the label of selected data.
 
 The default value is YES. The data label is shown only if it is applicable to the specified chart type. A layout event is triggered after setting this property.
 */
@property(nonatomic) BOOL showsSelectedDataLabel;  

/**
 A Boolean value that controls whether to show the grid line labels.
 
 The default value is YES. The axis is shown only if it is applicable to the specified chart type. A layout event is triggered after setting this property.
 */
@property(nonatomic) BOOL showsGridLabel; 

/**
 A Boolean value that controls whether to display x-axis at the top or bottom, for certain type of charts.
 
 The default value is YES. The x-axis appears at the top of the chart.
 */
@property(nonatomic) BOOL showsXAxisAtTop;

/**
 A value that determines whether to show the content range selector.
 
 Default is MARangeSelectorBehaviourAuto. No range selector is shown if both horizontal and vertical zoom are disabled.
 */
@property(nonatomic) MARangeSelectorBehavior contentRangeSelectorBehavior;

/**
 A value that determines the display of labels for multiple category levels. 
 
 Default is MAHierarchialCategoryLabelDisplayTopLevel.  
 */
@property(nonatomic) MAHierarchialCategoryLabelDisplay hierarchicalCategoryLabelDisplay;

/**
 A value that determines the height of each row in bar/horizontal bullet chart.
 */
@property(nonatomic) CGFloat rowHeight;

/**
 A value that determines the spacing of each row in bar/horizontal bullet chart.
 */
@property(nonatomic) CGFloat rowSpacing;

#pragma mark - Managing Scrolling and Zooming

/**
 A Boolean value that determines whether horizontal zoom is enabled.
 
 Default is YES
 */
@property(nonatomic,getter=isHorizontalZoomEnabled) BOOL horizontalZoomEnabled;

/**
 A Boolean value that determines whether vertical zoom is enabled.
 
 Default is NO.
 */
@property(nonatomic,getter=isVerticalZoomEnabled) BOOL verticalZoomEnabled;

/**
 A Boolean value that determines whether dual axis is enabled.
 
 Default is NO.
 */
@property(nonatomic,getter=isDualAxisEnabled) BOOL dualAxisEnabled;

#pragma mark

/**
 Title of the chart.
 */
@property(nonatomic,copy) NSString* title;

/**
 Name of the chart
 */
@property(nonatomic,copy) NSString* name;

/**
  The current scale for text rendering in the chart view.
 */
@property(nonatomic, readonly) CGFloat textScale;

/**
 A Boolean value that indicates whether the chart is in the midst of refreshing its data.
 */
@property(nonatomic) BOOL refreshing;
/**
 Whether to suppress layout accessory view
 */
@property(nonatomic) BOOL suppressChartContainerLayout;

/**
The minimum value to be displayed at the chart
 */
@property(nonatomic) CGFloat minDisplayValue;

/**
 The maximum value to be displayed at the chart
 */
@property(nonatomic) CGFloat maxDisplayValue;

#pragma mark - Refresh / Redraw

/**
 @brief Refreshes chart asynchronously.

 Call this method to reload data and refresh all chart specifications in an asynchronous thread.
 */
- (void)refresh;

/**
 @brief Refreshes chart synchronously. 
 
 Call this method to reload data and refresh all chart specifications.
 */
- (void)refreshSync:(BOOL)animated;

/**
 @brief Reloads data of the chart in the main thread.
 */
- (void)reloadData:(BOOL)animated;

/**
 @brief Reloads data of the chart in an asynchronous thread.
 */
- (void)reloadDataAsync:(BOOL)animated;

/**
 @brief Redraws chart. 

 Call this method to redraw chart with all chart specifications changes (data is not reloaded).
 */
- (void)redraw:(BOOL)animated;

/**
 @brief Quickly redraw chart. 
 
 Call this method to quickly redraw chart based on the current data and specifications.
 */
- (void)quickRedraw:(BOOL)animated;

#pragma mark - Accessing Drawing Coordinates

/** 
 Returns the point in the chart view coordinate system for a data identified by its data item index.
 @param dataItemIndex An index corresponding to a data item.
 */
- (CGPoint)pointForDataAtIndex:(NSUInteger)dataItemIndex; 

@end




