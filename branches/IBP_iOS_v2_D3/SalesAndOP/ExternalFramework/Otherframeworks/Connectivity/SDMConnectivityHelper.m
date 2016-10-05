/*
 
 File: SDMConnectivityHelper.m
 Abstract: A helper class that helps with making OData requests to the server.
 
 */


#import "SDMConnectivityHelper.h"
#import "RequestBuilder.h"
#import "SDMHttpRequest.h"
#import "SDMRequesting.h"
#import "Logger.h"
#import "Request.h"
#import "Requesting.h"
#import "ConnectivitySettings.h"

#define X_CSRF_TOKEN @"X-CSRF-TOKEN"
#define SAP_XSRF_COOKIE_PREFIX @"sap-XSRF_"
#define SAP_SESSION_ID_COOKIE_PREFIX @"SAP_SESSIONID_"
#define DATA_SERVICE_VERSION @"2.0"
#define IF_MATCH @"If-Match"

@implementation SDMConnectivityHelper

#pragma mark - Private methods

- (void)onBeforeRequestCall:(id <Requesting>)aRequest
{
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(onBeforeSend:)]) {
        [self.delegate onBeforeSend:aRequest];
    }
}

- (id <Requesting>)createRequestWithQuery:(ODataQuery *)aQuery
{
    if ([ConnectivitySettings isSUPMode]) {
        [RequestBuilder setRequestType:ODPRequestType];
    }
    else{
        [RequestBuilder setRequestType:HTTPRequestType];
    }
    id <Requesting> request = [RequestBuilder requestWithURL:aQuery.URL];

    if ([self.sapClient length] > 0) {
        [request addRequestHeader:@"sap-client" value:self.sapClient];
    }
    //add the supported OData version
    [request addRequestHeader:@"DataServiceVersion" value:DATA_SERVICE_VERSION];
    
    request.shouldRedirect = YES;
    request.shouldUseRFC2616RedirectBehaviour = NO;
    request.shouldPresentCredentialsBeforeChallenge = NO;
    
#if TARGET_IPHONE_SIMULATOR
    request.validatesSecureCertificate = NO;
#endif
    
    return request;
}

- (void)addCSRFDataToRequest:(id <Requesting>)request withCSRFData:(CSRFData *)aCSRFData
{
	if (aCSRFData) {
        [request addRequestHeader:X_CSRF_TOKEN value:aCSRFData.token];
        if ([ConnectivitySettings isSUPMode]) {
            [request addRequestHeader:@"Cookie" value:aCSRFData.cookies];
        }
        else {
            [[request requestCookies] addObject:aCSRFData.cookie];
        }
    }
	else
	{
		NSString *method = request.requestMethod;
		if (![method isEqualToString:@"GET"]) {
			[request addRequestHeader:@"X-Requested-With" value:@"XMLHttpRequest"];
		}
	}
}

- (id <Requesting>)createRequestWithQuery:(ODataQuery *)aQuery andBody:(NSString *)aBody andMethod:(NSString *)aHttpMethod andCSRFData:(CSRFData *)aCSRFData
{
    id <Requesting> request = [self createRequestWithQuery:aQuery];
    request.requestMethod = aHttpMethod;
    if (aBody.length > 0) {
        [request addRequestHeader:@"Content-Type" value:@"application/atom+xml"];
        NSMutableData *bodyData = [NSMutableData dataWithData:[aBody dataUsingEncoding:NSUTF8StringEncoding]];
        request.postBody = bodyData;
    }
    [self addCSRFDataToRequest:request withCSRFData:aCSRFData];
    return request;
}

- (NSString *)createLogMessageForRequest:(id <Requesting>)request sync:(BOOL)isSync
{
    NSString *url = [[request url] absoluteString];
    NSString *syncOption = isSync ? @"sync" : @"async";
    return [NSString stringWithFormat:@"Send HTTP %@ %@ request: %@", request.requestMethod, syncOption, url];
}

#pragma mark - Execute Basic Request methods

- (id <Requesting>)executeBasicSyncRequestWithQuery:(ODataQuery *)aQuery
{
    id <Requesting> request = [self createRequestWithQuery:aQuery];
    [self onBeforeRequestCall:request];
    NSString *msg = [self createLogMessageForRequest:request sync:YES];
    LOGNOTICE(msg);
    [request startSynchronous];
    return request;
}

