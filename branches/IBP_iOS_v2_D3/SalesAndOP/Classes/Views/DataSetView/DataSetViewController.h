//
//  DataSetViewController.h
//  S&OP
//
//  Created by Mayur Birari on 18/07/13.
//  Copyright (c) 2013 Linear Logics Corp.. All rights reserved.
//

#import <UIKit/UIKit.h>

/*!
 \internal
 @class DataSetViewController
 @abstract This class is used to display DataSet View.
 @discussion DataSetView has planning area list (Report Model).
 */
@interface DataSetViewController : UIViewController

/*!
 \internal
 @method fillDatasetArray.
 @discussion This method used to fill dataset array at runtime for Planning Area list.
 */
- (void)fillDatasetArray;

@end
