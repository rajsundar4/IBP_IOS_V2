//
//  MADataTable.h
//  MAKit
//
//  Created by Biao Hua on 3/15/11.
//  Copyright 2011 SAP AG. All rights reserved.
//

#import <Foundation/Foundation.h>

/** 
 @ingroup MAKit
 @brief Protocol that retrieves data for chart rendering.
 
*/
@protocol MAQueryDataTable <NSObject>

@optional 

/**
 * Whether data in this table is already sorted for the chart.
 */
@property(nonatomic, assign) BOOL sorted;

/**
 * The upper threshold.
 */
@property (nonatomic,retain) NSNumber* upperThreshold;

/**
 * The lower threshold.
 */
@property (nonatomic,retain) NSNumber* lowerThreshold;

/**
 * The reference value.
 */
@property (nonatomic,retain) NSNumber* referenceValue;

/**
 * Category from which predictive data starts.
 */
@property(nonatomic, retain) id predictiveStartCategory;

@required
/**	
 @brief Get column number in the data table.
 @returns Column count.
 */
-(int)getColumnCount;

/**	
 @brief Get row number in the data table.
 @returns Row count.
 */
-(int)getRows;

/**	
 @brief Gets data by column name and row index. 
 
 @param colName Requested column name.
 @param rowIndex Row index in the data table.
 @returns Data of assigned column. If the column or rowIndex does not exist, nil is returned.
 */
-(id)getData:(NSString*)colName atIndex:(int)rowIndex;

@optional 

/**	
 @brief Gets the accessory view by row index.
 
 @param categoryIndex Category index.
 @param serIndex Series index.
 @return Accessory view. If no acessory is required for the specified rowIndex, nil is returned.
 */
-(UIView*)getAccessoryViewAtIndex:(int)categoryIndex seriesIndex:(int)serIndex;

@end