- (id <Requesting>)executeBasicSyncRequestWithQuery:(ODataQuery *)aQuery andBody:(NSString *)aBody andMethod:(NSString *)aHttpMethod andCSRFData:(CSRFData *)aCSRFData
{
    id <Requesting> request = [self createRequestWithQuery:aQuery andBody:aBody andMethod:aHttpMethod andCSRFData:aCSRFData];
    [self onBeforeRequestCall:request];
    NSString *msg = [self createLogMessageForRequest:request sync:YES];
    LOGNOTICE(msg);
    [request startSynchronous];
    return request;
}

- (id <Requesting>)executeBasicSyncRequestWithQuery:(ODataQuery *)aQuery andBody:(NSString *)aBody andMethod:(NSString *)aHttpMethod andCSRFData:(CSRFData *)aCSRFData andRequestHeaders:(NSDictionary *)aRequestHeaders
{
    id <Requesting> request = [self createRequestWithQuery:aQuery andBody:aBody andMethod:aHttpMethod andCSRFData:aCSRFData];
    [self onBeforeRequestCall:request];
    NSString *msg = [self createLogMessageForRequest:request sync:YES];
    LOGNOTICE(msg);
    if (aRequestHeaders){
        [[request requestHeaders] addEntriesFromDictionary:aRequestHeaders];
    }
    
    [request startSynchronous];
    return request;
}

- (void)executeBasicAsyncRequestWithQuery:(ODataQuery *)aQuery andRequestDelegate:(__weak id <RequestDelegate>)aDelegate
{
    id <Requesting> request = [self createRequestWithQuery:aQuery];
    [request setDelegate:aDelegate];
    [self onBeforeRequestCall:request];
    NSString *msg = [self createLogMessageForRequest:request sync:NO];
    LOGNOTICE(msg);
    [request startAsynchronous];
}

- (void)executeBasicAsyncRequestWithQuery:(ODataQuery *)aQuery andBody:(NSString *)aBody andMethod:(NSString *)aHttpMethod andCSRFData:(CSRFData *)aCSRFData andRequestDelegate:(__weak id <RequestDelegate>)aDelegate
{
    id <Requesting> request = [self createRequestWithQuery:aQuery andBody:aBody andMethod:aHttpMethod andCSRFData:aCSRFData];
    [request setDelegate:aDelegate];
    [self onBeforeRequestCall:request];
    NSString *msg = [self createLogMessageForRequest:request sync:NO];
    LOGNOTICE(msg);
    [request startAsynchronous];
}

- (void)executeBasicAsyncRequestWithQuery:(ODataQuery *)aQuery andRequestDelegate:(__weak id <RequestDelegate>)aDelegate andDidFinishSelector:(SEL)aFinishSelector andUserInfo:(NSDictionary *)aUserInfo
{
    id <Requesting> request = [self createRequestWithQuery:aQuery];
    [request setDelegate:aDelegate];
    if (aFinishSelector) {
        request.didFinishSelector = aFinishSelector;
    }
    if (aUserInfo) {
        request.userInfo = aUserInfo;
    }
    [self onBeforeRequestCall:request];
    NSString *msg = [self createLogMessageForRequest:request sync:NO];
    LOGNOTICE(msg);
    [request startAsynchronous];
}

- (void)executeBasicAsyncRequestWithQuery:(ODataQuery *)aQuery andBody:(NSString *)aBody andMethod:(NSString *)aHttpMethod andCSRFData:(CSRFData *)aCSRFData andRequestDelegate:(__weak id <RequestDelegate>)aDelegate andDidFinishSelector:(SEL)aFinishSelector andUserInfo:(NSDictionary *)aUserInfo
{
    id <Requesting> request = [self createRequestWithQuery:aQuery andBody:aBody andMethod:aHttpMethod andCSRFData:aCSRFData];
    [request setDelegate:aDelegate];
    if (aFinishSelector) {
        request.didFinishSelector = aFinishSelector;
    }
    if (aUserInfo) {
        request.userInfo = aUserInfo;
    }
    [self onBeforeRequestCall:request];
    NSString *msg = [self createLogMessageForRequest:request sync:NO];
    LOGNOTICE(msg);
    [request startAsynchronous];
}

