//
//  WebviewCellVC.m
//  IBP
//
//  Created by Rick Thompson on 11/14/14.
//  Copyright (c) 2014 Linear Logics Corporation. All rights reserved.
//

#import "WebviewCellVC.h"
#import "FullWebviewVC.h"
#import "D3WebViewController.h"
#import "WebKitController.h"
#import "WKWebViewJavascriptBridge.h"
#import "ReportViewAttr.h"
#import "ReportView.h"


@interface WebviewCellVC ()
@property (nonatomic, strong) WKWebView *cellWKWebView;
@property (nonatomic, strong) NSOperationQueue *scriptQueue;


@property WKWebViewJavascriptBridge* bridge;

@end

@implementation WebviewCellVC

@synthesize cellName;
@synthesize contentReference;
@synthesize contentType;
//@synthesize cellWebView;
//@synthesize titleLabel;
@synthesize timeStampString;
@synthesize chartObject;
@synthesize fullScreenIcon;
@synthesize chart;
@synthesize reportviewID;

@synthesize wkWebViewWidth;
@synthesize wkWebViewHeight;
@synthesize graphDataSet;
@synthesize graphDataSetArray;

//@synthesize htmlString;


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
    self.titleLabel.text = self.titleString;
    self.timeStampLabel.text = self.timeStampString;
    //[[self cellWebView] setNeedsDisplay];
    
  
    //[self displayTestChart];
    //[self loadExamplePage];
    
//    if (([[chart reportViewType] caseInsensitiveCompare:@"COLUMN"] == NSOrderedSame) ||
//        ([[chart reportViewType] caseInsensitiveCompare:@"Vertical Bar Cluster"] == NSOrderedSame)) {
//        [self loadExamplePage];
//    } else {
//       // [self displayTestChart];
//    }
    
  
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
 
    //[self.view addSubview:_cellWKWebView ];
    //[self.webContainerView addSubview:cellWKWebView];
    [self cellWKWebView].navigationDelegate = self;
    
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
                                                      
                                                      [_cellWKWebView evaluateJavaScript:@"NEED SOMETHING HERE"
                                                                      completionHandler:^(id object, NSError *error) {
                                                                          
                                                                      }];
                                                  }];
    
    
    [[NSNotificationCenter defaultCenter] addObserverForName:D3_NOTE_UPDATE_DATA
                                                      object:self
                                                       queue:_scriptQueue
                                                  usingBlock:^(NSNotification *note) {
                                                      
                                                      NSString *js = [NSString stringWithFormat:@""];
                                                      
                                                      [_cellWKWebView evaluateJavaScript:js
                                                                      completionHandler:^(id object, NSError * error) {
                                                                          if (error) {
                                                                              NSLog(@"Error: %@", error.localizedDescription);
                                                                          }
                                                                      }];
                                                  }];
    
    
    //[self loadExamplePage];
   //[self renderButtons:webView];
    

}


-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    //Remove Observers added!
    //    [[NSNotificationCenter defaultCenter] removeObserver:<#(id)#> name:<#(NSString *)#> object:<#(id)#>];
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    NSLog(@"webViewDidStartLoad");
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSLog(@"webViewDidFinishLoad");
}

- (void)renderButtons:(WKWebView*)webView {
    UIFont* font = [UIFont fontWithName:@"HelveticaNeue" size:12.0];
    
    UIButton *callbackButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [callbackButton setTitle:@"Call handler" forState:UIControlStateNormal];
    [callbackButton addTarget:self action:@selector(callHandler:) forControlEvents:UIControlEventTouchUpInside];
    [self.view insertSubview:callbackButton aboveSubview:webView];
    callbackButton.frame = CGRectMake(10, 400, 100, 35);
    callbackButton.titleLabel.font = font;
    
    UIButton* reloadButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [reloadButton setTitle:@"Reload webview" forState:UIControlStateNormal];
    [reloadButton addTarget:webView action:@selector(reload) forControlEvents:UIControlEventTouchUpInside];
    [self.view insertSubview:reloadButton aboveSubview:webView];
    reloadButton.frame = CGRectMake(110, 400, 100, 35);
    reloadButton.titleLabel.font = font;
}

- (void)callHandler:(id)sender {
    id data = @{ @"greetingFromObjC": @"Hi there, JS!" };
    [_bridge callHandler:@"testJavascriptHandler" data:data responseCallback:^(id response) {
        NSLog(@"testJavascriptHandler responded: %@", response);
    }];
}

