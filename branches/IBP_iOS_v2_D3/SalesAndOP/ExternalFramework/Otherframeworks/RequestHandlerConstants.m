/*
 
 File: RequestHandlerConstants.m
 Abstract: Request Handler Constants
 
 */

#import "RequestHandlerConstants.h"

NSString * const kResponseItem = @"item";
NSString * const kResponseItems = @"items";
NSString * const kResponseData = @"data";
NSString * const kRequestedMediaLink = @"mediaLink";
NSString * const kServerResponseError = @"serverError";
NSString * const kParsingError = @"parsingError";
NSString * const kResponseParentItem = @"parent";

// Notification keys:
NSString * const kAuthenticationNeededNotification = @"AuthenticationNeeded";

// Client Certificate Constants:
NSString * const kCertificateFileName = @"client_certificate";
NSString * const kCertificateFileExtension = @"pfx";
/** TODO: Make sure to set this value with the password of the certificate supplied with the application bundle, if client certificate authentication is used. */
NSString * const kCertificatePassword = @"ENTER CERTIFICATE PASSWORD HERE";

@implementation RequestHandlerConstants

@end
