/*
 
 File: ConnectivitySettings.m
 Abstract: Holds the settings used for connecting the SAP NetWeaver Gateway server. 
 
 */

#import "ConnectivitySettings.h"

static AuthenticationType _authType = UsernamePasswordAuthenticationType;

static BOOL _isSUPMode = NO;

static NSString *_SUPHost = nil; 
static NSInteger _SUPPort = 0;
static NSString *_SUPFarmId = nil;
static NSString *_SUPAppId = nil;
static NSString *_SUPsecurityConfiguration = nil;
static NSURL *_portalUrl = nil;

@implementation ConnectivitySettings

+ (AuthenticationType)authenticationType
{
    return _authType;
}

+ (void)setAuthenticationType:(AuthenticationType)authenticationType
{
    _authType = authenticationType;
}

+ (BOOL)isSUPMode 
{
    return _isSUPMode;
}

+ (void)setSUPMode:(BOOL)isSUPMode
{
    _isSUPMode = isSUPMode;
}

+ (NSString *)SUPHost
{
    return _SUPHost;
}
+ (void)setSUPHost:(NSString *)SUPHost
{
    _SUPHost = SUPHost;   
}

+ (NSInteger)SUPPort
{
    return _SUPPort;
}

+ (void)setSUPPort:(NSInteger)SUPPort
{
    _SUPPort = SUPPort; 
}

+ (NSString *)SUPFarmID
{
    return _SUPFarmId;
}

+ (void)setSUPFarmID:(NSString *)SUPFarmID
{
    _SUPFarmId = SUPFarmID;
}

+ (NSString *)SUPAppID
{
    return _SUPAppId;
}

+ (void)setSUPAppID:(NSString *)SUPAppID
{
    _SUPAppId = SUPAppID;
}

+ (NSString *)SUPSecurityConfiguration
{
    return _SUPsecurityConfiguration;
}

+ (void)setSUPSecurityConfiguration:(NSString *)SUPSecurityConfiguration
{
    _SUPsecurityConfiguration = SUPSecurityConfiguration;
}

+ (NSURL *)portalUrl
{
    return _portalUrl;
}

+ (void)setPortalUrl:(NSURL *)portalUrl
{
    _portalUrl = portalUrl;
}

@end