- (void)executeBasicAsyncRequestWithQuery:(ODataQuery *)aQuery andBody:(NSString *)aBody andMethod:(NSString *)aHttpMethod andCSRFData:(CSRFData *)aCSRFData andRequestDelegate:(__weak id <RequestDelegate>)aDelegate andDidFinishSelector:(SEL)aFinishSelector andUserInfo:(NSDictionary *)aUserInfo andRequestHeaders:(NSDictionary *)aRequestHeaders
{
    id <Requesting> request = [self createRequestWithQuery:aQuery andBody:aBody andMethod:aHttpMethod andCSRFData:aCSRFData];
    [request setDelegate:aDelegate];
    if (aFinishSelector) {
        request.didFinishSelector = aFinishSelector;
    }
    
    if (aRequestHeaders){
        [[request requestHeaders] addEntriesFromDictionary:aRequestHeaders];
    }
    
    if (aUserInfo) {
        request.userInfo = aUserInfo;
    }
    
    [self onBeforeRequestCall:request];
    NSString *msg = [self createLogMessageForRequest:request sync:NO];
    LOGNOTICE(msg);
    [request startAsynchronous];
}

#pragma mark - Execute Create / Update / Delete Request methods

- (id <Requesting>)executeCreateSyncRequestWithQuery:(ODataQuery *)aQuery andBody:(NSString *)aBody andCSRFData:(CSRFData *)aCSRFData
{
    return [self executeBasicSyncRequestWithQuery:aQuery andBody:aBody andMethod:@"POST" andCSRFData:aCSRFData];
}

- (id <Requesting>)executeUpdateSyncRequestWithQuery:(ODataQuery *)aQuery andBody:(NSString *)aBody andCSRFData:(CSRFData *)aCSRFData andEtag:(NSString *)aEtag
{
    NSDictionary *requestHeaders = nil;
    if ([aEtag length] > 0) {
        requestHeaders = @{IF_MATCH : aEtag};
    }
    return [self executeBasicSyncRequestWithQuery:aQuery andBody:aBody andMethod:@"PUT" andCSRFData:aCSRFData andRequestHeaders:requestHeaders];
}

- (id <Requesting>)executeDeleteSyncRequestWithQuery:(ODataQuery *)aQuery andCSRFData:(CSRFData *)aCSRFData andEtag:(NSString *)aEtag
{
    NSDictionary *requestHeaders = nil;
    if ([aEtag length] > 0) {
        requestHeaders = @{IF_MATCH : aEtag};
    }
    return [self executeBasicSyncRequestWithQuery:aQuery andBody:nil andMethod:@"DELETE" andCSRFData:aCSRFData andRequestHeaders:requestHeaders];
}

- (void)executeCreateAsyncRequestWithQuery:(ODataQuery *)aQuery andBody:(NSString *)aBody andCSRFData:(CSRFData *)aCSRFData andRequestDelegate:(__weak id <RequestDelegate>)aDelegate andDidFinishSelector:(SEL)aFinishSelector andUserInfo:(NSDictionary *)aUserInfo
{
    [self executeBasicAsyncRequestWithQuery:aQuery andBody:aBody andMethod:@"POST" andCSRFData:aCSRFData andRequestDelegate:aDelegate andDidFinishSelector:aFinishSelector andUserInfo:aUserInfo];
}

- (void)executeUpdateAsyncRequestWithQuery:(ODataQuery *)aQuery andBody:(NSString *)aBody andCSRFData:(CSRFData *)aCSRFData andRequestDelegate:(__weak id <RequestDelegate>)aDelegate andDidFinishSelector:(SEL)aFinishSelector andUserInfo:(NSDictionary *)aUserInfo andEtag:(NSString *)aEtag
{
    NSDictionary *requestHeaders = nil;
    if ([aEtag length] > 0) {
        requestHeaders = @{IF_MATCH : aEtag};
    }
    
    [self executeBasicAsyncRequestWithQuery:aQuery andBody:aBody andMethod:@"PUT" andCSRFData:aCSRFData andRequestDelegate:aDelegate andDidFinishSelector:aFinishSelector andUserInfo:aUserInfo andRequestHeaders:requestHeaders];
}

