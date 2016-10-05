/*
 
 File: ServiceNegotiator.m
 Abstract: Responsible for finding the best matching service for a given service name and versions.
 
 */

#import "ServiceNegotiator.h"
#import "Logger.h"

@implementation ServiceNegotiator

#pragma mark - Private Helper Methods

- (NSString *)getValidUrl:(NSString *)url
{
    if ([url hasSuffix:@"/"]) {
		return url;
	}
	else {
		return [NSString stringWithFormat:@"%@/", url];
	}
}

- (NSString *)getCatalogServiceUrlWithServiceUrl:(NSString *)url andCatalogRelativeUrl:(NSString *)catalogUrl
{
	NSURL *serviceUrl = [NSURL URLWithString:[ODataQuery encodeURLLoosely:url]];
	NSString *scheme = serviceUrl.scheme;
	NSString *host = serviceUrl.host;
	NSNumber *port = serviceUrl.port;
	
	return [self getValidUrl:[NSString stringWithFormat:@"%@://%@:%@%@", scheme, host, port, catalogUrl]];
}

- (BOOL)parseBestMatchingServiceResponseData:(NSData *)responseData
{
    NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:responseData];
    xmlParser.delegate = self;
    if ([xmlParser parse]) {
		_bestMatchingServiceUrl = [self getValidUrl:serviceUrlString];
		_bestMatchingServiceVersion = serviceVersionString;
		NSString *msg = [NSString stringWithFormat:@"BestMatchingService Result URL: %@ Version: %@", self.bestMatchingServiceUrl, self.bestMatchingServiceVersion];
		LOGNOTICE(msg);
		return YES;
	}
	return NO;
}

- (BOOL)validateServiceNegotiationParams
{
	if (!catalogServiceUrl || catalogServiceUrl.length == 0) {
		LOGERROR(@"Invalid or missing catalog service URL");
		return NO;
	}
	if (!self.technicalServiceName || self.technicalServiceName.length == 0) {
		LOGERROR(@"Invalid or missing technical service name");
		return NO;
	}
	if (self.technicalServiceVersionMin < 0) {
		LOGERROR(@"Invalid min service version value");
		return NO;
	}
	if (self.technicalServiceVersionMax < 1) {
		LOGERROR(@"Invalid max service version value");
		return NO;
	}
	if (self.technicalServiceVersionMax < self.technicalServiceVersionMin) {
		LOGERROR(@"Invalid service version values");
		return NO;
	}
	return YES;
}

#pragma mark - Property Methods

- (void)setTechnicalServiceName:(NSString *)value
{
	if (!value || value.length == 0) {
		LOGERROR(@"Invalid or missing technical service name");
	}
	else {
		_technicalServiceName = value;
	}
}

- (void)setTechnicalServiceVersionMin:(NSInteger)value
{
	if (value < 0) {
		LOGERROR(@"Invalid min service version value");
	}
	else {
		_technicalServiceVersionMin = value;
	}
}

- (void)setTechnicalServiceVersionMax:(NSInteger)value
{
	if (value < 1) {
		LOGERROR(@"Invalid max service version value");
	}
	else {
		_technicalServiceVersionMax = value;
	}
}

#pragma mark - Initialization

- (id)initWithServiceUrl:(NSString *)url andCatalogRelativeUrl:(NSString *)catalogUrl
{
	self = [super init];
	if (self) {
		catalogServiceUrl = [self getCatalogServiceUrlWithServiceUrl:url andCatalogRelativeUrl:catalogUrl];
		_technicalServiceName = [NSString string];
		_technicalServiceVersionMin = 0;
		_technicalServiceVersionMax = 0;
		
		_bestMatchingServiceUrl = [NSString string];
		_bestMatchingServiceVersion = [NSString string];
	}
	return self;
}

#pragma mark - Public Methods

- (ODataQuery *)getBestMatchingServiceQuery
{
	if ([self validateServiceNegotiationParams]) {
		NSString *serviceNameParam = [NSString stringWithFormat:@"TechnicalServiceName='%@'", _technicalServiceName];
		NSString *minVersionParam = [NSString stringWithFormat:@"TechnicalServiceVersionMin=%d", _technicalServiceVersionMin];
		NSString *maxVersionParam = [NSString stringWithFormat:@"TechnicalServiceVersionMax=%d", _technicalServiceVersionMax];
		
		return [[ODataQuery alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@BestMatchingService?%@&%@&%@", catalogServiceUrl, serviceNameParam, minVersionParam, maxVersionParam]]];
	}
	else {
		return nil;
	}
}

- (BOOL)parseBestMatchingServiceResultWithData:(NSData *)data
{
	if (!data || data.length == 0) {
		LOGERROR(@"Invalid result data.");
		return NO;
	}
    return [self parseBestMatchingServiceResponseData:data];
}


#pragma mark - NSXMLParserDelegate

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if (startServiceUrlElement) {
        serviceUrlString = [serviceUrlString stringByAppendingString:string];
    }
	else if (startServiceVersionElement) {
		serviceVersionString = [serviceVersionString stringByAppendingString:string];
	}
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    NSString *lowercaseElementName = [elementName lowercaseString];
    if ([lowercaseElementName isEqualToString:@"d:serviceurl"] || [lowercaseElementName isEqualToString:@"serviceurl"]) {
        startServiceUrlElement = YES;
        serviceUrlString = [NSString string];
    }
	else if ([lowercaseElementName isEqualToString:@"d:technicalserviceversion"] || [lowercaseElementName isEqualToString:@"technicalserviceversion"]) {
        startServiceVersionElement = YES;
        serviceVersionString = [NSString string];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    NSString *lowercaseElementName = [elementName lowercaseString];
    if ([lowercaseElementName isEqualToString:@"d:serviceurl"] || [lowercaseElementName isEqualToString:@"serviceurl"]) {
        startServiceUrlElement = NO;
    }
	else if ([lowercaseElementName isEqualToString:@"d:technicalserviceversion"] || [lowercaseElementName isEqualToString:@"technicalserviceversion"]) {
        startServiceVersionElement = NO;
    }
}

@end