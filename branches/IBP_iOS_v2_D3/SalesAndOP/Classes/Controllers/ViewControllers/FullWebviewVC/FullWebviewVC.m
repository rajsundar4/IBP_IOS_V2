//
//  FullWebviewVC.m
//  IBP
//
//  Created by Rick Thompson on 11/14/14.
//  Copyright (c) 2014 Linear Logics Corporation. All rights reserved.
//

#import "FullWebviewVC.h"
#import "HTMLBuilder.h"
#import "DataController.h"
#import "WebKitController.h"
#import "D3WebViewController.h"
#import "WKWebViewJavascriptBridge.h"

#define PORTRAIT_WIDTH 768
#define PORTRAIT_HEIGHT 1024
#define LANDSCAPE_WIDTH 1024
#define LANDSCAPE_HEIGHT 768
#define TOOLBAR_HEIGHT 64

@interface FullWebviewVC ()
@property WKWebViewJavascriptBridge* bridge;
@property (weak, nonatomic) IBOutlet UIView *fullGraphView;

@end

@implementation FullWebviewVC
//BOOL chartFromDashboard;

@synthesize contentReference;
@synthesize cellWebView;
@synthesize dismissButton;
@synthesize chart;
@synthesize reportviewID;

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
//    // Do any additional setup after loading the view from its nib.
    ReportView *currentReportView;
    
    if (_chartFromDashboard == TRUE) {
        // If moving to fullscreen from dashboard do not retrieve data, use existing
        [self.dismissButton setHidden:NO];
    } else {
        // If chart selected from menu then we have to get the data from the server
        [[DataController sharedDataInstance] loadSelectedChart:chart];
        [self.dismissButton setHidden:YES];
    }
    
    NSArray *reportViewsArray = [[DataController sharedDataInstance] reportViewsArray];
    for (ReportView *report in reportViewsArray) {
        if ([reportviewID isEqualToString:report.reportViewId]) {
            currentReportView = report;
        }
    }
    HTMLBuilder *htmlBuilder = [[HTMLBuilder alloc] init];
    self.contentReference = [htmlBuilder buildHTMLChartWithData:chart andDBFlag:false];
    
    [[self cellWebView] setNeedsDisplay];
    //[self displayTestChart];
    [self loadExamplePage:chart.reportViewType];
    
//    WKWebViewConfiguration *theConfiguration = [[WKWebViewConfiguration alloc] init];
//    WKWebView *webView = [[WKWebView alloc] initWithFrame:self.view.frame configuration:theConfiguration];
//    // webView.navigationDelegate = self;
//    NSURL *nsurl=[NSURL URLWithString:@"http://www.apple.com"];
//    NSURLRequest *nsrequest=[NSURLRequest requestWithURL:nsurl];
//    [webView loadRequest:nsrequest];
//    [self.view addSubview:webView];
}

