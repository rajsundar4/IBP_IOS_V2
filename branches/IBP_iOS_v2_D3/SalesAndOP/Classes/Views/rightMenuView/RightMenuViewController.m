//
//  RightMenuViewController.m
//  S&OP
//
//  Created by Rick Thompson on 2/11/14.
//  Copyright (c) 2014 Linear Logics Corporation. All rights reserved.
//

#import "RightMenuViewController.h"
#import "sapsopaRequestHandler.h"

@interface RightMenuViewController ()

@end

@implementation RightMenuViewController
@synthesize jamWebView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        NSLog(@"rmvc - inside init customization.");
        activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        activityIndicator.frame = CGRectMake(50, 50, 50, 50);
        [self.view addSubview:activityIndicator];
        
        //webView = [[UIWebView alloc] initWithFrame:CGRectMake(x, y, w, h)];
        [jamWebView setDelegate:self];
    }
    
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSLog(@"%@ viewDidLoad.", [self class]);
    NSError *returnError;
    
    if(connectionType == DirectConnectToSAOPView) {
        [[JAMController sharedInstance] setBaseServerURL:[[NSUserDefaults standardUserDefaults] valueForKey:kSaveServerUrlMannualy ]];
        NSDictionary *jamConfigData = [[JAMController sharedInstance] getJamCollaborationConfigAndReturnError:&returnError];
        NSDictionary *jamRegistrationData = [[JAMController sharedInstance] getJamCollaborationRegistrationAndReturnError:&returnError];
        
        NSDictionary *jamSession = [[JAMController sharedInstance] getJamCollaborationSessionAndReturnError:&returnError];
        
        if ([JAMController sharedInstance].available == YES) {
            [[JAMController sharedInstance] sendAuthURLandReturnError:&returnError];
            [[JAMController sharedInstance] retrieveCookies];
            
            [[JAMController sharedInstance] getJamGroupsandReturnError:&returnError];
        }
    }
    
    
}


- (UIWebView *) webView
{
    return (UIWebView *) [self view];
}

