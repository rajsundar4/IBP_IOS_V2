/*
  
 File: SDMConnectivityHelperDelegate.h
 Abstract: A delegate used by SDMConnectivityHelper to allow customization
 of the HTTP request object before sending the request to the server.
  
*/


#import <Foundation/Foundation.h>
#import "SDMRequesting.h"
#import "Requesting.h"

/**
 A delegate used by SDMConnectivityHelper to allow customization
 of the HTTP request object before sending the request to the server.
*/
@protocol SDMConnectivityHelperDelegate <NSObject>

/**
 Provides a reference to the HTTP request object before sending the request to the server.
 @param request A reference to the request object (which is an <SDMRequesting> compliant object).
*/
- (void)onBeforeSend:(id <Requesting>)request;

@end
