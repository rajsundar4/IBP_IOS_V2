/*
 
 File: UsernamePasswordAuthenticator.m
 Abstract: Implements the Authenticating protocol for performing synchronous GET requests with user Basic / NTLM authentication: with username, password and domain (optional). See the Authenticating protocol for more information. Note: Domain is not supported when connecting to SUP. The class also supports Single Sign On (SSO), by securely storing the user credentials on the device.
 
 */

#import "UsernamePasswordAuthenticator.h"
#import "SUPHelper.h"
#import "ConnectivitySettings.h"
#import "Logger.h"
#import "KeychainHelper.h"
#import "ErrorHandling.h"

@implementation UsernamePasswordAuthenticator

@synthesize sapClient;

#pragma mark - Private methods

- (void)setCredentialsWithUsername:(NSString *)aUsername andPassword:(NSString *)aPassword
{
    NSRange rangeOfSlash = [aUsername rangeOfString:@"\\"];
    if (rangeOfSlash.location != NSNotFound) {
        username = [aUsername substringFromIndex:(rangeOfSlash.location + rangeOfSlash.length)]; //username without domain
        domain = [aUsername substringToIndex:rangeOfSlash.location];
    }
    else {
        username = aUsername;
        domain = nil;
    }
    
    password = aPassword;
}


- (void)loadCredentialsWithUsername:(NSString *)aUsername andPassword:(NSString *)aPassword
{
    [self setCredentialsWithUsername:aUsername andPassword:aPassword];
    
    NSError *error = nil;
    if (([username length] > 0) && ([password length] > 0)) {
        // Save given username and password if not nil or empty
        CredentialsData *credentials = [[CredentialsData alloc] initWithUsername:aUsername andPassword:aPassword];
        BOOL saved = [KeychainHelper saveCredentials:credentials error:&error];
        if (!saved) {
            NSString *msg = [error localizedDescription]; 
            LOGERROR(msg);
        }
    }
    else { 
        // Try to get credentials from keychain if given credentials are empty
        if ([KeychainHelper isCredentialsSaved]){
            CredentialsData *credentials = [KeychainHelper loadCredentialsAndReturnError:&error];
            if (credentials) {
                [self setCredentialsWithUsername:credentials.username andPassword:credentials.password];
            }
            else {
                NSString *msg = [error localizedDescription]; 
                LOGERROR(msg);
            }
        }
    }
}

- (void)initializeConnectivityHelper
{
    connectivityHelper = [[SDMConnectivityHelper alloc] init];
    connectivityHelper.delegate = self;
}

- (void)activateSUPConnectionWithUsername:(NSString *)aUsername andPassword:(NSString *)aPassword andSUPVaultPassword:(NSString *)vaultPassword
{
    @try {
        if (![SUPHelper isSUPUserRegisteredForAppID:[ConnectivitySettings SUPAppID]]) {
            // Use Connectivity Settings to set the SUP server connection profile for the application, and register the current user on the SUP server.
            [SUPHelper setSUPConnectionProfileWithHost:[ConnectivitySettings SUPHost] andSUPPort:[ConnectivitySettings SUPPort] andSUPFarmId:[ConnectivitySettings SUPFarmID] andAppId:[ConnectivitySettings SUPAppID]];
            
            [SUPHelper registerSUPUser:aUsername andPassword:aPassword andSecurityConfigName:[ConnectivitySettings SUPSecurityConfiguration] andVaultPassword:vaultPassword forAppID:[ConnectivitySettings SUPAppID]];
            [SUPHelper unlockSUPVaultWithPassword:vaultPassword forAppID:[ConnectivitySettings SUPAppID]];
            username = aUsername;
            password = aPassword;
        }
        else {
            // Use vault password to get the user credentials from the vault.
            if ([SUPHelper unlockSUPVaultWithPassword:vaultPassword forAppID:[ConnectivitySettings SUPAppID]]) {
                username = [SUPHelper getUsernameOfRegisteredSUPUserForAppID:[ConnectivitySettings SUPAppID]];
                password = [SUPHelper getPasswordOfRegisteredSUPUserForAppID:[ConnectivitySettings SUPAppID]];
            }
        }
    }
    @catch (NSException *exception) {
        NSString *errorMessage = [NSString stringWithFormat:@"Error setting credentials for SUP connectivity. %@",[exception reason]];
        LOGERROR(errorMessage);
    }
}

- (void)unregisterSUPUser
{
    @try {
        [SUPHelper unregisterSUPUserForAppID:[ConnectivitySettings SUPAppID]];
    }
    @catch (NSException *exception) {
        NSString *errorMessage = [NSString stringWithFormat:@"Error deleting credentials for SUP connectivity. %@",[exception reason]];
        LOGERROR(errorMessage);
    }    
}

#pragma mark - Initialize

- (id)init
{
    return [self initWithUsername:nil andPassword:nil];
}


- (id)initWithUsername:(NSString *)aUsername andPassword:(NSString *)aPassword
{
    self = [super init];
    if (self) {
        [self initializeConnectivityHelper];
        [self loadCredentialsWithUsername:aUsername andPassword:aPassword];    
        if ([ConnectivitySettings isSUPMode]) {
            LOGERROR(@"SUP Mode was activated in the Connectivity Settings, but Vault password was not supplied. Activating the SUP connection and registering the user cannot be done.");
        }
    }
    return self;
}

#pragma mark - Initialize for SUP connectivity

- (id)initWithUsername:(NSString *)aUsername andPassword:(NSString *)aPassword andSUPVaultPassword:(NSString *)vaultPassword
{
    self = [super init];
    if (self) {
        [self initializeConnectivityHelper];
        if ([ConnectivitySettings isSUPMode]) {
            [self activateSUPConnectionWithUsername:aUsername andPassword:aPassword andSUPVaultPassword:vaultPassword];
        }
        else {
            [self loadCredentialsWithUsername:aUsername andPassword:aPassword];
            if ([vaultPassword length] > 0) {
                LOGWARNING(@"SUP Mode was not activated in the Connectivity Settings. Vault password is ignored, and the requests will be sent directly to SAP NetWeaver Gateway.");
            }
        }
    }
    return self;
}

- (id)initWithSUPVaultPassword:(NSString *)vaultPassword
{
    return [self initWithUsername:nil andPassword:nil andSUPVaultPassword:vaultPassword];
}

#pragma mark - Authenticating

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
        if (authenticatedRequest.responseStatusCode == 401) {
            if ([ConnectivitySettings isSUPMode]) {
                [self unregisterSUPUser];
            }
            else {
                NSError *credentialsDeletionError = nil;
                BOOL deleted = [KeychainHelper deleteCredentialsAndReturnError:&credentialsDeletionError];
                if (!deleted) {
                    NSString *logErrorMessage = [credentialsDeletionError localizedDescription];
                    LOGERROR(logErrorMessage);
                }
            }
        }
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
    if (username && password) {        
        request.username = username;
        request.password = password;
        
        // Domain is relevant only if username and password are supplied (not relevant for anonymous access)
        if (domain) {
            request.domain = domain; 
        }
    }
}

@end
