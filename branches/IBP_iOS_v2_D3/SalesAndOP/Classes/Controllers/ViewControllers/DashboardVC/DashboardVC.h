//
//  DashboardVC.h
//  IBP
//
//  Created by Rick Thompson on 11/14/14.
//  Copyright (c) 2014 Linear Logics Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReportPage.h"


#define MAX_HORIZONTAL_CELLS 4
#define MAX_VERTICAL_CELLS 4
#define CELL_BORDER 10
#define TOOLBAR_HEIGHT 64
#define LANDSCAPE_DB_VIZ_CHART_HEIGHT 250  //px setting in html
#define PORTRAIT_MAX_HEIGHT (1024 - TOOLBAR_HEIGHT)
#define LANDSCAPE_MAX_HEIGHT (768 - TOOLBAR_HEIGHT)

#define PORTRAIT_CELL_WIDTH_1 179.5  //(768 - (5 * CELL_BORDER))/4
#define PORTRAIT_CELL_WIDTH_2 369
#define PORTRAIT_CELL_WIDTH_3 558.5
#define PORTRAIT_CELL_WIDTH_4 748

//#define PORTRAIT_CELL_HEIGHT_1 368  //(1024 - 64 - (4 * CELL_BORDER))/2.5
#define PORTRAIT_CELL_HEIGHT_1 265.6
#define PORTRAIT_CELL_HEIGHT_2
#define PORTRAIT_CELL_HEIGHT_3
#define PORTRAIT_CELL_HEIGHT_4

#define LANDSCAPE_CELL_WIDTH_1 243.5  //(1024 - (5 * CELL_BORDER))/4
#define LANDSCAPE_CELL_WIDTH_2 497
#define LANDSCAPE_CELL_WIDTH_3 750.5
#define LANDSCAPE_CELL_WIDTH_4 1004

#define LANDSCAPE_CELL_HEIGHT_1 265.6 //(768 - 64 - (4 * CELL_BORDER)) / 2.5
#define LANDSCAPE_CELL_HEIGHT_2 541.2
#define LANDSCAPE_CELL_HEIGHT_3 750
#define LANDSCAPE_CELL_HEIGHT_4 

#define VIZ_CHART_HEIGHT_1 250

#define PORTRAIT_CELL_WIDTH (768 - (5 * CELL_BORDER))/4
#define PORTRAIT_CELL_HEIGHT (1024 - 64 - (4 * CELL_BORDER))/2.5
#define LANDSCAPE_CELL_WIDTH (1024 - (5 * CELL_BORDER))/4
#define LANDSCAPE_CELL_HEIGHT (768 - 64 - (4 * CELL_BORDER))/2.5


#define PORTRAIT_SCROLL_VIEW CGRectMake(0,0,768,1024-TOOLBAR_HEIGHT)
#define PORTRAIT_SCROLL_AREA CGSizeMake(768, 1024-TOOLBAR_HEIGHT)
#define LANDSCAPE_SCROLL_VIEW CGRectMake(0,0,1024,768-TOOLBAR_HEIGHT)
#define LANDSCAPE_SCROLL_AREA CGSizeMake(1024, 768-TOOLBAR_HEIGHT)

#define GRIDROWS 6
#define GRIDCOLUMNS 4

@interface DashboardVC : UIViewController
{
    int dashboardGrid[GRIDROWS][GRIDCOLUMNS];  //  Grid to indicate available/occupied dashboard cell locations
    BOOL processFlag;
    float totalRows;
    int currentRow;
    int currentColumn;
    
    int count;
    
}
@property (nonatomic,strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic,strong) IBOutlet UILabel *errorMessageLabel;
@property (nonatomic,strong) NSMutableArray *cellArray;
@property (nonatomic,strong) ReportPage *reportPage;
//@property (nonatomic,strong) BOOL *processFlag;


- (void)leftMenuButton;


@end

