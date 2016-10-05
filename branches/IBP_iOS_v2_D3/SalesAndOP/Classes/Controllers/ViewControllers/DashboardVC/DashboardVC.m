//
//  DashboardVC.m
//  IBP
//
//  Created by Rick Thompson on 11/14/14.
//  Copyright (c) 2014 Linear Logics Corporation. All rights reserved.
//

#import "DashboardVC.h"
#import "WebviewCellVC.h"
#import "KPICellVC.h"
#import "DataController.h"
#import "ReportPage.h"
#import "ReportPageLayout.h"
#import "ReportView.h"
#import "ReportViewAttr.h"
#import "HTMLBuilder.h"
#import "ProcessCellVC.h"
#import "WKWebviewCellVC.h"
#import "JAMController.h"
#import "D3WebViewController.h"
#import "Constants.h"

@interface DashboardVC ()

@property (nonatomic,strong) ReportView *tempReportView;

@property (nonatomic,strong) NSMutableArray *tempReportViewArray;

@end

@implementation DashboardVC

//@synthesize scrollView;
@synthesize cellArray;
@synthesize reportPage;
//@synthesize processFlag;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self setAutomaticallyAdjustsScrollViewInsets:NO];
        //  Initialize the grid to all zeroes.
        [self initializeGrid];
        totalRows = 0.0;
        currentRow = 0;
        count = 0;
        processFlag = FALSE;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // 1.  Get reportPageLayouts (existing in DataController for reportPage)
    // 2.  Load data for charts, etc (JSon calls)
    // 3.  Determine sizes and layout of cells
    // 4.  Create required cells
    // 5.  Display
    
    cellArray = [[NSMutableArray alloc] init];
    _tempReportViewArray = [[NSMutableArray alloc] init];

    //  Get the list of objects along with their layout for the given report page (dashboard)
    NSMutableArray *reportPageLayoutArray = [[DataController sharedDataInstance] getListOfReportPageLayoutForReportPage:reportPage];
    //  Generate reportview objects complete with metadata and attribute data
    //  This call will skip any items that do not have metadata (non-chart items like PROCESS)
    NSMutableArray *reportviewsArray = [[DataController sharedDataInstance] getListOFJSONDataForCharts:reportPageLayoutArray];
    [[DataController sharedDataInstance] assignValuesToTheReportViewAttributes: reportviewsArray];
    
    if ([reportPageLayoutArray count] == 0) {
        NSLog(@"No reportpagelayouts for dashboard!");
        //return;
        //  Write a dummy error page with message.
        self.errorMessageLabel.hidden = NO;
        self.errorMessageLabel.numberOfLines = 2;
        self.errorMessageLabel.text = @"No charts configured for dashboard.";
        
    } else {
        //  Check type
        //
        //  add to layout grid
        //  generate html
        
        //  Loop through reportpagelayout types for this dashboard
        
        BOOL firstCounter = false;  // Flag for wkWebView testing
        for (ReportPageLayout *reportpageLayout in reportPageLayoutArray) {
            NSLog(@"reportpageLayoutArray%@, %@", reportpageLayout.reportViewName, reportpageLayout.reportViewType);
            //  Check type - could be a chart type, PROCESS, TASKGROUP
            if ([reportpageLayout.reportViewType isEqualToString:@"PROCESS"]) {
                //  Need to fetch the process data
                NSError *returnError = nil;
                
                [[JAMController sharedInstance] getJamCollaborationServicesAndReturnError:&returnError];
                
                processFlag = true;
                ProcessCellVC *cell = [[ProcessCellVC alloc] init];
                [cellArray addObject:cell];
                [cell setTitle:@"PROCESS"];
                //  Process cell is always first and same size
                [cell setRowSpan:[NSNumber numberWithFloat:0.5]];
                [cell setColumnSpan:[NSNumber numberWithInt:4]];
                [cell setStartRow:[NSNumber numberWithInt:0]];
                [cell setStartColumn:[NSNumber numberWithInt:0]];
                
                for (int i = 0; i<GRIDCOLUMNS; i++)
                    dashboardGrid[currentRow][i] = 1;
                currentRow++;
            } else if([reportpageLayout.reportViewType isEqualToString:@"TASKGROUP"]) {
                //  What is TASKGROUP?
            } else {
                //  Assuming it is a chart/KPI
                //  Create cell
                //  set size in cell variables - dependent upon portrait/landscape mode
                //  fetch data
                
                _tempReportView = [[ReportView alloc] init];
                //  Find the matching chart in chart array
                for (ReportView *chart in reportviewsArray) {
                    if ([chart.reportViewId isEqualToString:reportpageLayout.reportViewId]) {
                        _tempReportView = chart;
                    }
                }
                
                if ([_tempReportView.is_kpi caseInsensitiveCompare:@"true"] == NSOrderedSame) {
                    // Create a KPI cell and add to array
                    KPICellVC *cell = [[KPICellVC alloc] initWithNibName:@"KPICellVC" bundle:nil];
                    
                    cell.title = _tempReportView.reportViewName;
                    ReportViewAttr *tReportViewAttr = [_tempReportView.reportViewAttrArray objectAtIndex:0];
                    //NSArray *values = [tempReportView.reportViewAttrArray objectAtIndex:0];
                    //int valuesCount = [tReportViewAttr.valuesArray count];
                    //NSString *tempValue = [tReportViewAttr.valuesArray objectAtIndex:0];
                    NSDictionary *tempAttrData = [_tempReportView.chartsDictionary objectAtIndex:0];
                    NSString *tempAttrString = tReportViewAttr.attr_Id;
                    //  Using charts dictionary for value source.  For some reason valuesArray not getting filled.
                    
                    cell.kString = [tempAttrData objectForKey:tempAttrString];
                    cell.titleString = _tempReportView.reportViewName;
                    [cell setRowSpan:reportpageLayout.rowSpan];
                    [cell setColumnSpan:reportpageLayout.columnSpan];
                    
                    [self locateCellInGridWithRows:cell];
                    [self logDashboardGrid];
                    
                    [cellArray addObject:cell];
                    
                } else {
                    //  Testing WKWebView
                    /**
                    if (firstCounter == false) {
                        firstCounter = true;
                        WKWebviewCellVC *cell = [[WKWebviewCellVC alloc] initWithNibName:@"WKWebviewCellVC" bundle:nil];
                        [cell setChart:tempReportView];
                        [cell setReportviewID:tempReportView.reportViewId];
                        [cell setRowSpan:reportpageLayout.rowSpan];
                        [cell setColumnSpan:reportpageLayout.columnSpan];
                        
                        [self locateCellInGridWithRows:cell];
                        [self logDashboardGrid];
                        
                        [cellArray addObject:cell];
                        
                        // Generate the HTML for chart
                        HTMLBuilder *htmlBuilder = [[HTMLBuilder alloc] init];
                        cell.contentReference = [htmlBuilder buildHTMLChartWithData:tempReportView andDBFlag:true];
                        cell.titleString = tempReportView.reportViewName;
                    } else {
                    **/
                    
                        // Create a webviewcell for chart and add to array
                        WebviewCellVC *cell = [[WebviewCellVC alloc] initWithNibName:@"WebviewCellVC" bundle:nil];
                        [cell setChart:_tempReportView];
                        [cell setReportviewID:_tempReportView.reportViewId];
                        [cell setRowSpan:reportpageLayout.rowSpan];
                        [cell setColumnSpan:reportpageLayout.columnSpan];
                    
                        //  Set the timestamp
                        NSString *localizedDate = [NSDateFormatter localizedStringFromDate:_tempReportView.timeStamp dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle];
                        cell.timeStampString = [NSString stringWithFormat:@"Last updated:  %@", localizedDate];
                    
                        [self locateCellInGridWithRows:cell];
                        [self logDashboardGrid];
                        [cellArray addObject:cell];
                    
                    [_tempReportViewArray addObject:_tempReportView ];
                    //_tempReportView = [[ReportView alloc] init];
                    
                        // Generate the HTML for chart
                    HTMLBuilder *htmlBuilder = [[HTMLBuilder alloc] init];
                    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
                    NSMutableArray *dataDictionaryArray = [NSMutableArray array];
                    [dictionary setObject:@"0" forKey:@"x_key"];
                    [dictionary setObject:@"3" forKey:@"y_value"];
                    [dataDictionaryArray addObject:dictionary];
                    [dictionary setObject:@"4" forKey:@"x_key"];
                    [dictionary setObject:@"5" forKey:@"y_value"];
                    [dataDictionaryArray addObject:dictionary];
                    NSString *barDataSet =
                    @"[ { x_key: 0, y_value: 5 },{ x_key: 1, y_value: 10 },{ x_key: 2, y_value: 13 },{ x_key: 3, y_value: 19 }]";
                    
                    //if (([tempReportView.reportViewType caseInsensitiveCompare:@"COLUMN"] == NSOrderedSame) || ([tempReportView.reportViewType caseInsensitiveCompare:@"Vertical Bar Cluster"] == NSOrderedSame)) {
                    
                    cell.graphDataSet = barDataSet;
                    //cell.graphDataSetArray = [_tempReportView chartsDictionary];
                    
                    //} else {
                    cell.contentReference = [htmlBuilder buildHTMLChartWithData:_tempReportView andDBFlag:true];
                    //}
                    
                        cell.titleString = _tempReportView.reportViewName;
                    //} // End first count loop
                }
                
            }
        }
    }
    [self calculateTotalRows];
    
    NSLog(@"Total rows: %f", totalRows);
    
    //  Default cells to 1x2 in this example
    int cell_width = 2;
    int cell_height = 1;
    int yOffset = 0;
    int xOffset = 0;
    
    //To check for the current orientation.
    if((self.interfaceOrientation == UIDeviceOrientationLandscapeLeft) || (self.interfaceOrientation == UIDeviceOrientationLandscapeRight)) {
        float scrollHeight = (LANDSCAPE_CELL_HEIGHT_1 * totalRows) + (CELL_BORDER * (totalRows + 1));
        //[self.scrollView setFrame:CGRectMake(0, 0, 1024, 768 - TOOLBAR_HEIGHT)];
        [self.scrollView setContentSize:CGSizeMake(1024, scrollHeight)];
        [self.scrollView setScrollEnabled:YES];
        // Row 1 - Process
        yOffset = CELL_BORDER;
        xOffset = CELL_BORDER;
        
        
        for (id<DashboardCell> cell in cellArray) {
            if ([cell isKindOfClass:[ProcessCellVC class]]) {
                ProcessCellVC *newCell = (ProcessCellVC *) cell;
                int aColumnSpan = [newCell.columnSpan intValue];
                float aRowSpan = [newCell.rowSpan floatValue];
                int aStartRow = [newCell.startRow intValue];
                int aStartColumn = [newCell.startColumn intValue];
                xOffset = (CELL_BORDER * (aStartColumn + 1)) + (aStartColumn * LANDSCAPE_CELL_WIDTH_1);
                yOffset = (CELL_BORDER * (aStartRow + 1)) + (aStartRow * LANDSCAPE_CELL_HEIGHT_1);
                [newCell.view setFrame:CGRectMake(xOffset, yOffset, (LANDSCAPE_CELL_WIDTH_1 * [newCell.columnSpan intValue]) + (CELL_BORDER * (aColumnSpan-1)), LANDSCAPE_CELL_HEIGHT * aRowSpan)];
                [self addChildViewController:newCell];
                [self.scrollView addSubview:newCell.view];
            } else if ([cell isKindOfClass:[KPICellVC class]]) {
                KPICellVC *newCell = (KPICellVC *) cell;
                int aColumnSpan = [newCell.columnSpan intValue];
                int aRowSpan = [newCell.rowSpan intValue];
                int aStartRow = [newCell.startRow intValue];
                int aStartColumn = [newCell.startColumn intValue];
                xOffset = (CELL_BORDER * (aStartColumn + 1)) + (aStartColumn * LANDSCAPE_CELL_WIDTH_1);
                if (processFlag) {
                    yOffset = (CELL_BORDER * (aStartRow + 1)) + (aStartRow * LANDSCAPE_CELL_HEIGHT_1) - (LANDSCAPE_CELL_HEIGHT_1/2);
                } else {
                    yOffset = (CELL_BORDER * (aStartRow + 1)) + (aStartRow * LANDSCAPE_CELL_HEIGHT_1);
                }
                yOffset = (CELL_BORDER * (aStartRow + 1)) + (aStartRow * LANDSCAPE_CELL_HEIGHT_1);
                [newCell.view setFrame:CGRectMake(xOffset, yOffset, (LANDSCAPE_CELL_WIDTH_1 * [newCell.columnSpan intValue]) + (CELL_BORDER * (aColumnSpan - 1)), LANDSCAPE_CELL_HEIGHT * aRowSpan)];
                [self addChildViewController:newCell];
                [self.scrollView addSubview:newCell.view];
            } else if ([cell isKindOfClass:[WebviewCellVC class]]) {
                WebviewCellVC *newCell = (WebviewCellVC *) cell;
                int aColumnSpan = [newCell.columnSpan intValue];
                int aRowSpan = [newCell.rowSpan intValue];
                int aStartRow = [newCell.startRow intValue];
                int aStartColumn = [newCell.startColumn intValue];
                xOffset = (CELL_BORDER * (aStartColumn + 1)) + (aStartColumn * LANDSCAPE_CELL_WIDTH_1);
                if (processFlag) {
                    yOffset = (CELL_BORDER * (aStartRow + 1)) + (aStartRow * LANDSCAPE_CELL_HEIGHT_1) - (LANDSCAPE_CELL_HEIGHT_1/2);
                } else {
                    yOffset = (CELL_BORDER * (aStartRow + 1)) + (aStartRow * LANDSCAPE_CELL_HEIGHT_1);
                }
                [newCell.view setFrame:CGRectMake(xOffset, yOffset, (LANDSCAPE_CELL_WIDTH_1 * [newCell.columnSpan intValue]) + (CELL_BORDER * (aColumnSpan - 1)), (LANDSCAPE_CELL_HEIGHT * aRowSpan) + (CELL_BORDER * (aRowSpan - 1)))];
                CGFloat width = (LANDSCAPE_CELL_WIDTH_1 * [newCell.columnSpan intValue]) + (CELL_BORDER * (aColumnSpan - 1));
                CGFloat height = (LANDSCAPE_CELL_HEIGHT * aRowSpan) + (CELL_BORDER * (aRowSpan - 1));
                NSLog(@"Width : %f  Height %f",width , height);
                NSString *barDataSet =
                @"[ { x_key: 0, y_value: 5 },{ x_key: 1, y_value: 10 },{ x_key: 2, y_value: 13 },{ x_key: 3, y_value: 19 }]";
                newCell.wkWebViewWidth = [NSNumber numberWithFloat:width];
                newCell.wkWebViewHeight = [NSNumber numberWithFloat:height];
                newCell.graphDataSet = barDataSet;
                NSString *indexPath = [[NSBundle mainBundle] pathForResource:EXP_D3_PIE ofType:@"html"];
                NSURL *indexURL = [NSURL fileURLWithPath:indexPath];
                NSString *indexFile = [NSString stringWithContentsOfURL:indexURL encoding:NSUTF8StringEncoding error:nil];
                //                    NSString *VCName2 = @"WebviewCellVC";
                //                    WebviewCellVC *popupChartView = [[WebviewCellVC alloc] initWithNibName:VCName2 bundle:nil];
                [self loadRespectiveCharts:newCell];
//                if (([[[newCell chart] reportViewType] caseInsensitiveCompare:@"COLUMN"] == NSOrderedSame) || ([[[newCell chart] reportViewType]  caseInsensitiveCompare:@"Vertical Bar Cluster"] == NSOrderedSame)) {
//                    newCell.chart = _tempReportView;
//                    [newCell loadExamplePage:@"COLUMN"];
//                } else if ([[[newCell chart] reportViewType] caseInsensitiveCompare:@"BAR"] == NSOrderedSame)  {
//                    newCell.chart = _tempReportView;
//                    [newCell loadExamplePage:@"BAR"];
//                } else {
//                    [newCell displayTestChart];
//                }
                
                [self addChildViewController:newCell];
                [self.scrollView addSubview:newCell.view];
            } else if ([cell isKindOfClass:[WKWebviewCellVC class]]) {
                WKWebviewCellVC *newCell = (WKWebviewCellVC *) cell;
                int aColumnSpan = [newCell.columnSpan intValue];
                int aRowSpan = [newCell.rowSpan intValue];
                int aStartRow = [newCell.startRow intValue];
                int aStartColumn = [newCell.startColumn intValue];
                xOffset = (CELL_BORDER * (aStartColumn + 1)) + (aStartColumn * LANDSCAPE_CELL_WIDTH_1);
                if (processFlag) {
                    yOffset = (CELL_BORDER * (aStartRow + 1)) + (aStartRow * LANDSCAPE_CELL_HEIGHT_1) - (LANDSCAPE_CELL_HEIGHT_1/2);
                } else {
                    yOffset = (CELL_BORDER * (aStartRow + 1)) + (aStartRow * LANDSCAPE_CELL_HEIGHT_1);
                }
                [newCell.view setFrame:CGRectMake(xOffset, yOffset, (LANDSCAPE_CELL_WIDTH_1 * [newCell.columnSpan intValue]) + (CELL_BORDER * (aColumnSpan - 1)), (LANDSCAPE_CELL_HEIGHT * aRowSpan) + (CELL_BORDER * (aRowSpan - 1)))];
                [self addChildViewController:newCell];
                [self.scrollView addSubview:newCell.view];

                
            }

        }
        
    } else {
        float scrollHeight = (PORTRAIT_CELL_HEIGHT_1 * totalRows) + (CELL_BORDER * (totalRows + 1));
        //[self.scrollView setFrame:CGRectMake(0, 0, 768, 1024-TOOLBAR_HEIGHT)];
        [self.scrollView setContentSize:CGSizeMake(768, scrollHeight)];
        [self.scrollView setScrollEnabled:YES];
        // Row 1 - Process
        yOffset = CELL_BORDER;
        xOffset = CELL_BORDER;
        
        for (id<DashboardCell> cell in cellArray) {
            if ([cell isKindOfClass:[ProcessCellVC class]]) {
                ProcessCellVC *newCell = (ProcessCellVC *) cell;
                int aColumnSpan = [newCell.columnSpan intValue];
                float aRowSpan = [newCell.rowSpan floatValue];
                int aStartRow = [newCell.startRow intValue];
                int aStartColumn = [newCell.startColumn intValue];
                xOffset = (CELL_BORDER * (aStartColumn + 1)) + (aStartColumn * PORTRAIT_CELL_WIDTH_1);
                yOffset = (CELL_BORDER * (aStartRow + 1)) + (aStartRow * PORTRAIT_CELL_HEIGHT_1);
                [newCell.view setFrame:CGRectMake(xOffset, yOffset, (PORTRAIT_CELL_WIDTH_1 * [newCell.columnSpan intValue]) + (CELL_BORDER * (aColumnSpan-1)), PORTRAIT_CELL_HEIGHT_1 * aRowSpan)];
                [self addChildViewController:newCell];
                [self.scrollView addSubview:newCell.view];
            } else if ([cell isKindOfClass:[KPICellVC class]]) {
                KPICellVC *newCell = (KPICellVC *) cell;
                int aColumnSpan = [newCell.columnSpan intValue];
                int aRowSpan = [newCell.rowSpan intValue];
                int aStartRow = [newCell.startRow intValue];
                int aStartColumn = [newCell.startColumn intValue];
                xOffset = (CELL_BORDER * (aStartColumn + 1)) + (aStartColumn * PORTRAIT_CELL_WIDTH_1);
                if (processFlag) {
                    yOffset = (CELL_BORDER * (aStartRow + 1)) + (aStartRow * PORTRAIT_CELL_HEIGHT_1) - (PORTRAIT_CELL_HEIGHT_1/2);
                } else {
                    yOffset = (CELL_BORDER * (aStartRow + 1)) + (aStartRow * PORTRAIT_CELL_HEIGHT_1);
                }
                yOffset = (CELL_BORDER * (aStartRow + 1)) + (aStartRow * PORTRAIT_CELL_HEIGHT_1);
                [newCell.view setFrame:CGRectMake(xOffset, yOffset, (PORTRAIT_CELL_WIDTH_1 * [newCell.columnSpan intValue]) + (CELL_BORDER * (aColumnSpan - 1)), PORTRAIT_CELL_HEIGHT_1 * aRowSpan)];
                [self addChildViewController:newCell];
                [self.scrollView addSubview:newCell.view];
            } else if ([cell isKindOfClass:[WebviewCellVC class]]) {
                WebviewCellVC *newCell = (WebviewCellVC *) cell;
                int aColumnSpan = [newCell.columnSpan intValue];
                int aRowSpan = [newCell.rowSpan intValue];
                int aStartRow = [newCell.startRow intValue];
                int aStartColumn = [newCell.startColumn intValue];
                xOffset = (CELL_BORDER * (aStartColumn + 1)) + (aStartColumn * PORTRAIT_CELL_WIDTH_1);
                if (processFlag) {
                    yOffset = (CELL_BORDER * (aStartRow + 1)) + (aStartRow * PORTRAIT_CELL_HEIGHT_1) - (PORTRAIT_CELL_HEIGHT_1/2);
                } else {
                    yOffset = (CELL_BORDER * (aStartRow + 1)) + (aStartRow * PORTRAIT_CELL_HEIGHT_1);
                }
                [newCell.view setFrame:CGRectMake(xOffset, yOffset, (PORTRAIT_CELL_WIDTH_1 * [newCell.columnSpan intValue]) + (CELL_BORDER * (aColumnSpan - 1)), (PORTRAIT_CELL_HEIGHT_1 * aRowSpan) + (CELL_BORDER * (aRowSpan - 1)))];
                
                NSString *indexPath = [[NSBundle mainBundle] pathForResource:EXP_D3_PIE ofType:@"html"];
                NSURL *indexURL = [NSURL fileURLWithPath:indexPath];
                NSString *barDataSet =
                @"[ { x_key: 0, y_value: 5 },{ x_key: 1, y_value: 10 },{ x_key: 2, y_value: 13 },{ x_key: 3, y_value: 19 }]";
                newCell.graphDataSet = barDataSet;
                NSString *indexFile = [NSString stringWithContentsOfURL:indexURL encoding:NSUTF8StringEncoding error:nil];
                //                    NSString *VCName2 = @"WebviewCellVC";
                //                    WebviewCellVC *popupChartView = [[WebviewCellVC alloc] initWithNibName:VCName2 bundle:nil];
                [self loadRespectiveCharts:newCell];
//                if (([[[newCell chart] reportViewType] caseInsensitiveCompare:@"COLUMN"] == NSOrderedSame) || ([[[newCell chart] reportViewType]  caseInsensitiveCompare:@"Vertical Bar Cluster"] == NSOrderedSame)) {
//                    newCell.chart = _tempReportView;
//                    [newCell loadExamplePage:@"COLUMN"];
//                } else if ([[[newCell chart] reportViewType] caseInsensitiveCompare:@"BAR"] == NSOrderedSame)  {
//                    newCell.chart = _tempReportView;
//                    [newCell loadExamplePage:@"BAR"];
//                } else {
//                    [newCell displayTestChart];
//                }
                
                [self addChildViewController:newCell];
                [self.scrollView addSubview:newCell.view];
            }
            
        }
    }
    
    
    //scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, 768, 1024)];
    //[scrollView setContentSize:CGSizeMake(768, 1500)];
    //[self.view addSubview:scrollView];
    
    //  In order to configure dashboard content
    //  1 - Determine all required dashboard items (reportpageLayout)
    //  2 - Map each item to cell
    //  3 - Create cell for each item and pass content reference  (how to pass content type and ID?)
    //  4 -
    
}

