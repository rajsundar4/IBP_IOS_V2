/*
 
 File: SettingsUtilities.m
 Abstract: A utility class responsible for reading the application settings (as the service URL, the SAP client and the authentication configurations).
 
 */

#import "SettingsUtilities.h"
#import "ConnectivitySettings.h"
#import "ODataQuery.h"


@implementation SettingsUtilities

+ (NSMutableDictionary *)findPreferenceIn:(NSArray *)list forKey:(NSString *)key
{
	for (NSMutableDictionary* pref in list) {
		NSString* value = pref[@"Key"];
		if ([value length] > 0 && [value isEqualToString:key]) {
			return pref;
		}
	}
	return nil;
}

+ (NSString *)getPreferenceValueOrDefaultValueForKey:(NSString *)key inPlist:(NSString *)plistName
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSString *value = [defaults stringForKey:key];
	
	//if (!value) {

        NSString *pathToBundle = [[NSBundle mainBundle] pathForResource:plistName ofType:@"plist"];
		NSMutableDictionary* rootPlist = [NSMutableDictionary dictionaryWithContentsOfFile:
                                          [NSString stringWithFormat:@"%@", pathToBundle]];

		NSMutableDictionary *preferences = [SettingsUtilities findPreferenceIn:
                                            (NSArray*)rootPlist[@"PreferenceSpecifiers"] forKey:key];
		value = preferences[@"DefaultValue"];
        
        NSRange range = [value rangeOfString:@"com"];
        NSString *substring = [value substringFromIndex:NSMaxRange(range)];
       
        value=[NSString stringWithFormat:@"%@%@",[[NSUserDefaults standardUserDefaults]
                                                  valueForKey:kSaveServerUrlMannualy], substring];
        
       
		if (value) {
			NSDictionary *appDefaults = @{key: value};
			[defaults registerDefaults:appDefaults];
			[defaults synchronize];
		}
	//}
	return value;
}

+ (NSString *)getServiceUrlFromUserSettings{
    
	return [SettingsUtilities getPreferenceValueOrDefaultValueForKey:@"endPointURL" inPlist:@"Gateway"];
}

+ (NSString *)getServiceClientFromUserSettings{
    
	return [SettingsUtilities getPreferenceValueOrDefaultValueForKey:@"endPointClient" inPlist:@"Gateway"];
}

+ (void)updateConnectivitySettingsFromUserSettings{
    
    // SUP Mode Settings
    NSString *connectionMode = [SettingsUtilities getPreferenceValueOrDefaultValueForKey:@"connectionMode" inPlist:@"Root"];
    if ([connectionMode isEqualToString:@"modeSUP"]) {
        [ConnectivitySettings setSUPMode:YES];
    }
    
    NSString *authMethod = [SettingsUtilities getPreferenceValueOrDefaultValueForKey:@"authMethod" inPlist:@"Root"];
    
    // Authentication Method
    AuthenticationType authenticationType = UsernamePasswordAuthenticationType; // Default value
    
    if ([ConnectivitySettings isSUPMode]) {
        // Authentication options for SUP connectivity
        BOOL useCertificate = [[NSUserDefaults standardUserDefaults] boolForKey:@"supUseCertificate"]; // Considers also default value
        if (useCertificate) {
            authenticationType = CertificateAuthenticationType;
        }
    }
    else {
        // Authentication options for direct Gateway connectivity
        if ([authMethod isEqualToString:@"authUserPass"]) {
            authenticationType = UsernamePasswordAuthenticationType;
        }
        else if ([authMethod isEqualToString:@"authPortal"]) {
            authenticationType = PortalAuthenticationType;
        }
        else if ([authMethod isEqualToString:@"authCert"]) {
            authenticationType = CertificateAuthenticationType;
        }
    }
    
    [ConnectivitySettings setAuthenticationType:authenticationType];
    
    // Portal Settings
    NSString *portalURL = [SettingsUtilities getPreferenceValueOrDefaultValueForKey:@"portalUrl" inPlist:@"Portal"];
    if ([portalURL length] > 0) {
        NSString *encodedAbsoluteUrl = [ODataQuery encodeURLLoosely:portalURL];
        [ConnectivitySettings setPortalUrl:[NSURL URLWithString:encodedAbsoluteUrl]];
    }
    
    // SUP Settings
    NSString *host = [SettingsUtilities getPreferenceValueOrDefaultValueForKey:@"supHost" inPlist:@"SUP"];
    [ConnectivitySettings setSUPHost:host];
    
    NSString *portStr = [SettingsUtilities getPreferenceValueOrDefaultValueForKey:@"supPort" inPlist:@"SUP"];
    [ConnectivitySettings setSUPPort:[portStr integerValue]]; // Must be a number since the keyboard type for this text field in settings screen is NumberPad.
    
    NSString *farmID = [SettingsUtilities getPreferenceValueOrDefaultValueForKey:@"supFarmId" inPlist:@"SUP"];
    [ConnectivitySettings setSUPFarmID:farmID];
    
    NSString *securityConfig = [SettingsUtilities getPreferenceValueOrDefaultValueForKey:@"supSecConfig" inPlist:@"SUP"];
    [ConnectivitySettings setSUPSecurityConfiguration:securityConfig];
    
    NSString *appID = [SettingsUtilities getPreferenceValueOrDefaultValueForKey:@"supAppID" inPlist:@"SUP"];
    [ConnectivitySettings setSUPAppID:appID];
}


@end
