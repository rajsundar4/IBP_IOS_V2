//
//  DBManager.m
//  S&OP
//
//  Created by Mayur Birari on 25/09/13.
//  Copyright (c) 2013 Linear Logics Corp.. All rights reserved.
//

#import "Report.h"
#import "DBManager.h"
#import "ReportPage.h"
#import "ReportView.h"
#import "ReportViewAttr.h"
#import "ReportPageLayout.h"


/*!
 @class      DBManager
 @abstract   Hold an instance for Database Manager
 @discussion This class represent Manager which handle persistant data storage.
 */
@implementation DBManager

@synthesize database;


+(BOOL)checkForSQliteFile{
    
    BOOL success=FALSE;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *documentPath= [kDOCUMENTDIRECTORY_PATH stringByAppendingPathComponent:kSQLITEDB_FILENAME];
    
    success=[fileManager fileExistsAtPath:documentPath];
    
    return success;
    
}

/*!
 @function   setupDatabase
 @abstract   connet with the sql database
 @discussion This method is used to connect with the document dictionary database.
 */
- (void)setupDatabase{
    
    NSString *documentPath= [kDOCUMENTDIRECTORY_PATH stringByAppendingPathComponent:kSQLITEDB_FILENAME];
    
    if (![DBManager checkForSQliteFile]){
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSError* error=nil;
        
        
        // The writable database does not exist, so copy the default to the appropriate location.
        NSString *defaultDBPath = [[NSBundle mainBundle] pathForResource:@"SAOPData" ofType:@"sqlite"];
        BOOL success = [fileManager copyItemAtPath:defaultDBPath toPath:documentPath error:nil];
        if (!success) {
            NSLog(@"Failed to create writable database file with message %@",[error localizedDescription]);
        }
    }
    
    database = [SRCDatabase databaseWithPath:documentPath];
}

/*!
 @function   insertReports
 @abstract   insert Reports data
 @discussion This method is used to store planning area information.
 */
- (void)insertReports:(NSArray *)reportsList{
    
    @try{
        
        [database open];
        
        // Deleting older record
        [database executeUpdate:@"delete from Report"];
        
        for(Report *report in reportsList) {
            NSString *query = [NSString stringWithFormat:@"insert into Report \
                               values ('%@','%@','%@','%@','%@','%@','%@','%@')",report.reportId,report.reportName,report.reportDescr,report.iSMobileEnabled,report.createdBy,report.createdDate, report.lastModifiedDate, report.lastModifiedBy];
            [database executeUpdate:query];
        }
    }
    @catch (NSException* error) {
        
        [database close];
    }
    @finally {
        [database close];
    }
}

/*!
 @function   insertReportPages
 @abstract   insert ReportPage data
 @discussion This method is used to store Dashboard information.
 */
- (void)insertReportPages:(NSArray *)reportPagesList{
    
    @try{
        
        [database open];
        
        // Deleting older record
        [database executeUpdate:@"delete from ReportPage"];
        
        for(ReportPage *reportPage in reportPagesList) {
            NSString *query = [NSString stringWithFormat:@"insert into ReportPage \
                               values ('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",reportPage.reportPageId,reportPage.reportPageName,reportPage.reportPageDescr,reportPage.isOwner,reportPage.iSMobileEnabled,reportPage.layoutId, reportPage.numberOfRows, reportPage.numberOfColumns, reportPage.rowHeight, reportPage.columnWidth, reportPage.createdBy, reportPage.createdDate, reportPage.lastModifiedDate, reportPage.lastModifiedBy];
            [database executeUpdate:query];
        }
    }
    @catch (NSException* error) {
        
        [database close];
    }
    @finally {
        [database close];
    }
}

/*!
 @function   insertReportViews
 @abstract   insert ReportViews data
 @discussion This method is used to store Charts information.
 */
- (void)insertReportViews:(NSArray *)reportViewsList{
    
    @try{
        
        [database open];
        
        // Deleting older record
        [database executeUpdate:@"delete from ReportView"];
        
        for(ReportView *reportView in reportViewsList) {
            NSString *query = [NSString stringWithFormat:@"insert into ReportView \
                               values ('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",reportView.reportViewId,reportView.reportViewName,reportView.reportViewDescr,reportView.reportViewType,reportView.isOwner,reportView.iSMobileEnabled, reportView.reportId,reportView.displayLegend, reportView.legendPosition, reportView.createdBy, reportView.createdDate, reportView.lastModifiedDate, reportView.lastModifiedBy];
            [database executeUpdate:query];
        }
    }
    @catch (NSException* error) {
        
        [database close];
    }
    @finally {
        [database close];
    }
}

