/*
  
 File: BaseODataObject.m
 Abstract: The base class for all OData classes which represent OData types.
  
*/


#import "BaseODataObject.h"

// SAP OData Mobile SDK Imports
#import "ODataEntitySchema.h"
#import "ODataCollection.h"
#import "Logger.h"
#import "ErrorHandling.h"

@implementation BaseODataObject

+ (NSMutableDictionary *)getSchemaPropertiesFromCollection:(NSString *)aCollectionName andService:(ODataServiceDocument *)aSDMServiceDocument
{
    ODataSchema *schema = aSDMServiceDocument.schema;
    ODataCollection *entityCollection = [schema getCollectionByName:aCollectionName];
    if (!entityCollection) {
    	NSString *localizedMessage = NSLocalizedString(@"Collection %@ not found in the service metadata", @"Collection %@ not found in the service metadata");
        NSString *errorMessage = [NSString stringWithFormat:localizedMessage, aCollectionName];
        LOGERROR(errorMessage);
        return nil;
    }
	return entityCollection.entitySchema.root.children;
}

+ (NSString *)getLabelFromDictionary:(NSMutableDictionary *)aLabelDictionary forProperty:(NSString *)aPropertyName
{
    NSString *propertyLabel = nil;
    if (aLabelDictionary) {
        propertyLabel = aLabelDictionary[aPropertyName];
        if ((![propertyLabel isKindOfClass:[NSString class]]) || ([propertyLabel length] == 0)) { //Label was not found for property
            propertyLabel = aPropertyName; //Return the property name if the label is not defined
        }
    }
    else {
        LOGWARNING(@"Labels dictionary was not initialized. Call the loadLabels method of the appropriate entity class");   
    }
    return propertyLabel;
}

+ (BOOL)setStringValueForSDMEntry:(ODataEntry *)aSDMEntry withValue:(NSString *)aValue forSDMPropertyWithName:(NSString *)aName error:(NSError * __autoreleasing *)error
{
	BOOL result = YES;
    @try {
        ODataPropertyValueString *property = (ODataPropertyValueString *)[aSDMEntry getPropertyValueByPath:aName];
        [property setValue:aValue];
    }
    @catch (NSException* e) {
    	result = NO;
    	NSString *localizedMessage = NSLocalizedString(@"Exception during setting value %@ to property %@. Exception: %@", @"Exception during setting value %@ to property %@. Exception: %@");
        NSString *exceptionMsg = [NSString stringWithFormat:localizedMessage, aValue, aName, e.description];
        LOGERROR(exceptionMsg);        
        if (error) {
            *error = [[NSError alloc] initWithDomain:ERROR_DOMAIN code:SDM_ENTRY_PROPERTY_VALUE_ERROR_CODE userInfo:@{NSLocalizedDescriptionKey: exceptionMsg}];
        }
    }
    return result;
}

+ (BOOL)setDateTimeValueForSDMEntry:(ODataEntry *)aSDMEntry withValue:(NSDate *)aValue forSDMPropertyWithName:(NSString *)aName error:(NSError * __autoreleasing *)error
{
	BOOL result = YES;
    @try {
        ODataPropertyValueDateTime *property = (ODataPropertyValueDateTime *)[aSDMEntry getPropertyValueByPath:aName];
        [property setDateValue:aValue];
    }
    @catch (NSException* e) {
    	result = NO;
    	NSString *localizedMessage = NSLocalizedString(@"Exception during setting value %@ to property %@. Exception: %@", @"Exception during setting value %@ to property %@. Exception: %@");
        NSString *exceptionMsg = [NSString stringWithFormat:localizedMessage, aValue, aName, e.description];
        LOGERROR(exceptionMsg);
        if (error) {
            *error = [[NSError alloc] initWithDomain:ERROR_DOMAIN code:SDM_ENTRY_PROPERTY_VALUE_ERROR_CODE userInfo:@{NSLocalizedDescriptionKey: exceptionMsg}];
        }
    }
    return result;
}

+ (BOOL)setDecimalValueForSDMEntry:(ODataEntry *)aSDMEntry withValue:(NSDecimalNumber *)aValue forSDMPropertyWithName:(NSString *)aName error:(NSError * __autoreleasing *)error
{
	BOOL result = YES;
    @try {
        ODataPropertyValueDecimal *property = (ODataPropertyValueDecimal *)[aSDMEntry getPropertyValueByPath:aName];
        [property setDecimalValue:aValue];
    }
    @catch (NSException *e) {
    	result = NO;
    	NSString *localizedMessage = NSLocalizedString(@"Exception during setting value %@ to property %@. Exception: %@", @"Exception during setting value %@ to property %@. Exception: %@");
        NSString *exceptionMsg = [NSString stringWithFormat:localizedMessage, aValue, aName, e.description];
        LOGERROR(exceptionMsg);
        if (error) {
            *error = [[NSError alloc] initWithDomain:ERROR_DOMAIN code:SDM_ENTRY_PROPERTY_VALUE_ERROR_CODE userInfo:@{NSLocalizedDescriptionKey: exceptionMsg}];
        }
    }
    return result;
}

