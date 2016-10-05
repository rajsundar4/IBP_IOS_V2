/*
 
 File: BaseEntityType.m
 Abstract: The base class for all OData entities. Inherits from BaseODataObject.
 
 */

#import "BaseEntityType.h"
#import "ODataDataParser.h"
#import "ODataParserException.h"
#import "Logger.h"
#import "ErrorHandling.h"

@implementation BaseEntityType

- (id)initWithSDMEntry:(ODataEntry *)aSDMEntry
{
    self = [super initWithSDMDictionary:aSDMEntry.fields];
    if (self) {
        m_SDMEntry = aSDMEntry;
        self.etag = aSDMEntry.etag;
        self.baseUrl = [NSURL URLWithString:aSDMEntry.entryID];
        [self loadNavigationPropertyQueries];
        [self loadNavigationPropertyData];
        [self loadMediaLinkProperties];
    }
    return self;
}

- (ODataEntry *)buildSDMEntryFromPropertiesAndReturnError:(NSError * __autoreleasing *)error;
{
    return nil;
}

- (ODataQuery *)getRelatedLinkForNavigationName:(NSString *)aNavigationName
{
    const ODataRelatedLink *relatedLink = [m_SDMEntry getRelatedLinkByNavigationPropertyName:aNavigationName];
    return [[ODataQuery alloc] initWithURL:[NSURL URLWithString:relatedLink.href]];
}

- (NSMutableArray *)getInlinedRelatedEntriesForNavigationName:(NSString *)aNavigationName
{
    const ODataRelatedLink *relatedLink = [m_SDMEntry getRelatedLinkByNavigationPropertyName:aNavigationName];
    return [[m_SDMEntry getInlinedRelatedEntriesForRelatedLink:relatedLink.href] mutableCopy];
}

- (NSString *)getTargetCollectionFromNavigationProperty:(NSString *)aNavigationProperty
{
    const ODataRelatedLink *relativeLink = [m_SDMEntry getRelatedLinkByNavigationPropertyName:aNavigationProperty];
    return relativeLink.targetCollection;
}

- (void)loadNavigationPropertyQueries
{
    
}

- (void)loadNavigationPropertyData
{
    
}

- (void)loadMediaLinkProperties
{
	
}

- (void)addRelativeLinksToSDMEntryFromDictionary:(NSMutableDictionary *)aDictionary
{
    NSString *relLinkBaseUrl = @"http://schemas.microsoft.com/ado/2007/08/dataservices/related/";
    NSMutableDictionary *allRelativeLinks = [@{} mutableCopy];
    // Iterate all key-values in the dictionary and for each add a relative link to the SDMODataEntry object
    for (NSString *key in [aDictionary allKeys]) {
        NSArray *inlinedSDMEntriesArray = aDictionary[key];
        if ([inlinedSDMEntriesArray count] > 0) {
            NSString *relLinkUrl = [relLinkBaseUrl stringByAppendingString:key];
            // add links
            ODataRelatedLink *link = [[ODataRelatedLink alloc] initWithHRef:relLinkUrl
                                                                       andLinkRel:relLinkUrl
                                                                      andLinkType:@"application/atom+xml;type=feed"
                                                                     andLinkTitle:key];
            // add sdmEntries to dictionary
            [m_SDMEntry addLink:link];
            allRelativeLinks[relLinkUrl] = inlinedSDMEntriesArray;
        }
    }
    
    if ([allRelativeLinks count] > 0) {
        [m_SDMEntry setInlinedRelatedEntries:allRelativeLinks];
    }
}

- (MediaLink *)getFirstMediaLinkFromArray:(NSArray *)mediaLinks
{
	if (mediaLinks.count > 0) {
		ODataMediaResourceLink *mediaLink = mediaLinks[0];
        ODataQuery *mediaLinkQuery = [[ODataQuery alloc] initWithURL:[NSURL URLWithString:mediaLink.href]];
		MediaLink *link = [[MediaLink alloc] initWithQuery:mediaLinkQuery andContentType:mediaLink.type];
		return link;
	}
	else {
		return nil;
	}
}

- (NSMutableArray *)createSDMEntriesForNavigationPropertyEntries:(NSArray *)anEntriesArray
{
    NSMutableArray *entries = [@[] mutableCopy];
    for (BaseEntityType *anEntry in anEntriesArray) {
        ODataEntry *entry = [anEntry buildSDMEntryFromPropertiesAndReturnError:nil];
        if (entry) {
            [entries addObject:entry];
        }
    }
    return entries;
}

