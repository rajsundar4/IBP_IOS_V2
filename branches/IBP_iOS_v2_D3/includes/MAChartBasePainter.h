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
 *  MAChartBasePainter.h
 *  MADashboard
 *
 *  Created by Zhang Jie on 10/19/10.
 *  Copyright 2010 SAP AG. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>
#import "MAChartView.h"
#import "MAChartSelection.h"

#define kMaxContentWidth 400000.0f
#define kValueAxisVPadding 6.0f

/*!
 *  
 *  @ingroup MAKit
 *  \brief Protocol of chart base painter 
 *
 *  This protocol defines methods and properties that needs to be implemented by a chart base painter. 
 *  A chart base painter is responsible for painting the chart's basic infrastructures such as background, axes and labels.
 */
@protocol MAChartBasePainter <NSObject>

#pragma mark -
#pragma mark @required

@required

/*! A chart reference
 */
@property(nonatomic, assign) MAChartView* chart;

#pragma mark -
#pragma mark @optional

@optional

/**
 Anchor point of plot area layer.
 @return The point indicating the anchor of a layer.
 */
- (CGPoint)plotAreaBaseLayerAnchorPoint;

/**
 Returns the origin of plot area layer given the bounds.
 @param bounds Plot Area Bounds.
 @return The point indicating the origin of a layer.
 */
- (CGPoint)plotAreaBaseLayerPositionWithPlotAreaBounds:(CGRect)bounds;

/*! Asks if left area of the chart is enabled
 *  @returns A Boolean value; default NO.
 */
- (BOOL)enableLeftArea;

/*! Asks if right area of the chart is enabled.
 *  @returns A Boolean value; default NO.
 */
- (BOOL)enableRightArea;

/*! Asks if top area of the chart is enabled.
 *  @returns A Boolean value; default NO.
 */
- (BOOL)enableTopArea;

/*! Asks if bottom area of the chart is enabled.
 *  @returns A Boolean value; default NO.
 */
- (BOOL)enableBottomArea;

/*! Asks if top left area of the chart is enabled.
 *  @returns A Boolean value; default NO.
 */
- (BOOL)enableTopLeftArea;

/*! Asks if top right area of the chart is enabled.
 *  @returns A Boolean value; default NO.
 */
- (BOOL)enableTopRightArea;

/*! Asks if bottom left area of the chart is enabled.
 *  @returns A Boolean value; default NO.
 */
- (BOOL)enableBottomLeftArea;

/*! Asks if bottom right area of the chart is enabled.
 *  @returns A Boolean value; default NO.
 */
- (BOOL)enableBottomRightArea;

/*! Asks if legend is enabled
 *  @returns A Boolean value; default NO.
 */
- (BOOL)enableLegend;

/*! Method to define the left area width of the chart, if the left area is enabled.
 *  @returns width of the area; default 0.
 */
- (CGFloat)leftAreaWidth;

/*! Method to define the left area width of the chart, if the left area is enabled.
 *  @param boundSize Bounds size of the chart area which includes the plot area, as well as top, bottom, left, right areas. It does not include the value bubble, range selector, legend and title regions.
 *  @returns Width of the area; default 0.
 */
- (CGFloat)leftAreaWidthWithChartAreaBoundSize:(CGSize)boundSize;

/*! Method to define the right area width of the chart, if the right area is enabled.
 *  @returns Width of the area; default 0.
 */
- (CGFloat)rightAreaWidth;

/*! Method to define the top area height of the chart, if the top area is enabled.
 *  @returns Height of the area; default 0.
 */
- (CGFloat)topAreaHeight;

/*! Method to define the bottom area height of the chart, if the bottom area is enabled.
 *  @returns Height of the area; default 0.
 */
- (CGFloat)bottomAreaHeight;

/*! Returns the view to be drawn at the left area at the specified category index.
 *  @param categoryIndex Category index
 */
- (UIView*)leftAreaViewForCategoryAtIndex:(NSUInteger)categoryIndex;

/*! Returns the view to be drawn at the top left area.
 */
- (UIView*)topLeftAreaView;

/*! Method to draw contents in the left area, if the left area is enabled.
 *  @param context A core graphics context reference.
 *  @param bounds Bounds of the drawing area.
 */
