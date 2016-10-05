//
//  ProcessCellVC.h
//  IBP
//
//  Created by Rick Thompson on 11/21/14.
//  Copyright (c) 2014 Linear Logics Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DashboardCell.h"

@interface ProcessCellVC : UIViewController <DashboardCell>

@property (nonatomic,strong) NSNumber *rowSpan;
@property (nonatomic,strong) NSNumber *columnSpan;
@property (nonatomic,strong) NSNumber *startRow;
@property (nonatomic,strong) NSNumber *startColumn;
@property (nonatomic,strong) NSString *titleString;
@property (nonatomic,strong) NSString *timeStampString;
@property (nonatomic,strong) IBOutlet UILabel *titleLabel;
@property (nonatomic,strong) IBOutlet UILabel *timeStampLabel;
@property (nonatomic, strong)   IBOutlet UIScrollView *scrollView;


@end
