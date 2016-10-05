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
//  MADashboardViewDelegate.h
//  MAKit
//
//  Created by Zhang Jie on 2/2/11.
//  Copyright 2011 SAP AG. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MADashboardView;
@protocol MADashboardtheme;
@protocol MADashboardTheme;


/*! 
 *  @ingroup MAKit
 *  \brief Protocol of dashboard view delegate 
 *
 *  This protocol defines methods and properties that needs to be implemented by a dashboard view delegate. 
 *  The delegate of a MADashboardView object must adopt the MADashboardViewDelegate protocol. 
 */
@protocol MADashboardViewDelegate <NSObject>

@required

/*! @brief Asks the delegate for the theme to use for the dashboard view.
 *	@param dashboardView	A dashboard-view object.
 *	@returns					An object implementing MADashboardTheme that the dashboard view can use for the specified theme.
 */
- (id<MADashboardTheme>)themeForDashboardView:(MADashboardView *)dashboardView;

@optional

/*!	@brief Asks the delegate to return the content size of the dashboard view
 *
 *	If not implemented, frameSize is used as the default content size. Scrolling is enabled if content size is bigger than the frameSize.
 *	@param dashboardView A dashboard-view object.
 *	@param frameSize Size of the current dashboard content area in the dashboardView.
 *	@returns Size of the content.
 */
- (CGSize)dashboardView:(MADashboardView *)dashboardView contentSizeWithFrameSize:(CGSize)frameSize;

/*! @brief Asks the delegate for the frame for a item in a specified location.
 *	@param dashboardView	A dashboard-view object.
 *	@param indexPath		An index path that locates an item in dashboardView.
 *  @param contentSize		The dashboard content size
 *	@returns					An rect representing a frame for the specified item.
 */
- (CGRect)dashboardView:(MADashboardView *)dashboardView frameForItemAtIndexPath:(NSIndexPath *)indexPath withContentSize:(CGSize)contentSize;

/*! @brief Asks the delegate whether the title label for an item in a specified location is visible.
 *	@param dashboardView	A dashboard-view object.
 *	@param indexPath		An index path that locates an item in dashboardView.
 *	@returns				YES if the item title should be visible.
 */
- (BOOL)dashboardView:(MADashboardView *)dashboardView isTitleVisibleAtIndexPath:(NSIndexPath *)indexPath;

/*! @brief Asks the delegate whether the select button for an item in a specified location is visible.
 *	@param dashboardView	A dashboard-view object.
 *	@param indexPath		An index path that locates an item in dashboardView.
 *	@returns				YES if the select button is to be enabled.
 */
- (BOOL)dashboardView:(MADashboardView *)dashboardView isSelectButtonEnabledAtIndexPath:(NSIndexPath *)indexPath;

/*! @brief Tells the delegate that a specified item is about to be selected.
 *	@param dashboardView	A dashboard-view object.
 *	@param indexPath		An index path that locates an item in dashboardView.
 *	@returns					A BOOL value that confirms the selected item. Return YES if you want the item to be selected. Return NO if you don't want the item selected.
 */
- (BOOL)dashboardView:(MADashboardView *)dashboardView willSelectItemAtIndexPath:(NSIndexPath *)indexPath;

/*! @brief Tells the delegate that the specified item is now selected.
 *	@param dashboardView	A dashboard-view object.
 *	@param indexPath		An index path that locates an item in dashboardView.
 */
- (void)dashboardView:(MADashboardView *)dashboardView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;

/*! @brief Tells the delegate that a specified item is about to be deselected.
 *	@param dashboardView	A dashboard-view object.
 *	@param indexPath		An index path that locates an item in dashboardView.
 *	@returns					A BOOL value that confirms the deselected item. Return YES if you want the item to be deselected. Return NO if you don't want the item deselected.
 */
- (BOOL)dashboardView:(MADashboardView *)dashboardView willDeselectItemAtIndexPath:(NSIndexPath *)indexPath;

/*! @brief Tells the delegate that the specified item is now deselected.
 *	@param dashboardView	A dashboard-view object.
 *	@param indexPath		An index path that locates an item in dashboardView.
 */
- (void)dashboardView:(MADashboardView *)dashboardView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath;

//- (void)dashboardView:(MADashboardView *)dashboardView willDisplayItemContent:(UIView *)contentView forItemAtIndexPath:(NSIndexPath *)indexPath;

@end
