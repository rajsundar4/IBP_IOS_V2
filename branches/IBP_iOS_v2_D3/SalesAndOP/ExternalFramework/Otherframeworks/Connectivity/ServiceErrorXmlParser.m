/*
 
 File: ServiceErrorXmlParser.m
 Abstract: Parsing server error xmls.
 
 */

#import "ServiceErrorXmlParser.h"

@implementation ServiceError

@end

@implementation ServiceErrorXmlParser

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (id)initWithErrorData:(NSData *)data
{
    self = [super init];
    if (self) {
        parser = [[NSXMLParser alloc] initWithData:data];
        [parser setDelegate:self];
    }
    return self;
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    [currentString appendString:string];
}

// init the error object in case that there is error element tag.
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    elementName = [elementName lowercaseString];
    if([elementName isEqualToString:@"error"]){
        error = [[ServiceError alloc] init];
    }
    else{
        currentString = [@"" mutableCopy];
    }
}


// parsing the xml and initialize the following properties - error code number, error message and error inner message.
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    elementName = [elementName lowercaseString];
    if([elementName isEqualToString:@"error"]){
        return;
    } else if([elementName isEqualToString:@"code"]){
        error.errorCode = currentString;
    }
    else if([elementName isEqualToString:@"message"]){
        error.message = currentString;
    }
    else if([elementName isEqualToString:@"innererror"]){
        error.innerMessage = currentString;
    }
}


// Return the Service error object
- (ServiceError *)result
{
    return error;
}

//Returns YES if successful to parse, and NO in case of error.
- (BOOL)parse
{
    return [parser parse];
}


@end