- (void)loadExamplePage :(NSString *)chartType {
    if (_bridge) { return; }
    
    
    WKWebView* webView = [[NSClassFromString(@"WKWebView") alloc] initWithFrame:CGRectMake(0, 0, [wkWebViewWidth floatValue], [wkWebViewHeight  floatValue]-80)];
    webView.navigationDelegate = self;
    [WKWebViewJavascriptBridge enableLogging];
    _bridge = [WKWebViewJavascriptBridge bridgeForWebView:webView];
    [_bridge setWebViewDelegate:self];
    
    [_bridge registerHandler:@"testObjcCallback" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"testObjcCallback called: %@", data);
        responseCallback(@"Response from testObjcCallback");
    
    }];
    
    NSMutableDictionary *barDatadictionary = [NSMutableDictionary dictionary];
    [barDatadictionary setValue:@10785810 forKey:@"PCAOPREV"];
    [barDatadictionary setValue:@"Sep-16" forKey:@"PERIODID3"];
    [barDatadictionary setValue:@"Family 100-Headphones" forKey:@"PRDFAMILY"];
    
    NSMutableArray *barDatadictionaries = [NSMutableArray array];
    
    [barDatadictionaries addObject:barDatadictionaries];
    
    
    
    NSString *barDataset =
    @"[{PCAOPREV: 10785810,PERIODID3: Sep-16,PRDFAMILY: Family 100-Headphones,}, {PCAOPREV: 20960830,PERIODID3: Sep-16,PRDFAMILY: Family 200-Music Docks}, {PCAOPREV: 0,PERIODID3: Sep-16,PRDFAMILY: Family 300-Home Theater}, {PCAOPREV: 8875630,PERIODID3: Oct-16,PRDFAMILY: Family 100-Headphones}, {PCAOPREV: 16735190,PERIODID3: Oct-16,PRDFAMILY: Family 200-Music Docks}, {PCAOPREV: 0,PERIODID3: Oct-16,PRDFAMILY: Family 300-Home Theater}]";
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

    float height = [wkWebViewHeight  floatValue]-80;
    float width = [wkWebViewWidth floatValue];
    [presets setValue:@(height) forKey:@"height"];
    [presets setValue:@(width) forKey:@"width"];
    [presets setValue:colorPallete forKey:@"plotArea"];
    [presets setValue:measureArray forKey:@"measures"];
    [presets setValue:dimensionsArray forKey:@"dimensions"];

    [presets setValue:[chart chartsDictionary] forKey:@"dataset"];
    if ([chartType caseInsensitiveCompare:@"PIE"] == NSOrderedSame) {
        [presets setValue:@"PIE" forKey:@"type"];
    }
    
   
    
    [_bridge callHandler:@"testJavascriptHandler" data:presets];
    
    NSLog(@"ChartType Data %@",chartType);
    NSLog(@"Height and Width Data %f %f",height, width);
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
        //htmlPath = [[NSBundle mainBundle] pathForResource:@"StackBarChart" ofType:@"html"];
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
        
    } else if ([chartType caseInsensitiveCompare:@"COMBINATION"] == NSOrderedSame) {
        htmlPath = [[NSBundle mainBundle] pathForResource:@"CombinationChart" ofType:@"html"];
        //GEOBUBBLE
        
    } else if ([chartType caseInsensitiveCompare:@"GEOBUBBLE"] == NSOrderedSame) {
        htmlPath = [[NSBundle mainBundle] pathForResource:@"GeoBubbleChart" ofType:@"html"];
        //GEOBUBBLE
        
    }else if ([chartType caseInsensitiveCompare:@"NETVIZ BASIC"] == NSOrderedSame) {
        
    }else {
        
    }
    
    NSString* appHtml = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
    NSURL *baseURL = [NSURL fileURLWithPath:htmlPath];
    [webView loadHTMLString:appHtml baseURL:baseURL];
    
    [self.graphView addSubview:webView];
}

