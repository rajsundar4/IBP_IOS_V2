/*
 
 File: BaseServiceObject.m
 Abstract: The base class for the generated OData service class.
 
 */

#import "BaseServiceObject.h"
#import "ODataServiceDocumentParser.h"
#import "ODataMetaDocumentParser.h"
#import "ODataCollection.h"
#import "ODataLink.h"
#import "ODataDataParser.h"
#import "ODataFunctionImport.h"
#import "ODataFunctionImportResultParser.h"
#import "Logger.h"
#import "ODataXMLBuilder.h"
#import "ODataParserException.h"
#import "ErrorHandling.h"

#define DEFAULT_SERVICE_DOCUMENT @"ServiceDocument"
#define DEFAULT_SERVICE_METADATA @"ServiceMetadata"


@implementation BaseServiceObject

- (id)init
{
    NSString *serviceDocPath = [[NSBundle mainBundle] pathForResource:[self getServiceDocumentFilename] ofType:@"xml"];
    NSString *serviceMetadataPath = [[NSBundle mainBundle] pathForResource:[self getServiceMetadataFilename] ofType:@"xml"];
    
    NSData *serviceDocData = [NSData dataWithContentsOfFile:serviceDocPath];
    NSData *serviceMetadataData = [NSData dataWithContentsOfFile:serviceMetadataPath];
    
    return [self initWithServiceDocument:serviceDocData andMedatadata:serviceMetadataData];
}

- (id)initWithServiceDocument:(NSData *)aServiceDocument andMedatadata:(NSData *)aMetadata
{
    if(self = [super init]){
#ifdef DEBUG
        [Logger enableSDMDetailedLogging];
#endif
        @try {
            ODataServiceDocumentParser *sdmDocParser = [[ODataServiceDocumentParser alloc] init];
            [sdmDocParser parse:aServiceDocument];
            _sdmServiceDocument = sdmDocParser.serviceDocument;
            
            //Load the object with metadata xml:
            ODataMetaDocumentParser *sdmMetadataParser = [[ODataMetaDocumentParser alloc] initWithServiceDocument:self.sdmServiceDocument];
            [sdmMetadataParser parse:aMetadata];
        }
        @catch(ODataParserException *e) {
            NSString *exceptionMessage = e.detailedError ? e.detailedError : [e description];
            NSString *errorMessage = [NSString stringWithFormat:@"Exception during parsing Service Document or Metadata: %@", exceptionMessage];
            LOGERROR(errorMessage);
            return nil;
        }
    }
    
    [self loadEntitySetQueries];
    [self loadLabels];
    [self loadEntitySchemaForAllEntityTypes];
    
    return self;
}

- (NSString *)getServiceDocumentFilename
{
    return DEFAULT_SERVICE_DOCUMENT;
}

- (NSString *)getServiceMetadataFilename
{
    return DEFAULT_SERVICE_METADATA;
}

- (void)setServiceDocumentUrl:(NSString *)baseUrl
{
    self.sdmServiceDocument.baseUrl = baseUrl;
    [self loadEntitySetQueries];
}

- (ODataQuery *)getServiceDocumentQuery
{
    return [self getQueryForRelativePath:@""];
}

- (void)loadEntitySetQueries
{
    
}

- (void)loadEntitySchemaForAllEntityTypes
{
    
}

-(void)loadLabels
{
    
}

- (ODataQuery *)getQueryForRelativePath:(NSString *)aRelativeResourcePath
{
    NSMutableString *absoluteUrl = [NSMutableString stringWithString:self.sdmServiceDocument.baseUrl];
	if (![absoluteUrl hasSuffix:@"/"]) {
        [absoluteUrl appendString:@"/"];
    }
    [absoluteUrl appendString:aRelativeResourcePath];
    NSString *encodedAbsoluteUrl = [ODataQuery encodeURLLoosely:absoluteUrl];
    return [[ODataQuery alloc] initWithURL:[NSURL URLWithString:encodedAbsoluteUrl]];
}

- (BaseODataObject *)getFirstObjectFromArray:(NSArray *)array
{
	if (array.count > 0) {
		return array[0];
	}
	return nil;
}

