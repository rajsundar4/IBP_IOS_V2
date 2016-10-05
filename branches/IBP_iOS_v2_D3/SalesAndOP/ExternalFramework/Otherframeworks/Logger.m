/*
 
 File: Logger.m
 Abstract: Logger class.
 
 */


#import "Logger.h"


@implementation Logger


+ (void)logError:(NSString *)msg withInfo:(NSString *)info
{
#ifdef DEBUG
    NSLog(@"ERROR: %@ %@", msg, info);
#endif
}

+ (void)logWarning:(NSString *)msg withInfo:(NSString *)info
{
#ifdef DEBUG
    NSLog(@"WARNING: %@ %@", msg, info);
#endif
}

+ (void)logNotice:(NSString *)msg withInfo:(NSString *)info
{
#ifdef DEBUG
    NSLog(@"NOTICE: %@ %@", msg, info);
#endif
}

+ (void)logError:(NSString *)msg
{
    [Logger logError:msg withInfo:@""];
}

+ (void)logWarning:(NSString *)msg
{
    [Logger logWarning:msg withInfo:@""];
}

+ (void)logNotice:(NSString *)msg
{
    [Logger logNotice:msg withInfo:@""];
}

+ (void)enableSDMDetailedLogging
{
    [SDMLogger enableLogging];
}

+ (void)disableSDMDetailedLogging
{
    [SDMLogger disableLogging];
}

@end