- (void) calculateTotalRows
{
    //  Assuming the first cell of a row is always occupied
    for (int i = 0; i<GRIDROWS; i++)
        totalRows = totalRows + dashboardGrid[i][1];
    
    if (processFlag == true)
        totalRows = totalRows - 0.5;
}


- (void) locateCellInGridWithRows:(id)cell//(int)rows andColumns:(int)columns
{
    int startRow = 0;
    int startColumn = 0;
    int rows;
    int columns;
    
    //if ([cell isKindOfClass:[WebviewCellVC class]]) {
        NSNumber *temp = [cell rowSpan];
        rows = [temp intValue];
        temp = [cell columnSpan];
        columns = [temp intValue];
    //} else if ([cell isKindOfClass:[KPICellVC class]]) {
      //  rows = (KPICellVC *) [cell rowSpan];
        //columns = (KPICellVC *) [cell columnSpan];
    //}
    

    for (int i=currentRow; i<GRIDROWS; i++) {
        for (int j=currentColumn; j<GRIDCOLUMNS; j++) {
            if (dashboardGrid[i][j] == 0) {
                //  current row and column location is available!
                //  Now we need to sum the grid locations that the chart will occupy
                //  If sum=0 we can place it, otherwise try again.
                
                //  Check for enough columns and rows
                if ((j+columns) <= (GRIDCOLUMNS) && (i+rows) <= (GRIDROWS)) {
                
                    int tempSum = 0;
                    for (int x = i; x < (i + rows); x++)
                        for (int y = j; y < (j + columns); y++)
                            tempSum = tempSum + dashboardGrid[x][y];
                    
                    if (tempSum == 0) {
                        startRow = i;
                        startColumn = j;
                        
                        //  Set locations to used status
                        for (int x = i; x < (i + rows); x++)
                            for (int y = j; y < (j + columns); y++)
                                dashboardGrid[x][y] = 1;
                        
                        // advance?
                        //currentColumn = currentColumn + columns;
                        //currentRow = currentRow + rows;
                    }
                    [cell setStartRow:[NSNumber numberWithInt:startRow]];
                    [cell setStartColumn:[NSNumber numberWithInt:startColumn]];
                    return;
                }
            }
        }
    }
}

