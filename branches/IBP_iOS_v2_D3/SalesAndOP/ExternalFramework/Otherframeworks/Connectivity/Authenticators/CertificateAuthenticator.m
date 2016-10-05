/*
 
 File: CertificateAuthenticator.m
 Abstract: Implements the Authenticating protocol for performing synchronous GET requests with client certificate authentication. See the Authenticating protocol for more information.
 
 */

#import "CertificateAuthenticator.h"
#import "KeychainHelper.h"
#import "ConnectivitySettings.h"
#import "LOGGER.h"
#import "ErrorHandling.h"

@implementation CertificateAuthenticator

@synthesize sapClient;

- (id)init
{
    self = [super init];
    if(self) {
        connectivityHelper = [[SDMConnectivityHelper alloc] init];
        connectivityHelper.delegate = self;
        _certificate = [KeychainHelper loadClientCertificateInKeychainAndReturnError:nil];
    }
    
    return self;
}

- (id)initWithCertificate:(SecIdentityRef)aCertificate
{
    self = [super init];
    if(self) {
        connectivityHelper = [[SDMConnectivityHelper alloc] init];
        connectivityHelper.delegate = self;
        _certificate = aCertificate;
    }
    
    return self;
}

- (NSData *)authenticateWithODataQuery:(ODataQuery *)query error:(NSError * __autoreleasing *)error
{
    if ([self.sapClient length] > 0) {
        connectivityHelper.sapClient = self.sapClient;
    }
    id <Requesting> authenticatedRequest = [connectivityHelper executeBasicSyncRequestWithQuery:query];
    if ((!authenticatedRequest.error) && (authenticatedRequest.responseStatusCode == 200) && authenticatedRequest.responseData) {
        // Authentication succeeded
        return authenticatedRequest.responseData;
    }
    else {
        // Authentication failed
        NSString *errorMessage = NSLocalizedString(@"Login failed.", @"Login failed.");
        if (error) {
            *error = [[NSError alloc] initWithDomain:ERROR_DOMAIN code:LOGIN_ERROR_CODE userInfo:@{NSLocalizedDescriptionKey: errorMessage}];
        }
        NSString *logErrorMessage = [NSString stringWithFormat:@"Request failed with error: %@. Response status code: %d", authenticatedRequest.error ? [authenticatedRequest.error localizedDescription] : [authenticatedRequest responseStatusMessage], authenticatedRequest.responseStatusCode];
        LOGERROR(logErrorMessage);
        return nil;
    }
}

#pragma mark - SDMConnectivityHelperDelegate

- (void)onBeforeSend:(id<Requesting>)request
{
    if (self.certificate) {
        [request setClientCertificateIdentity:self.certificate];
    }
}

@end