- (void)viewWillAppear:(BOOL)animated{
    DLog(@"class: %@ viewWillAppear", [self class]);
    
    [super viewWillAppear:animated];
    //Check for the current interface orientation.
    DLog(@"interface orientation: %d", self.interfaceOrientation);
    [self.jamWebView setContentMode:UIViewContentModeRedraw];
    
    //NSLog(@"main screen width:  %f, height: %f", [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
    
    if ((self.interfaceOrientation == UIDeviceOrientationLandscapeLeft) || (self.interfaceOrientation == UIDeviceOrientationLandscapeRight)){
        [self.view setFrame:CGRectMake(0,0,[[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];;
        //[self.view setFrame:CGRectMake(0, 0, 1024, 768)];
        //[self.jamWebView setFrame:CGRectMake(687, 0, 337, 768)];
        [self.view setFrame:CGRectMake(677, 77, 347, 686)];
        [self.jamWebView setFrame:CGRectMake(5, 5, 337, 661)];
        //[analyticsTableView setFrame:ANALYTICS_TABLEVIEW_FRAME_LANDSCAPE];
    } else {
        [self.view setFrame:CGRectMake(0,0,[[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];
        [self.view setFrame:CGRectMake(421, 77, 347, 927)];
        [self.jamWebView setFrame:CGRectMake(5, 5, 337, 917)];
        //[analyticsTableView setFrame:ANALYTICS_TABLEVIEW_FRAME_PORTRAIT];
    }
    
    // Build the url to call
    NSError *returnError;
    NSURL *jamURL = [[JAMController sharedInstance] buildJamUrl];
    
    DLog(@"jamURL:  %@", jamURL);
    
    // If we want to capture the html page without displaying we can use the call below.
    //NSString *pageResponse = [[JAMController sharedInstance] callJamFeedWidgetAndReturnPage:jamURL andReturnError:&returnError];
    //NSLog(@"pageResponse: %@", pageResponse);
    
    //  The call below will blank the UIWebView.
    //[[self jamWebView] loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"about:blank"]]];
    //[Global showProgessindicator:[self jamWebView]];
    
    //NSLog(@"Data detector types: %u", jamWebView.dataDetectorTypes);
    NSURLRequest *jamRequest = [NSURLRequest requestWithURL:jamURL];
    [[self jamWebView] loadRequest:jamRequest];
    
    //NSString *jamURL2 = [NSString stringWithString:@"https://jamsalesdemo8.successfactors.com:443/widget_feed_items?type=group&num_items=30&avatar=false&live_update=false&mobile=false&post_mode=inline&reply_mode=inline&group_id=18137,%2018140,%205093,%2027507,%2018139,%2018136,%2027139,%2027138,%2018138,%2027651]
    //NSURLRequest *jamRequest2 = [NSU]
    
    //NSLog(@" baseJamUrl:  %@", [[JAMController sharedInstance] baseJamURL]);
    //NSURL *redirectedURL = [NSURL URLWithString:@"https://jamsalesdemo8.sapjam.com"];
    //[[self jamWebView] loadHTMLString:pageResponse baseURL:redirectedURL];
    //[[self jamWebView] reload];
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    DLog(@"interface orientation: %d", self.interfaceOrientation);
    if ((self.interfaceOrientation == UIDeviceOrientationLandscapeLeft) || (self.interfaceOrientation == UIDeviceOrientationLandscapeRight)){
        [self.view setFrame:CGRectMake(0,0,[[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];;
        //[self.view setFrame:CGRectMake(0, 0, 1024, 768)];
        //[self.jamWebView setFrame:CGRectMake(687, 0, 337, 768)];
        [self.view setFrame:CGRectMake(677, 77, 347, 686)];
        [self.jamWebView setFrame:CGRectMake(5, 5, 337, 661)];
        //[analyticsTableView setFrame:ANALYTICS_TABLEVIEW_FRAME_LANDSCAPE];
    } else {
        [self.view setFrame:CGRectMake(0,0,[[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];
        //[self.jamWebView setFrame:CGRectMake(431, 0, 337, 1024)];
        [self.view setFrame:CGRectMake(421, 77, 347, 927)];
        [self.jamWebView setFrame:CGRectMake(5, 5, 337, 917)];
        //[analyticsTableView setFrame:ANALYTICS_TABLEVIEW_FRAME_PORTRAIT];
    }
    //[analyticsTableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)webView:(UIWebView *)wv shouldStartLoadWithRequest:(NSURLRequest *)rq
{
    NSLog(@"%@: webView:shouldStartLoadingWithRequest.", [self class]);
    [activityIndicator startAnimating];
    return YES;
}

- (void) webViewDidStartLoad:(UIWebView *)webView
{
    DLog(@"%@: inside webViewDidStartLoad.", [self class]);
    [activityIndicator startAnimating];
}

- (void) webViewDidFinishLoad:(UIWebView *)webView {
    
    NSLog(@"%@: webViewDidFinishLoad.", [self class]);
    
    [activityIndicator stopAnimating];
    [Global hideProgessIndicator];
    /**
     NSString *jsFile = @"https://jamsalesdemo8.successfactors.com/assets/widgets2.js?35247";
     NSLog(@"jsFile:  %@", jsFile);
     NSLog(@"jsFile pathExtension:  %@", [jsFile pathExtension]);
     NSBundle *bundle = [NSBundle mainBundle];
     
     NSLog(@"bundle resource path: %@", [bundle resourcePath]);
     NSLog(@"jsFilePath: %@", [bundle pathForResource:[jsFile stringByDeletingPathExtension] ofType:[jsFile pathExtension]]);
     
     NSString *jsFilePath = [[NSBundle mainBundle] pathForResource:[jsFile stringByDeletingPathExtension] ofType:[jsFile pathExtension]];
     NSURL *jsURL = [NSURL fileURLWithPath:jsFilePath];
     NSString *javascriptCode = [NSString stringWithContentsOfFile:jsURL.path encoding:NSUTF8StringEncoding error:nil];
     //UIWebView *wv = (UIWebView *) [self view];
     
     NSString *returnString = [[self webView] stringByEvaluatingJavaScriptFromString:javascriptCode];
     NSLog(@"returnString: %@", returnString);
     // ...
     **/
}

- (void)webView:(UIWebView *)wv didFailLoadWithError:(NSError *)error
{
    NSLog(@"%@: webViewDidFailLoadWithError.", [self class]);
    NSLog(@"Error: %@", error);
    [activityIndicator stopAnimating];
}


@end