- (void) logDashboardGrid
{
    NSLog(@"Dashboard Grid:\n");
    for (int i = 0; i < GRIDROWS; i++) {
        NSMutableString *rowString = [NSMutableString stringWithString:@"{"];
        for (int j = 0; j < GRIDCOLUMNS; j++) {
            [rowString appendFormat:@"%d,",dashboardGrid[i][j]];
        }
        [rowString appendString:@"}"];
        NSLog(@"%@", rowString);
    }
}

-(void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
}

- (void)leftMenuButton {
    NSLog(@"Left button pressed!");
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    NSLog(@"didRotateFromInterfaceOrientation: Dashboard orientation has changed!");
    //To check for the current orientation.
    int yOffset = 0;
    int xOffset = 0;
    
    if((self.interfaceOrientation == UIDeviceOrientationLandscapeLeft) || (self.interfaceOrientation == UIDeviceOrientationLandscapeRight)) {
        float scrollHeight = (LANDSCAPE_CELL_HEIGHT_1 * totalRows) + (CELL_BORDER * (totalRows + 1));
        //[self.scrollView setFrame:CGRectMake(0, 0, 1024, 768-TOOLBAR_HEIGHT)];
        [self.scrollView setContentSize:CGSizeMake(1024, scrollHeight)];
        [self.scrollView setScrollEnabled:YES];
        // Row 1 - Process
        yOffset = CELL_BORDER;
        xOffset = CELL_BORDER;
    
        for (id<DashboardCell> cell in cellArray) {
            if ([cell isKindOfClass:[ProcessCellVC class]]) {
                ProcessCellVC *newCell = (ProcessCellVC *) cell;
                int aColumnSpan = [newCell.columnSpan intValue];
                float aRowSpan = [newCell.rowSpan floatValue];
                int aStartRow = [newCell.startRow intValue];
                int aStartColumn = [newCell.startColumn intValue];
                xOffset = (CELL_BORDER * (aStartColumn + 1)) + (aStartColumn * LANDSCAPE_CELL_WIDTH_1);
                yOffset = (CELL_BORDER * (aStartRow + 1)) + (aStartRow * LANDSCAPE_CELL_HEIGHT_1);
                [newCell.view setFrame:CGRectMake(xOffset, yOffset, (LANDSCAPE_CELL_WIDTH_1 * [newCell.columnSpan intValue]) + (CELL_BORDER * (aColumnSpan-1)), LANDSCAPE_CELL_HEIGHT * aRowSpan)];
                [self addChildViewController:newCell];
                [self.scrollView addSubview:newCell.view];
            } else if ([cell isKindOfClass:[KPICellVC class]]) {
                KPICellVC *newCell = (KPICellVC *) cell;
                int aColumnSpan = [newCell.columnSpan intValue];
                int aRowSpan = [newCell.rowSpan intValue];
                int aStartRow = [newCell.startRow intValue];
                int aStartColumn = [newCell.startColumn intValue];
                xOffset = (CELL_BORDER * (aStartColumn + 1)) + (aStartColumn * LANDSCAPE_CELL_WIDTH_1);
                if (processFlag) {
                    yOffset = (CELL_BORDER * (aStartRow + 1)) + (aStartRow * LANDSCAPE_CELL_HEIGHT_1) - (LANDSCAPE_CELL_HEIGHT_1/2);
                } else {
                    yOffset = (CELL_BORDER * (aStartRow + 1)) + (aStartRow * LANDSCAPE_CELL_HEIGHT_1);
                }
                yOffset = (CELL_BORDER * (aStartRow + 1)) + (aStartRow * LANDSCAPE_CELL_HEIGHT_1);
                [newCell.view setFrame:CGRectMake(xOffset, yOffset, (LANDSCAPE_CELL_WIDTH_1 * [newCell.columnSpan intValue]) + (CELL_BORDER * (aColumnSpan - 1)), LANDSCAPE_CELL_HEIGHT * aRowSpan)];
                [self addChildViewController:newCell];
                [self.scrollView addSubview:newCell.view];
            } else if ([cell isKindOfClass:[WebviewCellVC class]]) {
                WebviewCellVC *newCell = (WebviewCellVC *) cell;
                int aColumnSpan = [newCell.columnSpan intValue];
                int aRowSpan = [newCell.rowSpan intValue];
                int aStartRow = [newCell.startRow intValue];
                int aStartColumn = [newCell.startColumn intValue];
                xOffset = (CELL_BORDER * (aStartColumn + 1)) + (aStartColumn * LANDSCAPE_CELL_WIDTH_1);
                if (processFlag) {
                    yOffset = (CELL_BORDER * (aStartRow + 1)) + (aStartRow * LANDSCAPE_CELL_HEIGHT_1) - (LANDSCAPE_CELL_HEIGHT_1/2);
                } else {
                    yOffset = (CELL_BORDER * (aStartRow + 1)) + (aStartRow * LANDSCAPE_CELL_HEIGHT_1);
                }
                [newCell.view setFrame:CGRectMake(xOffset, yOffset, (LANDSCAPE_CELL_WIDTH_1 * [newCell.columnSpan intValue]) + (CELL_BORDER * (aColumnSpan - 1)), (LANDSCAPE_CELL_HEIGHT * aRowSpan) + (CELL_BORDER * (aRowSpan -1)))];
                NSString *indexPath = [[NSBundle mainBundle] pathForResource:EXP_D3_PIE ofType:@"html"];
                NSURL *indexURL = [NSURL fileURLWithPath:indexPath];
                NSString *indexFile = [NSString stringWithContentsOfURL:indexURL encoding:NSUTF8StringEncoding error:nil];
                //                    NSString *VCName2 = @"WebviewCellVC";
                //                    WebviewCellVC *popupChartView = [[WebviewCellVC alloc] initWithNibName:VCName2 bundle:nil];
                [self loadRespectiveCharts:newCell];
//                if (([[[newCell chart] reportViewType] caseInsensitiveCompare:@"COLUMN"] == NSOrderedSame) || ([[[newCell chart] reportViewType]  caseInsensitiveCompare:@"Vertical Bar Cluster"] == NSOrderedSame)) {
//                    newCell.chart = _tempReportView;
//                    [newCell loadExamplePage:@"COLUMN"];
//                } else if ([[[newCell chart] reportViewType] caseInsensitiveCompare:@"BAR"] == NSOrderedSame)  {
//                    newCell.chart = _tempReportView;
//                    [newCell loadExamplePage:@"BAR"];
//                } else {
//                    [newCell displayTestChart];
//                }

                [self addChildViewController:newCell];
                [self.scrollView addSubview:newCell.view];
            }
            
        }
    
    } else {
        float scrollHeight = (PORTRAIT_CELL_HEIGHT_1 * totalRows) + (CELL_BORDER * (totalRows + 1));
        //[self.scrollView setFrame:CGRectMake(0, 0, 768, 1024 - TOOLBAR_HEIGHT)];
        [self.scrollView setContentSize:CGSizeMake(768, scrollHeight)];
        [self.scrollView setScrollEnabled:YES];
        // Row 1 - Process
        yOffset = CELL_BORDER;
        xOffset = CELL_BORDER;
        
        for (id<DashboardCell> cell in cellArray) {
            if ([cell isKindOfClass:[ProcessCellVC class]]) {
                ProcessCellVC *newCell = (ProcessCellVC *) cell;
                int aColumnSpan = [newCell.columnSpan intValue];
                float aRowSpan = [newCell.rowSpan floatValue];
                int aStartRow = [newCell.startRow intValue];
                int aStartColumn = [newCell.startColumn intValue];
                xOffset = (CELL_BORDER * (aStartColumn + 1)) + (aStartColumn * PORTRAIT_CELL_WIDTH_1);
                yOffset = (CELL_BORDER * (aStartRow + 1)) + (aStartRow * PORTRAIT_CELL_HEIGHT_1);
                [newCell.view setFrame:CGRectMake(xOffset, yOffset, (PORTRAIT_CELL_WIDTH_1 * [newCell.columnSpan intValue]) + (CELL_BORDER * (aColumnSpan-1)), PORTRAIT_CELL_HEIGHT_1 * aRowSpan)];
                [self addChildViewController:newCell];
                [self.scrollView addSubview:newCell.view];
            } else if ([cell isKindOfClass:[KPICellVC class]]) {
                KPICellVC *newCell = (KPICellVC *) cell;
                int aColumnSpan = [newCell.columnSpan intValue];
                int aRowSpan = [newCell.rowSpan intValue];
                int aStartRow = [newCell.startRow intValue];
                int aStartColumn = [newCell.startColumn intValue];
                xOffset = (CELL_BORDER * (aStartColumn + 1)) + (aStartColumn * PORTRAIT_CELL_WIDTH_1);
                if (processFlag) {
                    yOffset = (CELL_BORDER * (aStartRow + 1)) + (aStartRow * PORTRAIT_CELL_HEIGHT_1) - (PORTRAIT_CELL_HEIGHT_1/2);
                } else {
                    yOffset = (CELL_BORDER * (aStartRow + 1)) + (aStartRow * PORTRAIT_CELL_HEIGHT_1);
                }
                yOffset = (CELL_BORDER * (aStartRow + 1)) + (aStartRow * PORTRAIT_CELL_HEIGHT_1);
                [newCell.view setFrame:CGRectMake(xOffset, yOffset, (PORTRAIT_CELL_WIDTH_1 * [newCell.columnSpan intValue]) + (CELL_BORDER * (aColumnSpan - 1)), PORTRAIT_CELL_HEIGHT_1 * aRowSpan)];
                [self addChildViewController:newCell];
                [self.scrollView addSubview:newCell.view];
            } else if ([cell isKindOfClass:[WebviewCellVC class]]) {
                WebviewCellVC *newCell = (WebviewCellVC *) cell;
                int aColumnSpan = [newCell.columnSpan intValue];
                int aRowSpan = [newCell.rowSpan intValue];
                int aStartRow = [newCell.startRow intValue];
                int aStartColumn = [newCell.startColumn intValue];
                xOffset = (CELL_BORDER * (aStartColumn + 1)) + (aStartColumn * PORTRAIT_CELL_WIDTH_1);
                if (processFlag) {
                    yOffset = (CELL_BORDER * (aStartRow + 1)) + (aStartRow * PORTRAIT_CELL_HEIGHT_1) - (PORTRAIT_CELL_HEIGHT_1/2);
                } else {
                    yOffset = (CELL_BORDER * (aStartRow + 1)) + (aStartRow * PORTRAIT_CELL_HEIGHT_1);
                }
                [newCell.view setFrame:CGRectMake(xOffset, yOffset, (PORTRAIT_CELL_WIDTH_1 * [newCell.columnSpan intValue]) + (CELL_BORDER * (aColumnSpan - 1)), (PORTRAIT_CELL_HEIGHT_1 * aRowSpan) + (CELL_BORDER * aRowSpan - 1))];
                
                [self loadRespectiveCharts:newCell];
//                if (([newCell.titleString caseInsensitiveCompare:@"COLUMN"] == NSOrderedSame) || ([newCell.titleString caseInsensitiveCompare:@"Vertical Bar Cluster"] == NSOrderedSame)) {
//                    newCell.chart = _tempReportView;
//                    [newCell loadExamplePage:@"COLUMN"];
//                } else if  ([newCell.titleString caseInsensitiveCompare:@"BAR"] == NSOrderedSame) {
//                    
//                }
//                else {
//                    [newCell displayTestChart];
//                }
                
                [self addChildViewController:newCell];
                [self.scrollView addSubview:newCell.view];
            }
            
        }
    }
}

