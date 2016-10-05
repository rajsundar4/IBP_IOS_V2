//
//  KPICellVC.m
//  IBP
//
//  Created by Rick Thompson on 11/14/14.
//  Copyright (c) 2014 Linear Logics Corporation. All rights reserved.
//

#import "KPICellVC.h"



@interface KPICellVC ()

@end

@implementation KPICellVC

@synthesize cellName;
@synthesize contentReference;
@synthesize contentType;
@synthesize kLabel;
@synthesize cLabel;
@synthesize titleLabel;
@synthesize timestamp;
@synthesize cString;
@synthesize kString;
@synthesize titleString;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //titleLabel = [[UILabel alloc] init];
        //timestamp =  [[UILabel alloc] init];
        //kLabel = [[UILabel alloc] init];
        //cLabel = [[UILabel alloc] init];
        //cellName = [[NSString alloc] init];
        //contentReference = [[NSString alloc] init];
        //contentType = [[NSString alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //  Format the numeric value here
    
    
    titleLabel.text = titleString;
    titleLabel.numberOfLines = 3;
    cLabel.text = cString;
    kLabel.text = [self formatNumberString:kString];
}


- (NSString *)formatNumberString:(NSString *)numberString
{
    double tempNumber;
    NSString *returnString;
    
    if (![numberString isKindOfClass:[NSNull class]]) {
        tempNumber = [numberString doubleValue];
        
        if (tempNumber >= 1000000000.0 || tempNumber <= -1000000000.0) {
            returnString = [NSString stringWithFormat:@"%3.1f B", (tempNumber/1000000000)];
            
        } else if (tempNumber >= 1000000.0 || tempNumber <= -1000000.0) {
            returnString = [NSString stringWithFormat:@"%3.1f M", (tempNumber/1000000)];
            
        } else if (tempNumber >= 1000.0 || tempNumber <= -1000.0) {
            //  format as xxx.x K
            returnString = [NSString stringWithFormat:@"%3.1f K", (tempNumber/1000)];
        } else if (tempNumber > 1.0 || tempNumber <= -1.0) {
            //  format as xxx.xx
            returnString = [NSString stringWithFormat:@"%3.2f", tempNumber];
        } else if (tempNumber >= 0 && tempNumber <= 1) {
            // format as percentage
            returnString = [NSString stringWithFormat:@"%2.1f %%", (tempNumber * 100)];
        }
    }
    
    return returnString;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

