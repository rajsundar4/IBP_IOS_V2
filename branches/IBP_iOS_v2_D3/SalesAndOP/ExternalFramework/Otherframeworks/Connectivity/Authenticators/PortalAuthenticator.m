/*
 
 File: PortalAuthenticator.m
 Abstract: Implements the Authenticating protocol for performing synchronous GET requests with Portal Basic / NTLM authentication: with username (may include donmain), password and Portal URL. Mainly used to authenticate user against the Portal and get the SSO cookie for subsequent calls to SAP NetWeaver Gateway. See the Authenticating protocol for and the UsernamePasswordAuthenticator class for more information more information. Note: When connecting to SUP the class behaves the same as a UsernamePasswordAuthenticator (SUP security configutation should be set to use the Portal URL by Administrator). The class also supports Single Sign On (SSO), by securely storing the user credentials on the device.
 */

#import "PortalAuthenticator.h"
#import "ConnectivitySettings.h"
#import "Logger.h"
#import "ErrorHandling.h"
#import "KeychainHelper.h"

@implementation PortalAuthenticator

/***********************************************************************************************************
 
 INSTRUCTIONS TO ENABLE SUP CONNECTIVITY SUPPORT:
 ------------------------------------------------
 Uncomment the content of the activateSUPConnectionWithUsername:andPassword:andSUPVaultPassword: and unregisterSUPUser methods
 in the UsernamePasswordAuthenticator class implementation for SUP Server connectivity support
 
 ***********************************************************************************************************/


- (NSData *)authenticateWithODataQuery:(ODataQuery *)query error:(NSError * __autoreleasing *)error
{
    // if working in SUP mode, the authentication should be a simple user name password authentication against
    // SUP server and not using Portal URL
    if ([ConnectivitySettings isSUPMode]) {
        return [super authenticateWithODataQuery:query error:error];
    }
    
    connectivityHelper.sapClient = nil;
    ODataQuery *portalQuery = [[ODataQuery alloc]initWithURL:[ConnectivitySettings portalUrl]];
    id <Requesting> authenticatedRequest = [connectivityHelper executeBasicSyncRequestWithQuery:portalQuery];
    if ((!authenticatedRequest.error) && (authenticatedRequest.responseStatusCode == 200)) {
        // Authentication to portal succeeded, now send a request to the input query and return the response
        
        // set the delegate to nil so that onBeforeSent will not be called for this request
        connectivityHelper.delegate = nil;
        
        // call the super method from UsernamePassword authenticator to execute a regular request to the query
        // (since delegate is nil, user name and password will not be sent, only the cookie will be sent)
        NSData *responseData = [super authenticateWithODataQuery:query error:error];
        
        // restore the delegate for other login attempts
        connectivityHelper.delegate = self;
        return responseData;
    }
    else {
        // Authentication failed
        if (authenticatedRequest.responseStatusCode == 401) {
            NSError *credentialsDeletionError = nil;
            BOOL deleted = [KeychainHelper deleteCredentialsAndReturnError:&credentialsDeletionError];
            if (!deleted) {
                NSString *logErrorMessage = [credentialsDeletionError localizedDescription];
                LOGERROR(logErrorMessage);
            }
        }
        NSString *errorMessage = NSLocalizedString(@"Portal login failed.", @"Portal login failed.");;
        if (error) {
            *error = [[NSError alloc] initWithDomain:ERROR_DOMAIN code:LOGIN_ERROR_CODE userInfo:@{NSLocalizedDescriptionKey: errorMessage}];
        }
        NSString *logErrorMessage = [NSString stringWithFormat:@"Request failed with error: %@. Response status code: %d", authenticatedRequest.error ? [authenticatedRequest.error localizedDescription] : [authenticatedRequest responseStatusMessage], authenticatedRequest.responseStatusCode];
        LOGERROR(logErrorMessage);
        return nil;
    }
}

@end
