/*
 
 File: SettingsUtilities.h
 Abstract: A utility class responsible for reading the application settings (as the service URL, the SAP client and the authentication configurations).
 
 */

#import <Foundation/Foundation.h>
#import "ConnectivitySettings.h"


/**
 A utility class responsible for reading the application settings (as the service URL, the SAP client and the authentication configurations).
 */
@interface SettingsUtilities : NSObject

/**
 @return The service URL from the application settings.
 */
+ (NSString *)getServiceUrlFromUserSettings;

/**
 @return The service SAP Client from the application settings.
 */
+ (NSString *)getServiceClientFromUserSettings;

/**
 Update ConnectivitySettings parameters from the application settings.
 */
+ (void)updateConnectivitySettingsFromUserSettings;


@end