/*!
 @function   insertReportPageLayouts
 @abstract   insert ReportPage Layout data.
 @discussion This method is used to store Dashboard and Charts Layout information.
 */
- (void)insertReportPageLayouts:(NSArray *)reportPageLayoutsList{
    
    @try{
        
        [database open];
        
        // Deleting older record
        [database executeUpdate:@"delete from ReportPageLayout"];
        
        for(ReportPageLayout *reportPageLayout in reportPageLayoutsList) {
            NSString *query = [NSString stringWithFormat:@"insert into ReportPageLayout \
                               values ('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",reportPageLayout.reportPageId,reportPageLayout.rowNumber,reportPageLayout.columnNumber,reportPageLayout.reportId,reportPageLayout.reportViewName,reportPageLayout.reportViewId, reportPageLayout.reportViewType,reportPageLayout.rowSpan, reportPageLayout.columnSpan, reportPageLayout.legendPosition, reportPageLayout.displayLegend];
            [database executeUpdate:query];
        }
    }
    @catch (NSException* error) {
        
        [database close];
    }
    @finally {
        [database close];
    }
}

/*!
 @function   insertReportViewAttributes
 @abstract   insert ReportView Attribute data.
 @discussion This method is used to store Charts Attribute information.
 */
- (void)insertReportViewAttributes:(NSArray *)reportViewList{
    
    @try{
        
        [database open];
        
        // Deleting older record
        [database executeUpdate:@"delete from ReportViewAttribute"];
        
        // Deleting older record from value table
        [database executeUpdate:@"delete from AttributeValue"];
        
        for(ReportView *reportView in reportViewList)
        for(ReportViewAttr *reportViewAttributes in reportView.reportViewAttrArray) {
            
            NSString *query = [NSString stringWithFormat:@"insert into ReportViewAttribute \
                               values ('%@','%@','%@','%@','%@','%@')",reportViewAttributes.reportId,reportViewAttributes.reportViewId,reportViewAttributes.attr_Id,reportViewAttributes.attr_name,reportViewAttributes.attr_type,reportViewAttributes.sequence];
            [database executeUpdate:query];
            
            for(NSObject *value in reportViewAttributes.valuesArray) {
                
                NSString *query = [NSString stringWithFormat:@"insert into AttributeValue \
                                   values ('%@','%@',?)",reportViewAttributes.attr_Id,reportViewAttributes.reportViewId];
                
                [database executeUpdate:query,value, nil];
            }
            
            
        }
    }
    @catch (NSException* error) {
        
        [database close];
    }
    @finally {
        [database close];
    }
}

/*!
 @function   getReportList
 @abstract   retriving all Reports.
 @discussion This method is used to get all Planning Area.
 */
- (NSArray *) getReportList {
    
    NSMutableArray *reportList = [[NSMutableArray alloc] init];
    @try{
        
        [database open];
        
        SRCResultSet *srcResultSet = [database executeQuery:@"SELECT * FROM Report"];
        
        while ([srcResultSet next]) {
            
            // Get the column data for this record and put it into a custom object
            Report *report = [[Report alloc] init];
            
            report.reportId = [srcResultSet stringForColumn:@"reportId"];
            report.reportName = [srcResultSet stringForColumn:@"reportName"];
            report.reportDescr = [srcResultSet stringForColumn:@"reportDescr"];
            report.iSMobileEnabled = [srcResultSet stringForColumn:@"iSMobileEnabled"];
            report.createdBy = [srcResultSet stringForColumn:@"createdBy"];
            report.createdDate = [srcResultSet dateForColumn:@"createdDate"];
            report.lastModifiedDate = [srcResultSet dateForColumn:@"lastModifiedDate"];
            report.lastModifiedBy = [srcResultSet stringForColumn:@"lastModifiedBy"];
            
            [reportList addObject:report];
        }
        [srcResultSet close];
    }
    @catch (NSException* error) {
        
        [database close];
    }
    @finally {
        [database close];
        
        return reportList;
    }
}

