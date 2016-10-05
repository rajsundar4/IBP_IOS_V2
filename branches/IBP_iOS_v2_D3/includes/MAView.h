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
//  MAView.h
//  MAKit
//
//  Created by Zhang Jie on 12/6/10.
//  Copyright 2010 SAP AG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MADashboardViewDelegate.h"
#import "MADashboardViewDataSource.h"
#import "MAChartViewDelegate.h"


@protocol MAChartTheme;
@protocol MADashboardTheme;
@protocol MAQueryDelegate;
@protocol MAErrorHandlingDelegate;
@protocol MAViewDelegate;


/*! 
 * @ingroup MAKit
 * \brief View class that contains main functions of MAKit.
 *
 * MAView accepts MAKit metadata configurations and renders a dashboard or a single chart with analytic features based on the configurations. 
 *
 *	\section codeexample Code Example
 *	\code
 MAView *view = [[MAViewController alloc] initWithFrame:CGRectMake(0, 0, 500, 500)];
 view.metaDataPath = [[NSBundle mainBundle] pathForResource:@"MAMeta" ofType:@"xml"];
 view.theme = [[[MAKitTheme_WelterWeight alloc] init] autorelease];
 ...
 [view refresh];
 *	\endcode
 */
@interface MAView : UIView <MADashboardViewDelegate, MADashboardViewDataSource, MAChartViewDelegate>
{

}

/*! Metadata file path
 */
@property(nonatomic, retain) NSString *metaDataPath;

/*! A dictionary of metadata definition
 */
@property(nonatomic, retain) NSMutableDictionary* metaDict;

/*! Theme of charts and dashboard in the view.
 */
@property(nonatomic, retain) id<MAChartTheme, MADashboardTheme> theme;

/*! Data source object
 */
@property(nonatomic, retain) id<MAQueryDelegate> dataSource;

/*! View controller
 */
@property(nonatomic, assign) UIViewController *controller;

/*! The error handler delegate
 */
@property (nonatomic, retain) id<MAErrorHandlingDelegate> errorHandler;

/**
 @brief The object that acts as the delegate of the receiving dahboard view.
 The delegate is not retained. 
 */
@property(nonatomic, assign) id<MAViewDelegate> delegate;

/*! Email sharing title
 */
@property(nonatomic, retain) NSString *emailSharingTitle;

/*! @brief Refresh the content
 */
- (void)refresh;

@end
