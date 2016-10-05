/*
 
 File: SUPHelper.m
 Abstract: Helper class for SUP Server connectivity support. 
 
 */

#import "SUPHelper.h"
#import "KeychainHelper.h"
#import "ErrorHandling.h"
/**
 * TODO: Uncomment the following lines for SUP Server connectivity support. 
 * Make sure to uncomment the additional required methods implementation under "Methods for SUP Server connectivity" pragma mark.
 * In addition, make sure to reference in the project the ODP client libraries and headers required for SUP connectivity.
 */
//#import "LiteSUPUserManager.h"
//#import "LiteSUPAppSettings.h"
//#import "LiteSUPCertificateStore.h"
//#import "SUPUtilities.h"
//#import "LiteSUPMessagingClient.h"

@implementation SUPHelper

#pragma  mark - Methods for SUP Server connectivity

/**
 * TODO: Uncomment the following methods implementation for SUP Server connectivity support
 */

+ (void)setSUPConnectionProfileWithHost:(NSString *)aSUPHost andSUPPort:(NSInteger)aSUPPort andSUPFarmId:(NSString *)aSUPFarmId andAppId:(NSString *)aAppId
{
//    LiteSUPUserManager *supUserManager = [LiteSUPUserManager getInstance:aAppId];
//    [supUserManager setConnectionProfile:aSUPHost withSupPort:aSUPPort withServerFarmID:aSUPFarmId];
}

+ (void)registerSUPUser:(NSString *)aUsername andPassword:(NSString *)aPassword andSecurityConfigName:(NSString *)aSecurityConfigName andVaultPassword:(NSString *)aVaultPassword forAppID:(NSString *)aAppId
{
//    LiteSUPUserManager *supUserManager = [LiteSUPUserManager getInstance:aAppId];
//    if (![supUserManager isUserRegistered]) {
//        [supUserManager registerUser:aUsername withSecurityConfig:aSecurityConfigName withPassword:aPassword withVaultPassword:aVaultPassword];
//    }
}

+ (void)unregisterSUPUserForAppID:(NSString *)aAppId
{
//    LiteSUPUserManager *supUserManager = [LiteSUPUserManager getInstance:aAppId];
//    if ([supUserManager isUserRegistered]) {
//        [supUserManager deleteUser];
//    }  
}

+ (BOOL)isSUPUserRegisteredForAppID:(NSString *)aAppId
{
    BOOL result = NO;
//    LiteSUPUserManager *supUserManager = [LiteSUPUserManager getInstance:aAppId];
//    result = [supUserManager isUserRegistered];

    return result;
}

+ (BOOL)unlockSUPVaultWithPassword:(NSString *)aVaultPassword forAppID:(NSString *)aAppId
{
    BOOL result = NO;
//    LiteSUPUserManager *supUserManager = [LiteSUPUserManager getInstance:aAppId];
//    result = [supUserManager unlock:aVaultPassword];

    return result;
}

+ (NSString *)getSUPApplicationEndPoint
{
    NSString *result = nil;
//    result = [LiteSUPAppSettings getApplicationEndPoint];

    return result;
}

+ (NSString *)getUsernameOfRegisteredSUPUserForAppID:(NSString *)aAppId
{
    NSString *result = nil;
//    LiteSUPUserManager *supUserManager = [LiteSUPUserManager getInstance:aAppId];
//    result = supUserManager._username;
    
    return result;    
}

+ (NSString *)getPasswordOfRegisteredSUPUserForAppID:(NSString *)aAppId
{
    NSString *result = nil;
//    LiteSUPUserManager *supUserManager = [LiteSUPUserManager getInstance:aAppId];
//    result = supUserManager._password;

    return result;
}

+ (CredentialsData *)getCredentialsFromCertificateFile:(NSString *)aCertPath withCertificatePassword:(NSString *)aCertPassword error:(NSError * __autoreleasing *)error
{
    CredentialsData *credentialsData = nil;
//    NSString *certStr = [[LiteSUPCertificateStore getInstance] getSignedCertificateFromFile:aCertPath withCertificatePassword:aCertPassword];
//    if ([certStr length] > 0) {
//        NSData *PKCS12Data = [[NSData alloc] initWithContentsOfFile:aCertPath];
//        SecIdentityRef certificate = [KeychainHelper extractIdentityFromClientCertificate:PKCS12Data WithPassword:aCertPassword];
//        if (certificate != NULL) {
//            NSString *certSubject = [KeychainHelper extractSubjectFromIdentity:certificate];
//            if ([certSubject length] > 0) {
//                credentialsData = [[CredentialsData alloc] initWithUsername:certSubject andPassword:certStr];
//            }
//            else if (error) {
//                NSString *errorMessage = NSLocalizedString(@"Failed to extract subject from identity", @"Failed to extract subject from identity");
//                *error = [NSError errorWithDomain:ERROR_DOMAIN code:CERTIFICATE_HANDLING_ERROR_CODE userInfo:@{NSLocalizedDescriptionKey : errorMessage}];
//            }
//        }
//        else if (error) {
//            NSString *errorMessage = NSLocalizedString(@"Failed to extract identity from certificate", @"Failed to extract identity from certificate");
//            *error = [NSError errorWithDomain:ERROR_DOMAIN code:CERTIFICATE_HANDLING_ERROR_CODE userInfo:@{NSLocalizedDescriptionKey : errorMessage}];
//        }
//    }
//    else if (error) {
//        NSString *errorMessage = NSLocalizedString(@"Failed to get certificate string from file", @"Failed to get certificate string from file");
//        *error = [NSError errorWithDomain:ERROR_DOMAIN code:CERTIFICATE_HANDLING_ERROR_CODE userInfo:@{NSLocalizedDescriptionKey : errorMessage}];
//    }
    
    return credentialsData;
}

+ (void)registerForAPNSPush:(UIApplication *)aApplication
{
//    [LiteSUPMessagingClient setupForPush:aApplication];
}

+ (void)sendDeviceTokenForPush:(NSData *)aDeviceToken andApplication:(UIApplication *)aApplication
{
//    [LiteSUPMessagingClient deviceTokenForPush:aApplication deviceToken:aDeviceToken];
}

+ (void)pushRegistrationFailedWithError:(NSError *)error andApplication:(UIApplication *)aApplication
{
//    [LiteSUPMessagingClient pushRegistrationFailed:aApplication errorInfo:error];
}

+ (void)receivedAPNSPushNotification:(NSDictionary *)aUserInfo andApplication:(UIApplication *)aApplication
{
//    [LiteSUPMessagingClient pushNotification:aApplication notifyData:aUserInfo];
}

+ (NSString *)getSUPApplicationPushEndPoint
{
    NSString *result = nil;
//    result = [LiteSUPAppSettings getPushEndPoint];
    
    return result;
}

+ (void)setPushDelegate:(id)aSDMSUPPushDelegate
{
//    [SUPUtilities setDelegate:aSDMSUPPushDelegate];
}

@end