+ (BOOL)setIntValueForSDMEntry:(ODataEntry *)aSDMEntry withValue:(NSNumber *)aValue forSDMPropertyWithName:(NSString *)aName error:(NSError * __autoreleasing *)error
{
	BOOL result = YES;
    @try {
        ODataPropertyValueInt *property = (ODataPropertyValueInt *)[aSDMEntry getPropertyValueByPath:aName];
        [property setIntValue:aValue];
    }
    @catch (NSException *e) {
    	result = NO;
    	NSString *localizedMessage = NSLocalizedString(@"Exception during setting value %@ to property %@. Exception: %@", @"Exception during setting value %@ to property %@. Exception: %@");
        NSString *exceptionMsg = [NSString stringWithFormat:localizedMessage, aValue, aName, e.description];
        LOGERROR(exceptionMsg);
        if (error) {
            *error = [[NSError alloc] initWithDomain:ERROR_DOMAIN code:SDM_ENTRY_PROPERTY_VALUE_ERROR_CODE userInfo:@{NSLocalizedDescriptionKey: exceptionMsg}];
        }
    }
    return result;
}

+ (BOOL)setBooleanValueForSDMEntry:(ODataEntry *)aSDMEntry withValue:(NSNumber *)aValue forSDMPropertyWithName:(NSString *)aName error:(NSError * __autoreleasing *)error
{
	BOOL result = YES;
    @try {
        ODataPropertyValueBoolean *property = (ODataPropertyValueBoolean *)[aSDMEntry getPropertyValueByPath:aName];
        [property setBooleanValue:aValue];
    }
    @catch (NSException *e) {
        result = NO;
        NSString *localizedMessage = NSLocalizedString(@"Exception during setting value %@ to property %@. Exception: %@", @"Exception during setting value %@ to property %@. Exception: %@");
        NSString *exceptionMsg = [NSString stringWithFormat:localizedMessage, aValue, aName, e.description];
        LOGERROR(exceptionMsg);
        if (error) {
            *error = [[NSError alloc] initWithDomain:ERROR_DOMAIN code:SDM_ENTRY_PROPERTY_VALUE_ERROR_CODE userInfo:@{NSLocalizedDescriptionKey: exceptionMsg}];
        }
    }
    return result;
}

+ (BOOL)setSingleValueForSDMEntry:(ODataEntry *)aSDMEntry withValue:(NSNumber *)aValue forSDMPropertyWithName:(NSString *)aName error:(NSError * __autoreleasing *)error
{
	BOOL result = YES;
    @try {
        ODataPropertyValueSingle *property = (ODataPropertyValueSingle *)[aSDMEntry getPropertyValueByPath:aName];
        [property setSingleValue:aValue];
    }
    @catch (NSException *e) {
    	result = NO;
    	NSString *localizedMessage = NSLocalizedString(@"Exception during setting value %@ to property %@. Exception: %@", @"Exception during setting value %@ to property %@. Exception: %@");
        NSString *exceptionMsg = [NSString stringWithFormat:localizedMessage, aValue, aName, e.description];
        LOGERROR(exceptionMsg);
        if (error) {
            *error = [[NSError alloc] initWithDomain:ERROR_DOMAIN code:SDM_ENTRY_PROPERTY_VALUE_ERROR_CODE userInfo:@{NSLocalizedDescriptionKey: exceptionMsg}];
        }
    }
    return result;
}

+ (BOOL)setDoubleValueForSDMEntry:(ODataEntry *)aSDMEntry withValue:(NSNumber *)aValue forSDMPropertyWithName:(NSString *)aName error:(NSError * __autoreleasing *)error
{
	BOOL result = YES;
    @try {
        ODataPropertyValueDouble *property = (ODataPropertyValueDouble *)[aSDMEntry getPropertyValueByPath:aName];
        [property setDoubleValue:aValue];
    }
    @catch (NSException *e) {
    	result = NO;
    	NSString *localizedMessage = NSLocalizedString(@"Exception during setting value %@ to property %@. Exception: %@", @"Exception during setting value %@ to property %@. Exception: %@");
        NSString *exceptionMsg = [NSString stringWithFormat:localizedMessage, aValue, aName, e.description];
        LOGERROR(exceptionMsg);
        if (error) {
            *error = [[NSError alloc] initWithDomain:ERROR_DOMAIN code:SDM_ENTRY_PROPERTY_VALUE_ERROR_CODE userInfo:@{NSLocalizedDescriptionKey: exceptionMsg}];
        }
    }
    return result;
}