- (void)viewWillLayoutSubviews {
    
    //  Check for portrait/landscape
    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    //UIDeviceOrientation currentDeviceOrientation = [[UIDevice currentDevice] orientation];
    if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        if (_chartFromDashboard == YES) {
            [self.view setFrame:CGRectMake(0, 0, PORTRAIT_WIDTH, PORTRAIT_HEIGHT)];
        } else {
            [self.view setFrame:CGRectMake(0, TOOLBAR_HEIGHT, LANDSCAPE_WIDTH, LANDSCAPE_HEIGHT)];
        }
    } else {
        if (_chartFromDashboard == YES) {
            [self.view setFrame:CGRectMake(0, 0, PORTRAIT_WIDTH, PORTRAIT_HEIGHT)];
        } else {
            [self.view setFrame:CGRectMake(0, TOOLBAR_HEIGHT, PORTRAIT_WIDTH, PORTRAIT_HEIGHT)];
        }
    }
     
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)loadExamplePage :(NSString *)chartType {
    
    if (_bridge) { return; }
    
    
    WKWebView* webView = [[NSClassFromString(@"WKWebView") alloc] initWithFrame:CGRectMake(10, 50, 700, 600)];
    webView.navigationDelegate = self;
    [WKWebViewJavascriptBridge enableLogging];
    _bridge = [WKWebViewJavascriptBridge bridgeForWebView:webView];
    [_bridge setWebViewDelegate:self];
    
    [_bridge registerHandler:@"testObjcCallback" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"testObjcCallback called: %@", data);
        responseCallback(@"Response from testObjcCallback");
    }];
    NSString *barDataset =
    @"[{ x_key: 0, y_value: 5 },{ x_key: 1, y_value: 10 },{ x_key: 2, y_value: 13 },{ x_key: 3, y_value: 19 },{ x_key: 4, y_value: 21 },{ x_key: 5, y_value: 25 },{ x_key: 6, y_value: 22 },{ x_key: 7, y_value: 18 },{ x_key: 8, y_value: 15 },{ x_key: 9, y_value: 13 },{ x_key: 10, y_value: 11 },{ x_key: 11, y_value: 12 },{ x_key: 12, y_value: 15 },{ x_key: 13, y_value: 20 },{ x_key: 14, y_value: 18 },{ x_key: 15, y_value: 17 },{ x_key: 16, y_value: 16 },{ x_key: 17, y_value: 18 },{ x_key: 18, y_value: 23 },{ x_key: 19, y_value: 25 }]";
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    NSMutableArray *dataDictionaryArray = [NSMutableArray array];
    
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    NSMutableDictionary *presets = [NSMutableDictionary dictionary];
    NSMutableDictionary *dimensions = [NSMutableDictionary dictionary];
    NSMutableDictionary *measures = [NSMutableDictionary dictionary];
    
    NSMutableArray *measureArray = [NSMutableArray array];
    NSMutableArray *dimensionsArray = [NSMutableArray array];
    
    // Dimensions
    // Loop through attribute arrays
    for(ReportViewAttr *attribute in chart.reportViewAttrArray) {
        if ([attribute.attr_type isEqualToString:@"C"] && [attribute.sequence isEqualToNumber:[NSNumber numberWithInt:1]]) {
            [dimensions setValue:@1  forKey:@"axis"];
            [dimensions setValue:attribute.attr_name  forKey:@"name"];
            [dimensions setValue:attribute.attr_Id  forKey:@"value"];
            
            [dimensionsArray addObject:dimensions];
            dimensions = [NSMutableDictionary dictionary];
            
        } else if ([attribute.attr_type isEqualToString:@"C"]) {
            [dimensions setValue:@2  forKey:@"axis"];
            [dimensions setValue:attribute.attr_name  forKey:@"name"];
            [dimensions setValue:attribute.attr_Id  forKey:@"value"];
            
            [dimensionsArray addObject:dimensions];
            dimensions = [NSMutableDictionary dictionary];
        }
    }
    
    // Measures
    // Loop through attribute arrays
    for(ReportViewAttr *attribute in chart.reportViewAttrArray) {
        if ([attribute.attr_type isEqualToString:@"K"]) {
            [measures setValue:attribute.attr_name  forKey:@"name"];
            [measures setValue:attribute.attr_Id  forKey:@"value"];
            
            [measureArray addObject:measures];
            measures = [NSMutableDictionary dictionary];
        }
    }
    
    NSMutableDictionary *colorPallete = [NSMutableDictionary dictionary];
    NSMutableArray *colors = [NSMutableArray array];
    [colors addObject:@"#21a3f1"];
    [colors addObject:@"#ff872e"];
    [colors addObject:@"#79b51a"];
    [colors addObject:@"#f7e326"];
    [colors addObject:@"#074389"];
    [colors addObject:@"#7876e5"];
    [colors addObject:@"#d5eb7e"];
    [colors addObject:@"#488bed"];
    [colors addObject:@"#ffc145"];
    [colors addObject:@"#8a8175"];
    [colors addObject:@"#0b7c16"];
    
    [colorPallete setValue:colors forKey:@"colorPalette"];
    
    [presets setValue:@600 forKey:@"height"];
    [presets setValue:@750 forKey:@"width"];
    [presets setValue:colorPallete forKey:@"plotArea"];
    [presets setValue:measureArray forKey:@"measures"];
    [presets setValue:dimensionsArray forKey:@"dimensions"];
    
    [presets setValue:[chart chartsDictionary] forKey:@"dataset"];
    if ([chartType caseInsensitiveCompare:@"PIE"] == NSOrderedSame) {
        [presets setValue:@"PIE" forKey:@"type"];
    }
    [_bridge callHandler:@"testJavascriptHandler" data:presets];
    
    NSLog(@"PresetData %@",presets);
    NSString *htmlpage = @"ExampleApp";
    NSString* htmlPath = [[NSBundle mainBundle] pathForResource:@"ExampleApp" ofType:@"html"];
    
    if ([chartType caseInsensitiveCompare:@"COLUMN"] == NSOrderedSame) {
        //[htmlpage initWithFormat:@"ExampleApp"];
        htmlPath = [[NSBundle mainBundle] pathForResource:@"VerticleBarChart" ofType:@"html"];
    } else if ([chartType caseInsensitiveCompare:@"BAR"] == NSOrderedSame) {
        //htmlpage = @"VerticleBarChart";
        htmlPath = [[NSBundle mainBundle] pathForResource:@"VerticleBarChart" ofType:@"html"];
        
    } else if ([chartType caseInsensitiveCompare:@"Vertical Bar Cluster"] == NSOrderedSame) {
        htmlPath = [[NSBundle mainBundle] pathForResource:@"VerticleBarChart" ofType:@"html"];;
        //htmlpage = @"ExampleAPP";
    }  else if ([chartType caseInsensitiveCompare:@"HORIZONTAL BAR"] == NSOrderedSame) {
        htmlPath = [[NSBundle mainBundle] pathForResource:@"HorizontalBarChart" ofType:@"html"];
        //htmlpage = @"ExampleAPP";
    } else if ([chartType caseInsensitiveCompare:@"LINE"] == NSOrderedSame) {
        htmlPath = [[NSBundle mainBundle] pathForResource:@"LineChart" ofType:@"html"];
        //htmlpage = @"ExampleAPP";
    } else if ([chartType caseInsensitiveCompare:@"DONUT"] == NSOrderedSame)  {
        htmlPath = [[NSBundle mainBundle] pathForResource:@"DonutChart" ofType:@"html"];
        //htmlpage = @"ExampleAPP";
        
    } else if ([chartType caseInsensitiveCompare:@"PIE"] == NSOrderedSame) {
        htmlPath = [[NSBundle mainBundle] pathForResource:@"DonutChart" ofType:@"html"];
        //htmlpage = @"ExampleAPP";
        
    }else if ([chartType caseInsensitiveCompare:@"BAR STACKED"] == NSOrderedSame) {
        htmlPath = [[NSBundle mainBundle] pathForResource:@"StackBarChart" ofType:@"html"];
        //htmlpage = @"ExampleAPP";
        
    } else if ([chartType caseInsensitiveCompare:@"HEATMAP"] == NSOrderedSame) {
        htmlPath = [[NSBundle mainBundle] pathForResource:@"HeatMapChart" ofType:@"html"];
        //htmlpage = @"ExampleAPP";
        
    } else if (([chartType caseInsensitiveCompare:@"COMBINATION"] == NSOrderedSame) || ([chartType caseInsensitiveCompare:@"DUALCOMBINATION"] == NSOrderedSame)) {
        htmlPath = [[NSBundle mainBundle] pathForResource:@"CombinationChart" ofType:@"html"];
        //GEOBUBBLE
        
    } else if (([chartType caseInsensitiveCompare:@"GEOBUBBLE"] == NSOrderedSame) ||
               ([chartType caseInsensitiveCompare:@"CHOROPLETH"] == NSOrderedSame)){
        htmlPath = [[NSBundle mainBundle] pathForResource:@"GeoBubbleChart" ofType:@"html"];
        //GEOBUBBLE
        
    } else {
        //htmlpage = @"ExampleAPP";
    }
    
    NSString* appHtml = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
    NSURL *baseURL = [NSURL fileURLWithPath:htmlPath];
    [webView loadHTMLString:appHtml baseURL:baseURL];
    
    [self.view addSubview:webView];
}

