/*
 
 File: SDMConnectivityHelper.h
 Abstract: A helper class that helps with making OData requests to the server.
 
 */


#import <Foundation/Foundation.h>
#import "ODataQuery.h"
#import "CSRFData.h"
#import "MediaLink.h"

// SAP OData Mobile SDK Imports
#import "SDMConnectivityHelperDelegate.h"
#import "SDMHttpRequestDelegate.h"
#import "ODataEntry.h"
#import "ODataServiceDocument.h"
#import "RequestDelegate.h"


/**
 A helper class that helps with making OData requests to the server.
 */
@interface SDMConnectivityHelper : NSObject

#pragma mark - Execute OData query synchronously

/**
 A helper method that executes an OData query synchronously.
 @param aQuery The OData query to execute.
 @return <SDMRequesting> compliant object.
 */
- (id <Requesting>)executeBasicSyncRequestWithQuery:(ODataQuery *)aQuery;

/**
 A helper method that executes an OData query synchronously.
 @param aQuery The OData query to execute.
 @param aBody The request body.
 @param aHttpMethod The HTTP method to use in this request.
 @param aCSRFData Object containing the CSRF cookie and token.
 @return <SDMRequesting> compliant object.
 */
- (id <Requesting>)executeBasicSyncRequestWithQuery:(ODataQuery *)aQuery andBody:(NSString *)aBody andMethod:(NSString *)aHttpMethod andCSRFData:(CSRFData *)aCSRFData;

/**
 A helper method that executes an OData query synchronously.
 @param aQuery The OData query to execute.
 @param aBody The request body.
 @param aHttpMethod The HTTP method to use in this request.
 @param aCSRFData Object containing the CSRF cookie and token.
 @param aRequestHeaders The dictionary that contain the request header parameters (optional, may be nil).
 @return <SDMRequesting> compliant object.
 */

- (id <Requesting>)executeBasicSyncRequestWithQuery:(ODataQuery *)aQuery andBody:(NSString *)aBody andMethod:(NSString *)aHttpMethod andCSRFData:(CSRFData *)aCSRFData andRequestHeaders:(NSDictionary *)aRequestHeaders;

/**
 A helper method that executes an OData Create query synchronously.
 @param aQuery The OData query to execute.
 @param aBody The post body.
 @param aCSRFData Object containing the CSRF cookie and token.
 @return <SDMRequesting> compliant object.
 */
- (id <Requesting>)executeCreateSyncRequestWithQuery:(ODataQuery *)aQuery andBody:(NSString *)aBody andCSRFData:(CSRFData *)aCSRFData;

/**
 A helper method that executes an OData Update query synchronously.
 @param aQuery The OData query to execute.
 @param aBody The post body.
 @param aCSRFData Object containing the CSRF cookie and token.
 @param aEtag the etag that is sent in the request header (optional, may be nil).
 @return <SDMRequesting> compliant object.
 */
- (id <Requesting>)executeUpdateSyncRequestWithQuery:(ODataQuery *)aQuery andBody:(NSString *)aBody andCSRFData:(CSRFData *)aCSRFData andEtag:(NSString *)aEtag;

/**
 A helper method that executes an OData Delete query synchronously.
 @param aQuery The OData query to execute.
 @param aCSRFData Object containing the CSRF cookie and token.
 @param aEtag the etag that is sent in the request header (optional, may be nil).
 @return <SDMRequesting> compliant object.
 */
- (id <Requesting>)executeDeleteSyncRequestWithQuery:(ODataQuery *)aQuery andCSRFData:(CSRFData *)aCSRFData andEtag:(NSString *)aEtag;

/**
 A helper method that creates an OData media link synchronously.
 @param aMediaLink The media link object to create.
 @param aBody The post body data.
 @param aCSRFData Object containing the CSRF cookie and token.
 @return <SDMRequesting> compliant object.
 */
- (id <Requesting>)executeCreateMediaLinkSyncRequest:(MediaLink *)aMediaLink andBody:(NSMutableData *)aBody andCSRFData:(CSRFData *)aCSRFData;

/**
 A helper method that updates an OData media link synchronously.
 @param aMediaLink The media link object to execute.
 @param aBody The request body data.
 @param aCSRFData Object containing the CSRF cookie and token.
 @return <SDMRequesting> compliant object.
 */
- (id <Requesting>)executeUpdateMediaLinkSyncRequest:(MediaLink *)aMediaLink andBody:(NSMutableData *)aBody andCSRFData:(CSRFData *)aCSRFData;

/**
 A helper method that deletes an OData media link synchronously.
 @param aMediaLink The media link object to execute.
 @param aCSRFData Object containing the CSRF cookie and token.
 @return <SDMRequesting> compliant object.
 */
- (id <Requesting>)executeDeleteMediaLinkSyncRequest:(MediaLink *)aMediaLink andCSRFData:(CSRFData *)aCSRFData;

#pragma mark - Execute OData query asynchronously

/**
 A helper method that executes an OData query asynchronously.
 @param aQuery The OData query to execute.
 @param aDelegate A delegate to an SDMHttpRequestDelegate object that will handle the response.
 */