- (void)executeDeleteAsyncRequestWithQuery:(ODataQuery *)aQuery andCSRFData:(CSRFData *)aCSRFData andRequestDelegate:(__weak id <RequestDelegate>)aDelegate andDidFinishSelector:(SEL)aFinishSelector andUserInfo:(NSDictionary *)aUserInfo andEtag:(NSString *)aEtag
{
    NSDictionary *requestHeaders = nil;
    if ([aEtag length] > 0) {
        requestHeaders = @{IF_MATCH : aEtag};
    }
    
    [self executeBasicAsyncRequestWithQuery:aQuery andBody:nil andMethod:@"DELETE" andCSRFData:aCSRFData andRequestDelegate:aDelegate andDidFinishSelector:aFinishSelector andUserInfo:aUserInfo andRequestHeaders:requestHeaders];
}

#pragma mark - Execute Create / Update / Delete Media Links methods

- (id <Requesting>)executeCreateMediaLinkSyncRequest:(MediaLink *)aMediaLink andBody:(NSMutableData *)aBody andCSRFData:(CSRFData *)aCSRFData
{
	id <Requesting> request = [self createRequestWithQuery:aMediaLink.mediaLinkQuery];
    request.requestMethod = @"POST";
	[request addRequestHeader:@"Content-Type" value:aMediaLink.contentType];
	[request addRequestHeader:@"Slug" value:aMediaLink.slug];
	request.postBody = aBody;
    [self addCSRFDataToRequest:request withCSRFData:aCSRFData];
    [self onBeforeRequestCall:request];
    NSString *msg = [self createLogMessageForRequest:request sync:YES];
    LOGNOTICE(msg);
    [request startSynchronous];
    return request;
}

- (id <Requesting>)executeUpdateMediaLinkSyncRequest:(MediaLink *)aMediaLink andBody:(NSMutableData *)aBody andCSRFData:(CSRFData *)aCSRFData
{
	id <Requesting> request = [self createRequestWithQuery:aMediaLink.mediaLinkQuery];
    request.requestMethod = @"PUT";
	[request addRequestHeader:@"Content-Type" value:aMediaLink.contentType];
	request.postBody = aBody;
    [self addCSRFDataToRequest:request withCSRFData:aCSRFData];
    [self onBeforeRequestCall:request];
    NSString *msg = [self createLogMessageForRequest:request sync:YES];
    LOGNOTICE(msg);
    [request startSynchronous];
    return request;
}

- (id <Requesting>)executeDeleteMediaLinkSyncRequest:(MediaLink *)aMediaLink andCSRFData:(CSRFData *)aCSRFData
{
	return [self executeBasicSyncRequestWithQuery:aMediaLink.mediaLinkQuery andBody:nil andMethod:@"DELETE" andCSRFData:aCSRFData];
}

- (void)executeCreateMediaLinkAsyncRequest:(MediaLink *)aMediaLink andBody:(NSMutableData *)aBody andCSRFData:(CSRFData *)aCSRFData andRequestDelegate:(__weak id <RequestDelegate>)aDelegate andDidFinishSelector:(SEL)aFinishSelector andUserInfo:(NSDictionary *)aUserInfo
{
	id <Requesting> request = [self createRequestWithQuery:aMediaLink.mediaLinkQuery];
	request.requestMethod = @"POST";
	[request addRequestHeader:@"Content-Type" value:aMediaLink.contentType];
	[request addRequestHeader:@"Slug" value:aMediaLink.slug];
	request.postBody = aBody;
    [self addCSRFDataToRequest:request withCSRFData:aCSRFData];
    [request setDelegate:aDelegate];
    if (aFinishSelector) {
        request.didFinishSelector = aFinishSelector;
    }
    if (aUserInfo) {
        request.userInfo = aUserInfo;
    }
    [self onBeforeRequestCall:request];
    NSString *msg = [self createLogMessageForRequest:request sync:NO];
    LOGNOTICE(msg);
    [request startAsynchronous];
}

- (void)executeUpdateMediaLinkAsyncRequest:(MediaLink *)aMediaLink andBody:(NSMutableData *)aBody andCSRFData:(CSRFData *)aCSRFData andRequestDelegate:(__weak id <RequestDelegate>)aDelegate andDidFinishSelector:(SEL)aFinishSelector andUserInfo:(NSDictionary *)aUserInfo
{
	id <Requesting> request = [self createRequestWithQuery:aMediaLink.mediaLinkQuery];
	request.requestMethod = @"PUT";
	[request addRequestHeader:@"Content-Type" value:aMediaLink.contentType];
	request.postBody = aBody;
    [self addCSRFDataToRequest:request withCSRFData:aCSRFData];
    [request setDelegate:aDelegate];
    if (aFinishSelector) {
        request.didFinishSelector = aFinishSelector;
    }
    if (aUserInfo) {
        request.userInfo = aUserInfo;
    }
    [self onBeforeRequestCall:request];
    NSString *msg = [self createLogMessageForRequest:request sync:NO];
    LOGNOTICE(msg);
    [request startAsynchronous];
}

