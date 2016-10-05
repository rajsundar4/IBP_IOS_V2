//
//  LeftMenuViewController.m
//  S&OP
//
//  Created by Mayur Birari on 18/07/13.
//  Copyright (c) 2013 Linear Logics Corp.. All rights reserved.
//

#import "Global.h"
#import "Report.h"
#import "ReportView.h"
#import "ReportPage.h"
#import "DataController.h"
#import "ReportPageLayout.h"
#import "AnalyticsTableViewCell.h"
#import "LeftMenuViewController.h"

/*!
 @protocol LeftMenuViewDelegate
 @abstract Used to load the dashboard and chart.
 @discussion This delegate used to notify on the event of dashboard and chart selected from the left panel, Home screen load the selected item.
 */
@interface LeftMenuViewController ()<UITableViewDataSource, UITableViewDelegate> {
    
    /// select dashbord list button.
    UIButton* dashbordsListButton;
    /// select chart list button.
    UIButton* chartsListButton;
    
    /// left panel analytics data table view.
    __weak IBOutlet UITableView *analyticsTableView;
    
    /// Uset to fill data from ReportPages(Dashboard) and ReportViews(Charts)
    NSMutableArray *datasourceArray;
    
    // enum for chart or dashboard type.
    DashboardOrCharts dashboardOrCharts;
    
    /// Instance for models.
    
    /// Selected Planning Area model
    Report *reportModel;
    /// Selected Dashboard model
    ReportPage *reportPageModel;
    /// Selected Chart model
    ReportView *reportViewModel;
    /// Used to store filter array from Data Controller
    NSMutableArray *filterAnalaticalArray;
    
    NSIndexPath* prevIndexPathForDashboard;
    NSIndexPath* prevIndexPathForChart;
}

/*!
 @method dashboardButtonPressed.
 @discussion This method used to show dashboard.
 @param sender - action object.
 @result nil.
 */
- (IBAction)dashboardButtonPressed:(id)sender;

/*!
 @method chartsButtonPressed.
 @discussion This method used to show chart.
 @param sender - action object.
 @result nil.
 */
- (IBAction)chartsButtonPressed:(id)sender;

@end

@implementation LeftMenuViewController
@synthesize footerImageView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    DLog(@"class: %@ initWithNobName", [self class]);
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        // Add notification form Dataset View Controller
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(receivedReportData:)
                                                     name:kSelectedPlannigAreaKey
                                                   object:nil];
    }
    return self;
}

#pragma mark - UIView lifeCycle

- (void)viewDidLoad{
    
    DLog(@"class: %@ viewDidLoad", [self class]);
    [super viewDidLoad];
    
    // Get access to the buttons
    dashbordsListButton = (UIButton *)[self.view viewWithTag:kDashboardListButtonTag];
    chartsListButton = (UIButton *)[self.view viewWithTag:kChartsListButtonTag];
    
    // Customize buttons.
    [self customizeButton];
    
    // Initialize array and Set default Dashboard.
    filterAnalaticalArray = [[NSMutableArray alloc] init];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kIsDashboard];
    
    // Intially fill dashboard
    [self fillDashboardArray];
}

