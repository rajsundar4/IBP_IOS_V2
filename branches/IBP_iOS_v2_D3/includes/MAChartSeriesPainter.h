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

/*
 *  MAChartSeriesPainter.h
 *  MADashboard
 *
 *  Created by Zhang Jie on 10/19/10.
 *  Copyright 2010 SAP AG. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@protocol MAChartBasePainter;
@protocol MAAnimatorDelegate;
@protocol MAShape;
@protocol MAChartSeriesSpec;

/*!
 @ingroup MAKit
 @brief Protocol of chart series painter.
 This protocol defines methods and properties that needs to be implemented by a chart series painter. A chart series painter is responsible for paint the content of a chart series layer such as columns, lines and bars.
*/
@protocol MAChartSeriesPainter <NSObject>

@required

/**
 The animator for the series layer.
 */
@property(nonatomic, retain) id<MAAnimatorDelegate> animator;

/**
 The shape of the series layer.
 */
@property(nonatomic, retain) id<MAShape> shape;

/**
 @brief Returns the anchor of the series layer.
 @param seriesSpec Series specification.
 @param chartBasePainter Chart base painter.
 @return The point indicating the layer anchor
 */
- (CGPoint)layerAnchorPointWithSeriesSpec:(id<MAChartSeriesSpec>)seriesSpec withChartBasePainter:(id<MAChartBasePainter>)chartBasePainter;

/**
 @brief Returns the bounds of the series layer.
 @param seriesSpec Series specification.
 @param bounds Plot are bounds.
 @param chartBasePainter Chart base painter.
 @return The rectangle indicating the bounds.
 */
- (CGRect)layerBoundsWithSeriesSpec:(id<MAChartSeriesSpec>)seriesSpec inPlotAreaBounds:(CGRect)bounds withChartBasePainter:(id<MAChartBasePainter>)chartBasePainter;

/**
 @brief Draws the series layer.
 @param context Drawing context.
 @param seriesSpec Series specification.
 @param bounds Plot are bounds.
 @param chartBasePainter Chart base painter.
 */
- (void)drawInContext:(CGContextRef)context withSeriesSpec:(id<MAChartSeriesSpec>)seriesSpec inBounds:(CGRect)bounds withChartBasePainter:(id<MAChartBasePainter>)chartBasePainter;

/**
 @brief Draws the legend marker of the series .
 @param context Drawing context.
 @param seriesSpec Series specification.
 @param rect Plot are bounds.
 @param chartBasePainter Chart base painter.
 */
- (void)drawLegendMarkerInContext:(CGContextRef)context withSeriesSpec:(id<MAChartSeriesSpec>)seriesSpec inBounds:(CGRect)rect withChartBasePainter:(id<MAChartBasePainter>)chartBasePainter;

@optional

/**
 The index of the chart series layer.
 */
@property(nonatomic, assign) NSUInteger layerIndex;

/**
 @brief Returns the point of the series layer origin.
 @param seriesSpec Series specification.
 @param bounds Plot are bounds.
 @param chartBasePainter Chart base painter.
 @return The point indicating the layer origin.
 */
- (CGPoint)layerPositionWithSeriesSpec:(id<MAChartSeriesSpec>)seriesSpec inPlotAreaBounds:(CGRect)bounds withChartBasePainter:(id<MAChartBasePainter>)chartBasePainter;

#pragma mark - Accessing Drawing Areas of the Plot Content View

/** 
 Returns the point in the content view for a data identified by its category and series index.
 @param categoryIndex An index corresponding to a category.
 @param globalSeriesIndex An index corresponding to a series based on all chart layers.
 @param chartBasePainter Chart base painter.
 */
- (CGPoint)pointForDataAtCategory:(NSUInteger)categoryIndex andSeries:(NSUInteger)globalSeriesIndex withChartBasePainter:(id<MAChartBasePainter>)chartBasePainter;

/** 
 Returns the point in the content view for a data identified by its data item index.
 @param dataItemIndex An index corresponding to a data item.
 @param chartBasePainter Chart base painter.
 */
- (CGPoint)pointForDataAtIndex:(NSUInteger)dataItemIndex withChartBasePainter:(id<MAChartBasePainter>)chartBasePainter;

