//
//  DBDownloadManager.m
//  S&OP
//
//  Created by Mayur Birari on 30/09/13.
//  Copyright (c) 2013 Linear Logics Corp.. All rights reserved.
//

#import "DBDownloadManager.h"


// Request file http://www.linearlogics.com/SOPWS/SOPDBrequest.php
// download file http://www.linearlogics.com/SOPWS/data/SAOPData.sqlite

@implementation DBDownloadManager


/*!
 \internal
 @method saopDBRequest:
 @abstract Request to download the file with valid credentials.
 @param urlString
 @param username
 @param password
 */
-(void)saopDBRequest:(NSString *)urlString username:(NSString *)username password:(NSString *)password {
    
    dispatch_async(dispatch_queue_create("com.ameri100.saop", DISPATCH_QUEUE_SERIAL), ^{
        
        NSURL *aUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@/SOPWS/SOPDBrequest.php", urlString]];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aUrl
                                                               cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                           timeoutInterval:60.0];
        
        [request setHTTPMethod:@"POST"];
        NSString *postString = [NSString stringWithFormat:@"user=%@&pwd=%@&dev_id=dummydeviceid&format=Json", username, password];
        
        [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
        
        NSURLResponse* urlResponse = nil;
        NSError* error = nil;
        
        NSData* responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
        
        NSDictionary *responseDataDictionary = nil;
        if(responseData) {
         responseDataDictionary = [NSJSONSerialization JSONObjectWithData: responseData options:NSJSONReadingMutableContainers error:&error];
        
        responseDataDictionary = [responseDataDictionary valueForKey:@"response"];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if(error == nil) {
                
                if([[responseDataDictionary valueForKey:@"status"] isEqualToString:@"SUCCESS"]) {
                    
                [self downloadSQLiteDataBaseFile:[responseDataDictionary valueForKey:@"download_path"]];
                }
                else {
                
                    [_dbDownloadDelegate failToDownloadSqlFile:@"Invalid username or password."];
                }
            }
            else {
                
                [_dbDownloadDelegate  failToDownloadSqlFile:@"File download fail, check your server details."];
            }
        });
    });
}

/*!
 \internal
 @method downloadSQLiteDataBaseFile
 @abstract This method download the file by getting valid url from the
 response of the saopDBRequest method.
 @param urlString
 */
-(void)downloadSQLiteDataBaseFile:(NSString *)urlString {
    
    dispatch_async(dispatch_queue_create("com.ameri100.saop", DISPATCH_QUEUE_SERIAL), ^{
        
        NSURL *aUrl = [NSURL URLWithString:urlString];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aUrl
                                                               cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                           timeoutInterval:60.0];
        
        [request setHTTPMethod:@"GET"];
        
        NSURLResponse* urlResponse = nil;
        NSError* error = nil;
        NSData* responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
        NSString *documentPath= [kDOCUMENTDIRECTORY_PATH stringByAppendingPathComponent:kSQLITEDB_FILENAME];
        
        if(responseData) {
        [responseData writeToFile:documentPath atomically:YES];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if(error == nil) {
                
                [_dbDownloadDelegate databaseFileDownloadSuccessfully];
            }
            else {
                
                [_dbDownloadDelegate  failToDownloadSqlFile:@"File download fail, check your server details."];
            }
        });
    });
}


@end