- (void)viewWillAppear:(BOOL)animated{
    DLog(@"class: %@ viewWillAppear", [self class]);
    
    [super viewWillAppear:animated];
    //Check for the current interface orientation.
    if((self.interfaceOrientation == UIDeviceOrientationLandscapeLeft) || (self.interfaceOrientation == UIDeviceOrientationLandscapeRight)){
        [self.view setFrame:CGRectMake(0,0,[[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];;
        [self.footerImageView setFrame:FOOTER_IMAGE_VIEW_LANDSCAPE];
        [analyticsTableView setFrame:ANALYTICS_TABLEVIEW_FRAME_LANDSCAPE];
    }else{
        [self.view setFrame:CGRectMake(0,0,[[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];
        [self.footerImageView setFrame:FOOTER_IMAGE_VIEW_PORTRAIT];
        [analyticsTableView setFrame:ANALYTICS_TABLEVIEW_FRAME_PORTRAIT];
    }
}

#pragma mark - Custom method

/*!
 @method customizeButton.
 @abstract.
 @discussion This method used to change button property.
 @param nil.
 @result nil.
 */
- (void)customizeButton{
    
    DLog(@"class: %@ customizeButton", [self class]);
    [dashbordsListButton setTitleColor:kLeftViewButtonTitleColor forState:UIControlStateNormal];
    [dashbordsListButton.titleLabel setShadowColor:[UIColor blackColor]];
    [dashbordsListButton.titleLabel setShadowOffset:CGSizeMake(0, 1.0)];
    
    [chartsListButton.titleLabel setShadowColor:[UIColor blackColor]];
    [chartsListButton.titleLabel setShadowOffset:CGSizeMake(0, 1.0)];
    [chartsListButton setTitleColor:kLeftViewButtonTitleColor forState:UIControlStateNormal];
    
}

/*!
 @method refreshLeftMenu.
 @abstract.
 @discussion This method used to refill dashboard or charts array at runtime.
 @param nil.
 @result nil.
 */
- (void)refreshLeftMenu{
    
    DLog(@"class: %@ refreshLeftMenu", [self class]);
    if([[NSUserDefaults standardUserDefaults] boolForKey:kIsDashboard]){
        
        // Dashboard
        if([filterAnalaticalArray count]){
            [filterAnalaticalArray removeAllObjects];
        }
        
        if([[[DataController sharedDataInstance] reportPagesArray] count]){
            [filterAnalaticalArray addObjectsFromArray:[[DataController sharedDataInstance]
                                                        reportPagesArray]];
        }
        
        dashboardOrCharts = Dashboard;
        [self fillDashboardArray];
    } else {
        
        // Charts
        if([filterAnalaticalArray count]){
            [filterAnalaticalArray removeAllObjects];
        }
        
        // If Report object is NULL then take default Report from Data Controller.
        if(!reportModel){
            reportModel = [[DataController sharedDataInstance] defaultReport];
        }
        
        filterAnalaticalArray = [[DataController sharedDataInstance]
                                 getChartsForSelectedPlanningArea:reportModel];
        
        dashboardOrCharts = Charts;
        [self fillChartsArray];
    }
    
}

/*!
 @method fillDashboardArray.
 @abstract.
 @discussion This method used to fill dashboard array at runtime.
 @param nil.
 @result nil.
 */
- (void)fillDashboardArray{
    
    DLog(@"class: %@ fillDashBoardArray", [self class]);
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kIsDashboard];
    
    // Set Dashboard as default.
    if([filterAnalaticalArray count]){
        [filterAnalaticalArray removeAllObjects];
    }
    
    if([[[DataController sharedDataInstance] reportPagesArray] count]){
        [filterAnalaticalArray addObjectsFromArray:[[DataController sharedDataInstance]
                                                    reportPagesArray]];
    }
    
    dashboardOrCharts = Dashboard;
    
    // Reload table.
    [analyticsTableView reloadData];
    
    [dashbordsListButton setSelected:YES];
    [chartsListButton setSelected:NO];
}

/*!
 @method fillChartsArray.
 @abstract.
 @discussion This method used to fill charts array at runtime.
 @param nil.
 @result nil.
 */
- (void)fillChartsArray{
    
    DLog(@"class: %@ fillChartArray", [self class]);
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kIsDashboard];
    
    // Set Dashboard as default.
    if([filterAnalaticalArray count]){
        [filterAnalaticalArray removeAllObjects];
    }
    
    // If Report object is NULL then take default Report from Data Controller.
    if(!reportModel){
        reportModel = [[DataController sharedDataInstance] defaultReport];
    }
    
    filterAnalaticalArray = [[DataController sharedDataInstance]
                             getChartsForSelectedPlanningArea:reportModel];
    
    dashboardOrCharts = Charts;
    
    // Reload table.
    [analyticsTableView reloadData];
    
    [dashbordsListButton setSelected:NO];
    [chartsListButton setSelected:YES];
}

-(void)hideTheLeftBar {
    
    DLog(@"class: %@ hideTheLeftBar", [self class]);
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:kAnimationDuration];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    self.view.frame = CGRectMake(-self.view.frame.size.width,0,self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
    [self.view removeFromSuperview];
    
}

#pragma mark - NSNotification method

- (void)receivedReportData:(NSNotification *)notification{
    
    DLog(@"class: %@ receivedReportData", [self class]);
    [self fillDashboardArray];
}

#pragma mark- UITableViewDatasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [filterAnalaticalArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* rowIdentifier=@"analyticCellIdentifier";
    AnalyticsTableViewCell* cell= (AnalyticsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:rowIdentifier];
    
    if(cell == nil) {
        
        NSArray* nibsArray=[[NSBundle mainBundle] loadNibNamed:@"AnalyticsTableViewCell" owner:self options:nil];
        cell=(AnalyticsTableViewCell *)[nibsArray objectAtIndex:0];
        
        UIImageView *selectionColor = [[UIImageView alloc] initWithImage:[Global setImage:@"bg_listitem_normal@2x"]];
        selectionColor.backgroundColor = kSelectionViewColor;
        [cell setSelectedBackgroundView:selectionColor];
        selectionColor=nil;
    }
    
    switch (dashboardOrCharts) {
            
        case Dashboard:
            // Used to show Dashboard data.
            reportPageModel = [filterAnalaticalArray objectAtIndex:indexPath.row];
            [cell.chartTypeImageView setImage:[Global setImage:@"icn_dashboard@2x"]];
            [cell.analyticsLabel setText:reportPageModel.reportPageName];
            
            if([[[DataController sharedDataInstance] defaultReportPageModel] isKindOfClass:[ReportPage class]] && [[(ReportPage *)[[DataController sharedDataInstance] defaultReportPageModel] reportPageId] isEqualToString:reportPageModel.reportPageId]) {
            
                [analyticsTableView selectRowAtIndexPath:indexPath animated:NO
                                          scrollPosition:UITableViewScrollPositionNone];
            }
            
            break;
            
        case Charts:
            // Used to show charts data.
            reportViewModel = [filterAnalaticalArray objectAtIndex:indexPath.row];
            // Make report view types are lower case.
            reportViewModel.reportViewType = [reportViewModel.reportViewType lowercaseString];
            
            // Set Report view name to cell label.
            [cell.analyticsLabel setText:reportViewModel.reportViewName];
            
            // Set Report view type image to cell image view.
            SWITCH (reportViewModel.reportViewType) {
                
                CASE (kPie) {
                    [cell.chartTypeImageView setImage:[Global setImage:@"icn_chart_pie@2x"]];
                    break;
                }
                CASE (kCombination) {
                    [cell.chartTypeImageView setImage:
                     [Global setImage:@"icn_chart_combination@2x"]];
                    break;
                }
                CASE (kDonut) {
                    [cell.chartTypeImageView setImage:[Global setImage:@"icn_chart_donut@2x"]];
                    break;
                }
                CASE (kVerticalBarCluster) {
                    [cell.chartTypeImageView setImage:
                     [Global setImage:@"icn_chart_verticalbarcluster@2x"]];
                    break;
                }
                CASE (kHorizontalBar) {
                    [cell.chartTypeImageView setImage:[Global setImage:@"icn_chart_bar@2x"]];
                    break;
                }
                CASE (kHorizontalBarStacked) {
                    [cell.chartTypeImageView setImage:[Global setImage:@"icn_chart_verticalbarstacked@2x"]];
                    break;
                }
                CASE (kLine) {
                    [cell.chartTypeImageView setImage:[Global setImage:@"icn_chart_line@2x"]];
                    break;
                }
                CASE (kVerticalBarStacked) {
                    [cell.chartTypeImageView setImage:
                     [Global setImage:@"icn_chart_verticalbarstacked@2x"]];
                    break;
                }
                CASE (kTable) {
                    [cell.chartTypeImageView setImage:
                     [Global setImage:@"icn_chart_table@2x"]];
                    break;
                }
                DEFAULT {
                    [cell.chartTypeImageView setImage:[Global setImage:@"icn_dashboard@2x"]];
                    break;
                }
            }
            
            if([[[DataController sharedDataInstance] defaultReportPageModel] isKindOfClass:[ReportView class]] && [[(ReportView *)[[DataController sharedDataInstance] defaultReportPageModel] reportViewId] isEqualToString:reportViewModel.reportViewId]) {
                
                [analyticsTableView selectRowAtIndexPath:indexPath animated:NO
                                          scrollPosition:UITableViewScrollPositionNone];
            }
            break;
            
            
        default:
            break;
    }
    
    return cell;
}

- (UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 110)];
    
    [headerView setBackgroundColor:[UIColor clearColor]];
    
    return headerView;
}

#pragma mark- UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if([Global isNetworkReachable] || (connectionType == DefaultDashboardView)){
        
        prevIndexPathForDashboard = nil;
        prevIndexPathForChart = nil;
        
        switch (dashboardOrCharts) {
                
            case Dashboard:
                
                prevIndexPathForDashboard = indexPath ;
                
                // Used to show Dashboard data.
                reportPageModel = [filterAnalaticalArray objectAtIndex:indexPath.row];
                
                // Save dashboard data is new of default.
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kLoadDashboardData];
                // Save current selected dashboard name.
                [[NSUserDefaults standardUserDefaults] setValue:reportPageModel.reportPageName forKey:kSelectedDashboardName];
                
                // Pass it to the delegate
                [_leftMenuViewDelegate selectDashboardToLoad:reportPageModel];
                break;
                
            case Charts:
                
                prevIndexPathForChart = indexPath ;
                
                reportViewModel = [filterAnalaticalArray objectAtIndex:indexPath.row];
                
                // Save chart data is new of default.
                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kLoadDashboardData];
                // Save selected chart name.
                [[NSUserDefaults standardUserDefaults] setValue:reportViewModel.reportViewName forKey:kSelectedChartName];
                
                // Pass it to the delegate.
                [_leftMenuViewDelegate selectChartToLoad:reportViewModel];
                break;
                
        }
    }else{
        
        [Global displayNoNetworkAlert];
        
        if(prevIndexPathForDashboard && dashbordsListButton.selected) {
            
            [analyticsTableView selectRowAtIndexPath:prevIndexPathForDashboard animated:NO
                                      scrollPosition:UITableViewScrollPositionNone];
        }
        else if(prevIndexPathForChart && chartsListButton.selected) {
        
            [analyticsTableView selectRowAtIndexPath:prevIndexPathForChart animated:NO
                                      scrollPosition:UITableViewScrollPositionNone];
        }
        else {
        
            [analyticsTableView deselectRowAtIndexPath:indexPath animated:YES];
        }
    }
    // Row has been select
    [self hideTheLeftBar];
    
    
}

#pragma mark - UIButton Action methods

- (IBAction)dashboardButtonPressed:(id)sender {
    
    DLog(@"class: %@ dashboardButtonPressed", [self class]);
    // Fill dashboards array.
    [self fillDashboardArray];
    
}

- (IBAction)chartsButtonPressed:(id)sender {
    DLog(@"class: %@ chartButtonPressed", [self class]);
    // Fill charts array.
    [self fillChartsArray];
    
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    if((self.interfaceOrientation == UIDeviceOrientationLandscapeLeft) || (self.interfaceOrientation == UIDeviceOrientationLandscapeRight)){
        [self.view setFrame:CGRectMake(0,0,[[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];;
        [self.footerImageView setFrame:FOOTER_IMAGE_VIEW_LANDSCAPE];
        [analyticsTableView setFrame:ANALYTICS_TABLEVIEW_FRAME_LANDSCAPE];
    }else{
        [self.view setFrame:CGRectMake(0,0,[[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];
        [self.footerImageView setFrame:FOOTER_IMAGE_VIEW_PORTRAIT];
        [analyticsTableView setFrame:ANALYTICS_TABLEVIEW_FRAME_PORTRAIT];
    }
    [analyticsTableView reloadData];
}

@end
