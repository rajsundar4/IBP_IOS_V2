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

/*
 *  MALog.h
 *  MAExpression
 *
 *  Created by Anders Karlsson on 5/20/10.
 *  Copyright 2010 SAP AG. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>


/*! 
 *  @ingroup MAKit
 *	\brief Class for logging.
 */
@interface MALog : NSObject 
{
}	

/**
 * Logs a performance message to the Apple System Log facility only if trace level is 3.
 *
 * Note: You must end the argument list with nil, for example, [MALog trace:@"somestring", nil ]
 */

+(void)performanceTrace:(NSString *)format, ... NS_REQUIRES_NIL_TERMINATION;

/**
 * Logs a trace message to the Apple System Log facility only if trace level is less than or equal to 2.
 *
 * Note: You must end the argument list with nil, for example, [MALog trace:@"somestring", nil ]
 */

+(void)trace:(NSString *)format, ... NS_REQUIRES_NIL_TERMINATION;

/**
 * Logs a message to the Apple System Log facility only if trace level equal to 2.
 *
 * Note: You must end the argument list with nil, for example, [MALog trace:@"somestring", nil ]
 */

+(void)verbose:(NSString *)format, ... NS_REQUIRES_NIL_TERMINATION;

/**
 * Logs a message to the Apple System Log facility regardless of trace level.
 *
 * Note: You must end the argument list with nil, for example, [MALog trace:@"somestring", nil ]
 */

+(void)forceTrace:(NSString *)format, ... NS_REQUIRES_NIL_TERMINATION;

/**
 * Logs an error message to the Apple System Log facility regardless of trace level. Error messages will be prefixed with ###
 *
 * Note: You must end the argument list with nil, for example, [MALog error:@"somestring", nil ]
 */

+(void)error:(NSString *)format, ... NS_REQUIRES_NIL_TERMINATION;

/**
 * Logs a warning message to the Apple System Log facility regardless of trace level. Warning messages will be prefixed with ===
 *
 * Note: You must end the argument list with nil, for example, [MALog warning:@"somestring", nil ]
 */

+(void)warning:(NSString *)format, ... NS_REQUIRES_NIL_TERMINATION;

/**
 * Sets the trace level.
 * @param newTraceLevel 0 for no tracing. 1 onwards to output trace messages.
 */
+(int)setTraceLevel:(int)newTraceLevel;

/**
 * Returns the trace level.
 */
+(int)getTraceLevel;

@end