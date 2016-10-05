//
//  WKWebviewCellVC.m
//  IBP
//
//  Created by Rick Thompson on 11/25/14.
//  Copyright (c) 2014 Linear Logics Corporation. All rights reserved.
//

#import "WKWebviewCellVC.h"
#import "FullWebviewVC.h"
#import "D3WebViewController.h"
#import "WebKitController.h"

#import "DashboardCell.h"

@interface WKWebviewCellVC ()
@property (nonatomic, strong) NSOperationQueue *scriptQueue;
@end

#define LANDSCAPE_CELL_WIDTH_1 243.5
#define LANDSCAPE_CELL_HEIGHT_1 265.6
#define CELL_BORDER 10

@implementation WKWebviewCellVC

@synthesize cellName;
@synthesize contentReference;
@synthesize contentType;
//@synthesize cellWebView;
@synthesize titleLabel;
@synthesize timestamp;
@synthesize chartObject;
@synthesize fullScreenIcon;
@synthesize chart;
@synthesize reportviewID;
@synthesize cellWKWebView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //titleLabel = [[UILabel alloc] init];
        //timestamp =  [[UILabel alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.titleLabel.text = [NSString stringWithFormat:@"%@-WK",self.titleString];
    
    //WKWebViewConfiguration *theConfiguration = [[WKWebViewConfiguration alloc] init];
    float rowS = [_rowSpan floatValue];
    float columnS = [_columnSpan floatValue];
    cellWKWebView = [[WKWebView alloc] initWithFrame:[self.webContainerView frame]];
    
    
    
    [[self cellWKWebView] setNeedsDisplay];
    
   // [self displayTestChart];
    //[self.webContainerView addSubview:cellWKWebView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setupWebView];
    [self.webContainerView addSubview:cellWKWebView];
    
    _scriptQueue = [[NSOperationQueue alloc] init];
    _scriptQueue.qualityOfService = NSOperationQueuePriorityVeryHigh;
    
    [[NSNotificationCenter defaultCenter] addObserverForName:D3_NOTE_JS_MESSAGE_SAMPLE
                                                      object:self
                                                       queue:_scriptQueue
                                                  usingBlock:^(NSNotification *note) {
                                                      
                                                      //From here add these as part of the arguments for the script we are sending this to.
                                                      NSString *name = note.name;
                                                      NSDictionary *jsObject = note.userInfo;
                                                      NSLog(@"Name: %@\njsObject: %@", name, jsObject);
                                                      
                                                      [cellWKWebView evaluateJavaScript:@"NEED SOMETHING HERE"
                                                                 completionHandler:^(id object, NSError *error) {
                                                                     
                                                                 }];
                                                  }];
    
    
    [[NSNotificationCenter defaultCenter] addObserverForName:D3_NOTE_UPDATE_DATA
                                                      object:self
                                                       queue:_scriptQueue
                                                  usingBlock:^(NSNotification *note) {
                                                      
                                                      NSString *js = [NSString stringWithFormat:@""];
                                                      
                                                      [cellWKWebView evaluateJavaScript:js
                                                                 completionHandler:^(id object, NSError * error) {
                                                                     if (error) {
                                                                         NSLog(@"Error: %@", error.localizedDescription);
                                                                     }
                                                                 }];
                                                  }];
    
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    //Remove Observers added!
    //    [[NSNotificationCenter defaultCenter] removeObserver:<#(id)#> name:<#(NSString *)#> object:<#(id)#>];
}

#pragma mark - Setup
-(void)setupWebView
{
    WebKitController *wkController = [WebKitController sharedInstance];
    cellWKWebView = [[WKWebView alloc] initWithFrame:CGRectMake(self.view.frame.size.width , self.view.center.y , self.view.frame.size.width - (self.view.frame.size.width ), self.view.frame.size.height)configuration:wkController.config];
    WKWebViewConfiguration *theConfiguration = [[WKWebViewConfiguration alloc] init];
    cellWKWebView =  [[WKWebView alloc] initWithFrame:self.view.frame configuration:wkController.config];
    cellWKWebView.UIDelegate = self;
    cellWKWebView.navigationDelegate = self;
    cellWKWebView.allowsBackForwardNavigationGestures = NO; //This disables the ability to go back and go forward (we will be updating manually).
    
    [cellWKWebView setBackgroundColor:[UIColor greenColor]];
    
    //External Example.
    //     NSURL *url = [NSURL URLWithString:@"https:www.google.com"];
    //     NSURLRequest *request = [NSURLRequest requestWithURL:url];
    //     [cellWKWebView loadRequest:request];
    // request = nil;
    
    
    //    WKWebViewConfiguration *theConfiguration = [[WKWebViewConfiguration alloc] init];
    //    WKWebView *webView = [[WKWebView alloc] initWithFrame:self.view.frame configuration:theConfiguration];
    //    // webView.navigationDelegate = self;
    //    NSURL *nsurl=[NSURL URLWithString:@"http://www.apple.com"];
    //    NSURLRequest *nsrequest=[NSURLRequest requestWithURL:nsurl];
    //    [webView loadRequest:nsrequest];
    //    [self.view addSubview:webView];
    //This is found in the D3Samples folder in the Supporting files.
    //    NSString *indexPath = @"<!DOCTYPE html><html ><head><meta charset=\"UTF-8\"><title>line graph</title><link rel=\"stylesheet\" href=\"css/style.css\"></head><body><script src=\"d3.js\"></script><script src=\"lineGraph.js\"></script></body></html>";
    NSString *indexPath = [[NSBundle mainBundle] pathForResource:EXP_D3_PIE ofType:@"html"];
    NSURL *indexURL = [NSURL fileURLWithPath:indexPath];
    NSString *indexFile = [NSString stringWithContentsOfURL:indexURL encoding:NSUTF8StringEncoding error:nil];
    //    NSLog(@"indexURL: %@", indexURL);
    //    NSLog(@"indexfile: %@", indexFile);
    
    // [cellWKWebView loadHTMLString:embedHTML baseURL:nil];
    [cellWKWebView loadHTMLString:indexFile baseURL:indexURL];
    
    
}

