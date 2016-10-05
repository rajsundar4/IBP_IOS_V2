//
//  ProcessStepVC.h
//  IBP
//
//  Created by Rick Thompson on 12/11/14.
//  Copyright (c) 2014 Linear Logics Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface ProcessStepVC : UIViewController
{
    float blockWidth;
}

@property (nonatomic,strong) NSString *stepNameString;
@property (nonatomic,strong) IBOutlet UILabel *stepNameLabel;
@property (nonatomic,strong) NSString *datesString;
@property (nonatomic,strong) IBOutlet UILabel *datesLabel;
@property (nonatomic,strong) IBOutlet UILabel *backCompletionLabel;
@property (nonatomic,strong) IBOutlet UILabel *frontCompletionLabel;
@property (nonatomic,strong) NSNumber *completionPercentage;
@property (nonatomic,strong) NSString *statusString;

@end
