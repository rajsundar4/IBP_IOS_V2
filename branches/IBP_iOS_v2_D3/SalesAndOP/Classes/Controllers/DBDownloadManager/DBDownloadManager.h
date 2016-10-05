//
//  DBDownloadManager.h
//  S&OP
//
//  Created by Mayur Birari on 30/09/13.
//  Copyright (c) 2013 Linear Logics Corp.. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 \internal
 @protocol DBDownloadDelegate
 @abstract Used to notify the View Controller.
 @discussion This delegate notify Settings View Controller for success or failure on
             Database SQLite file downloading.
 */
@protocol DBDownloadDelegate <NSObject>

/*!
 \internal
 @method databaseFileDownloadSuccessfully
 @abstract Used to observe the success of downloading.
 */
-(void)databaseFileDownloadSuccessfully;

/*!
 \internal
 @method failToDownloadSqlFile
 @abstract Used to observe the failure (error).
 @param errorMessage
 */
-(void)failToDownloadSqlFile:(NSString *)errorMessage;

@end

/*!
 \internal
 @protocol DBDownloadManager
 @abstract Download sql file.
 @discussion This controller request for file downloding using credentials and
             recieve file path in response, and controller also responsible to download
            the file and saved it at location Document directory.
 */
@interface DBDownloadManager : NSObject

/// Database download observer delegate.
@property (nonatomic, weak) id<DBDownloadDelegate> dbDownloadDelegate;


/*!
 \internal
 @method saopDBRequest:
 @abstract Request to download the file with valid credentials.
 @param urlString
 @param username
 @param password
 */
-(void)saopDBRequest:(NSString *)urlString username:(NSString *)username password:(NSString *)password;

/*!
 \internal
 @method downloadSQLiteDataBaseFile
 @abstract This method download the file by getting valid url from the
           response of the saopDBRequest method.
 @param urlString
 */
-(void)downloadSQLiteDataBaseFile:(NSString *)urlString;

@end
