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
//  MADashboardTheme.h
//  MAKit
//
//  Created by Zhang Jie on 11/19/10.
//  Copyright 2010 SAP AG. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MADashboardItemView;	

/**
 @ingroup MAKit
 @brief Protocol that defines the dashboard theme
 */
@protocol MADashboardTheme <NSObject>

@required

/**
 @brief Asks the theme object to draw skin for the dashboard item view.
 
 @param itemView An object representing the dashboard item view requesting the skin.
 @param context A CGContextRef for the graphic context.
 @param rect The bounds of the drawing area.
 */
- (void) drawSkinForDashboardItemView:(MADashboardItemView*)itemView context:(CGContextRef)context rect:(CGRect)rect;

/*! @brief Returns the background color of dashboard
 */
- (UIColor*)dashboardBackgroundColor;

/*! @brief Returns the border color of dashboard
 */
- (UIColor*)dashboardBorderColor;

/*! @brief Returns the border color of dashboard
 */
- (UIColor*)dashboardItemTitleTextColor;

/*! @brief Returns the background color of dashboard item
 */
- (UIColor*)dashboardItemBackgroundColor;

/*! @brief Returns the border color of dashboard item
 */
- (UIColor*)dashboardItemBorderColor;


@optional

/**
 @brief Asks the theme object for the region whereby the dashboard item view will be selected
 
 @param itemView An object representing the dashboard item view requesting the skin.
 @param bounds The bounds of the drawing area.
 */
- (CGRect)selectButtonFrameForDashboardItemView:(MADashboardItemView*)itemView itemBounds:(CGRect)bounds;

/**
 @brief Asks the theme object for the region whereby the title label should be drawn
 
 @param itemView An object representing the dashboard item view requesting the skin.
 @param bounds The bounds of the drawing area.
 */
- (CGRect)titleLabelFrameForDashboardItemView:(MADashboardItemView*)itemView itemBounds:(CGRect)bounds;

/**
 @brief Asks the theme object for the region whereby the content view should be drawn
 
 @param itemView An object representing the dashboard item view requesting the skin.
 @param bounds The bounds of the drawing area.
 */
- (CGRect)contentFrameForDashboardItemView:(MADashboardItemView*)itemView itemBounds:(CGRect)bounds;

/**
 Slider control minimum track image for different states.
 */
@property (nonatomic, retain) NSMutableDictionary *sliderControlMinimumTrackThemes;

/**
 Slider control maximum track image for different states.
 */
@property (nonatomic, retain) NSMutableDictionary *sliderControlMaximumTrackThemes;

/**
 Slider control thumb image for different states.
 */
@property (nonatomic, retain) NSMutableDictionary *sliderControlThumbThemes;


@end
