/*
 
 File: MediaLink.h
 Abstract: Holds the media link data (URL and content type). Used only with entities containing media links.
 
 */

#import "MediaLink.h"

@implementation MediaLink

- (id)initWithQuery:(ODataQuery *)query
{
	return [self initWithQuery:query andContentType:@""];
}

- (id)initWithQuery:(ODataQuery *)query andContentType:(NSString *)aContentType
{
	return [self initWithQuery:query andContentType:aContentType andSlug:@""];
}

- (id)initWithQuery:(ODataQuery *)query andContentType:(NSString *)aContentType andSlug:(NSString *)aSlug
{
	self = [super init];
	if (self) {
		self.mediaLinkQuery = query;
		self.contentType = aContentType;
		self.slug = aSlug;
	}
	return self;
}

@end