- (void)drawLeftAreaInContext:(CGContextRef)context withBounds:(CGRect)bounds;

/*! Method to draw contents in the right area, if the right area is enabled.
 *  @param context A core graphics context reference
 *  @param bounds Bounds of the drawing area
 */
- (void)drawRightAreaInContext:(CGContextRef)context withBounds:(CGRect)bounds;

/*! Method to draw contents in the top area, if the top area is enabled.
 *  @param context A core graphics context reference
 *  @param bounds Bounds of the drawing area
 */
- (void)drawTopAreaInContext:(CGContextRef)context withBounds:(CGRect)bounds;

/*! Method to draw contents in the bottom area, if the bottom area is enabled.
 *  @param context A core graphics context reference.
 *  @param bounds Bounds of the drawing area.
 */
- (void)drawBottomAreaInContext:(CGContextRef)context withBounds:(CGRect)bounds;

/*! Method to draw contents in the top left area, if the top left area is enabled.
 *  @param context A core graphics context reference.
 *  @param bounds Bounds of the drawing area.
 */
- (void)drawTopLeftAreaInContext:(CGContextRef)context withBounds:(CGRect)bounds;

/*! Method to draw contents in the top right area, if the top right area is enabled.
 *  @param context A core graphics context reference.
 *  @param bounds Bounds of the drawing area.
 */
- (void)drawTopRightAreaInContext:(CGContextRef)context withBounds:(CGRect)bounds;

/*! Method to draw contents in the bottom left area, if the bottom left area is enabled.
 *  @param context A core graphics context reference.
 *  @param bounds Bounds of the drawing area.
 */
- (void)drawBottomLeftAreaInContext:(CGContextRef)context withBounds:(CGRect)bounds;

/*! Method to draw contents in the bottom right area, if the bottom right area is enabled.
 *  @param context A core graphics context reference.
 *  @param bounds Bounds of the drawing area.
 */
- (void)drawBottomRightAreaInContext:(CGContextRef)context withBounds:(CGRect)bounds;

/*! Method to draw contents in the plot area.
 *  @param context A core graphics context reference.
 *  @param bounds Bounds of the drawing area.
 */
- (void)drawPlotAreaInContext:(CGContextRef)context withBounds:(CGRect)bounds;

/*! Method to define the spacing to the left of the chart.
 *  @returns Width of the spacing; default 0.
 */
- (CGFloat)leftSpacing;

/*! Method to define the spacing after the right of the chart.
 *  @returns Width of the spacing; default 0.
 */
- (CGFloat)rightSpacing;

/*! Method to define the spacing to the top of the chart.
 *  @returns Width of the spacing; default 0.
 */
- (CGFloat)topSpacing;

/*! Method to define the spacing to the bottom of the chart.
 *  @returns Width of the spacing; default 0.
 */
- (CGFloat)bottomSpacing;

/*! Method for the receiver to setup the contents in the accessory view.
 *  @param accessoryView The accessory view
 */
- (void)setupAccessoryView:(UIView*)accessoryView;

/*! Method for the receiver to layout the contents in the accessory view.
 *  @param accessoryView The accessory view
 */
- (void)layoutAccessoryView:(UIView*)accessoryView;

/*!	@brief Tells the receiver when chart content is about to refresh.
 *
 *	Update the painter properties if needed.
 */
- (void)willRefresh;

#pragma mark - Managing content size

/*!	@brief Returns the default plot area content size based on the given bound size.
 *
 *	@param boundSize Bound size of the plot area.
 *	@returns Content size of the plot area.
 */
- (CGSize)defaultPlotAreaContentSizeWithPlotAreaBoundSize:(CGSize)boundSize;

/*!	@brief Returns the maximum plot area content size based on the given bound size.
 *
 *	@param boundSize Bound size of the plot area.
 *	@returns Content size of the plot area.
 *  If not implemented, the default behaviour is that the content size is the same as the plot bound size.
 */
- (CGSize)maxPlotAreaContentSizeWithPlotAreaBoundSize:(CGSize)boundSize;

