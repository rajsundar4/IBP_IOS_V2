//
//  JAMController.m
//  S&OP
//
//  Created by Rick Thompson on 2/17/14.
//  Copyright (c) 2014 Linear Logics Corporation. All rights reserved.
//

#import "JAMController.h"

@implementation JAMController

@synthesize groups;
@synthesize collaborationServicesArray;
@synthesize collaborationServicesTimeStamp;

NSString * const kkJamCollaborationConfig = @"/sap/sop/sopfnd/services/collaboration/CollaborationServices.xsjs?objname=CollaborationConfig";
NSString * const kkJamCollaborationRegistration = @"/sap/sop/sopfnd/services/collaboration/CollaborationServices.xsjs?objname=CollaborationRegistration";
NSString * const kkJamCollaborationSession = @"/sap/sop/sopfnd/services/collaboration/CollaborationServices.xsjs?objname=CollaborationSession";
NSString * const kkJamGetGroups = @"/sap/sop/sopfnd/services/collaboration/CollaborationServices.xsjs?objname=Groups&action=getGroups";
NSString * const kkCollaborationServices = @"/sap/sop/sopfnd/services/collaboration/CollaborationServices.xsjs?objName=Instances&action=getOpenInstances";

/*!
 @function sharedDataInstance.
 @abstract -
 @discussion This method is used to create unique instance for JAMController.
 @param  nil.
 @result JAMController.
 */
+ (JAMController *)sharedInstance
{
    
    static JAMController *jamController;
    
    if(!jamController){
        
        jamController = [[JAMController alloc] init];
        
    }
    
    return jamController;
    
}