- (void)executeBasicAsyncRequestWithQuery:(ODataQuery *)aQuery andRequestDelegate:(__weak id<RequestDelegate>)aDelegate;

/**
 A helper method that executes an OData query asynchronously.
 @param aQuery The OData query to execute.
 @param aBody The request body.
 @param aHttpMethod The HTTP method to use in this request.
 @param aCSRFData Object containing the CSRF cookie and token.
 @param aDelegate A delegate to an SDMHttpRequestDelegate object that will handle the response.
 */
- (void)executeBasicAsyncRequestWithQuery:(ODataQuery *)aQuery andBody:(NSString *)aBody andMethod:(NSString *)aHttpMethod andCSRFData:(CSRFData *)aCSRFData andRequestDelegate:(__weak id <RequestDelegate>)aDelegate;

/**
 A helper method that executes an OData query asynchronously,
 with an option to define a specified selector for handling successfully received response,
 and a userInfo dictionary for custom information associated with the request.
 @param aQuery The OData query to execute.
 @param aDelegate A delegate to an SDMHttpRequestDelegate object that will handle the response.
 @param aFinishSelector A selector to a method that will handle the successfully received response (optional, may be nil).
 @param aUserInfo A userInfo dictionary with custom information associated with the request and can be used in method handling the response (optional, may be nil).
 */
- (void)executeBasicAsyncRequestWithQuery:(ODataQuery *)aQuery andRequestDelegate:(__weak id<RequestDelegate>)aDelegate andDidFinishSelector:(SEL)aFinishSelector andUserInfo:(NSDictionary *)aUserInfo;

/**
 A helper method that executes an OData query asynchronously,
 with an option to define a specified selector for handling successfully received response,
 and a userInfo dictionary for custom information associated with the request.
 @param aQuery The OData query to execute.
 @param aBody The request body.
 @param aHttpMethod The HTTP method to use in this request.
 @param aCSRFData Object containing the CSRF cookie and token.
 @param aDelegate A delegate to an SDMHttpRequestDelegate object that will handle the response.
 @param aFinishSelector A selector to a method that will handle the successfully received response (optional, may be nil).
 @param aUserInfo A userInfo dictionary with custom information associated with the request and can be used in method handling the response (optional, may be nil).
 */
- (void)executeBasicAsyncRequestWithQuery:(ODataQuery *)aQuery andBody:(NSString *)aBody andMethod:(NSString *)aHttpMethod andCSRFData:(CSRFData *)aCSRFData andRequestDelegate:(__weak id<RequestDelegate>)aDelegate andDidFinishSelector:(SEL)aFinishSelector andUserInfo:(NSDictionary *)aUserInfo ;

/**
 A helper method that executes an OData query asynchronously,
 with an option to define a specified selector for handling successfully received response,
 and a userInfo dictionary for custom information associated with the request.
 @param aQuery The OData query to execute.
 @param aBody The request body.
 @param aHttpMethod The HTTP method to use in this request.
 @param aCSRFData Object containing the CSRF cookie and token.
 @param aDelegate A delegate to an SDMHttpRequestDelegate object that will handle the response.
 @param aFinishSelector A selector to a method that will handle the successfully received response (optional, may be nil).
 @param aUserInfo A userInfo dictionary with custom information associated with the request and can be used in method handling the response (optional, may be nil).
 @param aRequestHeaders The dictionary that contain the request header parameters (optional, may be nil).
 */
- (void)executeBasicAsyncRequestWithQuery:(ODataQuery *)aQuery andBody:(NSString *)aBody andMethod:(NSString *)aHttpMethod andCSRFData:(CSRFData *)aCSRFData andRequestDelegate:(__weak id <RequestDelegate>)aDelegate andDidFinishSelector:(SEL)aFinishSelector andUserInfo:(NSDictionary *)aUserInfo andRequestHeaders:(NSDictionary *)aRequestHeaders;

/**
 A helper method that executes an OData Create query asynchronously.
 @param aQuery The OData query to execute.
 @param aBody The post body.
 @param aCSRFData Object containing the CSRF cookie and token.
 @param aDelegate A delegate to an SDMHttpRequestDelegate object that will handle the response.
 @param aFinishSelector A selector to a method that will handle the successfully received response (optional, may be nil).
 @param aUserInfo A userInfo dictionary with custom information associated with the request and can be used in method handling the response (optional, may be nil).
 */
- (void)executeCreateAsyncRequestWithQuery:(ODataQuery *)aQuery andBody:(NSString *)aBody andCSRFData:(CSRFData *)aCSRFData andRequestDelegate:(__weak id<RequestDelegate>)aDelegate andDidFinishSelector:(SEL)aFinishSelector andUserInfo:(NSDictionary *)aUserInfo;

/**
 A helper method that executes an OData Update query asynchronously.
 @param aQuery The OData query to execute.
 @param aBody The post body.
 @param aCSRFData Object containing the CSRF cookie and token.
 @param aDelegate A delegate to an SDMHttpRequestDelegate object that will handle the response.
 @param aFinishSelector A selector to a method that will handle the successfully received response (optional, may be nil).
 @param aUserInfo A userInfo dictionary with custom information associated with the request and can be used in method handling the response (optional, may be nil).
 @param aEtag the etag that is sent in the request header (optional, may be nil).
 */
