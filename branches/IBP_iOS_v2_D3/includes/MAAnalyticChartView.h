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
//  MAAnalyticChartView.h
//  MAKit
//
//  Created by Zhang Jie on 9/2/11.
//  Copyright 2011 SAP AG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MAChartViewDelegate.h"
#import "MAChartViewDataSource.h"
#import "MAChartTheme.h"
#import "MADashboardTheme.h"
#import "MAQueryDelegate.h"
#import "MAChartView.h"
#import "MAAnalyticChartViewDelegate.h"

@protocol MAErrorHandlingDelegate;

@protocol MAQueryDataSource;


/**
 @ingroup MAKit
 @brief A chart view with analytic capabilities, having its data source defined by a metadata file.
 */
@interface MAAnalyticChartView : UIView<MAChartViewDelegate, MAChartViewDataSource, MAChartDataModel>
{
    @private
    struct {
        unsigned int delegateDidSelectItems:1;
    } _analyticChartViewFlags;
    
}

#pragma mark - Properties

/*! Metadata file path
 */
@property(nonatomic, copy) NSString *metaDataPath;

/*! A dictionary of metadata definition
 */
@property(nonatomic, retain) NSMutableDictionary* metaDict;

/*! The object that acts as the data source of the receiving analytic chart view.
 */
@property(nonatomic, retain) id<MAQueryDelegate> dataSource;

/**
 The object that acts as the delegate of the receiving analytic chart view.
 */
@property(nonatomic, assign) id<MAAnalyticChartViewDelegate> delegate;

/*! The object that provides the theme of the receiving analytic chart view
 */
@property(nonatomic, retain) id<MAChartTheme, MADashboardTheme> theme;

/** 
 The object that acts as the error handler of the receiving analytic chart view.
 */
@property(nonatomic, retain) id<MAErrorHandlingDelegate> errorHandler;

/**
 A string serves as the identifier to the chart view if necessary.
 */
@property(nonatomic, copy) NSString *identifier;

#pragma mark - Managing Layout

/**
 A value that determines whether the analytic chart view supports content range selection.
 
 The default is MARangeSelectorBehaviourAuto.  
 */
@property(nonatomic) MARangeSelectorBehavior contentRangeSelectorBehavior;

/**
 A value that determines the display of labels for multiple category levels  
 
 Default is MAHierarchialCategoryLabelDisplayTopLevel.  
 */
@property(nonatomic) MAHierarchialCategoryLabelDisplay hierarchicalCategoryLabelDisplay;

/**
 A Boolean value that determines whether chart view is in thumbnail mode.
 
 The default is NO.
 */
@property(nonatomic) BOOL isThumbnailMode;

/**
 A Boolean value that determines whether chart view title is hidden.
 
 The default is NO.
 */
@property(nonatomic) BOOL isTitleHidden;

/**
 A Boolean value that determines whether chart legend view is hidden.
 
 The default value depends on the chart type. The legend will only be shown if it's applicable for the specified chart type and there are multiple series.
 */
@property(nonatomic) BOOL isLegendHidden;

/**
 A Boolean value that controls whether the horizontal axis title should be shown.
 
 The default value is NO. The axis title is only shown if it's applicable for the specified chart type, and the datasource implements the related title retrieval method.  A layout event is triggered after setting this property.
 */
@property(nonatomic) BOOL showsHorizontalAxisTitle; 

/**
 A Boolean value that controls whether the vertical axis title should be shown.
 
 The default value is NO. The axis title is only shown if it's applicable for the specified chart type, and the datasource implements the related title retrieval method. A layout event is triggered after setting this property. */
@property(nonatomic) BOOL showsVerticalAxisTitle;  

/**
 A Boolean value that controls whether the horizontal axis with labels and tick marks should be shown.
 
 The default value is YES. The axis is only shown if it's applicable for the specified chart type. A layout event is triggered after setting this property.
 */
@property(nonatomic) BOOL showsHorizontalAxis; 

/**
 A Boolean value that controls whether the vertical axis with labels and tick mark should be shown.
 
 The default value is YES. The axis is only shown if it's applicable for the specified chart type. A layout event is triggered after setting this property.
 */
@property(nonatomic) BOOL showsVerticalAxis;  

/**
 A Boolean value that controls whether the series labels should be shown.
 
 The default value is YES. Series labels are only applicable for pie chart. A layout event is triggered after setting this property.
 */
@property(nonatomic) BOOL showsSeriesLabels;  