- (void) displayTestChart
{
    
    NSBundle *bundle = [NSBundle mainBundle];
    //  Get the full path to the Documents directory to access html file saved there.
    //NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //NSString *documentsDirectory = [paths objectAtIndex:0];
    
    //  Load html from generated file in documents directory
    NSString *aPathForResource = [[NSString alloc] initWithFormat:@"%@/%@", [bundle resourcePath],contentReference];
    NSString *htmlString = [NSString stringWithContentsOfFile:aPathForResource
                                                     encoding:NSUTF8StringEncoding
                                                        error:nil];
    
    NSLog(@"html file:  %@", htmlString);
    
    
    NSLog(@"bundle resource path: %@", [bundle resourcePath]);
    NSLog(@"bundle resource URL: %@", [bundle resourceURL]);
    NSString *baseResourceURLString = [[NSString alloc] initWithFormat:@"%@",[[NSBundle mainBundle] bundlePath]];
    
    NSURL *baseURL = [NSURL fileURLWithPath:[bundle bundlePath]];
    [self.cellWebView setScalesPageToFit:NO];
    [self.cellWebView.scrollView setScrollEnabled:YES];
    // Load the generated html page directly from string variable
    NSString *embedHTML = @"<html><head><script src=\"http://d3js.org/d3.v3.min.js\"></script><script src=\"http://dimplejs.org/dist/dimple.v2.1.6.min.js\"></script></head><body><p>1. You agree that you will be the technician servicing this work order?.<br>2. You are comfortable with the scope of work on this work order?.<br>3. You understand that if you go to site and fail to do quality repair for  any reason, you will not be paid?.<br>4. You must dress business casual when going on the work order.</p><script type=\"text/javascript\">var svg = dimple.newSvg(\"body\", 800, 600);var data = [{ \"Word\":\"Hello\", \"Awesomeness\":2000 },{ \"Word\":\"World\", \"Awesomeness\":3000 }];var chart = new dimple.chart(svg, data);chart.addCategoryAxis(\"x\", \"Word\");chart.addMeasureAxis(\"y\", \"Awesomeness\");chart.addSeries(null, dimple.plot.bar);chart.draw();</script></body></html>";
    
    //[[self cellWebView] loadHTMLString:embedHTML baseURL:nil];
    [[self cellWebView] loadHTMLString:contentReference baseURL:baseURL];
    
}