- (NSMutableArray *)getSDMEntriesForFunctionImportName:(NSString *)aFunctionImportName andData:(NSData *)aData error:(NSError * __autoreleasing *)error
{
    NSMutableArray *sdmEntries = nil;
    if (aData) {
        @try {
            ODataFunctionImport *functionImport = [self.sdmServiceDocument getFunctionImports][aFunctionImportName];
            if (functionImport) {
                ODataFunctionImportResultParser *parser = [[ODataFunctionImportResultParser alloc] initWithFunctionImport:functionImport];
                [parser parse:aData];
                sdmEntries = parser.entries;
                if (!sdmEntries) {
                    sdmEntries = [@[] mutableCopy];
                    NSString *noticeMessage = [NSString stringWithFormat:@"The response contains no entries"];
                    LOGNOTICE(noticeMessage);
#ifdef DEBUG
                    NSString *responseString = [[NSString alloc] initWithData:aData encoding:NSUTF8StringEncoding];
                    LOGNOTICE(responseString);
#endif
                }
            }
            else {
            	NSString *localizedMessage = NSLocalizedString(@"FunctionImport %@ not found in the service metadata", @"FunctionImport %@ not found in the service metadata");
                NSString *errorMessage = [NSString stringWithFormat:localizedMessage, aFunctionImportName];
                LOGERROR(errorMessage);
                if (error) {
                    *error = [[NSError alloc] initWithDomain:ERROR_DOMAIN code:SCHEMA_ERROR_CODE userInfo:@{NSLocalizedDescriptionKey: errorMessage}];
                }
            }
        }
        @catch(ODataParserException *e) {
            NSString *exceptionMessage = e.detailedError ? e.detailedError : [e description];
            NSString *localizedMessage = NSLocalizedString(@"Exception during parsing response data. Error: %@", @"Exception during parsing response data. Error: %@");
            NSString *errorMessage = [NSString stringWithFormat:localizedMessage, exceptionMessage];
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
    return sdmEntries;
}


- (ODataPropertyValueObject *)getSDMPropertyEDMValueForFunctionImportSDMEntry:(ODataEntry *)anEntry
{
    return [anEntry getFields][@"element"];
}

- (NSString *)getStringValueForFunctionImportSDMEntry:(ODataEntry *)anEntry
{
    ODataPropertyValueString *SDMValue = (ODataPropertyValueString *)[self getSDMPropertyEDMValueForFunctionImportSDMEntry:anEntry];
    return [SDMValue getValue];
}


- (NSDate *)getDateTimeValueForFunctionImportSDMEntry:(ODataEntry *)anEntry
{
    ODataPropertyValueDateTime *SDMValue = (ODataPropertyValueDateTime *)[self getSDMPropertyEDMValueForFunctionImportSDMEntry:anEntry];
    return [SDMValue getDateValue];
}


- (NSDecimalNumber *)getDecimalValueForFunctionImportSDMEntry:(ODataEntry *)anEntry
{
    ODataPropertyValueDecimal *SDMValue = (ODataPropertyValueDecimal *)[self getSDMPropertyEDMValueForFunctionImportSDMEntry:anEntry];
    return [SDMValue getDecimalValue];
}


- (NSNumber *)getIntValueForFunctionImportSDMEntry:(ODataEntry *)anEntry
{
    ODataPropertyValueInt *SDMValue = (ODataPropertyValueInt *)[self getSDMPropertyEDMValueForFunctionImportSDMEntry:anEntry];
    return [SDMValue getIntValue];
}


- (NSNumber *)getBooleanValueForFunctionImportSDMEntry:(ODataEntry *)anEntry
{
    ODataPropertyValueBoolean *SDMValue = (ODataPropertyValueBoolean *)[self getSDMPropertyEDMValueForFunctionImportSDMEntry:anEntry];
    return [SDMValue getBooleanValue];
}


- (NSNumber *)getSingleValueForFunctionImportSDMEntry:(ODataEntry *)anEntry
{
    ODataPropertyValueSingle *SDMValue = (ODataPropertyValueSingle *)[self getSDMPropertyEDMValueForFunctionImportSDMEntry:anEntry];
    return [SDMValue getSingleValue];
}

- (NSNumber *)getDoubleValueForFunctionImportSDMEntry:(ODataEntry *)anEntry
{
    ODataPropertyValueDouble *SDMValue = (ODataPropertyValueDouble *)[self getSDMPropertyEDMValueForFunctionImportSDMEntry:anEntry];
    return [SDMValue getDoubleValue];
}


- (NSString *)getGuidValueForFunctionImportSDMEntry:(ODataEntry *)anEntry
{
    ODataPropertyValueGuid *SDMValue = (ODataPropertyValueGuid *)[self getSDMPropertyEDMValueForFunctionImportSDMEntry:anEntry];
    return [SDMValue getValue];
}


- (NSString *)getDateTimeOffsetValueForFunctionImportSDMEntry:(ODataEntry *)anEntry
{
    ODataPropertyValueDateTimeOffset *SDMValue = (ODataPropertyValueDateTimeOffset *)[self getSDMPropertyEDMValueForFunctionImportSDMEntry:anEntry];
    return [SDMValue getValue];
}


- (NSMutableData *)getBinaryValueForFunctionImportSDMEntry:(ODataEntry *)anEntry
{
    ODataPropertyValueBinary *SDMValue = (ODataPropertyValueBinary *)[self getSDMPropertyEDMValueForFunctionImportSDMEntry:anEntry];
    return [SDMValue getBinaryData];
}


- (ODataDuration *)getTimeValueForFunctionImportSDMEntry:(ODataEntry *)anEntry
{
    ODataPropertyValueTime *SDMValue = (ODataPropertyValueTime *)[self getSDMPropertyEDMValueForFunctionImportSDMEntry:anEntry];
    return [SDMValue getTimeValue];
}

- (NSString *)getXMLFromEntity:(BaseEntityType *)anEntity andOperation:(const enum TEN_ENTRY_OPERATIONS) operation error:(NSError * __autoreleasing *)error
{
    ODataEntry *newEntry = [anEntity buildSDMEntryFromPropertiesAndReturnError:error];
    
    // if an error occured while constructing the SDMODataEntry, return nil
    if (!newEntry) {
        return nil;
    }
    if ([newEntry isValid]) {
        ODataEntryBody *entryXml = nil;
        @try {
            entryXml = buildODataEntryRequestBody(newEntry, operation, self.sdmServiceDocument, YES, BUILD_STYLE_ATOM_XML);
#ifdef DEBUG
            NSString *noticeMsg = [NSString stringWithFormat:@"xml:\n %@\nmethod: %@", entryXml.body, entryXml.method];
            LOGNOTICE(noticeMsg);
#endif
            return [entryXml body];
        }
        @catch (ODataParserException *e) {
        	NSString *localizedMessage = NSLocalizedString(@"Exception during building entry xml: %@", @"Exception during building entry xml: %@");
            NSString *exceptionMsg = [NSString stringWithFormat:localizedMessage, e.detailedError];
            LOGERROR(exceptionMsg);
            if (error) {
                *error = [[NSError alloc] initWithDomain:ERROR_DOMAIN code:SDM_ENTRY_XML_BUILDER_ERROR_CODE userInfo:@{NSLocalizedDescriptionKey: exceptionMsg}];
            }
        }
    }
    else {
        NSString *errorMsg = @"The entry is not a valid entry";
        LOGERROR(errorMsg);
        if (error) {
            *error = [[NSError alloc] initWithDomain:ERROR_DOMAIN code:SDM_ENTRY_INVALID_ERROR_CODE userInfo:@{NSLocalizedDescriptionKey: errorMsg}];
        }
        
    }
    return nil;
}

- (NSString *)getXMLForCreateRequest:(BaseEntityType *)anEntity error:(NSError * __autoreleasing *)error
{
    return [self getXMLFromEntity:anEntity andOperation:ENTRY_OPERATION_CREATE error:error];
}

- (NSString *)getXMLForUpdateRequest:(BaseEntityType *)anEntity error:(NSError * __autoreleasing *)error
{
    return [self getXMLFromEntity:anEntity andOperation:ENTRY_OPERATION_UPDATE_FULL error:error];
}

@end