/*!	@brief Returns the minimum plot area content size based on the given bound size.
 *
 *	@param boundSize Bound size of the plot area.
 *	@returns Content size of the plot area.
 *  If not implemented, the default behaviour is that the content size is the same as the plot bound size.
 */
- (CGSize)minPlotAreaContentSizeWithPlotAreaBoundSize:(CGSize)boundSize;

/*!	@brief Returns the plot area content size and content offset based on the given bound size, given that the specified category range is to be visible.
 *
 *	@param boundSize Bound size of the plot area.
 *  @param categoryRange Category indexes range to be shown within the plot area bounds size.
 *	@returns Content size and offset of the plot area.
 *  If not implemented, the default behaviour is that the content size is the same as the plot bound size, with zero offset.
 */
//- (CGRect)contentSizeAndOffsetWithPlotAreaBoundSize:(CGSize)boundSize showingCategoryRange:(NSRange)categoryRange;
- (CGRect)contentSizeAndOffsetWithPlotAreaBoundSize:(CGSize)boundSize showingCategoryRange:(NSUInteger)categoryRange;

/*!	@brief Tells the receiver when plot area content size has been updated.
 *
 *  Use this to update the rendering model if needed.
 *	@param contentSize Content size of the plot area.
 */
- (void)didUpdatePlotAreaContentSize:(CGSize)contentSize;

/*!	@brief Tells the receiver when plot area content offset has been updated.
 *
 *	@param contentOffset Content offset of the plot area.
 */
- (void)didUpdatePlotAreaContentOffset:(CGPoint)contentOffset;

/*!	@brief Tells the receiver when selected category has been updated.
 *
 */
- (void)didUpdateSelectedCategory;

#pragma mark - Scrolling and Zooming

/*!	@brief Tells the receiver whether the horizontal content scope picker is needed.
 *
 *  If the method is not implemented, assume it returns NO.
 *	@returns A Boolean value indicating if the horizontal scope picker is needed.
 */
- (BOOL)requiresHorizontalRangeSelector;

/*!	@brief Tells the receiver whether the vertical content scope picker is needed.
 *
 *  If the method is not implemented, assume it returns NO.
 *	@returns A Boolean value indicating if the vertical scope picker is needed.
 */
- (BOOL)requiresVerticalRangeSelector;

/*!	@brief Tells the receiver whether to show scroll indicators.
 *
 *  If the method is not implemented, assume it returns NO.
 *	@return A Boolean value indicating whether to show scroll indicators.
 */
- (BOOL)showsScrollIndicators;

/*!	@brief Tells the receiver whether touch scrolling is allowed in chart content view.
 *
 *  If the method is not implemented, assume it returns NO.
 *	@returns A Boolean value
 */
- (BOOL)allowTouchScrolling;

/*!	@brief Tells the receiver whether there is individual unique animation for each series.
 *
 *  If the method is not implemented, assume it returns NO.
 *	@return A Boolean value indicating series animation.
 */
//- (BOOL)hasSeriesAnimation;

#pragma mark -

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

/*! Tells the receiver when the top area scroll view is loaded. 
 *  This method is most commonly used to perform additional initialization steps on the top area scroll view, 
 *  for example, to modify gesture recognizers, and create drawing layers.
 *  @param view A UIScrollView representing the parent view of the top area content view.
 */
- (void)topAreaScrollViewDidLoad:(UIScrollView*)view;

/*! Tells the receiver when the bottom area scroll view is loaded. 
 *  This method is most commonly used to perform additional initialization steps on the bottom area scroll view, 
 *  for example, to modify gesture recognizers, and create drawing layers.
 *  @param view A UIScrollView representing the parent view of the bottom area content view.
 */
- (void)bottomAreaScrollViewDidLoad:(UIScrollView*)view;

/*! Tells the receiver when the left area scroll view is loaded. 
 *  This method is most commonly used to perform additional initialization steps on the left area scroll view, 
 *  for example, to modify gesture recognizers, and create drawing layers.
 *  @param view A UIScrollView representing the parent view of the left area content view.
 */
- (void)leftAreaScrollViewDidLoad:(UIScrollView*)view;

