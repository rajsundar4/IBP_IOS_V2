//
//  KPICellVC.h
//  IBP
//
//  Created by Rick Thompson on 11/14/14.
//  Copyright (c) 2014 Linear Logics Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface KPICellVC : UIViewController

@property (nonatomic,strong) NSString *cellName;
@property (nonatomic,strong) NSString *contentReference;
@property (nonatomic,strong) NSString *contentType;
@property (nonatomic,strong) NSString *titleString;
@property (nonatomic,strong) NSString *kString;
@property (nonatomic,strong) NSString *cString;
@property (nonatomic,strong) IBOutlet UILabel *kLabel;
@property (nonatomic,strong) IBOutlet UILabel *cLabel;
@property (nonatomic,strong) IBOutlet UILabel *titleLabel;
@property (nonatomic,strong) IBOutlet UILabel *timestamp;
@property (nonatomic,strong) NSNumber *rowSpan;
@property (nonatomic,strong) NSNumber *columnSpan;
@property (nonatomic,strong) NSNumber *startRow;
@property (nonatomic,strong) NSNumber *startColumn;

@end