/*!
 @function   getReportPageList
 @abstract   retriving ReportPages.
 @discussion This method is used to get all Dashboard.
 */
- (NSArray *) getReportPageList {
    
    NSMutableArray *reportPageList = [[NSMutableArray alloc] init];
    @try{
        
        [database open];
        
        SRCResultSet *srcResultSet = [database executeQuery:@"SELECT * FROM ReportPage"];
        
        while ([srcResultSet next]) {
            
            // Get the column data for this record and put it into a custom object
            ReportPage *reportPage = [[ReportPage alloc] init];
            
            reportPage.reportPageId = [srcResultSet stringForColumn:@"reportPageId"];
            reportPage.reportPageName = [srcResultSet stringForColumn:@"reportPageName"];
            reportPage.reportPageDescr = [srcResultSet stringForColumn:@"reportPageDescr"];
            reportPage.isOwner = [srcResultSet stringForColumn:@"isOwner"];
            reportPage.iSMobileEnabled = [srcResultSet stringForColumn:@"iSMobileEnabled"];
            reportPage.layoutId = [srcResultSet stringForColumn:@"layoutId"];
            reportPage.numberOfRows = [NSNumber numberWithInt:[[srcResultSet stringForColumn:@"numberOfRows"] intValue]];
            reportPage.numberOfColumns = [NSNumber numberWithInt:[[srcResultSet stringForColumn:@"numberOfColumns"] intValue]];
            reportPage.rowHeight = [srcResultSet stringForColumn:@"rowHeight"];
            reportPage.columnWidth = [srcResultSet stringForColumn:@"columnWidth"];
            reportPage.createdBy = [srcResultSet stringForColumn:@"createdBy"];
            reportPage.createdDate = [srcResultSet dateForColumn:@"createdDate"];
            reportPage.lastModifiedDate = [srcResultSet dateForColumn:@"lastModifiedDate"];
            reportPage.lastModifiedBy = [srcResultSet stringForColumn:@"lastModifiedBy"];
            
            [reportPageList addObject:reportPage];
        }
        [srcResultSet close];
    }
    @catch (NSException* error) {
        
        [database close];
    }
    @finally {
        [database close];
        
        return reportPageList;
    }
}

/*!
 @function   getReportPageLayoutList
 @abstract   retriving ReportPageLayouts.
 @discussion This method is used to get all Chart Layout information.
 */
- (NSArray *) getReportPageLayoutList {
    
    NSMutableArray *reportPageLayoutList = [[NSMutableArray alloc] init];
    @try{
        
        [database open];
        
        SRCResultSet *srcResultSet = [database executeQuery:@"SELECT * FROM ReportPageLayout"];
        
        while ([srcResultSet next]) {
            
            // Get the column data for this record and put it into a custom object
            ReportPageLayout *reportPageLayout = [[ReportPageLayout alloc] init];
            
            reportPageLayout.reportPageId = [srcResultSet stringForColumn:@"reportPageId"];
            reportPageLayout.rowNumber = [NSNumber numberWithInt:[[srcResultSet stringForColumn:@"rowNumber"] intValue]];
            reportPageLayout.columnNumber = [NSNumber numberWithInt:[[srcResultSet stringForColumn:@"columnNumber"] intValue]];            
            reportPageLayout.reportId = [srcResultSet stringForColumn:@"reportId"];
            reportPageLayout.reportViewName = [srcResultSet stringForColumn:@"reportViewName"];
            reportPageLayout.reportViewId = [srcResultSet stringForColumn:@"reportViewId"];
            reportPageLayout.reportViewType = [srcResultSet stringForColumn:@"reportViewType"];
            reportPageLayout.rowSpan = [NSNumber numberWithInt:[[srcResultSet stringForColumn:@"rowSpan"] intValue]];
            reportPageLayout.columnSpan = [NSNumber numberWithInt:[[srcResultSet stringForColumn:@"columnSpan"] intValue]];
            reportPageLayout.legendPosition = [srcResultSet stringForColumn:@"legendPosition"];
            reportPageLayout.displayLegend = [srcResultSet stringForColumn:@"displayLegend"];
            
            [reportPageLayoutList addObject:reportPageLayout];
        }
        [srcResultSet close];
    }
    @catch (NSException* error) {
        
        [database close];
    }
    @finally {
        [database close];
        
        return reportPageLayoutList;
    }

}