#pragma mark - WKWebView
//Where the App 'injects' itself.

#pragma mark WKNavigationDelegate
-(void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    switch (navigationAction.navigationType) {
        case WKNavigationTypeOther:
        case WKNavigationTypeReload:
            //This is the action for loading from a local HTML document.
            NSLog(@"Navigation Allowed.");
            decisionHandler(WKNavigationActionPolicyAllow);
            break;
            
        case WKNavigationTypeBackForward:
        case WKNavigationTypeFormSubmitted:
        case WKNavigationTypeFormResubmitted:
        case WKNavigationTypeLinkActivated:
            NSLog(@"Navigation Denied.");
            decisionHandler(WKNavigationActionPolicyCancel);
            break;
            
        default:
            break;
    }
    
    /*//Sample implementation for future...
     NSURL *url = navigationAction.request.URL;
     if (![url.host.lowercaseString hasPrefix:@"https://"]) {
     decisionHandler(WKNavigationActionPolicyCancel);
     return;
     }
     */
}

-(void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler
{
    //This is not being used at the moment, this would be what would be called right after the decidePolicy, this will return true as long as the type of file is visible at the moment.
    //Handle Reponse
    if (navigationResponse.canShowMIMEType) {
        decisionHandler(WKNavigationResponsePolicyAllow);
    } else {
        decisionHandler(WKNavigationResponsePolicyCancel);
    }
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) displayTestChart
{
    
    //titleLabel.text = [NSString stringWithFormat:@"%@",contentReference];
    titleLabel.numberOfLines = 2;
    
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
    NSString *pathToLanguage = [[NSBundle mainBundle] pathForResource:@"language_en" ofType:@"js"];
    DLog(@"pathToLanguage: %@", pathToLanguage);
    NSString *pathToSAPUICORE = [[NSBundle mainBundle] pathForResource:@"sap-ui-core" ofType:@"js" inDirectory:@"sapui5-static"];
    DLog(@"pathToSAPUICORE: %@", pathToSAPUICORE);
    
    //NSURL *baseURL = [NSURL fileURLWithPath:[bundle bundlePath]];
    
    NSURL *baseURL = [NSURL fileURLWithPath:NSTemporaryDirectory()];
    //NSURL *tmpBaseURL = [SwiftlyBridge buildURL:NSTemporaryDirectory()];
    //NSURL *swiftTmpBaseURL = [SwiftlyBridge buildURL:NSTemporaryDirectory()];
    DLog(@"baseURL:  %@", baseURL);
    
    //NSURL *baseURL = [NSURL URLWithString:@"http://192.168.1.14/~rickt/"];
    //[self.cellWKWebView. setScalesPageToFit:NO];
    [self.cellWKWebView.scrollView setScrollEnabled:YES];
    // Load the generated html page directly from string variable
    [[self cellWKWebView] loadHTMLString:contentReference baseURL:baseURL];
    //[[self cellWKWebView] loadRequest:[NSURL ] contentReference];
}

- (void) touchesBegan: (NSSet *) touches withEvent: (UIEvent *) event {
    UITouch *touch = [touches anyObject];
    if([touch view] == fullScreenIcon) {
        
        NSLog(@"Title in cell has been touched:  %@", cellName);
        //  Need to add code to show fullscreen chart here
        // Show as fullscreen
        //  Try as modal view...
        
//        FullWebviewVC *popupChartView = [[FullWebviewVC alloc] initWithNibName:@"FullWebviewVC" bundle:nil];
//        [popupChartView setChart:chart];
//        [popupChartView setReportviewID:reportviewID];
//        //[popupChartView setContentReference:contentReference];
//        [popupChartView setModalInPopover:YES];
//        [popupChartView setModalPresentationStyle:UIModalPresentationPageSheet];
//        [self presentViewController:popupChartView animated:YES completion:nil];
        
        NSString *VCName1 = @"TestWKWebViewController";
        NSString *VCName2 = @"D3WebViewController";
        D3WebViewController *popupChartView = [[D3WebViewController alloc] initWithNibName:VCName2 bundle:nil];
        [self presentViewController:popupChartView animated:YES completion:nil];
        
    }
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
