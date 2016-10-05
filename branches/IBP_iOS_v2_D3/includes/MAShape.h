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
//  MAShape.h
//  MADashboard
//
//  Created by Cordelia Lee on 10/14/10.
//  Copyright 2010 SAP AG. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MAShapeModel;

/*! 
 *  @ingroup MAKit
 *  \brief Protocol of chart basic shape.
 *
 *  This protocol defines methods and properties to be implemented by a chart shape. 
 *  A chart shape is responsible for painting the basic element for a chart series.  
 *  For example, a shape can be a column/bar, a line, or a pie piece.
 *  It provides users with a way to customize the chart look and feel.  
 *  Users may implement this protocol to create their own drawings for a basic shape, for example, a pencil shape for a column chart.
 */
@protocol MAShape <NSObject>

/**
 @brief Draws the shape using the specified shape model
 @param context Drawing context
 @param model Shape model
 */
- (void)drawInContext:(CGContextRef)context model:(MAShapeModel*)model;

@end