// compare chart and load
- (void) loadRespectiveCharts :(WebviewCellVC *) newCell  {
    
    newCell.chart = [_tempReportViewArray objectAtIndex:count];
    count = count + 1;
    
    //if (([[[newCell chart] reportViewType] caseInsensitiveCompare:@"COLUMN"] == NSOrderedSame||
        if ([[[newCell chart] reportViewType]  caseInsensitiveCompare:@"Vertical Bar Cluster"] == NSOrderedSame) {
        //newCell.chart = _tempReportView;
        //[newCell displayTestChart];
            [newCell loadExamplePage:@"BAR"];
        //[newCell loadExamplePage:@"COLUMN"];
    } else if ((([[[newCell chart] reportViewType] caseInsensitiveCompare:@"BAR"] == NSOrderedSame)  || ([[[newCell chart] reportViewType] caseInsensitiveCompare:@"COLUMN"] == NSOrderedSame) || ([[[newCell chart] reportViewType] caseInsensitiveCompare:@"Vertical Bar Cluster"] == NSOrderedSame) )){
        //newCell.chart = _tempReportView;
        [newCell loadExamplePage:@"BAR"];
    }
    else if ([[[newCell chart] reportViewType] caseInsensitiveCompare:@"HORIZONTAL BAR"] == NSOrderedSame)  {
        //newCell.chart = _tempReportView;
        [newCell loadExamplePage:@"HORIZONTAL BAR"];
    } else if ([[[newCell chart] reportViewType] caseInsensitiveCompare:@"LINE"] == NSOrderedSame)  {
        //newCell.chart = _tempReportView;
        [newCell loadExamplePage:@"LINE"];
        //[newCell displayTestChart];
    } else if ([[[newCell chart] reportViewType] caseInsensitiveCompare:@"BAR STACKED"] == NSOrderedSame)  {
        //newCell.chart = _tempReportView;
        [newCell loadExamplePage:@"BAR STACKED"];
        //[newCell displayTestChart];
    } else if ([[[newCell chart] reportViewType] caseInsensitiveCompare:@"HEATMAP"] == NSOrderedSame)  {
        //newCell.chart = _tempReportView;
        [newCell loadExamplePage:@"HEATMAP"];
        //[newCell displayTestChart];
    } else if ([[[newCell chart] reportViewType] caseInsensitiveCompare:@"DONUT"] == NSOrderedSame)  {
        //newCell.chart = _tempReportView;
        [newCell loadExamplePage:@"DONUT"];
        //[newCell displayTestChart];
    }else if ([[[newCell chart] reportViewType] caseInsensitiveCompare:@"PIE"] == NSOrderedSame)  {
        //newCell.chart = _tempReportView;
        [newCell loadExamplePage:@"PIE"];
        //[newCell displayTestChart];
    }  else if (([[[newCell chart] reportViewType] caseInsensitiveCompare:@"COMBINATION"] == NSOrderedSame) || ([[[newCell chart] reportViewType] caseInsensitiveCompare:@"DUALCOMBINATION"] == NSOrderedSame))  {
        //newCell.chart = _tempReportView;
        [newCell loadExamplePage:@"COMBINATION"];
        //[newCell displayTestChart];  DUALCOMBINATION
    } else if (([[[newCell chart] reportViewType] caseInsensitiveCompare:@"GEOBUBBLE"] == NSOrderedSame) || ([[[newCell chart] reportViewType] caseInsensitiveCompare:@"CHOROPLETH"] == NSOrderedSame) ) {
        //newCell.chart = _tempReportView;
        [newCell loadExamplePage:@"GEOBUBBLE"];
        NSLog(@"Geo Bubble chart is there");
        //[newCell displayTestChart];
    } else if ([[[newCell chart] reportViewType] caseInsensitiveCompare:@"NETVIZ BASIC"] == NSOrderedSame)  {
        //newCell.chart = _tempReportView;
        [newCell loadExamplePage:@"NETVIZ BASIC"];
        NSLog(@"Geo Bubble chart is there");
        //[newCell displayTestChart];
    } else {
        [newCell displayTestChart];
    }
    //[newCell displayTestChart];
}

