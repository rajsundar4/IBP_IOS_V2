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
//  MAAnalyticChartViewDelegate.h
//  MAKit
//
//  Created by Zhang Jie on 9/12/11.
//  Copyright 2011 SAP AG. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MAAnalyticChartView;
@class MAChartViewController;
@class MAChartSelection;


/** 
 @ingroup MAKit
 @brief Protocol of analytic chart view delegate
 */
@protocol MAAnalyticChartViewDelegate <NSObject>

@optional

/**
 @brief Notifies the delegate that the chart view has been refreshed.
 @param chartView The analytic chart view object informing the delegate of this event.
 */
- (void)didRefreshInChartView:(MAAnalyticChartView*)chartView;

/**
 @brief Notifies the delegate that the the drill down level has been changed (drilldown/drillup) in the chart view.
 @param chartView The analytic chart view object informing the delegate of this event.
 @param level A number indicating the new drilling level.
 @param category The category index of the previous drilling level
 */
- (void)didChangeDrillDownLevelInChartView:(MAAnalyticChartView *)chartView toLevel:(NSUInteger)level fromCategory:(NSUInteger)category;

/**
 @brief Notifies the delegate to show embedded chart in the MAChartViewController.
 @param miniChartController containing the selected embedded chart.
 */
-(void)didClickEmbeddedChart:(MAChartViewController *)miniChartController;

/**
 @brief Queries the receiver whether multiple items selection should be enabled
 
 @param chartView An object representing the chart view requesting this information.
 @return YES to enable mutiple items selection; NO otherwise.
 */
- (BOOL)willSelectItems:(MAAnalyticChartView *)chartView;

/**
 @brief Informs the receiver that multiple items have been selected.
 
 @param chartView An object representing the chart view requesting this information.
 @param selection An object representing the selected items.
 */
- (void)chartView:(MAAnalyticChartView *)chartView didSelectItems:(MAChartSelection*)selection;

@end

