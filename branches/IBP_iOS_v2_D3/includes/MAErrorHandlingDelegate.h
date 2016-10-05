//
//  MAErrorHandlerDelegate.h
//  MAKit
//
//  Created by Steven Xia on 9/15/11.
//  Copyright 2011 SAP Singapore. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MAError;


/**	
 @ingroup MAKit
 @brief The MAKit Error Handler delegate.  
 */
@protocol MAErrorHandlingDelegate <NSObject>

/**	
 @brief Notifies the delegate when runtime error is detected. 
 @param error The error object that contains error information
 */
-(void)handleError:(MAError*)error;

@end