//  Required for iOS 8
- (void)viewWillTransitionToSize:(CGSize)size
       withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    NSLog(@"viewWillTransitionToSize: Dashboard orientation has changed - new method!");
    //To check for the current orientation.
    int yOffset = 0;
    int xOffset = 0;
    
    //  Need to check screen size instead...
    //  If width is greater than height we are in landscape mode
    //  Note:  The sizes pick up the current setting, not the new - so if it indicates portrait mode that means we are
    //  transitioning to landscape.
    if (self.view.frame.size.width < self.view.frame.size.height) {
    //if((self.interfaceOrientation == UIDeviceOrientationLandscapeLeft) || (self.interfaceOrientation == UIDeviceOrientationLandscapeRight)) {
        float scrollHeight = (LANDSCAPE_CELL_HEIGHT_1 * totalRows) + (CELL_BORDER * (totalRows + 1));
        //[self.scrollView setFrame:CGRectMake(0, 0, 1024, 768-TOOLBAR_HEIGHT)];
        [self.scrollView setContentSize:CGSizeMake(1024, scrollHeight)];
        [self.scrollView setScrollEnabled:YES];
        // Row 1 - Process
        yOffset = CELL_BORDER;
        xOffset = CELL_BORDER;
        
        for (id<DashboardCell> cell in cellArray) {
            if ([cell isKindOfClass:[ProcessCellVC class]]) {
                ProcessCellVC *newCell = (ProcessCellVC *) cell;
                int aColumnSpan = [newCell.columnSpan intValue];
                float aRowSpan = [newCell.rowSpan floatValue];
                int aStartRow = [newCell.startRow intValue];
                int aStartColumn = [newCell.startColumn intValue];
                xOffset = (CELL_BORDER * (aStartColumn + 1)) + (aStartColumn * LANDSCAPE_CELL_WIDTH_1);
                yOffset = (CELL_BORDER * (aStartRow + 1)) + (aStartRow * LANDSCAPE_CELL_HEIGHT_1);
                [newCell.view setFrame:CGRectMake(xOffset, yOffset, (LANDSCAPE_CELL_WIDTH_1 * [newCell.columnSpan intValue]) + (CELL_BORDER * (aColumnSpan-1)), LANDSCAPE_CELL_HEIGHT * aRowSpan)];
                [self addChildViewController:newCell];
                [self.scrollView addSubview:newCell.view];
            } else if ([cell isKindOfClass:[KPICellVC class]]) {
                KPICellVC *newCell = (KPICellVC *) cell;
                int aColumnSpan = [newCell.columnSpan intValue];
                int aRowSpan = [newCell.rowSpan intValue];
                int aStartRow = [newCell.startRow intValue];
                int aStartColumn = [newCell.startColumn intValue];
                xOffset = (CELL_BORDER * (aStartColumn + 1)) + (aStartColumn * LANDSCAPE_CELL_WIDTH_1);
                if (processFlag) {
                    yOffset = (CELL_BORDER * (aStartRow + 1)) + (aStartRow * LANDSCAPE_CELL_HEIGHT_1) - (LANDSCAPE_CELL_HEIGHT_1/2);
                } else {
                    yOffset = (CELL_BORDER * (aStartRow + 1)) + (aStartRow * LANDSCAPE_CELL_HEIGHT_1);
                }
                yOffset = (CELL_BORDER * (aStartRow + 1)) + (aStartRow * LANDSCAPE_CELL_HEIGHT_1);
                [newCell.view setFrame:CGRectMake(xOffset, yOffset, (LANDSCAPE_CELL_WIDTH_1 * [newCell.columnSpan intValue]) + (CELL_BORDER * (aColumnSpan - 1)), LANDSCAPE_CELL_HEIGHT * aRowSpan)];
                [self addChildViewController:newCell];
                [self.scrollView addSubview:newCell.view];
            } else if ([cell isKindOfClass:[WebviewCellVC class]]) {
                WebviewCellVC *newCell = (WebviewCellVC *) cell;
                int aColumnSpan = [newCell.columnSpan intValue];
                int aRowSpan = [newCell.rowSpan intValue];
                int aStartRow = [newCell.startRow intValue];
                int aStartColumn = [newCell.startColumn intValue];
                xOffset = (CELL_BORDER * (aStartColumn + 1)) + (aStartColumn * LANDSCAPE_CELL_WIDTH_1);
                if (processFlag) {
                    yOffset = (CELL_BORDER * (aStartRow + 1)) + (aStartRow * LANDSCAPE_CELL_HEIGHT_1) - (LANDSCAPE_CELL_HEIGHT_1/2);
                } else {
                    yOffset = (CELL_BORDER * (aStartRow + 1)) + (aStartRow * LANDSCAPE_CELL_HEIGHT_1);
                }
                [newCell.view setFrame:CGRectMake(xOffset, yOffset, (LANDSCAPE_CELL_WIDTH_1 * [newCell.columnSpan intValue]) + (CELL_BORDER * (aColumnSpan - 1)), (LANDSCAPE_CELL_HEIGHT * aRowSpan) + (CELL_BORDER * (aRowSpan - 1)))];
                [self addChildViewController:newCell];
                [self.scrollView addSubview:newCell.view];
            }
            
        }
        
    } else {
        float scrollHeight = (PORTRAIT_CELL_HEIGHT_1 * totalRows) + (CELL_BORDER * (totalRows + 1));
        //[self.scrollView setFrame:CGRectMake(0, 0, 768, 1024 - TOOLBAR_HEIGHT)];
        [self.scrollView setContentSize:CGSizeMake(768, scrollHeight)];
        [self.scrollView setScrollEnabled:YES];
        // Row 1 - Process
        yOffset = CELL_BORDER;
        xOffset = CELL_BORDER;
        
        for (id<DashboardCell> cell in cellArray) {
            if ([cell isKindOfClass:[ProcessCellVC class]]) {
                ProcessCellVC *newCell = (ProcessCellVC *) cell;
                int aColumnSpan = [newCell.columnSpan intValue];
                float aRowSpan = [newCell.rowSpan floatValue];
                int aStartRow = [newCell.startRow intValue];
                int aStartColumn = [newCell.startColumn intValue];
                xOffset = (CELL_BORDER * (aStartColumn + 1)) + (aStartColumn * PORTRAIT_CELL_WIDTH_1);
                yOffset = (CELL_BORDER * (aStartRow + 1)) + (aStartRow * PORTRAIT_CELL_HEIGHT_1);
                [newCell.view setFrame:CGRectMake(xOffset, yOffset, (PORTRAIT_CELL_WIDTH_1 * [newCell.columnSpan intValue]) + (CELL_BORDER * (aColumnSpan-1)), PORTRAIT_CELL_HEIGHT_1 * aRowSpan)];
                [self addChildViewController:newCell];
                [self.scrollView addSubview:newCell.view];
            } else if ([cell isKindOfClass:[KPICellVC class]]) {
                KPICellVC *newCell = (KPICellVC *) cell;
                int aColumnSpan = [newCell.columnSpan intValue];
                int aRowSpan = [newCell.rowSpan intValue];
                int aStartRow = [newCell.startRow intValue];
                int aStartColumn = [newCell.startColumn intValue];
                xOffset = (CELL_BORDER * (aStartColumn + 1)) + (aStartColumn * PORTRAIT_CELL_WIDTH_1);
                if (processFlag) {
                    yOffset = (CELL_BORDER * (aStartRow + 1)) + (aStartRow * PORTRAIT_CELL_HEIGHT_1) - (PORTRAIT_CELL_HEIGHT_1/2);
                } else {
                    yOffset = (CELL_BORDER * (aStartRow + 1)) + (aStartRow * PORTRAIT_CELL_HEIGHT_1);
                }
                yOffset = (CELL_BORDER * (aStartRow + 1)) + (aStartRow * PORTRAIT_CELL_HEIGHT_1);
                [newCell.view setFrame:CGRectMake(xOffset, yOffset, (PORTRAIT_CELL_WIDTH_1 * [newCell.columnSpan intValue]) + (CELL_BORDER * (aColumnSpan - 1)), PORTRAIT_CELL_HEIGHT_1 * aRowSpan)];
                [self addChildViewController:newCell];
                [self.scrollView addSubview:newCell.view];
            } else if ([cell isKindOfClass:[WebviewCellVC class]]) {
                WebviewCellVC *newCell = (WebviewCellVC *) cell;
                int aColumnSpan = [newCell.columnSpan intValue];
                int aRowSpan = [newCell.rowSpan intValue];
                int aStartRow = [newCell.startRow intValue];
                int aStartColumn = [newCell.startColumn intValue];
                xOffset = (CELL_BORDER * (aStartColumn + 1)) + (aStartColumn * PORTRAIT_CELL_WIDTH_1);
                if (processFlag) {
                    yOffset = (CELL_BORDER * (aStartRow + 1)) + (aStartRow * PORTRAIT_CELL_HEIGHT_1) - (PORTRAIT_CELL_HEIGHT_1/2);
                } else {
                    yOffset = (CELL_BORDER * (aStartRow + 1)) + (aStartRow * PORTRAIT_CELL_HEIGHT_1);
                }
                [newCell.view setFrame:CGRectMake(xOffset, yOffset, (PORTRAIT_CELL_WIDTH_1 * [newCell.columnSpan intValue]) + (CELL_BORDER * (aColumnSpan - 1)), (PORTRAIT_CELL_HEIGHT_1 * aRowSpan) + (CELL_BORDER * (aRowSpan - 1)))];
                [self addChildViewController:newCell];
                [self.scrollView addSubview:newCell.view];
            }
            
        }
    }
}

// MARK: WKWebView Delegate
//-
//func webView(webView: WKWebView, didReceiveAuthenticationChallenge challenge: NSURLAuthenticationChallenge,
//             completionHandler: (NSURLSessionAuthChallengeDisposition, NSURLCredential?) -> Void) {
//    let cred = NSURLCredential.init(forTrust: challenge.protectionSpace.serverTrust!)
//    completionHandler(.UseCredential, cred)
//}
- (void) initializeGrid
{
    for (int i=0; i < GRIDROWS; i++) {
        for (int j=0; j<GRIDCOLUMNS; j++) {
            dashboardGrid[i][j] = 0;
        }
    }
}

- (void) findNextAvailableForRows:(int)rows andColumns:(int)columns
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
