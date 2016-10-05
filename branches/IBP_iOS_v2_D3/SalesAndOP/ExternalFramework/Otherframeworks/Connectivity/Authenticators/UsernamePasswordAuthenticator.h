/*
 
 File: UsernamePasswordAuthenticator.h
 Abstract: Implements the Authenticating protocol for performing synchronous GET requests with user Basic / NTLM authentication: with username, password and domain (optional). See the Authenticating protocol for more information. Note: Domain is not supported when connecting to SUP. The class also supports Single Sign On (SSO), by securely storing the user credentials on the device. 
 
 */

#import <Foundation/Foundation.h>
#import "Authenticating.h"
#import "SDMConnectivityHelperDelegate.h"
#import "SDMConnectivityHelper.h"

/**
 A class implements the Authenticating protocol for performing synchronous GET requests with user Basic / NTLM authentication: with username, password and domain (optional). See the Authenticating protocol for more information. The class also supports Single Sign On (SSO), by securely storing the user credentials on the device.
 */
@interface UsernamePasswordAuthenticator : NSObject <Authenticating, SDMConnectivityHelperDelegate> {
    SDMConnectivityHelper *connectivityHelper;
    NSString *username;
    NSString *password;
    NSString *domain;
}

#pragma mark - Initialize

/**
 Creates an instance of the UsernamePasswordAuthenticator class.
 Do not use this method if you would like to enable connectivity with SUP server.
 The method tries to extract the credentials from the Keychain.
 
 For enabling Single Sign On (SSO):
 At the first application run use the initWithUsername:andPassword: method to pass the username and password to securely store the user credentials on the device.
 At later calls, use this method to exctract the stored user credentials.
 */
- (id)init;


/**
 Creates an instance of the UsernamePasswordAuthenticator class.
 Do not use this method if you would like to enable connectivity with SUP server.
 The method stores the given credentials in the Keychain.
 If the given username and password are nil or empty, the method tries to extract the credentials from the Keychain.
 
 For enabling Single Sign On (SSO):
 At the first application run pass the username and password to securely store the user credentials on the device.
 At later calls, pass empty credentials or use the default init method to exctract the stored user credentials.
 
 @param aUsername The user name used for the authentication. If domain is required, the username should be in the format: [domain]\[user]
 @param aPassword The password for the provided user name.
 */
- (id)initWithUsername:(NSString *)aUsername andPassword:(NSString *)aPassword;

#pragma mark - Initialize for SUP connectivity

/**
 Creates an instance of the UsernamePasswordAuthenticator class.
 Use this init method for enabling connectivity with SUP server.
 At the first application run, pass the username and password for connecting the SAP NetWeaver Gateway server to register the user on the SUP server, and pass the Vault password to securely store the user credentials on the device.
 At later calls, pass only the Vault password or use the initWithSUPVaultPassword: method to exctract the stored user credentials.
 If the SUP Mode is set to YES in the Connectivity Settings, you must also set the following SUP connectivity settings: SUPHost, SUPPort, SUPFarmId, SUPSecurityConfiguration and SUPAppID.
 @param aUsername The user name used for the authentication (may be nil if the user is already registerd in the SUP server).
 @param aPassword The password for the provided user name (may be nil if the user is already registerd in the SUP server).
 @param vaultPassword The password for the Vault used for securely storing the user credentials on the device (cannot be nil).
 */
- (id)initWithUsername:(NSString *)aUsername andPassword:(NSString *)aPassword andSUPVaultPassword:(NSString *)vaultPassword;


/**
 Creates an instance of the UsernamePasswordAuthenticator class.
 Use this init method for enabling connectivity with SUP server.
 At the first application run, use the initWithUsername:andPassword:andSUPVaultPassword: method to pass the username and password for connecting the SAP NetWeaver Gateway server to register the user on the SUP server, and pass the Vault password to securely store the user credentials on the device.
 At later calls, use this method to pass only the Vault password to exctract the stored user credentials.
 If the SUP Mode is set to YES in the Connectivity Settings, you must also set the following SUP connectivity settings: SUPHost, SUPPort, SUPFarmId, SUPSecurityConfiguration and SUPAppID.
 @param vaultPassword The password for the Vault used for securely storing the user credentials on the device (cannot be nil).
 */
- (id)initWithSUPVaultPassword:(NSString *)vaultPassword;
@end
