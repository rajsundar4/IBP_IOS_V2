/*

 File: BaseComplexType.m
 Abstract: The base class for all OData complex types. Inherits from BaseODataObject.
 
 */

#import "BaseComplexType.h"

@implementation BaseComplexType 

- (BOOL)setComplexTypePropertiesToSDMEntry:(ODataEntry *)aSDMEntry complexTypePropertyName:(NSString *)aComplexPropertyName error:(NSError *__autoreleasing *)error
{
    return YES;
}
@end
