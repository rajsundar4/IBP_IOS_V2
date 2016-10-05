//
//  DashboardCell.h
//  IBP
//
//  Created by Rick Thompson on 11/23/14.
//  Copyright (c) 2014 Linear Logics Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DashboardCell <NSObject>

- (NSNumber *)getRowSpan;
- (NSNumber *)getColumnSpan;
- (NSNumber *)setStartRow;
- (NSNumber *)setStartColumn;
- (void) setReportviewID;


@end
