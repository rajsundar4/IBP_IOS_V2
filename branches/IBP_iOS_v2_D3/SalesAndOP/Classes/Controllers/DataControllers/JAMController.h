//
//  JAMController.h
//  S&OP
//
//  Created by Rick Thompson on 2/17/14.
//  Copyright (c) 2014 Linear Logics Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Foundation/NSHTTPCookieStorage.h>
#import "SDMRequestBuilder.h"
#import "Request.h"
#import "FormDataRequest.h"


@interface JAMController : NSObject
@property (strong, nonatomic, setter = setBaseServerURL:) NSString *baseServerURL;
@property (strong, nonatomic, setter = setAuthURL:) NSURL *authURL;
@property (strong, nonatomic) NSURL *baseJamURL;
@property (strong, nonatomic) NSURL *jamURL;
@property (strong, nonatomic) NSMutableArray *groups;
@property (strong, nonatomic) NSURL *collaboration_base_url;
@property (strong, nonatomic) NSString *user_id;
@property (strong, nonatomic) NSString *collaboration_user_mail;
@property (strong, nonatomic) NSString *company_id;
//  Flag to indicate that Jam server is available to this IBP instance
@property (assign, nonatomic) BOOL available;
//  Array holding dictionary structures with process step data
@property (strong, nonatomic) NSArray *collaborationServicesArray;
@property (strong,nonatomic) NSDate *collaborationServicesTimeStamp;


+ (JAMController *)sharedInstance;

- (void) retrieveCookies;
- (NSDictionary *) getJamCollaborationSessionAndReturnError:(__autoreleasing NSError **) aError;
- (NSDictionary *) getJamCollaborationRegistrationAndReturnError:(__autoreleasing NSError **) aError;
- (NSDictionary *) getJamCollaborationConfigAndReturnError:(__autoreleasing NSError **) aError;
- (void) sendAuthURLandReturnError:(__autoreleasing NSError **) aError;
- (void) getJamGroupsandReturnError:(__autoreleasing NSError **) aError;
- (NSURL *) buildJamUrl;
- (NSString *) callJamFeedWidgetAndReturnPage: (NSURL *) jamurl andReturnError: (__autoreleasing NSError **) aError;
- (BOOL) getJamCollaborationServicesAndReturnError:(__autoreleasing NSError **) aError;

@end
