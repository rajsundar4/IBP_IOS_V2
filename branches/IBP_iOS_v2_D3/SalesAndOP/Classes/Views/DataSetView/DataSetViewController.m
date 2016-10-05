//
//  DataSetViewController.m
//  S&OP
//
//  Created by Mayur Birari on 18/07/13.
//  Copyright (c) 2013 Linear Logics Corp.. All rights reserved.
//

#import "Global.h"
#import "Report.h"
#import "UIConfigValue.h"
#import "DataController.h"
#import "HomeViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "DataSetViewController.h"
#import "AnalyticsTableViewCell.h"

/*!
 @class DataSetViewController
 @abstract This class is used to display DataSet View.
 @discussion DataSetView has planning area list (Report Model).
 */
@interface DataSetViewController ()<UITableViewDataSource, UITableViewDelegate>{

    /// Used to store the Reports (Planning Area) data.
    NSMutableArray *datasetArray;
    /// UITableView, instance of Report list
    __weak IBOutlet UITableView *dataSetTableView;
}

@end

@implementation DataSetViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    // Fill dataset array.
    [self fillDatasetArray];
    
    // Set first cell in table as selected by default.
    [dataSetTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO
                            scrollPosition:UITableViewScrollPositionNone];
}

#pragma mark - Custom methods

/*!
 @method fillDatasetArray.
 @abstract.
 @discussion This method used to fill dataset array at runtime.
 @param nil.
 @result nil.
 */
- (void)fillDatasetArray{
    
    // Fill with Data Controllers Report array.
    datasetArray = [[NSMutableArray alloc] init];
    if([[[DataController sharedDataInstance] reportsArray]  count])
        [datasetArray addObjectsFromArray:[[DataController sharedDataInstance] reportsArray]];
}

#pragma mark- UITableViewDatasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [datasetArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* rowIdentifier=@"CellIdentifier";
    UITableViewCell* cell= [tableView dequeueReusableCellWithIdentifier:rowIdentifier];

    if(cell == nil) {
    
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:rowIdentifier];
        
        // Add custom label in cell.
        UILabel *customLabel = [[UILabel alloc] initWithFrame:kCellCustomLabelFrame];
        [customLabel setTag:kCustomLabelInDatasetViewTag];
        [customLabel setBackgroundColor:[UIColor clearColor]];
        [customLabel setFont:kProFont_18];
        [customLabel setTextColor:kCellLabelTextColor];
        [customLabel setHighlightedTextColor:[UIColor whiteColor]];
        [cell setIndentationLevel:1];
        [cell.contentView addSubview:customLabel];
    }

    // Get data from Report model and Data Controller and display in Cell.
    Report *reportModel = [datasetArray objectAtIndex:indexPath.row];
    UILabel *localCustomLabel = (UILabel *)[cell viewWithTag:kCustomLabelInDatasetViewTag];
    [localCustomLabel setText:reportModel.reportName];

    // Set drop shadow
    cell.textLabel.layer.shadowOpacity = kCustomLabelOpacity;
    cell.textLabel.layer.shadowRadius = kCustomLabelShadowRadius;
    cell.textLabel.layer.shadowColor = [UIColor whiteColor].CGColor;
    cell.textLabel.layer.shadowOffset = CGSizeMake(0.0, 1);
    
    // Add selection view.
    UIView *selectionColor = [[UIView alloc] init];
    selectionColor.backgroundColor = kSelectionViewColor;
    [cell setSelectedBackgroundView:selectionColor];
    selectionColor=nil;
    
    
    
    return cell;
}

#pragma mark- UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [[(HomeViewController *)self.parentViewController headerView].datasetButton setSelected:NO];
    
    Report *reportModel = [datasetArray objectAtIndex:indexPath.row];
   
    NSDictionary *selectedReport = [NSDictionary dictionaryWithObject:reportModel
                                                                    forKey:kGetAllReportDataKey];
    // Add notification to send selected Report object.
    [[NSNotificationCenter defaultCenter] postNotificationName:kSelectedPlannigAreaKey object:nil
                                                      userInfo:selectedReport];
    
    // Row has been select
    [self.view removeFromSuperview];
}

@end
