/*
  
 File: ODataQuery.m
 Abstract: Represents an OData query. Provides the functionality
 to create an OData query URL with parameters.
 
*/


#import "ODataQuery.h"

// SAP OData Mobile SDK Imports
#import "Logger.h"

@implementation ODataQuery

+ (NSString *)encodeURLParameter:(NSString*)aParameterString
{
    NSString * encodedString = 
    (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                         (__bridge_retained CFStringRef)aParameterString,
                                                                          NULL,
                                                                         (CFStringRef)@"\"!*'();:@&=+$,/?%#[]",
                                                                          kCFStringEncodingUTF8 );
    return encodedString;
}

+ (NSString *)encodeURLLoosely:(NSString*)aUrlString
{
    NSString * encodedString = 
    (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                          (__bridge_retained CFStringRef)aUrlString,
                                                                          (CFStringRef)@"%",
                                                                          (CFStringRef)@"\"!*@+#[]",
                                                                          kCFStringEncodingUTF8 );
    return encodedString;
}


- (NSURL *)getUrl
{
    if (![m_baseUrl absoluteString]) {
        return nil;
    }
    
    NSMutableString *absoluteUrlString = [NSMutableString stringWithString:[m_baseUrl absoluteString]];
    
    for (NSString *key in m_additionalParameters) {
        NSString *value = m_additionalParameters[key];
        NSRange rangeOfDash = [absoluteUrlString rangeOfString:@"?"];
        if (rangeOfDash.location != NSNotFound) {
            [absoluteUrlString appendString:[NSString stringWithFormat:@"&%@=%@",key,value]];
        }
        else {
            [absoluteUrlString appendString:[NSString stringWithFormat:@"?%@=%@",key,value]];
        }
    }
    
//    NSLog(@"absoluteUrlString - %@",absoluteUrlString);
    
    return [NSURL URLWithString:absoluteUrlString];
}

- (id)initWithURL:(NSURL *)baseUrl
{
    if(self = [super init]){
        m_additionalParameters = [[NSMutableDictionary alloc] init];
        m_baseUrl = baseUrl;
    }
    return self;
}

- (void)addParameterWithKey:(NSString *)parameterKey andValue:(NSString *)parameterValue
{
    if (([parameterKey length] > 0) && ([parameterValue length] > 0)) {
        m_additionalParameters[parameterKey] = [ODataQuery encodeURLParameter:parameterValue];
    }    
}

- (void)filter:(NSString *)filterStringValue
{
    [self addParameterWithKey:@"$filter" andValue:filterStringValue];
}

- (void)orderBy:(NSString *)orderByStringValue
{
    [self addParameterWithKey:@"$orderby" andValue:orderByStringValue];
}

- (void)select:(NSString*)selectStringValue
{
    [self addParameterWithKey:@"$select" andValue:selectStringValue];
}

- (void)expand:(NSString *)expandStringValue
{
    [self addParameterWithKey:@"$expand" andValue:expandStringValue];
}

@end