/*!
 \internal
 @function   getReportViewsList
 @abstract   retriving ReportViews.
 @discussion This method is used to get all Charts information.
 */
- (NSArray *) getReportViewsList {
    
    NSMutableArray *reportViewList = [[NSMutableArray alloc] init];
    @try{
        
        [database open];
        
        SRCResultSet *srcResultSet = [database executeQuery:@"SELECT * FROM ReportView"];
        
        while ([srcResultSet next]) {
            
            // Get the column data for this record and put it into a custom object
            ReportView *reportView = [[ReportView alloc] init];
            
            reportView.reportViewId = [srcResultSet stringForColumn:@"reportViewId"];
            reportView.reportViewName = [srcResultSet stringForColumn:@"reportViewName"];
            reportView.reportViewDescr = [srcResultSet stringForColumn:@"reportViewDescr"];
            reportView.reportViewType = [srcResultSet stringForColumn:@"reportViewType"];
            reportView.isOwner = [srcResultSet stringForColumn:@"isOwner"];
            reportView.iSMobileEnabled = [srcResultSet stringForColumn:@"iSMobileEnabled"];
            reportView.reportId = [srcResultSet stringForColumn:@"reportId"];
            reportView.displayLegend = [srcResultSet stringForColumn:@"displayLegend"];
            reportView.legendPosition = [srcResultSet stringForColumn:@"legendPosition"];
            reportView.createdBy = [srcResultSet stringForColumn:@"createdBy"];
            reportView.createdDate = [srcResultSet dateForColumn:@"createdDate"];
            reportView.lastModifiedDate = [srcResultSet dateForColumn:@"lastModifiedDate"];
            reportView.lastModifiedBy = [srcResultSet stringForColumn:@"lastModifiedBy"];
            
            [reportViewList addObject:reportView];
        }
        [srcResultSet close];
    }
    @catch (NSException* error) {
        
        [database close];
    }
    @finally {
        [database close];
        
        return reportViewList;
    }
    
}

/*!
 \internal
 @function   getReportviewAttributeList
 @abstract   retriving ReportView Attribute data.
 @discussion This method is used to get all Charts Attribute information.
 */
- (NSArray *) getReportviewAttributeList {
    
    NSMutableArray *reportViewAttributeList = [[NSMutableArray alloc] init];
    @try{
        
        [database open];
        
        SRCResultSet *srcResultSet = [database executeQuery:@"SELECT * FROM ReportViewAttribute"];
        
        while ([srcResultSet next]) {
            
            // Get the column data for this record and put it into a custom object
            ReportViewAttr *reportViewAttr = [[ReportViewAttr alloc] init];
            
            reportViewAttr.reportViewId = [srcResultSet stringForColumn:@"reportViewId"];
            reportViewAttr.reportId = [srcResultSet stringForColumn:@"reportId"];
            reportViewAttr.attr_Id = [srcResultSet stringForColumn:@"attr_Id"];
            reportViewAttr.attr_name = [srcResultSet stringForColumn:@"attr_name"];
            reportViewAttr.attr_type = [srcResultSet stringForColumn:@"attr_type"];
            reportViewAttr.sequence = [NSNumber numberWithInt:[[srcResultSet stringForColumn:@"sequence"] intValue]];

            reportViewAttr.valuesArray = [[NSMutableArray alloc] init];
                        
            SRCResultSet *srcValueResultSet = [database executeQuery:[NSString stringWithFormat:@"SELECT * FROM AttributeValue WHERE attr_id='%@' and reportViewId='%@'", reportViewAttr.attr_Id, reportViewAttr.reportViewId]];
            
            while ([srcValueResultSet next]) {
                
                [reportViewAttr.valuesArray addObject:[srcValueResultSet stringForColumn:@"attr_Value"]];
            }
            [srcValueResultSet close];

            [reportViewAttributeList addObject:reportViewAttr];
        }
        [srcResultSet close];
    }
    @catch (NSException* error) {
        
        [database close];
    }
    @finally {
        [database close];
        
        return reportViewAttributeList;
    }
}


@end
