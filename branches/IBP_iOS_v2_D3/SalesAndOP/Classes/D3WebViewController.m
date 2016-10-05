//
//  D3WebViewController.m
//  IBP
//
//  Created by Sudhir Kumar on 8/1/16.
//  Copyright © 2016 Linear Logics Corporation. All rights reserved.
//

#import "D3WebViewController.h"
#import "WebKitController.h"

@interface D3WebViewController ()

//@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) NSOperationQueue *scriptQueue;

@end

@implementation D3WebViewController

-(void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setupWebView];
    [self.view addSubview:_webView];
    
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
                                                      
                                                      [_webView evaluateJavaScript:@"NEED SOMETHING HERE"
                                                                 completionHandler:^(id object, NSError *error) {
                                                                     
                                                                 }];
                                                  }];
    
    
    [[NSNotificationCenter defaultCenter] addObserverForName:D3_NOTE_UPDATE_DATA
                                                      object:self
                                                       queue:_scriptQueue
                                                  usingBlock:^(NSNotification *note) {
                                                      
                                                      NSString *js = [NSString stringWithFormat:@""];
                                                      
                                                      [_webView evaluateJavaScript:js
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
    _webView = [[WKWebView alloc] initWithFrame:CGRectMake(self.view.frame.size.width , self.view.center.y , self.view.frame.size.width - (self.view.frame.size.width ), self.view.frame.size.height)configuration:wkController.config];
    WKWebViewConfiguration *theConfiguration = [[WKWebViewConfiguration alloc] init];
    _webView =  [[WKWebView alloc] initWithFrame:self.view.frame configuration:wkController.config];
    _webView.UIDelegate = self;
    _webView.navigationDelegate = self;
    _webView.allowsBackForwardNavigationGestures = NO; //This disables the ability to go back and go forward (we will be updating manually).
    
    [_webView setBackgroundColor:[UIColor greenColor]];
    
    //External Example.
//     NSURL *url = [NSURL URLWithString:@"https:www.google.com"];
//     NSURLRequest *request = [NSURLRequest requestWithURL:url];
//     [_webView loadRequest:request];
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
    
   // [_webView loadHTMLString:embedHTML baseURL:nil];
    [_webView loadHTMLString:indexFile baseURL:indexURL];
    
    
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

#pragma mark - IBAction
- (IBAction)refreshWebView:(id)sender {
    //    NSLog(@"Reloaded");
    //    [_webView evaluateJavaScript:@"window.webkit.messageHandlers.{NAME}.postMessage({body: "" })"
    //               completionHandler:^(id object, NSError * error) {
    //        [_webView reload];
    //    }];
    
    //    [_webView evaluateJavaScript:@"fireOffCustomEvent();" completionHandler:nil];
    
    NSString *pieDataSet = @"[ { x_key:\"A\", y_value: 5 },{ x_key: \"B\", y_value: 10 }]";
    NSString *funcString = [NSString stringWithFormat:@"updateGraph(%@)", pieDataSet];
    [_webView evaluateJavaScript:funcString completionHandler:nil];
}

- (void) loadLineChart:(NSString*) jsonData {
    NSString *pieDataSet = @"[ { x_key:\"A\", y_value: 5 },{ x_key: \"B\", y_value: 10 }]";
    NSString *funcString = [NSString stringWithFormat:@"updateGraph(%@)", pieDataSet];
    [_webView evaluateJavaScript:funcString completionHandler:nil];
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
