/*
 
 File: ServiceErrorXmlParser.h
 Abstract: Parsing server error xmls.
 
 */

#import <Foundation/Foundation.h>

// Class which hold the service error
@interface ServiceError: NSObject

@property (nonatomic,strong) NSString *errorCode; // The service error code.
@property (nonatomic,strong) NSString *message; // The service error message.
@property (nonatomic,strong) NSString *innerMessage; // The service error inner messgae.

@end

// Class which parsing the service error xml.
@interface ServiceErrorXmlParser : NSObject<NSXMLParserDelegate> {
    NSXMLParser *parser;
    ServiceError *error;
    NSMutableString *currentString;
}

- (ServiceError *)result;
- (BOOL)parse;
- (id)initWithErrorData:(NSData *)data;

@end