- (id) init
{
    self = [super init];
    if (self) {
        self.groups = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (NSDictionary *) jsonRequestWithUrl:(NSURL *) lUrl andHTTPMethod: (NSString *) httpMethod andReturnError: (__autoreleasing NSError **) aError
{
    DLog(@"Inside jsonRequestWithUrl:andHttpMethod:andReturnError function.");
    
    Request *sopRequest = [Request requestWithURL:lUrl];
    [sopRequest setRequestMethod:httpMethod];
    [sopRequest buildPostBody];
    [sopRequest buildRequestHeaders];
    [sopRequest startSynchronous];
    
    //NSLog(@"response cookies: %@", [sopRequest responseCookies]);
    //NSLog(@"response string: %@", [sopRequest responseString]);
    //NSLog(@"Response headers: %@", [sopRequest responseHeaders]);
    //NSLog(@"Response status code: %d", [sopRequest responseStatusCode]);
    //NSLog(@"Response status message: %@", [sopRequest responseStatusMessage]);
    //NSLog(@"Response data: %@", [sopRequest responseData]);
    
    // Check http response code for errors
    // Note:  Can receive 200 status but still receive no data!
    
    if ([sopRequest responseStatusCode] < 200 || [sopRequest responseStatusCode] >=300) {
        // Check to see that the error parameter was passed in
        if (aError != NULL) {
            // Insert code to populate NSError object
            NSError *returnError = [sopRequest error];
            *aError = [[NSError alloc] initWithDomain:[returnError domain] code:[returnError code] userInfo:[returnError userInfo]];
            //*aError = [[NSError alloc] initWithDomain:@"JSONCallError" code:[sopRequest responseStatusCode] userInfo:[sopRequest responseStatusMessage]];
        }
        return nil;
    }
    
    NSData *responseData = [NSData dataWithData:[sopRequest responseData]];
    NSError *jsonError = [[NSError alloc] init];
    NSDictionary *data = [NSJSONSerialization JSONObjectWithData: responseData options:NSJSONReadingMutableContainers error:&jsonError];
    
    //if (!data) {
    if ([jsonError code]) {
        if (aError != NULL) {
            // Insert code to populate NSError object
            *aError = [[NSError alloc] initWithDomain:[jsonError domain] code:[jsonError code] userInfo:[jsonError userInfo]];
        }
    }
    
    if ([data count] == 0) {
        // Check to see that the error parameter was passed in
        if (aError != NULL) {
            // Insert code to populate NSError object
            NSDictionary *errorDict = [[NSDictionary alloc] initWithObjectsAndKeys:@"No data returned from json call.", @"jsonError", nil];
            *aError = [[NSError alloc] initWithDomain:@"jsonRequestWithUrl" code:100 userInfo:errorDict];
        }
    }
    
    DLog(@"In jsonRequestWithUrl-data: %@", data);
    
    return data;
}


- (void) retrieveCookies
{
    NSArray *cookies;
    NSDictionary *cookieHeaders;
    
    cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    cookieHeaders = [NSHTTPCookie requestHeaderFieldsWithCookies:cookies];
    
    NSLog(@"cookies: %@", cookieHeaders);
}

- (NSString *) callJamFeedWidgetAndReturnPage: (NSURL *) jamurl andReturnError: (__autoreleasing NSError **) aError
{
    
    DLog(@"Inside callJamFeedWidgetAndReturnPage function.");
    
    Request *sopRequest = [Request requestWithURL:jamurl];
    [sopRequest setRequestMethod:@"GET"];
    [sopRequest buildPostBody];
    [sopRequest buildRequestHeaders];
    [sopRequest startSynchronous];
    
    //NSLog(@"response cookies: %@", [sopRequest responseCookies]);
    //NSLog(@"response string: %@", [sopRequest responseString]);
    //NSLog(@"Response headers: %@", [sopRequest responseHeaders]);
    //NSLog(@"Response status code: %d", [sopRequest responseStatusCode]);
    //NSLog(@"Response status message: %@", [sopRequest responseStatusMessage]);
    //NSLog(@"Response data: %@", [sopRequest responseData]);
    
    // Check http response code for errors
    // Note:  Can receive 200 status but still receive no data!
    
    if ([sopRequest responseStatusCode] < 200 || [sopRequest responseStatusCode] >=300) {
        // Check to see that the error parameter was passed in
        if (aError != NULL) {
            // Insert code to populate NSError object
            NSError *returnError = [sopRequest error];
            *aError = [[NSError alloc] initWithDomain:[returnError domain] code:[returnError code] userInfo:[returnError userInfo]];
            //*aError = [[NSError alloc] initWithDomain:@"JSONCallError" code:[sopRequest responseStatusCode] userInfo:[sopRequest responseStatusMessage]];
        }
        return nil;
    }

    return [sopRequest responseString];
}

- (NSURL *) buildJamUrl
{
    //     NSURL *jamURL = [NSURL URLWithString:@"https://jamsalesdemo8.successfactors.com/c/JAM097.com/widget/v1/feed?wid=1$auth=session&skin=jam&faces=true&type=group&num_items=30&avatar=false&live_update=false&mobile=false&post_mode=inline&reply_mode=inline&group_id=18351,%2018354,%2018353,%2018350,%2018352"];
    NSString *jamurl = [NSString stringWithFormat:@"%@/c/%@/widget/v1/feed?wid=1$auth=session&skin=jam&faces=true&type=group&num_items=30&avatar=false&live_update=false&mobile=false&post_mode=inline&reply_mode=inline&group_id=", self.baseJamURL, self.company_id];
    
    for (NSDictionary *groupDictionary in self.groups) {
        jamurl = [jamurl stringByAppendingFormat:@"%@,", [groupDictionary objectForKey:@"id"]];
    }
    NSCharacterSet *charSetComma = [NSCharacterSet characterSetWithCharactersInString:@","];
    NSString *jamurl2 = [jamurl stringByTrimmingCharactersInSet:charSetComma];
    self.jamURL = [NSURL URLWithString:jamurl2];
    return self.jamURL;
}

- (void) getJamGroupsandReturnError:(__autoreleasing NSError **) aError
{
    DLog(@"Inside getJamGroupsReturnError function.");
    NSString *serverURL = [NSString stringWithFormat:@"%@%@", self.baseServerURL, kkJamGetGroups];
    NSError *returnError;
    NSDictionary *data = [self jsonRequestWithUrl:[NSURL URLWithString: serverURL] andHTTPMethod:@"GET" andReturnError:&returnError];
    
    NSString *body = [data objectForKey:@"body"];
    NSLog(@"body: %@", body);
    NSCharacterSet *charSet = [NSCharacterSet characterSetWithCharactersInString:@"{}"];
    NSArray *parsedArray = [body componentsSeparatedByCharactersInSet:charSet];
    
    for (NSString *tstring in parsedArray) {
        NSLog(@"tstring:  %@", tstring);
        if ([tstring isEqualToString:@"["] || [tstring isEqualToString:@"]"] || [tstring isEqualToString:@","])
            continue;
        NSCharacterSet *charSet = [NSCharacterSet characterSetWithCharactersInString:@","];
        NSArray *parsedArray2 = [tstring componentsSeparatedByCharactersInSet:charSet];
        NSLog(@"parsedArray2 count: %d, data: %@", [parsedArray2 count], parsedArray2);
        NSMutableDictionary *tempDict = [[NSMutableDictionary alloc] init];
        for (NSString *tstring2 in parsedArray2) {
            NSLog(@"tstring2:  %@", tstring2);
            NSCharacterSet *charSet = [NSCharacterSet characterSetWithCharactersInString:@":"];
            NSArray *parsedArray3 = [tstring2 componentsSeparatedByCharactersInSet:charSet];
            NSLog(@"parsedArray3 count: %d, data: %@", [parsedArray3 count], parsedArray3);
            NSString *key = [parsedArray3 objectAtIndex:0];
            NSCharacterSet *charSetQuote = [NSCharacterSet characterSetWithCharactersInString:@"\""];
            NSString *key2 = [key stringByTrimmingCharactersInSet:charSetQuote];
            NSString *value = [parsedArray3 objectAtIndex:1];
            NSString *value2 = [value stringByTrimmingCharactersInSet:charSetQuote];
            [tempDict setValue:value2 forKey:key2];
        }
        [groups addObject:tempDict];
    }
    NSLog(@" groupArray count: %d, data: %@", [groups count], groups);
    
}

- (BOOL) getJamCollaborationServicesAndReturnError:(__autoreleasing NSError **) aError
{
    DLog(@"Inside getJamCollaborationServicesAndReturnError function.");
    NSError *returnError;
    NSString *serverURL = [NSString stringWithFormat:@"%@%@", self.baseServerURL, kkCollaborationServices];
    NSDictionary *returnedData = [self jsonRequestWithUrl:[NSURL URLWithString: serverURL] andHTTPMethod:@"GET" andReturnError:&returnError];
    
    //  Check for errors
    //  return the NSArray with process steps
    if (!returnError) {
        //NSArray *tempArray = [returnedData objectForKey:@"body"];
        collaborationServicesArray = [returnedData objectForKey:@"body"];
        collaborationServicesTimeStamp = [NSDate date];
        return YES;
    } else {
        DLog(@"Error in getJamCollaborationServices:  %@", returnError);
        return NO;
    }
    
}

- (NSDictionary *) getJamCollaborationConfigAndReturnError:(__autoreleasing NSError **) aError
{
    DLog(@"Inside getJamCollaborationConfigandReturnError function.");
    NSError *returnError;
    NSString *serverURL = [NSString stringWithFormat:@"%@%@", self.baseServerURL, kkJamCollaborationConfig];
    NSDictionary *returnedData = [self jsonRequestWithUrl:[NSURL URLWithString: serverURL] andHTTPMethod:@"GET" andReturnError:&returnError];
    
    //NSString *body = [[NSString alloc] init];
    NSString *body = [NSString  stringWithFormat:@"%@",[returnedData valueForKey:@"body"]];
    NSLog(@"body:  %@", body);
    NSCharacterSet *charSet = [NSCharacterSet characterSetWithCharactersInString:@"{}"];
    NSString *body2 = [body stringByTrimmingCharactersInSet:charSet];
    charSet = [NSCharacterSet characterSetWithCharactersInString:@";"];
    NSArray *parsedArray = [body2 componentsSeparatedByCharactersInSet:charSet];

    for (NSString *tstring in parsedArray) {
        NSLog(@"tstring:  %@", tstring);
        //NSCharacterSet *charSet = [NSCharacterSet characterSetWithCharactersInString:@"{}\n"];
        //NSArray *parsedArray2 = [body2 componentsSeparatedByCharactersInSet:charSet];
        //NSLog(@"parsedArray2: %@", parsedArray2);
        
        charSet = [NSCharacterSet characterSetWithCharactersInString:@"="];
        NSArray *parsedArray2 = [tstring componentsSeparatedByCharactersInSet:charSet];
        NSCharacterSet *charSet = [NSCharacterSet characterSetWithCharactersInString:@" \"\n"];
        NSString *key = [(NSString *) [parsedArray2 objectAtIndex:0] stringByTrimmingCharactersInSet:charSet];
        NSString *value = [(NSString *) [parsedArray2 objectAtIndex:1] stringByTrimmingCharactersInSet:charSet];
        
        NSLog(@"key: %@, value: %@", key, value);
        if ([key isEqualToString:@"COMPANY_ID"]) {
            self.company_id = value;
            break;
        }


    }
    
    
    //self.company_id = [data objectForKey:@"company_id"];
    return returnedData;
}

- (NSDictionary *) getJamCollaborationRegistrationAndReturnError:(__autoreleasing NSError **) aError
{
    DLog(@"Inside getJamCollaborationRegistrationandReturnError function.");
    NSString *serverURL = [NSString stringWithFormat:@"%@%@", self.baseServerURL, kkJamCollaborationRegistration];
    NSError *returnError;
    NSDictionary *data = [self jsonRequestWithUrl:[NSURL URLWithString:serverURL] andHTTPMethod:@"GET" andReturnError:&returnError];
    NSLog(@"error:  %@", returnError);
    /**
    NSString *body = [data objectForKey:@"body"];
    NSLog(@"body:  %@", body);
    NSCharacterSet *charSet = [NSCharacterSet characterSetWithCharactersInString:@";"];
    NSArray *parsedArray = [body componentsSeparatedByCharactersInSet:charSet];
    
    for (NSString *tstring in parsedArray) {
        NSLog(@"tstring:  %@", tstring);
    }
    **/
    return data;
}

- (NSDictionary *) getJamCollaborationSessionAndReturnError:(__autoreleasing NSError **) aError
{
    DLog(@"Inside getJamCollaborationSessionandReturnError function.");
    NSString *serverURL = [NSString stringWithFormat:@"%@%@", self.baseServerURL, kkJamCollaborationSession];
    NSDictionary *data = [self jsonRequestWithUrl:[NSURL URLWithString:serverURL] andHTTPMethod:@"POST" andReturnError:aError];
    
    NSString *bodyRaw = [data objectForKey:@"body"];
    NSLog(@"bodyRaw: %@", bodyRaw);
    
    if (bodyRaw != nil) {
        self.available = YES;
        
        NSArray *bodyComponents = [bodyRaw componentsSeparatedByString:@","];
        NSLog(@"bodyComponents count: %d, components: %@", [bodyComponents count], bodyComponents);
        
        NSDataDetector *detector1 = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink error:nil];
        NSArray *matches = [detector1 matchesInString:[bodyComponents objectAtIndex:0] options:0 range:NSMakeRange(0, [[bodyComponents objectAtIndex:0] length] )];
        NSLog(@"matches count: %d, data: %@", [matches count], matches);
        NSURL *authUrl = [[matches objectAtIndex:0] URL];
        NSLog(@"url:  %@", authUrl);
        [self setAuthURL:authUrl];
        //self.baseJamURL = [authUrl standardizedURL];
        //NSLog(@"scheme: %@, host: %@, port: %@", [authUrl scheme], [authUrl host], [authUrl port]);
        self.baseJamURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@://%@:%@", [authUrl scheme], [authUrl host], [authUrl port]]];
    } else {
        self.available = NO;
    }
    return data;
}

- (void) sendAuthURLandReturnError:(__autoreleasing NSError **) aError
{
    DLog(@"Inside getJamCollaborationSessionandReturnError function.");
    [self jsonRequestWithUrl:[self authURL] andHTTPMethod:@"GET" andReturnError:aError];
    
}


/*!
 @function setBaseServerUrl:
 @abstract -
 @discussion This method is used to get Charts(Report Views) for seleted planning area.
 @param  arg_serverText - Server textfield text from ConfigureViewController.
 @result nil.
 */
/**
- (void)setBaseServerUrl: NSString *
{
    
    [self setBaseServerURL:[[NSUserDefaults standardUserDefaults] valueForKey:kSaveServerUrlMannualy]];
}
**/

@end
