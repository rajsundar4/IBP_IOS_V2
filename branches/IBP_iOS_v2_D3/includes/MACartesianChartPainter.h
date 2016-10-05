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
//  MACartesianChartPainter.h
//  MADashboard
//
//  Created by Zhang Jie on 10/21/10.
//  Copyright 2010 SAP AG. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MACartesianRenderModel;


/*!
 *  @ingroup MAKit
 *  \brief Protocol of cartesian chart painter 
 *
 *  This protocol defines additional methods and properties that needs to be implemented by a cartesian chart type base painter.
 */
@protocol MACartesianChartPainter

@required

/**
 The cartesian render model
 */
@property(nonatomic, retain) MACartesianRenderModel *cartesianRenderModel;

/**
  A Boolean value that determines whether the cartesian chart has a horizontal axis title
 */
- (BOOL)hasHorizontalAxisTitle;

/**
 The font of the horizontal axis label
 */
- (UIFont*)horizontalAxisLabelFont;

/**
 The color of the horizontal axis label
 */
- (UIColor*)horizontalAxisLabelColor;

/**
 The text of the horizontal axis title
 */
- (NSString*)horizontalAxisTitle;

/**
 A Boolean value that determines whether the cartesian chart has a vertical axis title
 */
- (BOOL)hasVerticalAxisTitle;

/**
 The font of the vertical axis label
 */
- (UIFont*)verticalAxisLabelFont;

/**
 The color of the vertical axis label
 */
- (UIColor*)verticalAxisLabelColor;

/**
 The text of the vertical axis title
 */
- (NSString*)verticalAxisTitle;

@end
