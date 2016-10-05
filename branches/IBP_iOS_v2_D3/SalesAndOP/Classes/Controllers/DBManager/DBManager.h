//
//  DBManager.h
//  S&OP
//
//  Created by Mayur Birari on 25/09/13.
//  Copyright (c) 2013 Linear Logics Corp.. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SRCDatabase.h"
#import "SRCResultSet.h"

/*
 \internal
 @class      DBManager
 @abstract   Hold an instance for Database Manager 
 @discussion This class represent Manager which handle persistant data storage.
 */
@interface DBManager : NSObject 
    

@property(nonatomic,retain)SRCDatabase *database;

+(BOOL)checkForSQliteFile;

/*!
 \internal
 @function   setupDatabase
 @abstract   connet with the database 
 @discussion This method is used to connect with the document dictionary database.
 */
- (void)setupDatabase;

/*!
 \internal 
 @function   insertReports
 @abstract   insert Reports data
 @discussion This method is used to store planning area information.
 */
- (void)insertReports:(NSArray *)reportsList;

/*!
 \internal 
@function   insertReportPages
@abstract   insert ReportPage data
@discussion This method is used to store Dashboard information.
*/
- (void)insertReportPages:(NSArray *)reportPagesList;

/*!
 \internal 
@function   insertReportViews
@abstract   insert ReportViews data
@discussion This method is used to store Charts information.
*/
- (void)insertReportViews:(NSArray *)reportViewsList;

/*!
 \internal 
@function   insertReportPageLayouts
@abstract   insert ReportPage Layout data.
@discussion This method is used to store Dashboard and Charts Layout information.
*/
- (void)insertReportPageLayouts:(NSArray *)reportPageLayoutsList;

/*!
\internal
@function   insertReportViewAttributes
@abstract   insert ReportView Attribute data.
@discussion This method is used to store Charts Attribute information.
*/
- (void)insertReportViewAttributes:(NSArray *)reportViewAttributesList;

/*!
 \internal
 @function   getReportList
 @abstract   retriving all Reports.
 @discussion This method is used to get all Planning Area.
 */
- (NSArray *) getReportList;

/*!
 \internal
 @function   getReportPageList
 @abstract   retriving ReportPages.
 @discussion This method is used to get all Dashboard.
 */
- (NSArray *) getReportPageList;

/*!
 \internal
 @function   getReportPageLayoutList
 @abstract   retriving ReportPageLayouts.
 @discussion This method is used to get all Chart Layout information.
 */
- (NSArray *) getReportPageLayoutList;

/*!
 \internal
 @function   getReportViewsList
 @abstract   retriving ReportViews.
 @discussion This method is used to get all Charts information.
 */
- (NSArray *) getReportViewsList;

/*!
 \internal
 @function   getReportviewAttributeList
 @abstract   retriving ReportView Attribute data.
 @discussion This method is used to get all Charts Attribute information.
 */
- (NSArray *) getReportviewAttributeList;

@end