- (void)executeUpdateAsyncRequestWithQuery:(ODataQuery *)aQuery andBody:(NSString *)aBody andCSRFData:(CSRFData *)aCSRFData andRequestDelegate:(__weak id <RequestDelegate>)aDelegate andDidFinishSelector:(SEL)aFinishSelector andUserInfo:(NSDictionary *)aUserInfo andEtag:(NSString *)aEtag;

/**
 A helper method that executes an OData Delete query asynchronously.
 @param aQuery The OData query to execute.
 @param aCSRFData Object containing the CSRF cookie and token.
 @param aDelegate A delegate to an SDMHttpRequestDelegate object that will handle the response.
 @param aFinishSelector A selector to a method that will handle the successfully received response (optional, may be nil).
 @param aUserInfo A userInfo dictionary with custom information associated with the request and can be used in method handling the response (optional, may be nil).
 @param aEtag the etag that is sent in the request header (optional, may be nil).
 */
- (void)executeDeleteAsyncRequestWithQuery:(ODataQuery *)aQuery andCSRFData:(CSRFData *)aCSRFData andRequestDelegate:(__weak id <RequestDelegate>)aDelegate andDidFinishSelector:(SEL)aFinishSelector andUserInfo:(NSDictionary *)aUserInfo andEtag:(NSString *)aEtag;

/**
 A helper method that creates an OData media link asynchronously.
 @param aMediaLink The media link object to create.
 @param aBody The post body data.
 @param aCSRFData Object containing the CSRF cookie and token.
 @param aDelegate A delegate to an SDMHttpRequestDelegate object that will handle the response.
 @param aFinishSelector A selector to a method that will handle the successfully received response (optional, may be nil).
 @param aUserInfo A userInfo dictionary with custom information associated with the request and can be used in method handling the response (optional, may be nil).
 */
- (void)executeCreateMediaLinkAsyncRequest:(MediaLink *)aMediaLink andBody:(NSMutableData *)aBody andCSRFData:(CSRFData *)aCSRFData andRequestDelegate:(__weak id <RequestDelegate>)aDelegate andDidFinishSelector:(SEL)aFinishSelector andUserInfo:(NSDictionary *)aUserInfo;

/**
 A helper method that updates an OData media link asynchronously.
 @param aMediaLink The media link object to update.
 @param aBody The request body data.
 @param aCSRFData Object containing the CSRF cookie and token.
 @param aDelegate A delegate to an SDMHttpRequestDelegate object that will handle the response.
 @param aFinishSelector A selector to a method that will handle the successfully received response (optional, may be nil).
 @param aUserInfo A userInfo dictionary with custom information associated with the request and can be used in method handling the response (optional, may be nil).
 */
- (void)executeUpdateMediaLinkAsyncRequest:(MediaLink *)aMediaLink andBody:(NSMutableData *)aBody andCSRFData:(CSRFData *)aCSRFData andRequestDelegate:(__weak id <RequestDelegate>)aDelegate andDidFinishSelector:(SEL)aFinishSelector andUserInfo:(NSDictionary *)aUserInfo;

/**
 A helper method that deletes an OData media link asynchronously.
 @param aMediaLink The media link object to create.
 @param aCSRFData Object containing the CSRF cookie and token.
 @param aDelegate A delegate to an SDMHttpRequestDelegate object that will handle the response.
 @param aFinishSelector A selector to a method that will handle the successfully received response (optional, may be nil).
 @param aUserInfo A userInfo dictionary with custom information associated with the request and can be used in method handling the response (optional, may be nil).
 */
- (void)executeDeleteMediaLinkAsyncRequest:(MediaLink *)aMediaLink andCSRFData:(CSRFData *)aCSRFData andRequestDelegate:(__weak id <RequestDelegate>)aDelegate andDidFinishSelector:(SEL)aFinishSelector andUserInfo:(NSDictionary *)aUserInfo;

#pragma mark - CSRF helper methods

/**
 A Helper method to get X-CSRF token.
 This is needed for POST requests.
 @param aServiceQuery to the service document (use serviceDocumentQuery property of your service proxy object).
 @return CSRFData containing the CSRF cookie and token.
 */
- (CSRFData *)getCSRFDataForServiceQuery:(ODataQuery *)aServiceQuery;

/**
 A Helper method to add X-CSRF token to the request.
 This is needed for POST requests.
 @param aRequest The request object to which the X-CSRF token will be added.
 @param aServiceQuery to the service document (use serviceDocumentQuery property of your service proxy object).
 */
- (void)addCSRFDataToRequest:(id <Requesting>)aRequest andServiceQuery:(ODataQuery *)aServiceQuery;

#pragma mark

@property (strong, nonatomic) NSString *sapClient; ///< The SAP client to connect to.
@property (weak, nonatomic) id <SDMConnectivityHelperDelegate> delegate; ///< A delegate to an SDMConnectivityHelperDelegate object that will allow the HTTP request object customization before sending it to the server.

@end