#pragma mark 

/*! Tells the receiver when the series layer is loaded. 
 *  This method is most commonly used to perform additional initialization steps on the plot area view,
 *  for example, to modify gesture recognizers, and create drawing layers.
 *  @param view A UIView representing the plot area view.
 *  @param seriesSpec Series specifications.
 *  @param chartBasePainter Chart base painter.
 */
- (void)seriesLayerDidLoadInPlotArea:(UIView*)view withSeriesSpec:(id<MAChartSeriesSpec>)seriesSpec withChartBasePainter:(id<MAChartBasePainter>)chartBasePainter;

/*! Asks for the mask layer for the series layer if necessary.
 *  @param seriesSpec Series specifications.
 *   @param chartBasePainter Chart base painter.
 */
- (CALayer*)maskLayerWithSeriesSpec:(id<MAChartSeriesSpec>)seriesSpec withChartBasePainter:(id<MAChartBasePainter>)chartBasePainter;

/*! Method for the receiver to setup the contents in the accessory view.
 *  @param accessoryView The accessory view.
 *  @param seriesSpec Series specifications.
 *  @param chartBasePainter Chart base painter.
 */
- (void)setupAccessoryView:(UIView*)accessoryView withSeriesSpec:(id<MAChartSeriesSpec>)seriesSpec withChartBasePainter:(id<MAChartBasePainter>)chartBasePainter;

/*! Method for the receiver to layout the contents in the accessory view.
 *  @param accessoryView The accessory view.
 *  @param seriesSpec Series specifications.
 *  @param chartBasePainter Chart base painter.
 */
- (void)layoutAccessoryView:(UIView*)accessoryView withSeriesSpec:(id<MAChartSeriesSpec>)seriesSpec withChartBasePainter:(id<MAChartBasePainter>)chartBasePainter;

/*! Tells the receiver when the plot area scroll view is loaded. 
 *  This method is most commonly used to perform additional initialization steps on the plot area scroll view,
 *  for example, to modify gesture recognizers, and create drawing layers.
 *  @param view A UIScrollView representing the parent view of the plot area content view.
 */
- (void)plotAreaScrollViewDidLoad:(UIScrollView*)view;

/*! Tells the receiver when the plot area content view is loaded. 
 *  This method is most commonly used to perform additional initialization steps on the plot area view,
 *  for example, to modify gesture recognizers, and create drawing layers.
 *  @param view A UIView representing the plot area view.
 */
- (void)plotAreaContentViewDidLoad:(UIView*)view;

///*! Tells the receiver when one or more fingers touch begins in the plot area.
// *  @param touches A set of UITouch instances that represent the touches for the starting phase of the event represented by event.
// *  @param event An object representing the event to which the touches belong.
// *  @param seriesSpec Series specifications.
// *  @param view A UIView instance representing plot area content view.
// *  @deprecated
// */
//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event withSeriesSpec:(id<MAChartSeriesSpec>)seriesSpec inPlotArea:(UIView*)view  withChartBasePainter:(id<MAChartBasePainter>)chartBasePainter;
//
///*! Tells the receiver when one or more fingers touch moves in the plot area.
// *  @param touches A set of UITouch instances that represent the touches for the starting phase of the event represented by event.
// *  @param event An object representing the event to which the touches belong.
// *  @param seriesSpec Series specifications
// *  @param view A UIView instance representing plot area content view.
// *  @deprecated
// */
//- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event withSeriesSpec:(id<MAChartSeriesSpec>)seriesSpec inPlotArea:(UIView*)view  withChartBasePainter:(id<MAChartBasePainter>)chartBasePainter;
//
///*! Tells the receiver when one or more fingers touch ends in the plot area.
// *  @param touches A set of UITouch instances that represent the touches for the starting phase of the event represented by event.
// *  @param event An object representing the event to which the touches belong.
// *  @param seriesSpec Series specifications
// *  @param view A UIView instance representing plot area content view.
// *  @deprecated
// */
//- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event withSeriesSpec:(id<MAChartSeriesSpec>)seriesSpec inPlotArea:(UIView*)view  withChartBasePainter:(id<MAChartBasePainter>)chartBasePainter;

@end