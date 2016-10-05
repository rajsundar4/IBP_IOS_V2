//
//  ProcessCellVC.m
//  IBP
//
//  Created by Rick Thompson on 11/21/14.
//  Copyright (c) 2014 Linear Logics Corporation. All rights reserved.
//

#import "ProcessCellVC.h"
#import "JAMController.h"
#import "ProcessStepVC.h"


@interface ProcessCellVC ()

@end

@implementation ProcessCellVC

@synthesize titleString;
@synthesize timeStampString;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //  Set the timestamp
    NSString *localizedDate = [NSDateFormatter localizedStringFromDate:[[JAMController sharedInstance] collaborationServicesTimeStamp] dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle];
    self.timeStampLabel.text = [NSString stringWithFormat:@"Last updated:  %@", localizedDate];
    
    //  Get the collaborationServices array
    NSArray *processArray = [[JAMController sharedInstance] collaborationServicesArray];
    
    //  Check that there are processes available
    if ([processArray count] != 0) {
        //  Display first process flow by default
        NSDictionary *process1Dictionary = [processArray objectAtIndex:0];  //Crash
        self.titleLabel.text = [NSString stringWithFormat:@"Process:  %@", [process1Dictionary valueForKey:@"name"]];
        NSArray *stepsArray = [process1Dictionary objectForKey:@"steps"];
        
        // Loop through steps to build diagram
        int xoffset = 10;
        int yoffset = 10;
        int x_interval = 246;
        int y_height = 91;
        
        for (NSDictionary *stepDictionary in stepsArray) {
            //NSDictionary *stepDictionary = [stepsArray objectAtIndex:3];
            ProcessStepVC *stepVC = [[ProcessStepVC alloc] initWithNibName:@"ProcessStepVC" bundle:nil];
            
            //stepVC.stepNameLabel.text = [stepDictionary valueForKey:@"name"];
            stepVC.stepNameString = [stepDictionary valueForKey:@"name"];
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"YYYY-MM-DD"];
            NSDate *unformattedStartDate = [dateFormatter dateFromString:[stepDictionary valueForKey:@"startDate"]];
            NSString *localizedStartDate = [NSDateFormatter localizedStringFromDate:unformattedStartDate dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterNoStyle];
            NSDate *unformattedEndDate = [dateFormatter dateFromString:[stepDictionary valueForKey:@"endDate"]];
            NSString *localizedEndDate = [NSDateFormatter localizedStringFromDate:unformattedEndDate dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterNoStyle];
            
            //stepVC.datesLabel.text = [NSString stringWithFormat:@"%@ - %@", localizedStartDate, localizedEndDate];
            stepVC.datesString = [NSString stringWithFormat:@"%@ - %@", localizedStartDate, localizedEndDate];
            
            //[stepVC.frontCompletionLabel setFrame:CGRectMake(46,29,50,21)];
            NSString *progressString = [stepDictionary valueForKey:@"progress"];
            stepVC.completionPercentage = [NSNumber numberWithFloat:([progressString floatValue] / 100)];
            stepVC.statusString = [stepDictionary valueForKey:@"status"];
            [stepVC.view setFrame:CGRectMake(xoffset, yoffset, 239, 91)];
            [self addChildViewController:stepVC];
            [self.scrollView addSubview:stepVC.view];
            xoffset = xoffset + x_interval;
        }
        
        [self.scrollView setContentSize:CGSizeMake(xoffset, y_height)];
        
        [self.scrollView setScrollEnabled:YES];
    }
}

- (void)viewWillLayoutSubviews
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