/**
 A Boolean value that controls whether the label of the selected data should be shown.
 
 The default value is YES. The data label is only shown if it's applicable for the specified chart type. A layout event is triggered after setting this property.
 */
@property(nonatomic) BOOL showsSelectedDataLabel;  

/**
 A Boolean value that controls whether the grid line labels should be shown.
 
 The default value is YES. The axis is only shown if it's applicable for the specified chart type. A layout event is triggered after setting this property.
 */
@property(nonatomic) BOOL showsGridLabel; 

/**
 A Boolean value that controls whether to display x-axis at top or bottom, for certain type of charts
 
 The default value is YES. The x-axis is displayed at top of the chart
 */
@property(nonatomic) BOOL showsXAxisAtTop; 

/**
 Edge insets (Padding) around chart view
 */
@property(nonatomic) UIEdgeInsets chartViewEdgeInsets;

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
 Chart type of the chart view.
 */
@property(nonatomic, readonly) NSUInteger chartType;

/**
 Total level counts in the drill down path, including the top level chart.  If no drill down defined, returns 1.
 */
@property(nonatomic, readonly) NSUInteger drillDownPathLevelCount;

/**
 Current level index in the drill down path. Top level == 0.
 */
@property(nonatomic, readonly) NSUInteger currentLevelInDrillDownPath;

/**
 Drill down path titles of the current chart view.  An array of string instances.
 */
@property(nonatomic, readonly) NSArray *drillDownPathTitles;

/**
 Count of category hierarchies (for example, semantic zooming, treemap category grouping) of the chart view in the current drill down level; if no semantic zooming defined, returns 1.
 */
@property(nonatomic, readonly) NSUInteger categoryHierarchyCount;

/**
 Current level index in the category hierarchy of the chart view. Bottom level (most detailed level) == 0.
 */
@property(nonatomic, readonly) NSUInteger currentLevelInCategoryHierarchy;

/**
 Category titles for all cateogry hierarchy levels of the current chart view.  An array of string instances.
 */
@property(nonatomic, readonly) NSArray *categoryHierarchyTitles;

/**
 Returns a boolean value that determines whether chart view has what if scenario
 */
@property(nonatomic, readonly) BOOL hasWhatIfScenario;

/**
 Returns a boolean value that determines whether chart is a datagrid type
 */
@property(nonatomic, readonly) BOOL isDataGridChart;


#pragma mark - Methods

/**
 @brief Reloads data of the chart view asynchronously
 
 Call this method to reload data from the data source in an asynchronous thread and reconstruct the chart view, including subviews and sublayers.
 */
- (void)reloadData:(BOOL)animated;

/**
 @brief Reloads data of the chart view synchronously 
 
 Call this method to reload data from the data source and reconstruct the chart view, including subviews and sublayers.
 */
- (void)reloadDataSync:(BOOL)animated;

/**
 @brief Redraws the chart view.  
 
 Call this method to redraw the chart view.
 @param animated If YES, animates the view as redrawn; otherwise, does not.
 */

- (void)setNeedsDisplay:(BOOL)animated;

/**
 @brief Drills up to the specified level in chart. 
 
 Call this method to drill up one level (return to the previous level) in the drill down path, if applicable.
 @param level The number specifying the level to drill up to
 */
- (void)drillUpToLevel:(NSUInteger)level;

/**
 @brief Changes hierarchy level in chart. (Zoom in/Zoom out)
 
 Call this method to change hierarchy level, if applicable.  If level is invalid, there will be no changes.
 @param level The number specifying the hierarchy level
*/
- (void)changeHierarchyLevel:(NSUInteger)level;

/**
 @brief Toggles what-if panel between show and hidden states, if applicable.
 
 No panel will be shown if there is no what-if scenario defined in the metadata file.
 @return A boolean value indicating the visibility of the what-if panel is visible after the toggle is done.
 */
- (BOOL)toggleWhatIfPanel;

/**
 @brief Toggles between the chart itself and data table, if applicable. 
 */
- (void)toggleTable;

/**
 @brief Shows e-mail panel with the chart picture.
 @param controller The current view controller  
 */
- (void)sharedByEmail:(UIViewController*)controller;

#pragma mark - Accessing Drawing Coordinates

/** 
 Returns the point in the chart view coordinate system for a data identified by its data item index.
 @param dataItemIndex An index corresponding to a data item
 */
- (CGPoint)pointForDataAtIndex:(NSUInteger)dataItemIndex;

@end
