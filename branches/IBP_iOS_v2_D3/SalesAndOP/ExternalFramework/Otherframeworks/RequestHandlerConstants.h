/*
 
 File: RequestHandlerConstants.h
 Abstract: Request Handler Constants
 
 */

#import <Foundation/Foundation.h>

#pragma mark - Notifications

//Notification UserInfo keys:
extern NSString * const kResponseItem; ///< Single item response
extern NSString * const kResponseItems; ///< Multiple items response
extern NSString * const kResponseData; ///< Raw response data
extern NSString * const kRequestedMediaLink; ///< Media link item
extern NSString * const kServerResponseError; ///< Server response error
extern NSString * const kParsingError; ///< Parsing response error
extern NSString * const kResponseParentItem; ///< Item selected in the view previous to the one triggered the request

//Notification keys:
extern NSString * const kAuthenticationNeededNotification; ///< Notification key for request authentication challenge.

#pragma mark - Certificate

extern NSString * const kCertificateFileName; ///< Certificate file name
extern NSString * const kCertificateFileExtension; ///< Certificate file extension
extern NSString * const kCertificatePassword; ///< certificate password

@interface RequestHandlerConstants : NSObject

@end