+ (BOOL)setGuidValueForSDMEntry:(ODataEntry *)aSDMEntry withValue:(NSString *)aValue forSDMPropertyWithName:(NSString *)aName error:(NSError * __autoreleasing *)error
{
	BOOL result = YES;
    @try {
        ODataPropertyValueGuid *property = (ODataPropertyValueGuid *)[aSDMEntry getPropertyValueByPath:aName];
        [property setValue:aValue];
    }
    @catch (NSException *e) {
    	result = NO;
    	NSString *localizedMessage = NSLocalizedString(@"Exception during setting value %@ to property %@. Exception: %@", @"Exception during setting value %@ to property %@. Exception: %@");
        NSString *exceptionMsg = [NSString stringWithFormat:localizedMessage, aValue, aName, e.description];
        LOGERROR(exceptionMsg);
        if (error) {
            *error = [[NSError alloc] initWithDomain:ERROR_DOMAIN code:SDM_ENTRY_PROPERTY_VALUE_ERROR_CODE userInfo:@{NSLocalizedDescriptionKey: exceptionMsg}];
        }
    }
    return result;
}

+ (BOOL)setDateTimeOffsetValueForSDMEntry:(ODataEntry *)aSDMEntry withValue:(NSString *)aValue forSDMPropertyWithName:(NSString *)aName error:(NSError * __autoreleasing *)error
{
	BOOL result = YES;
    @try {
        ODataPropertyValueDateTimeOffset *property = (ODataPropertyValueDateTimeOffset *)[aSDMEntry getPropertyValueByPath:aName];
        [property setValue:aValue];
    }
    @catch (NSException *e) {
    	result = NO;
    	NSString *localizedMessage = NSLocalizedString(@"Exception during setting value %@ to property %@. Exception: %@", @"Exception during setting value %@ to property %@. Exception: %@");
        NSString *exceptionMsg = [NSString stringWithFormat:localizedMessage, aValue, aName, e.description];
        LOGERROR(exceptionMsg);
        if (error) {
            *error = [[NSError alloc] initWithDomain:ERROR_DOMAIN code:SDM_ENTRY_PROPERTY_VALUE_ERROR_CODE userInfo:@{NSLocalizedDescriptionKey: exceptionMsg}];
        }
    }
    return result;
}

+ (BOOL)setBinaryValueForSDMEntry:(ODataEntry *)aSDMEntry withValue:(NSMutableData *)aValue forSDMPropertyWithName:(NSString *)aName error:(NSError * __autoreleasing *)error
{
	BOOL result = YES;
    @try {
        ODataPropertyValueBinary *property = (ODataPropertyValueBinary *)[aSDMEntry getPropertyValueByPath:aName];
        [property setBinaryData:aValue];
    }
    @catch (NSException *e) {
    	result = NO;
    	NSString *localizedMessage = NSLocalizedString(@"Exception during setting value %@ to property %@. Exception: %@", @"Exception during setting value %@ to property %@. Exception: %@");
        NSString *exceptionMsg = [NSString stringWithFormat:localizedMessage, aValue, aName, e.description];
        LOGERROR(exceptionMsg);
        if (error) {
            *error = [[NSError alloc] initWithDomain:ERROR_DOMAIN code:SDM_ENTRY_PROPERTY_VALUE_ERROR_CODE userInfo:@{NSLocalizedDescriptionKey: exceptionMsg}];
        }
    }
    return result;
}

+ (BOOL)setTimeValueForSDMEntry:(ODataEntry *)aSDMEntry withValue:(ODataDuration *)aValue forSDMPropertyWithName:(NSString *)aName error:(NSError * __autoreleasing *)error
{
	BOOL result = YES;
    @try {
        ODataPropertyValueTime *property = (ODataPropertyValueTime *)[aSDMEntry getPropertyValueByPath:aName];
        [property setTimeValue:aValue];
    }
    @catch (NSException *e) {
    	result = NO;
    	NSString *localizedMessage = NSLocalizedString(@"Exception during setting value %@ to property %@. Exception: %@", @"Exception during setting value %@ to property %@. Exception: %@");
        NSString *exceptionMsg = [NSString stringWithFormat:localizedMessage, aValue, aName, e.description];
        LOGERROR(exceptionMsg);
        if (error) {
            *error = [[NSError alloc] initWithDomain:ERROR_DOMAIN code:SDM_ENTRY_PROPERTY_VALUE_ERROR_CODE userInfo:@{NSLocalizedDescriptionKey: exceptionMsg}];
        }
    }
    return result;
}


