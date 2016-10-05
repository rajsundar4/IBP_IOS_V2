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
//  MAAnalyticChartViewController.h
//  MAKit
//
//  Created by Zhang Jie on 9/11/11.
//  Copyright 2011 SAP AG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "MAAnalyticChartView.h"

@protocol MAErrorHandlingDelegate;

/**
 @ingroup MAKit
 @brief A view controller for analytic chart view.
 */
@interface MAAnalyticChartViewController : UIViewController <MAAnalyticChartViewDelegate,MFMailComposeViewControllerDelegate>
{
    
}

/**
 Returns the analytic chart view managed by the controller object.
 */
@property(nonatomic, retain) MAAnalyticChartView* chartView;

/**
 Returns the toolbar managed by the controller object.
 */
@property(nonatomic, retain) UIToolbar* toolbar;

/** 
 The object that acts as the error handler of the receiving analytic chart view.
 */
@property(nonatomic, retain) id<MAErrorHandlingDelegate> errorHandler;

/**
 @brief Initializes an analytic chart view controller to manage an analytic chart view
 @param chartView The analytic chart view that the controller is to manage
 @return An initialized controller object or nil if the object couldn't be created
 */
- (id)initWithAnalyticChartView:(MAAnalyticChartView*)chartView;

/**
 @brief Reloads data of the analytic chart view
 */
- (IBAction)reloadData;

/**
 @brief Animates in the data table
 */
- (IBAction)openDataTable;

/**
 @brief Animates in the what-if panel
 */
- (IBAction)openWhatIfPanel;

/**
 @brief Captures the current chart as an image and opens a modal view to perform annotations and e-mail sharing
 */
- (IBAction)shareByMail;

@end
