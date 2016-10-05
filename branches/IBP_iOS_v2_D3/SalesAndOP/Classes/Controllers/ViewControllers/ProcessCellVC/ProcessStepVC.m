//
//  ProcessStepVC.m
//  IBP
//
//  Created by Rick Thompson on 12/11/14.
//  Copyright (c) 2014 Linear Logics Corporation. All rights reserved.
//

#import "ProcessStepVC.h"

@interface ProcessStepVC ()

@end

@implementation ProcessStepVC
@synthesize stepNameString;
@synthesize  datesString;
@synthesize completionPercentage;
@synthesize statusString;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _frontCompletionLabel = [[UILabel alloc] init];
    [_frontCompletionLabel.layer setBorderWidth:1.0];
    [_frontCompletionLabel.layer setCornerRadius:3];
    [_frontCompletionLabel setTextColor:[UIColor whiteColor]];
    [_frontCompletionLabel setFont:[UIFont fontWithName:@"Arial-BoldMT" size:14]];
    _stepNameLabel.text = self.stepNameString;
    _datesLabel.text = self.datesString;
    
    if ([statusString caseInsensitiveCompare:@"COMPLETED"] == NSOrderedSame) {
        blockWidth = 150;
        [_frontCompletionLabel setBackgroundColor:[UIColor colorWithRed:58/255.f green:185.0/255.f blue:255/255.f alpha:1.0]];
        _frontCompletionLabel.text = @" Completed";
    } else if ([statusString caseInsensitiveCompare:@"NOT_STARTED"] == NSOrderedSame) {
        blockWidth = 150;
        [_frontCompletionLabel setBackgroundColor:[UIColor whiteColor]];
    } else {
        //  status = IN_PROGRESS
        blockWidth = 150 * [completionPercentage floatValue];
        [_frontCompletionLabel setBackgroundColor:[UIColor colorWithRed:58/255.f green:185.0/255.f blue:255/255.f alpha:1.0]];
        _frontCompletionLabel.text = [NSString stringWithFormat:@" %d%%", (int) roundf([completionPercentage floatValue] * 100)];
        
    }

    [_frontCompletionLabel setFrame:CGRectMake(46, 29, blockWidth, 21)];
    [self.view addSubview:_frontCompletionLabel];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
