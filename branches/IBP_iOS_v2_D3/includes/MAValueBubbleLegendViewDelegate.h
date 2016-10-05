//
//  MAValueBubbleLegendViewDelegate.h
//  MAKit
//
//  Created by Zhang Jie on 8/24/11.
//  Copyright 2011 SAP AG. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MAValueBubbleLegendView;

/** 
 *  @ingroup MAKit
 *  @brief Protocol of delegate for value bubble legend view 
 */
@protocol MAValueBubbleLegendViewDelegate <NSObject>

@optional

/**
 @brief Notifies the receiver that a legend item has been selected
 @param legendView A legend view notifing the delegate
 @param itemIndex Index of item selected
 */
- (void)legendView:(MAValueBubbleLegendView*)legendView didSelectItem:(NSUInteger)itemIndex;

/**
 @brief Notifies the receiver that a legend item has been deselected
 @param legendView A legend view notifing the delegate
 @param itemIndex Index of item deselected
 */
- (void)legendView:(MAValueBubbleLegendView*)legendView didDeselectItem:(NSUInteger)itemIndex;

@end
