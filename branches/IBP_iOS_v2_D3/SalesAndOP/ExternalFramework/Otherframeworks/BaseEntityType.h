/*
 
 File: BaseEntityType.h
 Abstract: The base class for all OData entities. Inherits from BaseODataObject.
 
 */

#import <Foundation/Foundation.h>
#import "BaseODataObject.h"
#import "ODataQuery.h"
#import "MediaLink.h"

// SAP OData Mobile SDK Imports
#import "ODataEntry.h"
#import "ODataProperty.h"
#import "ODataLink.h"


/**
 The base class for all OData entities.
 */
@interface BaseEntityType : BaseODataObject {
    ODataEntry *m_SDMEntry;
}

@property (strong, nonatomic) NSURL *baseUrl; ///< The URL to the specific entity instance entry.
@property (strong, nonatomic) NSString *etag; ///< The etag data returned for the OData entry.

/**
 Create a new instance of an entity type obejct with the provided parameter.
 @param aSDMEntry an OData entry containing the entity data (entity properties, navigation properties etc.).
 */
- (id)initWithSDMEntry:(ODataEntry *)aSDMEntry;

/**
 Build an instance of an SDMODataEntry obejct based on the object property values.
 It may be used for getting the XML payload representation of the Entity.
 NOTE: In case the Object wasn't initialized with an SDMODataEntry, the returned
 object doesn't include any relative URLs (of base URL, Navigation Properties URL, etc').
 @param error A pointer to an NSError object.
 @return a SDMODataEntry with all properties set. returns nil if aSchema is nil.
 */
- (ODataEntry *)buildSDMEntryFromPropertiesAndReturnError:(NSError * __autoreleasing *)error;

/**
 Returns the URL for the provided navigation name.
 @param aNavigationName navigation property name.
 @return ODataQuery with the navigation URL.
 */
- (ODataQuery *)getRelatedLinkForNavigationName:(NSString *)aNavigationName;

/**
 Returns the inlined entries for the provided navigation name.
 @param aNavigationName navigation property name.
 @return array of SDMODataEntry objects represents the inlined entries for the provided navigation property.
 */
- (NSMutableArray *)getInlinedRelatedEntriesForNavigationName:(NSString *)aNavigationName;

/**
 Abstract method (no implementation).
 Implemented by derived entity type objects.
 Loads the query object for each navigation property.
 */
- (void)loadNavigationPropertyQueries;

/**
 Abstract method (no implementation).
 Implemented by derived entity type objects.
 Loads the objects for each navigation property.
 */
- (void)loadNavigationPropertyData;

/**
 Abstract method (no implementation).
 Implemented by derived entity type objects.
 Loads the media links properties
 */
- (void)loadMediaLinkProperties;

/**
 Returns the collection name of the given navigation property's target.
 @param aNavigationProperty navigation property name.
 @return target collection (entity set) name.
 */
- (NSString *)getTargetCollectionFromNavigationProperty:(NSString *)aNavigationProperty;

/**
 Adds all relative links and their inlined entries to the internal SDMODataEntry
 @param aDictionary that its keys are the navigation names from the SDMODataEntry,
 and the value for each key is a NSMutableArray that contains all the inlined SDMODataEntry objects
 for this navigation property.
 */
- (void)addRelativeLinksToSDMEntryFromDictionary:(NSMutableDictionary *)aDictionary;

/**
 Returns an array of SDMODataEntry objects out of the received BaseODataEntry array.
 @return Returns a NSMutableArray object represents the SDMODataEntry objects extracted from each BaseODataEntry object in the input array.
 */
- (NSMutableArray *)createSDMEntriesForNavigationPropertyEntries:(NSArray *)anEntriesArray;

/**
 Returns the media link for reading a media resource associated with this entry.
 @return Returns a MediaLink object represents the media link for reading. Returns nil if no such link is available.
 */
- (MediaLink *)getMediaLinkForReading;

/**
 Returns the media link for editing a media resource associated with this entry.
 @return Returns a MediaLink object represents the media link for editing. Returns nil if no such link is available.
 */
- (MediaLink *)getMediaLinkForEditing;

/**
 Returns an array of SDMEntries from a provided NSData.
 @param anEntitySchema The SDMODataEntitySchema of the provided NSData (e.g. Products).
 @param aData The NSData of the provided SDMODataEntitySchema.
 @param error A pointer to an NSError object.
 @return Returns an array of SDMEntries.
 */
+ (NSMutableArray *)getSDMEntriesForEntitySchema:(ODataEntitySchema *)anEntitySchema andData:(NSData *)aData error:(NSError * __autoreleasing *)error;

/**
 Returns an array of SDMEntries including related entries from a provided NSData.
 @param anEntitySchema The SDMODataEntitySchema of the provided NSData (e.g. Products).
 @param aData The NSData of the provided SDMODataEntitySchema.
 @param aServiceDocument The SDMODataServiceDocument of the service.
 @param error A pointer to an NSError object.
 @return Returns an array of SDMEntries.
 */
+ (NSMutableArray *)getExpandedSDMEntriesForEntitySchema:(ODataEntitySchema *)anEntitySchema andData:(NSData *)aData andServiceDocument:(ODataServiceDocument *)aServiceDocument error:(NSError * __autoreleasing *)error;

/**
 Returns the first object from a provided array of objects.
 @param array The array of objects.
 @return Returns BaseODataObject.
 @remark: Returns nil if the array contains no objects.
 */
+ (BaseODataObject *)getFirstObjectFromArray:(NSArray *)array;

/**
 Returns an Empty SDMODataEntry using the provided entity schema.
 Handles errors as well - in case schema entity is empty, logs it.
 @param aSchema The schema of the SDMODataEntry to be returned.
 @return a new SDMODataEntry without any properties set. returns nil if aSchema is nil.
 */
+ (ODataEntry *)createEmptySDMODataEntryWithSchema:(ODataEntitySchema *)aSchema error:(NSError * __autoreleasing *)error;

@end