-(bool) isNumeric:(NSString*) checkText{
    
    NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
    //Set the locale to US
    [numberFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    //Set the number style to Scientific
    [numberFormatter setNumberStyle:NSNumberFormatterScientificStyle];
    NSNumber* number = [numberFormatter numberFromString:checkText];
    if (number != nil) {
        return true;
    }
    return false;
}

#pragma mark - Setup
-(void) setupWebView :(NSString *) html : (NSURL *) indexURL
{
//    WebKitController *wkController = [WebKitController sharedInstance];
//    _cellWKWebView = [[WKWebView alloc] initWithFrame:CGRectMake(self.view.frame.size.width , self.view.center.y , self.view.frame.size.width - (self.view.frame.size.width ), self.view.frame.size.height)configuration:wkController.config];
//    WKWebViewConfiguration *theConfiguration = [[WKWebViewConfiguration alloc] init];
//    _cellWKWebView =  [[WKWebView alloc] initWithFrame:self.view.frame configuration:wkController.config];
//    _cellWKWebView.UIDelegate = self;
//    _cellWKWebView.navigationDelegate = self;
//    _cellWKWebView.allowsBackForwardNavigationGestures = NO; //This disables the ability to go back and go forward (we will be updating manually).
//    
//    [_cellWKWebView setBackgroundColor:[UIColor greenColor]];
//    
//    //External Example.
//    //     NSURL *url = [NSURL URLWithString:@"https:www.google.com"];
//    //     NSURLRequest *request = [NSURLRequest requestWithURL:url];
//    //     [cellWKWebView loadRequest:request];
//    // request = nil;
//    
//    
//    //    WKWebViewConfiguration *theConfiguration = [[WKWebViewConfiguration alloc] init];
//    //    WKWebView *webView = [[WKWebView alloc] initWithFrame:self.view.frame configuration:theConfiguration];
//    //    // webView.navigationDelegate = self;
//    //    NSURL *nsurl=[NSURL URLWithString:@"http://www.apple.com"];
//    //    NSURLRequest *nsrequest=[NSURLRequest requestWithURL:nsurl];
//    //    [webView loadRequest:nsrequest];
//    //    [self.view addSubview:webView];
//    //This is found in the D3Samples folder in the Supporting files.
//    //    NSString *indexPath = @"<!DOCTYPE html><html ><head><meta charset=\"UTF-8\"><title>line graph</title><link rel=\"stylesheet\" href=\"css/style.css\"></head><body><script src=\"d3.js\"></script><script src=\"lineGraph.js\"></script></body></html>";
////    NSString *indexPath = [[NSBundle mainBundle] pathForResource:EXP_D3_PIE ofType:@"html"];
////    NSURL *indexURL = [NSURL fileURLWithPath:indexPath];
////    NSString *indexFile = [NSString stringWithContentsOfURL:indexURL encoding:NSUTF8StringEncoding error:nil];
//    //    NSLog(@"indexURL: %@", indexURL);
//    //    NSLog(@"indexfile: %@", indexFile);
//    
//    // [cellWKWebView loadHTMLString:embedHTML baseURL:nil];
//    [_cellWKWebView loadHTMLString:html baseURL:indexURL];
//    [self.view addSubview:_cellWKWebView ];
//    NSString *barDataSet =
//    @"[ { x_key: 0, y_value: 5 },{ x_key: 1, y_value: 10 },{ x_key: 2, y_value: 13 },{ x_key: 3, y_value: 19 }]";
//    NSString *funcString = [NSString stringWithFormat:@"customBarGraph(%@)", barDataSet];
//    [_cellWKWebView evaluateJavaScript:funcString completionHandler:nil];
    
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

// And the delegate method that is not getting called is
- (void)webView:(WKWebView *)webView
didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *credential))completionHandler {
    SecTrustRef serverTrust = challenge.protectionSpace.serverTrust;
    CFDataRef exceptions = SecTrustCopyExceptions(serverTrust);
    SecTrustSetExceptions(serverTrust, exceptions);
    CFRelease(exceptions);
    
    completionHandler(NSURLSessionAuthChallengeUseCredential,
                      [NSURLCredential credentialForTrust:serverTrust]);
}

- (void) displayTestChart
{
    
    //titleLabel.text = [NSString stringWithFormat:@"%@",contentReference];
    _titleLabel.numberOfLines = 2;
    
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
    
    NSURL *baseURL = [NSURL fileURLWithPath:[bundle bundlePath]];
    [self.cellWebView setScalesPageToFit:NO];
    [self.cellWebView.scrollView setScrollEnabled:YES];
    // Load the generated html page directly from string variable
    [[self cellWebView] loadHTMLString:contentReference baseURL:baseURL];
    
    [self.view addSubview:_cellWebView];
    
}

// MARK: Full web View
- (void) touchesBegan: (NSSet *) touches withEvent: (UIEvent *) event {
    UITouch *touch = [touches anyObject];
    if([touch view] == fullScreenIcon) {
        
        NSLog(@"Title in cell has been touched:  %@", cellName);
        //  Need to add code to show fullscreen chart here
        // Show as fullscreen
        //  Try as modal view...
        
        FullWebviewVC *popupChartView = [[FullWebviewVC alloc] initWithNibName:@"FullWebviewVC" bundle:nil];
        [popupChartView setChart:chart];
        [popupChartView setReportviewID:reportviewID];
        [popupChartView setChartFromDashboard:TRUE];
        
        
        //[popupChartView setContentReference:contentReference];
        [popupChartView setModalInPopover:YES];
        [popupChartView setModalPresentationStyle:UIModalPresentationPageSheet];
        [self presentViewController:popupChartView animated:YES completion:nil];
        
//        NSString *VCName1 = @"TestWKWebViewController";
//        NSString *VCName2 = @"D3WebViewController";
//         D3WebViewController *popupChartView = [[D3WebViewController alloc] initWithNibName:VCName2 bundle:nil];
//        [self presentViewController:popupChartView animated:YES completion:nil];
        
    }
}

@end
