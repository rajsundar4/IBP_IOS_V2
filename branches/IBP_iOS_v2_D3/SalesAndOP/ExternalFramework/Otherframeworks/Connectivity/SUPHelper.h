/*
 
 File: SUPHelper.h
 Abstract: Helper class for SUP Server connectivity support.
 
 */

#import <Foundation/Foundation.h>
#import "CredentialsData.h"

/**
 Helper class for SUP Server connectivity support.
 */
@interface SUPHelper : NSObject

#pragma  mark - Methods for SUP Server connectivity

/**
 Set the SUP server connection profile for the application.
 This process should be performed once in the application first run.
 You must surround this method call with try-catch and refer to LiteSUPUserManager class documentation.
 @param aSUPHost a SUP Server host as configured by the Administrator of Sybase Control Center.
 @param aSUPPort a SUP Server port as configured by the Administrator of Sybase Control Center.
 @param aSUPFarmId a SUP Farm Id as configured by the Administrator of Sybase Control Center.
 @param aAppId an Application Id as configured by the Administrator of Sybase Control Center.
 */
+ (void)setSUPConnectionProfileWithHost:(NSString *)aSUPHost andSUPPort:(NSInteger)aSUPPort andSUPFarmId:(NSString *)aSUPFarmId andAppId:(NSString *)aAppId;


/**
 Registers a new user for your application. Use the vault password for maximum security.
 You must surround this method call with try-catch and refer to LiteSUPUserManager class documentation.
 @param aUsername a user name.
 @param aPassword a password.
 @param aSecurityConfigName as configured by the Administrator of Sybase Control Center.
 @param aVaultPassword the password for the Vault.
 @param aAppId an Application Id as configured by the Administrator of Sybase Control Center.
 */
+ (void)registerSUPUser:(NSString *)aUsername andPassword:(NSString *)aPassword andSecurityConfigName:(NSString *)aSecurityConfigName andVaultPassword:(NSString *)aVaultPassword forAppID:(NSString *)aAppId;

/**
 Unregisters the registered user for your application.
 @param aAppId an Application Id as configured by the Administrator of Sybase Control Center.
 */
+ (void)unregisterSUPUserForAppID:(NSString *)aAppId;

/**
 Checks if there is a registered user for your application.
 Refer to LiteSUPUserManager class documentation.
 @param aAppId an Application Id as configured by the Administrator of Sybase Control Center.
 @return YES if there is a registered user or NO otherwise.
 */
+ (BOOL)isSUPUserRegisteredForAppID:(NSString *)aAppId;

/**
 Unlocks the SUP Vault for your application. Use the vault password for maximum security.
 You must surround this method call with try-catch and refer to LiteSUPUserManager class documentation.
 @param aVaultPassword the password for the Vault.
 @param aAppId an Application Id as configured by the Administrator of Sybase Control Center.
 @return An indication if the operation succeeded.
 */
+ (BOOL)unlockSUPVaultWithPassword:(NSString *)aVaultPassword forAppID:(NSString *)aAppId;

/**
 Get the application end point URL from SUP server.
 Refer to LiteSUPUserManager class documentation.
 @return The end point URL as NSString object.
 */
+ (NSString *)getSUPApplicationEndPoint;

/**
 Get the username of the registered user for your application.
 Make sure to call unlockSUPVaultWithPassword method before.
 Refer to LiteSUPUserManager class documentation.
 @param aAppId an Application Id as configured by the Administrator of Sybase Control Center.
 @return The username value.
 */
+ (NSString *)getUsernameOfRegisteredSUPUserForAppID:(NSString *)aAppId;

/**
 Get the password of the registered user for your application.
 Make sure to call unlockSUPVaultWithPassword method before.
 Refer to LiteSUPUserManager class documentation.
 @param aAppId an Application Id as configured by the Administrator of Sybase Control Center.
 @return The password value.
 */
+ (NSString *)getPasswordOfRegisteredSUPUserForAppID:(NSString *)aAppId;

/**
 Get the certificate credentials from the certificate file.
 @param aCertPath the path to the certificate file.
 @param aCertPassword the certificate password.
 @param error a pointer to an NSError object.
 @return The certificate credentials.
 */
+ (CredentialsData *)getCredentialsFromCertificateFile:(NSString *)aCertPath withCertificatePassword:(NSString *)aCertPassword error:(NSError * __autoreleasing *)error;

#pragma  mark - Methods for Push notifications

/**
 Registers the application for APNS Push.
 Refer to LiteSUPMessagingClient.h.
 @param aApplication Instance of the application class.
 */
+ (void)registerForAPNSPush:(UIApplication *)aApplication;

/**
 Sends the device token received to the SUP server.
 The device token must be sent to the SUP server for it to send notification through APNS. This is to be put in the applicationDidRegisterForRemoteNotifications delegate.
 @param aDeviceToken The device token that is received from the delegate.
 @param aApplication Instance of the application class.
 */
+ (void)sendDeviceTokenForPush:(NSData *)aDeviceToken andApplication:(UIApplication *)aApplication;

/**
 APNS Push registration failed.
 This method has to be implemented in didFailToRegisterForRemoteNotification delegate.
 @param aError The Error object received from the delegate in case of an error.
 @param aApplication Instance of the application class.
 */
+ (void)pushRegistrationFailedWithError:(NSError *)error andApplication:(UIApplication *)aApplication;

/**
 Receives APNS remote notifications and notifies SUP.
 This method has to be implemented in didReceiveRemoteNotification delegate.
 @param aUserInfo Information about the pushed data in the form of NSDictionary.
 @param aApplication Instance of the application class.
 */
+ (void)receivedAPNSPushNotification:(NSDictionary *)aUserInfo andApplication:(UIApplication *)aApplication;

/**
 Get the application push end point URL from SUP server.
 Refer to LiteSUPUserManager class documentation.
 @return The push end point URL as NSString object.
 */
+ (NSString *)getSUPApplicationPushEndPoint;

/**
 Set a delegate for online push.
 Refer to SDMSUPPushDelegate.h.
 @param aSDMSUPPushDelegate Instance of the class where the SDMSUPPushDelegate protocol has been implemented.
 */
+ (void)setPushDelegate:(id)aSDMSUPPushDelegate;
@end
