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
//  MAViewDelegate.h
//  MAKit
//
//  Created by Cordelia Lee on 9/30/11.
//  Copyright 2011 SAP AG. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MAView;

/** 
 @ingroup MAKit
 @brief Protocol of delegate for MAView class
 */
@protocol MAViewDelegate <NSObject>

@optional

/**
 @brief Tells the delegate that data in the dashboard view is about to be refreshed.
 
This event is invoked whenever the refresh button of MAView is being pressed. The event is not invoked when MAView is first loaded or when the data refresh is due to drill-down or filtering.
 @param view An object representing the dashboard view requesting this information.
 @returns Return YES if the data should be refreshed
 */
- (BOOL)willRefreshDataInView:(MAView *)view;

/**
 @brief Tells the delegate that data in the dashboard view has been refreshed.
 
 @param view An object representing the dashboard view requesting this information.
 */
- (void)didRefreshDataInView:(MAView *)view;

/**
 @brief Tells the delegate a row of RFTable is tapped.
 */
- (void)chartView:(MAChartView *)chartView singleTapRow:(NSUInteger)rowIndex column:(NSUInteger)columnIndex;

@end