- (id)initWithSDMDictionary:(NSDictionary *)aDictionary
{
    if (self = [super init]) {
        m_properties = [NSDictionary dictionaryWithDictionary:aDictionary];
        [self loadProperties];
    }
    return self;
}

- (NSDictionary *)getDictionaryForComplexTypeProperty:(NSString *)aPropertyName
{
    ODataPropertyValueComplex *complexProperty = (ODataPropertyValueComplex *)[self getValueForProperty:aPropertyName];
    return complexProperty.children;
}

- (ODataPropertyValueObject *)getValueForProperty:(NSString *)aPropertyName
{
    return m_properties[aPropertyName];
}


- (NSString *)getStringValueForSDMPropertyWithName:(NSString *)aPropertyName
{
    NSString *result = nil;
    @try {
        ODataPropertyValueString *SDMValue = (ODataPropertyValueString *)[self getValueForProperty:aPropertyName];
        result = [SDMValue getValue];
    }
    @catch (NSException *e) {
    	NSString *localizedMessage = NSLocalizedString(@"Exception during parsing property '%@'. Exception: %@", @"Exception during parsing property '%@'. Exception: %@");
        NSString *exceptionMsg = [NSString stringWithFormat:localizedMessage, aPropertyName, e.description];
        LOGERROR(exceptionMsg);
    }
    return result;
}

- (NSDate *)getDateTimeValueForSDMPropertyWithName:(NSString *)aPropertyName
{
    NSDate *result = nil;
    @try {
        ODataPropertyValueDateTime *SDMValue = (ODataPropertyValueDateTime *)[self getValueForProperty:aPropertyName];
        result = [SDMValue getDateValue];
    }
    @catch (NSException *e) {
    	NSString *localizedMessage = NSLocalizedString(@"Exception during parsing property '%@'. Exception: %@", @"Exception during parsing property '%@'. Exception: %@");
        NSString *exceptionMsg = [NSString stringWithFormat:localizedMessage, aPropertyName, e.description];
        LOGERROR(exceptionMsg);
    }
    return result;
}

- (NSDecimalNumber *)getDecimalValueForSDMPropertyWithName:(NSString *)aPropertyName
{
    NSDecimalNumber *result = nil;
    @try {
        ODataPropertyValueDecimal *SDMValue = (ODataPropertyValueDecimal *)[self getValueForProperty:aPropertyName];
        result = [SDMValue getDecimalValue];
    }
    @catch (NSException *e) {
    	NSString *localizedMessage = NSLocalizedString(@"Exception during parsing property '%@'. Exception: %@", @"Exception during parsing property '%@'. Exception: %@");
        NSString *exceptionMsg = [NSString stringWithFormat:localizedMessage, aPropertyName, e.description];
        LOGERROR(exceptionMsg);
    }
    return result;
}

- (NSNumber *)getIntValueForSDMPropertyWithName:(NSString *)aPropertyName
{
    NSNumber *result = nil;
    @try {
        ODataPropertyValueInt *SDMValue = (ODataPropertyValueInt *)[self getValueForProperty:aPropertyName];
        result = [SDMValue getIntValue];
    }
    @catch (NSException *e) {
    	NSString *localizedMessage = NSLocalizedString(@"Exception during parsing property '%@'. Exception: %@", @"Exception during parsing property '%@'. Exception: %@");
        NSString *exceptionMsg = [NSString stringWithFormat:localizedMessage, aPropertyName, e.description];
        LOGERROR(exceptionMsg);
    }
    return result;
}

- (NSNumber *)getBooleanValueForSDMPropertyWithName:(NSString *)aPropertyName
{
    NSNumber *result = nil;
    @try {
        ODataPropertyValueBoolean *SDMValue = (ODataPropertyValueBoolean *)[self getValueForProperty:aPropertyName];
        result = [SDMValue getBooleanValue];
    }
    @catch (NSException *e) {
    	NSString *localizedMessage = NSLocalizedString(@"Exception during parsing property '%@'. Exception: %@", @"Exception during parsing property '%@'. Exception: %@");
        NSString *exceptionMsg = [NSString stringWithFormat:localizedMessage, aPropertyName, e.description];
        LOGERROR(exceptionMsg);
    }
    return result;
}