- (MediaLink *)getMediaLinkForReading
{
	return [self getFirstMediaLinkFromArray:[m_SDMEntry getMediaLinksForReading]];
}

- (MediaLink *)getMediaLinkForEditing
{
	return [self getFirstMediaLinkFromArray:[m_SDMEntry getMediaLinksForEditing]];
}

+ (NSMutableArray *)getSDMEntriesForEntitySchema:(ODataEntitySchema *)anEntitySchema andData:(NSData *)aData andServiceDocument:(ODataServiceDocument *)aServiceDocument error:(NSError * __autoreleasing *)error
{
    NSMutableArray *sdmEntries = nil;
    if ([aData length] > 0) {
        @try {
            if (anEntitySchema) {
                ODataDataParser *dataParser = [[ODataDataParser alloc] initWithEntitySchema:anEntitySchema andServiceDocument:aServiceDocument];
                [dataParser parse:aData];
                sdmEntries = dataParser.entries;
                if (!sdmEntries) {
                    sdmEntries = [@[] mutableCopy];
                    NSString *noticeMessage = NSLocalizedString(@"The response contains no entries", @"The response contains no entries");
                    LOGNOTICE(noticeMessage);
#ifdef DEBUG
                    NSString *responseString = [[NSString alloc] initWithData:aData encoding:NSUTF8StringEncoding];
                    LOGNOTICE(responseString);
#endif
                }
            }
            else {
                NSString *errorMessage = NSLocalizedString(@"EntitySchema object must not be nil", @"EntitySchema object must not be nil");
                LOGERROR(errorMessage);
                if (error) {
                    *error = [[NSError alloc] initWithDomain:ERROR_DOMAIN code:SCHEMA_ERROR_CODE userInfo:@{NSLocalizedDescriptionKey: errorMessage}];
                }
            }
        }
        @catch(ODataParserException *e) {
            NSString *exceptionMessage = e.detailedError ? e.detailedError : [e description];
            NSString *localizedMessage = NSLocalizedString(@"Exception during parsing response data. Error:", @"Exception during parsing response data. Error:");
            NSString *errorMessage = [NSString stringWithFormat:@"%@ %@", localizedMessage, exceptionMessage];
            LOGERROR(errorMessage);
            if (error) {
                *error = [[NSError alloc] initWithDomain:ERROR_DOMAIN code:RESPONSE_PARSER_ERROR_CODE userInfo:@{NSLocalizedDescriptionKey: errorMessage}];
            }
#ifdef DEBUG
            NSString *responseString = [[NSString alloc] initWithData:aData encoding:NSUTF8StringEncoding];
            LOGERROR(responseString);
#endif
        }
    }
    else {
        LOGERROR(@"Response data is nil");
        if (error) {
            *error = [[NSError alloc] initWithDomain:ERROR_DOMAIN code:RESPONSE_PARSER_ERROR_CODE userInfo:@{NSLocalizedDescriptionKey: NSLocalizedString(@"Empty response data", @"Empty response data")}];
        }
    }
    return sdmEntries;
}

+ (NSMutableArray *)getSDMEntriesForEntitySchema:(ODataEntitySchema *)anEntitySchema andData:(NSData *)aData error:(NSError * __autoreleasing *)error
{
    return [BaseEntityType getSDMEntriesForEntitySchema:anEntitySchema andData:aData andServiceDocument:nil error:error];
}

+ (NSMutableArray *)getExpandedSDMEntriesForEntitySchema:(ODataEntitySchema *)anEntitySchema andData:(NSData *)aData andServiceDocument:(ODataServiceDocument *)aServiceDocument error:(NSError * __autoreleasing *)error
{
    return [BaseEntityType getSDMEntriesForEntitySchema:anEntitySchema andData:aData andServiceDocument:aServiceDocument error:error];
}


+ (BaseODataObject *)getFirstObjectFromArray:(NSArray *)array
{
    if (array.count > 0) {
		return array[0];
	}
	return nil;
    
}

+ (ODataEntry *)createEmptySDMODataEntryWithSchema:(ODataEntitySchema *)aSchema error:(NSError * __autoreleasing *)error
{
    if (aSchema) {
        return [[ODataEntry alloc] initWithEntitySchema:aSchema];
    }
    else {
        NSString *errorMessage = NSLocalizedString(@"EntitySchema object must not be nil", @"EntitySchema object must not be nil");
        LOGERROR(errorMessage);
        if (error) {
            *error = [[NSError alloc] initWithDomain:ERROR_DOMAIN code:SCHEMA_ERROR_CODE userInfo:@{NSLocalizedDescriptionKey: errorMessage}];
        }
        return nil;
    }
}

@end
