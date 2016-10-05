/*
 
 File: ConnectivitySettings.h
 Abstract: Holds the settings used for connecting the SAP NetWeaver Gateway server. 
 
 */

#import <Foundation/Foundation.h>

/**
 * Defines authentication type constants
 */
typedef enum AuthenticationType : NSUInteger {
	UsernamePasswordAuthenticationType	= 0xFE,  ///< denotes Username/Password/Domain(optional) authentication (Basic / NTLM).
	PortalAuthenticationType = 0xFF, ///< denotes SAP Portal SSO Authentication.
    CertificateAuthenticationType = 0xFD ///< denotes Certificate Authentication.
} AuthenticationType;

/**
 A class that holds the settings used for connecting the SAP NetWeaver Gateway server.
 */
@interface ConnectivitySettings : NSObject

+ (AuthenticationType)authenticationType; ///< The type of user authentication used for the SAP NetWeaver Gateway connectivity. Note that if SAML2 is used for authentication, this property indicates the authentication type used by the Identity Provider server.
+ (void)setAuthenticationType:(AuthenticationType)authenticationType;

+ (BOOL)isSUPMode; ///< Indicating whether an SUP server is used for the SAP NetWeaver Gateway connectivity, or not.

/**
 Switch the application to work with SUP Server, or directly with SAP NetWeaver Gateway.
 If you set the SUP mode to YES, make sure to perform the following:
 1. Add the ODP client libraries to the project.
 2. Uncomment all the relevant code for SUP connectivity (for more information, see the documentation).
 3. Set the following SUP connectivity settings: SUPHost, SUPPort, SUPFarmId, SUPSecurityConfiguration and SUPAppID. 
 4. Before making calls using the SDMConnectivityHelper class, use the appropriate Authenticating protocol implementation for user authentication (this will also configure the LiteSUPUserManager correctly). Make sure to use the SUPVaultPassword parameter when initating the Authenticating protocol implementation. 
 */
+ (void)setSUPMode:(BOOL)isSUPMode; 

+ (NSString *)SUPHost; ///< The SUP Server Host as configured by the Administrator of Sybase Control Center (must be set if SUPMode is set to YES).
+ (void)setSUPHost:(NSString *)SUPHost;

+ (NSInteger)SUPPort; ///< The SUP Server Port as configured by the Administrator of Sybase Control Center (must be set if SUPMode is set to YES).
+ (void)setSUPPort:(NSInteger)SUPPort;

+ (NSString *)SUPFarmID; ///< The SUP Farm Id as configured by the Administrator of Sybase Control Center (must be set if SUPMode is set to YES).
+ (void)setSUPFarmID:(NSString *)SUPFarmID;

+ (NSString *)SUPAppID; ///< The Application Id as configured by the Administrator of Sybase Control Center (must be set if SUPMode is set to YES).
+ (void)setSUPAppID:(NSString *)SUPAppID;

+ (NSString *)SUPSecurityConfiguration; ///< The Application Security Configuration name as configured by the Administrator of Sybase Control Center (must be set if SUPMode is set to YES).
+ (void)setSUPSecurityConfiguration:(NSString *)SUPSecurityConfiguration;

+ (NSURL *)portalUrl; ///< The Portal URL used for authentication against the Portal and allowing the application to work with Portal SSO
+ (void)setPortalUrl:(NSURL *)portalUrl;


@end