//  Required for iOS 8
- (void)viewWillTransitionToSize:(CGSize)size
       withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    //  Check for portrait/landscape
    UIInterfaceOrientation fromInterfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    //UIDeviceOrientation currentDeviceOrientation = [[UIDevice currentDevice] orientation];
    if (fromInterfaceOrientation == UIInterfaceOrientationPortrait || fromInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        if (_chartFromDashboard == YES) {
            [self.view setFrame:CGRectMake(0, 0, PORTRAIT_WIDTH, PORTRAIT_HEIGHT)];
        } else {
            [self.view setFrame:CGRectMake(0, TOOLBAR_HEIGHT, LANDSCAPE_WIDTH, LANDSCAPE_HEIGHT)];
        }
    } else {
        if (_chartFromDashboard == YES) {
            [self.view setFrame:CGRectMake(0, 0, PORTRAIT_WIDTH, PORTRAIT_HEIGHT)];
        } else {
            [self.view setFrame:CGRectMake(0, TOOLBAR_HEIGHT, PORTRAIT_WIDTH, PORTRAIT_HEIGHT)];
        }
    }
}

- (IBAction) dismissButtonPressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction) emailButtonPressed:(id)sender
{
    
    UIImage *viewImage = [self captureView];
    NSData *imageData = UIImagePNGRepresentation(viewImage);
    
    NSString *emailTitle = @"SAP IBP data to review";
    NSString *messageBody = @"IBP chart attached.";
    //NSArray *toRecipents = [NSArray arrayWithObject:@"support@appcoda.com"];
    
    if ([MFMailComposeViewController canSendMail] == YES) {
        MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
        mc.mailComposeDelegate = self;
        [mc setSubject:emailTitle];
        [mc setMessageBody:messageBody isHTML:YES];
        //[mc setToRecipients:toRecipents];
        
        [mc addAttachmentData:imageData mimeType:@"image/png" fileName:@"png_image_1"];
        
        [self presentViewController:mc animated:YES completion:NULL];
    } else {
        // Popup an error
        UIAlertController *alert1 = [UIAlertController alertControllerWithTitle:@"Email alert!" message:@"Email not available on this device." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {}];
        [alert1 addAction:defaultAction];
        [self presentViewController:alert1 animated:YES completion:nil];
    }
    
}

- (void)showEmail:(NSString*)file {
    
    NSString *emailTitle = @"Great Photo and Doc";
    NSString *messageBody = @"Hey, check this out!";
    NSArray *toRecipents = [NSArray arrayWithObject:@"support@appcoda.com"];
    
    if ([MFMailComposeViewController canSendMail] == YES) {
        MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
        mc.mailComposeDelegate = self;
        [mc setSubject:emailTitle];
        [mc setMessageBody:messageBody isHTML:NO];
        [mc setToRecipients:toRecipents];
    }
    
}

- (UIImage *)captureView
{
    
    //hide controls if needed
    CGRect rect = [self.view bounds];
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [cellWebView.layer renderInContext:context];
    //[self.view.layer renderInContext:context];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
    
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
