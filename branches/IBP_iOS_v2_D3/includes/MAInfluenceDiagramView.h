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
//  MAInfluenceDiagramView.h
//  MAKit
//
//  Created by Bensam Joyson on 6/8/11.
//  Copyright 2011 SAP AG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MAInfluenceDiagramDelegate.h"
#import "MAMetricNodeViewDelegate.h"
#import "MAQueryDelegate.h"
#import "MADiagramSpec.h"
#import "MADiagramTheme.h"

@protocol MAInfluenceDiagramDelegate;
@protocol MAMetricNodeViewDelegate;
@class MAMetricNodeView;
@class MAInfluenceDiagramModel;

typedef enum  {
    MAInfluenceDiagramModeNone = 0,
	MAInfluenceDiagramModeSnapshot,
	MAInfluenceDiagramModeNormal,
	MAInfluenceDiagramModeGoalSeek
} MAInfluenceDiagramMode;


/**
 @ingroup MAKit
 @brief  Influence diagram view class,
 
 */
@interface MAInfluenceDiagramView : UIView <UIScrollViewDelegate, MAMetricNodeViewDelegate> {


}

#pragma mark -
#pragma mark Properties

/*! Metadata file path.
 */
@property(nonatomic, copy) NSString *metaDataPath;

/*! View mode of diagram.
 */
@property(nonatomic, assign) MAInfluenceDiagramMode viewMode;

/*! Metadata spec of diagram.
 */
@property(nonatomic, retain) MADiagramSpec *metaDataSpec;

/*! Metadata dictionary of diagram.
 */
@property(nonatomic, retain) NSMutableDictionary* metaDict;

/*! Delegate of diagram.
 */
@property (nonatomic, assign) id <MAInfluenceDiagramDelegate>delegate;

/*! Data source of diagram.
 */
@property(nonatomic, retain) id<MAQueryDelegate> dataSource;

/*! Theme of diagram.
 */
@property(nonatomic, retain) id<MADiagramTheme> theme;

#pragma mark -

#pragma mark Methods
/**
 @brief A constructor of influence diagram with frame, metadata file path and view mode.
 @param frame The frame of influence diagram.
 @param metaDataFile The metadata file path of influence diagram.
 @param viewMode The view mode of influence diagram.
 */
- (id)initWithFrame:(CGRect)frame metaDataFile:(NSString*)filePath viewMode:(MAInfluenceDiagramMode)mode;

/**
 @brief A constructor of influence diagram with frame and view mode.
 @param frame The frame of influence diagram.
 @param viewMode The view mode of influence diagram.
 */
- (id)initWithFrame:(CGRect)frame viewMode:(MAInfluenceDiagramMode)mode;

/**
 @brief A constructor of influence diagram with frame.
 @param frame The frame of influence diagram.
 */
- (id)initWithFrame:(CGRect)frame;

/**
 @brief Redraw the diagram view.
 @param animated Whether to display animation.
 */
-(void)setNeedsDisplay:(BOOL)animated;

/**
 @brief Refreshs the diagram view.  
 
 Call this method to reload data from the data source in an asynchornous thread and redraw the view.
 */
-(void)reloadData;

/**
 @brief Set number of alerts for nodes.
 @param alertforNodes A dictionary with node name as key and number of
 alerts as value.
 */
-(void)setAlertForNodes:(NSDictionary*)alertNodes;

/**
 @brief Set new selected node.
 @param Name of the selected node.
 */
-(void)setSelectedNode:(NSString*)node;

/**
 @brief Reset all actual values to original after goalseek.
 */
-(void)resetActualValues;

@end