/*! Tells the receiver when the right area scroll view is loaded. 
 *  This method is most commonly used to perform additional initialization steps on the right area scroll view, 
 *  for example, to modify gesture recognizers, and create drawing layers.
 *  @param view A UIScrollView representing the parent view of the right area content view.
 */
- (void)rightAreaScrollViewDidLoad:(UIScrollView*)view;

/*! Tells the receiver when the top area content view is loaded. 
 *  This method is most commonly used to perform additional initialization steps on the top area view,
 *  for example, to modify gesture recognizers, and create drawing layers.
 *  @param view A UIView representing the top area content view.
 */
- (void)topAreaContentViewDidLoad:(UIView*)view;

/*! Tells the receiver when the bottom area content view is loaded. 
 *  This method is most commonly used to perform additional initialization steps on the bottom area view,
 *  for example, to modify gesture recognizers, and create drawing layers.
 *  @param view A UIView representing the bottom area content view.
 */
- (void)bottomAreaContentViewDidLoad:(UIView*)view;

/*! Tells the receiver when the left area content view is loaded. 
 *  This method is most commonly used to perform additional initialization steps on the left area view,
 *  for example, to modify gesture recognizers, and create drawing layers.
 *  @param view A UIView representing the left area content view.
 */
- (void)leftAreaContentViewDidLoad:(UIView*)view;

/*! Tells the receiver when the right area content view is loaded. 
 *  This method is most commonly used to perform additional initialization steps on the right area view,
 *  for example, to modify gesture recognizers, and create drawing layers.
 *  @param view A UIView representing the right area content view.
 */
- (void)rightAreaContentViewDidLoad:(UIView*)view;

/*! Tells the receiver when the top left area content view is loaded. 
 *  This method is most commonly used to perform additional initialization steps on the top left area view,
 *  for example, to modify gesture recognizers, and create drawing layers.
 *  @param view A UIView representing the top left area content view.
 */
- (void)topLeftAreaContentViewDidLoad:(UIView*)view;

/*! Tells the receiver when the top right area content view is loaded. 
 *  This method is most commonly used to perform additional initialization steps on the top right area view,
 *  for example, to modify gesture recognizers, and create drawing layers.
 *  @param view A UIView representing the top right area content view.
 */
- (void)topRightAreaContentViewDidLoad:(UIView*)view;

/*! Tells the receiver when the bottom left area content view is loaded. 
 *  This method is most commonly used to perform additional initialization steps on the bottom left area view,
 *  for example, to modify gesture recognizers, and create drawing layers.
 *  @param view A UIView representing the bottom left area content view.
 */
- (void)bottomLeftAreaContentViewDidLoad:(UIView*)view;

/*! Tells the receiver when the bottom right area content view is loaded. 
 *  This method is most commonly used to perform additional initialization steps on the bottom right area view,
 *  for example, to modify gesture recognizers, and create drawing layers.
 *  @param view A UIView representing the bottom right area content view.
 */
- (void)bottomRightAreaContentViewDidLoad:(UIView*)view;

#pragma mark - Selection

/*! Tells the receiver to return the rectangle occupied by the data items given the rectangle of the plot content view.
 * @param rect A CGRect in plot content view coordinates.
 * @return A CGRect occupied by the data items 
 */
- (CGRect)itemsRectForPlotContentRect:(CGRect)rect;

/*! Tells the receiver to return the data items within the rectangular region. 
 *  @param rect A CGRect in plot content view coordinates.
 *  @return A chart selection indicating the data items
 */
- (MAChartSelection*)getItemsInPlotContentRect:(CGRect)rect;

#pragma mark - Gestures

/*! Tells the receiver to handle the single-tap gesture.
 *  @param gestureRecognizer An instance of a subclass of UITapGestureRecognizer.
 */
- (void)handlePlotAreaSingleTapGesture:(UIGestureRecognizer*)gestureRecognizer;

/*! Tells the receiver to handle the double-tap gesture.
 *  @param gestureRecognizer An instance of a subclass of UITapGestureRecognizer..
 *  @return YES if the gesture is successfully handled
 */
- (BOOL)handlePlotAreaDoubleTapGesture:(UIGestureRecognizer*)gestureRecognizer;

/*! Highlights category
 */
-(void)highlightCategory;


@end
