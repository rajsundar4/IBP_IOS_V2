/*
 
 File: TypeConverter.h
 Abstract: OData primitive type converters.
 
 */

#import "TypeConverter.h"

@implementation ODataURITypeConverter

- (id)init
{
    self = [super init];
    if (self) {
        //Initiate decimal separator local and date formatter once, for low-cost performance and memory
        decimalSeparatorLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]; //for getting the decimal separator as '.'
        dateFormatter = [[NSDateFormatter alloc] init]; //for Edm.DateTime formatting
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
        NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
        [dateFormatter setTimeZone:timeZone];        
    }
    return self;
}

+ (ODataURITypeConverter *)uniqueInstance
{
    static ODataURITypeConverter *instance;
	
    @synchronized(self) {
        if (!instance) {
            instance = [[ODataURITypeConverter alloc] init];
        }
        return instance;
    }
}

- (NSString *)convertToEdmBinaryURI:(NSMutableData *)value
{
    if (value) {
        NSString *rawData = [value description]; //hexadecimal representation
        return [NSString stringWithFormat:@"binary'%@'", rawData];
    }
    return @"null";
}

- (NSString *)convertToEdmBooleanURI:(NSNumber *)value
{
    if (value) {
        BOOL boolValue = [value boolValue];
        if (boolValue) {
            return @"true";
        }
        else {
            return @"false";
        }
    }
    return @"null";
}

- (NSString *)convertToEdmByteURI:(NSNumber *)value
{
    if (value) {
        unsigned char byteValue = [value unsignedCharValue]; //unsigned 8-bit integer
        return [NSString stringWithFormat:@"%X", byteValue];
    }
    return @"null";
}

- (NSString *)convertToEdmSByteURI:(NSNumber *)value
{
    if (value) {
        char sbyteValue = [value charValue]; //signed 8-bit integer
        return [NSString stringWithFormat:@"%i", sbyteValue];
    }
    return @"null";
}

- (NSString *)convertToEdmSingleURI:(NSNumber *)value
{
    if (value) {
        float singleValue = [value floatValue]; //single persicion floating point number (32-bit)
        return [NSString stringWithFormat:@"%0.7ff", singleValue];
    }
    return @"null";
}

- (NSString *)convertToEdmDoubleURI:(NSNumber *)value
{
    if (value) {
        double doubleValue = [value doubleValue]; //double persicion floating point number (64-bit)
        return [NSString stringWithFormat:@"%0.15f", doubleValue];
    }
    return @"null";
}

- (NSString *)convertToEdmInt16URI:(NSNumber *)value
{
    if (value) {
        short int16Value = [value shortValue]; //signed 16-bit integer
        return [NSString stringWithFormat:@"%hi", int16Value];    
    }
    return @"null";
}

- (NSString *)convertToEdmInt32URI:(NSNumber *)value
{
    if (value) {
        int int32Value = [value intValue]; //signed 32-bit integer
        return [NSString stringWithFormat:@"%i", int32Value];
    }
    return @"null";
}

- (NSString *)convertToEdmInt64URI:(NSNumber *)value
{
    if (value) {
        long long int64Value = [value longLongValue]; //signed 64-bit integer
        return [NSString stringWithFormat:@"%lliL", int64Value];
    }
    return @"null";
}

- (NSString *)convertToEdmDecimalURI:(NSDecimalNumber *)value
{
    if (value) {
        return [NSString stringWithFormat:@"%@M",[value descriptionWithLocale:decimalSeparatorLocale]];
    }
    return @"null";
}

- (NSString *)convertToEdmStringURI:(NSString *)value
{
    if (value) {
        return [NSString stringWithFormat:@"'%@'",value];
    }
    return @"null";
}

- (NSString *)convertToEdmDateTimeURI:(NSDate *)value
{
    if (value) {
        NSString *formattedDateString = [dateFormatter stringFromDate:value];
        return [NSString stringWithFormat:@"datetime'%@'", formattedDateString];
    }
    return @"null";
}

- (NSString *)convertToEdmDateTimeOffsetURI:(NSString *)value
{
    if (value) {
        return [NSString stringWithFormat:@"datetimeoffset'%@'", value];
    }
    return @"null";
}

- (NSString *)convertToEdmTimeURI:(ODataDuration *)value
{
    if (value) {
        return [NSString stringWithFormat:@"time'%02u:%02u:%@%0.1f'", value.hours, value.minutes, (value.seconds < 10 ? @"0" : @""), value.seconds];
    }
    return @"null";
}

- (NSString *)convertToEdmGuidURI:(NSString *)value
{
    if (value) {
        return [NSString stringWithFormat:@"guid'%@'", value];
    }
    return @"null";    
}

@end
