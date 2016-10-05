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
//  MAInfluenceDiagramDelegate.h
//  MAKit
//
//  Created by Thomas Zang.
//  Copyright 2011 SAP AG. All rights reserved.
//
@class MAInfluenceDiagramView;

/**
   @ingroup MAKit
   @brief Protocol of influence diagram delegate 
 
   This protocol defines methods that need to be implemented by a influence diagram delegate. 
 */
@protocol MAInfluenceDiagramDelegate

@optional
/**
 @brief A event is triggered when the values of nodes are changed during goal seek
 @param influenceDiagram The instance of influence diagram
 @param actualValues A dictionary with node name as key and changed actual
 value as value
 */
-(void)
didChangeValueOnMetricNode:(MAInfluenceDiagramView*)influenceDiagram
actualValues:(NSDictionary*)values;

/**
 @brief A event is triggered when the values of nodes are changed after goal seek
 @param influenceDiagram The instance of influence diagram
 @param actualValues A dictionary with node name as key and changed actual
 value as value
 */
-(void)
didChangeValueOnMetricNodeDragEnd:(MAInfluenceDiagramView*)influenceDiagram
actualValues:(NSDictionary*)values;

/**
 @brief A event is triggered when the influence diagram is panned around
 @param influenceDiagram The instance of influence diagram
 @param metricNodes A list of node names that are visible in the view after panning
 */
-(void) didPanOnInfluenceDiagram:(MAInfluenceDiagramView*)influenceDiagram
                     metricNodes:(NSArray*)nodes;

/**
 @brief A event is triggered when a new node is selected
 @param influenceDiagram  The instance of influence diagram
 @param aMetricNode  The name of new selected node
 */
-(void) didSelectOnMetricNode:(MAInfluenceDiagramView*)influenceDiagram
                  aMetricNode:(NSString*)node;

/**
 @brief A event is triggered when a node with associated charts is double-tapped
 @param influenceDiagram The instance of influence diagram
 @param aMetricNode The name of the node double-tapped
 @param associatedCharts A list of chart names associated with the node double-tapped
 */
-(void) didDoubleTapOnMetricNode:(MAInfluenceDiagramView*)influenceDiagram
                     aMetricNode:(NSString*)node associatedCharts:(NSArray*)charts;

/**
 @brief A event is triggered when tapping the influence diagram in Snapshot mode
 @param influenceDiagram  The instance of influence diagram
 */
-(void)didTapOnInfluenceDiagramInSnapshotMode:(MAInfluenceDiagramView*)influenceDiagram;

/**
 @brief A event is triggered when a node is single-tapped
 @param influenceDiagram  The instance of influence diagram
 @param aMetricNode  The name of the node single-tapped
 */
-(void)didSingleTapOnMetricNode:(MAInfluenceDiagramView*)influenceDiagram aMetricNode:(NSString*)node;

@end






