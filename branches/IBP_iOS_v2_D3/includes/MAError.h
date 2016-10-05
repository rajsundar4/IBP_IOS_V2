/*

Copyright (c) SAP AG. 2011  All rights reserved.                                   

In addition to the license terms set out in the SAP License Agreement for 
the SAP Mobile Platform ("Program"), the following additional or different 
rights and accompanying obligations and restrictions shall apply to the source 
code in this file ("Code").  SAP grants you a limited, non-exclusive, 
non-transferable, revocable license to use, reproduce, and modify the Code 
solely for purposes of (i) maintaining the Code as reference material to better
understand the operation of the Program, and (ii) development and testing of 
applications created in connection with your licensed use of the Program.  
The Code may not be transferred, sold, assigned, sublicensed or otherwise 
conveyed (whether by operation of law or otherwise) to another party without 
SAP's prior written consent.  The following provisions shall apply to any 
modifications you make to the Code: (i) SAP will not provide any maintenance
or support for modified Code or problems that result from use of modified Code;
(ii) SAP expressly disclaims any warranties and conditions, express or 
implied, relating to modified Code or any problems that result from use of the 
modified Code; (iii) SAP SHALL NOT BE LIABLE FOR ANY LOSS OR DAMAGE RELATING
TO MODIFICATIONS MADE TO THE CODE OR FOR ANY DAMAGES RESULTING FROM USE OF THE 
MODIFIED CODE, INCLUDING, WITHOUT LIMITATION, ANY INACCURACY OF DATA, LOSS OF 
PROFITS OR DIRECT, INDIRECT, SPECIAL, INCIDENTAL OR CONSEQUENTIAL DAMAGES, EVEN
IF SAP HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGES; (iv) you agree 
to indemnify, hold harmless, and defend SAP from and against any claims or 
lawsuits, including attorney's fees, that arise from or are related to the 
modified Code or from use of the modified Code. 

*/
//  MAError.h
//  MAKit
//
//  Created by Steven Xia on 9/15/11.
//  Copyright 2011 SAP Singapore. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
	MAError_MetadataPathNotSpecified = 0,	// The metadata path is not specified
	MAError_MetadataFileNotFound = 1,		// The metadata file is not found
    MAError_MetadataInvalidXMLFormat = 3,	// The input metadata is not a valid XML text string
    MAError_MetaDataMissingNode = 4,		// Required node is not found in the metadata
	MAError_MetaDataMissingAttr = 5,		// Required attribute is not found in the metadata
	MAError_MetadataAttrWrongValue = 6,	// The metadata attribute value is wrong
	MAError_MetadataOutOfSequence = 7,		// The object sequence number is out of sequene
    MAError_MetadataUnrecognizedItem = 9,	// Unrecognized item is found in the metadata
	MAError_MetadataObjUndefined = 10,	// Referring to undefined object
	MAError_DataMissingColumn = 11,	// The input data table does not contain required column
	MAError_DataTableEmpty=12,	// The input data table is empty
	MAError_LowMemory= 13,	// Low memory warning is received
	MAError_ExpressionWrongDataType = 14,	// The expression result has a wrong data type (Values expression result can only be numberic)
	MAError_ExpressionEvalation = 15, // Failed to evaluate an expression
	MAError_Other = 16,		// Other unknown runtime errors
}MAErrorCode;

typedef enum
{
	MAErrorLevel_Warning = 0,	// Warning: warning detected. MAKit can continue working.
	MAErrorLevel_Error = 1,		// Fatal Error: error detected. MAKit cannot continue working.
}MAErrorLevel;

typedef enum
{
	MAErrorKey_MetadataFileName = 0,		// The metadata file name
	MAErrorKey_MetadataLineNumber = 1,		// The line number of the error in the metadata XML
	MAErrorKey_MetadataColumnNumber = 2,	// The line number of the error in the metadata XML
	MAErrorKey_MetadataNodeName = 3,		// The node name in the metadata that triggers the error
	MAErrorKey_MetadataAttrName = 4,		// The attribute name in the metadata that triggers the error
	MAErrorKey_MetadataAttrValue = 5,		// The attribute value in the metadata that triggers the error
	MAErrorKey_MetadataSequence = 6,		// The sequence number of metadata node
	MAErrorKey_DataColumnName = 7,			// The name of the column in the input data table
	MAErrorKey_DataRowNumber = 8,			// The row number in the input data table
	MAErrorKey_DataQueryName = 9,			// The query name
	MAErrorKey_Expression = 10,				// The expression
	MAErrorKey_ChartName = 11,				// The chart name
	MAErrorKey_ValueType = 12,				// The value type
	MAErrorKey_Other = 13,					// Other general information
}MAErrorKey;


/**
 @ingroup MAKit
 @brief Class of error information
 */
@interface MAError : NSObject {

}

/*! The error code
 */
@property MAErrorCode errorCode;

/*! The error level
 */
@property MAErrorLevel errorLevel;

/*! Detailed error information. Details can be accessed with predefined keys
 */
@property(nonatomic, retain) NSDictionary *errorDetails;

/*! Create an MAError object
 */
+(MAError*)errroWithCode:(uint)code andLevel:(uint)level andDetails:(NSDictionary*)details;

@end