- (void)executeDeleteMediaLinkAsyncRequest:(MediaLink *)aMediaLink andCSRFData:(CSRFData *)aCSRFData andRequestDelegate:(__weak id <RequestDelegate>)aDelegate andDidFinishSelector:(SEL)aFinishSelector andUserInfo:(NSDictionary *)aUserInfo
{
	[self executeBasicAsyncRequestWithQuery:aMediaLink.mediaLinkQuery andBody:nil andMethod:@"DELETE" andCSRFData:aCSRFData andRequestDelegate:aDelegate andDidFinishSelector:aFinishSelector andUserInfo:aUserInfo];
}

#pragma mark - CSRF methods

- (CSRFData *)getCSRFDataForServiceQuery:(ODataQuery *)aServiceQuery
{
    id <Requesting> request = [self createRequestWithQuery:aServiceQuery];
    [request addRequestHeader:X_CSRF_TOKEN value:@"Fetch"];
    NSString *msg = [self createLogMessageForRequest:request sync:YES];
    LOGNOTICE(msg);
    [request startSynchronous];
    
    CSRFData *csrfData = [[CSRFData alloc] init];
    
    NSUInteger xsrfCookieStrPosition = NSNotFound;
    NSUInteger sessionIDCookieStrPosition = NSNotFound;
    
    csrfData.token = [request responseHeaders][X_CSRF_TOKEN];
    if ([ConnectivitySettings isSUPMode]) {
        NSString *cookiesString = [request responseHeaders][@"SET-COOKIE"];
        xsrfCookieStrPosition = [cookiesString rangeOfString:SAP_XSRF_COOKIE_PREFIX options:NSCaseInsensitiveSearch].location;
        sessionIDCookieStrPosition = [cookiesString rangeOfString:SAP_SESSION_ID_COOKIE_PREFIX options:NSCaseInsensitiveSearch].location;
        
        if (xsrfCookieStrPosition != NSNotFound || sessionIDCookieStrPosition != NSNotFound ) {
            csrfData.cookies = cookiesString;
        }
    }
    else {
        csrfData.cookie = [self getCSRFCookieFromArray:request.responseCookies];
        
        //if SAP XSRF cookie already exists in the request it will not be returned in the response.
        if (!csrfData.cookie) {
            csrfData.cookie = [self getCSRFCookieFromArray:request.requestCookies];
        }
    }
    
    // if the CSRF cookie or CSRF Token is nil, the whole CSRF data is considered as invalid
    if (csrfData.token == nil || (csrfData.cookie == nil && csrfData.cookies == nil)) {
        return nil;
    }
    
    return csrfData;
}

- (NSHTTPCookie *)getCSRFCookieFromArray:(NSArray *)cookiesArray
{
    NSUInteger xsrfCookieStrPosition = NSNotFound;
    NSUInteger sessionIDCookieStrPosition = NSNotFound;
    
    for (NSHTTPCookie *aCookie in cookiesArray) {
        xsrfCookieStrPosition = [aCookie.name rangeOfString:SAP_XSRF_COOKIE_PREFIX options:NSCaseInsensitiveSearch].location;
        sessionIDCookieStrPosition = [aCookie.name rangeOfString:SAP_SESSION_ID_COOKIE_PREFIX options:NSCaseInsensitiveSearch].location;
        
        if ( xsrfCookieStrPosition != NSNotFound || sessionIDCookieStrPosition != NSNotFound ) {
            return aCookie;
        }
    }
    
    return nil;
}

- (void)addCSRFDataToRequest:(id <Requesting>)aRequest andServiceQuery:(ODataQuery *)aServiceQuery
{
    CSRFData *csrfData = [self getCSRFDataForServiceQuery:aServiceQuery];
	[self addCSRFDataToRequest:aRequest withCSRFData:csrfData];
}

#pragma mark


@end