- (NSNumber *)getSingleValueForSDMPropertyWithName:(NSString *)aPropertyName
{
    NSNumber *result = nil;
    @try {
        ODataPropertyValueSingle *SDMValue = (ODataPropertyValueSingle *)[self getValueForProperty:aPropertyName];
        result = [SDMValue getSingleValue];
    }
    @catch (NSException *e) {
    	NSString *localizedMessage = NSLocalizedString(@"Exception during parsing property '%@'. Exception: %@", @"Exception during parsing property '%@'. Exception: %@");
        NSString *exceptionMsg = [NSString stringWithFormat:localizedMessage, aPropertyName, e.description];
        LOGERROR(exceptionMsg);
    }
    return result;
}

- (NSNumber *)getDoubleValueForSDMPropertyWithName:(NSString *)aPropertyName
{
    NSNumber *result = nil;
    @try {
        ODataPropertyValueDouble *SDMValue = (ODataPropertyValueDouble *)[self getValueForProperty:aPropertyName];
        result = [SDMValue getDoubleValue];
    }
    @catch (NSException *e) {
    	NSString *localizedMessage = NSLocalizedString(@"Exception during parsing property '%@'. Exception: %@", @"Exception during parsing property '%@'. Exception: %@");
        NSString *exceptionMsg = [NSString stringWithFormat:localizedMessage, aPropertyName, e.description];
        LOGERROR(exceptionMsg);
    }
    return result;
}

- (NSString *)getGuidValueForSDMPropertyWithName:(NSString *)aPropertyName
{
    NSString *result = nil;
    @try {
        ODataPropertyValueGuid *SDMValue = (ODataPropertyValueGuid *)[self getValueForProperty:aPropertyName];
        result = [SDMValue getValue];
    }
    @catch (NSException *e) {
    	NSString *localizedMessage = NSLocalizedString(@"Exception during parsing property '%@'. Exception: %@", @"Exception during parsing property '%@'. Exception: %@");
        NSString *exceptionMsg = [NSString stringWithFormat:localizedMessage, aPropertyName, e.description];
        LOGERROR(exceptionMsg);
    }
    return result;
    
}

- (NSString *)getDateTimeOffsetValueForSDMPropertyWithName:(NSString *)aPropertyName
{
    NSString *result = nil;
    @try {
        ODataPropertyValueDateTimeOffset *SDMValue = (ODataPropertyValueDateTimeOffset *)[self getValueForProperty:aPropertyName];
        result = [SDMValue getValue];
    }
    @catch (NSException *e) {
    	NSString *localizedMessage = NSLocalizedString(@"Exception during parsing property '%@'. Exception: %@", @"Exception during parsing property '%@'. Exception: %@");
        NSString *exceptionMsg = [NSString stringWithFormat:localizedMessage, aPropertyName, e.description];
        LOGERROR(exceptionMsg);
    }
    return result;
}

- (NSMutableData *)getBinaryValueForSDMPropertyWithName:(NSString *)aPropertyName
{
    NSMutableData *result = nil;
    @try {
        ODataPropertyValueBinary *SDMValue = (ODataPropertyValueBinary *)[self getValueForProperty:aPropertyName];
        result = [SDMValue getBinaryData];
    }
    @catch (NSException *e) {
    	NSString *localizedMessage = NSLocalizedString(@"Exception during parsing property '%@'. Exception: %@", @"Exception during parsing property '%@'. Exception: %@");
        NSString *exceptionMsg = [NSString stringWithFormat:localizedMessage, aPropertyName, e.description];
        LOGERROR(exceptionMsg);
    }
    return result;
}

- (ODataDuration *)getTimeValueForSDMPropertyWithName:(NSString *)aPropertyName
{
    ODataDuration *result = nil;
    @try {
        ODataPropertyValueTime *SDMValue = (ODataPropertyValueTime *)[self getValueForProperty:aPropertyName];
        result = [SDMValue getTimeValue];
    }
    @catch (NSException *e) {
    	NSString *localizedMessage = NSLocalizedString(@"Exception during parsing property '%@'. Exception: %@", @"Exception during parsing property '%@'. Exception: %@");
        NSString *exceptionMsg = [NSString stringWithFormat:localizedMessage, aPropertyName, e.description];
        LOGERROR(exceptionMsg);
    }
    return result;
}

- (void)loadProperties
{
	
}

@end
