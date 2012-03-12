//
//  BaseRESTFulTests.m
//  MixAndMatch
//
//  Created by Florian Schebelle on 12.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BaseRESTFulTests.h"
#import "EventRequest.h"
#import "Match.h"
#import "Location.h"

@implementation BaseRESTFulTests

+ (NSDateFormatter *) JSON_DATE_FORMATTER
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter new] autorelease];
    [dateFormatter  setDateFormat:@"yyyyMMdd"];
    dateFormatter.timeZone = [NSTimeZone defaultTimeZone];
    dateFormatter.locale = [NSLocale currentLocale];
    return dateFormatter;
}

+ (NSDateFormatter *) GERMAN_DATE_FORMATTER
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter new] autorelease];
    [dateFormatter  setDateFormat:@"dd.MM.yyyy"];
    dateFormatter.timeZone = [NSTimeZone defaultTimeZone];
    dateFormatter.locale = [NSLocale currentLocale];
    return dateFormatter;
    
}

-(void)setUp
{
    [super setUp];
    
    // Setup the RKObjectManager for the RESTFul Webservice URL.
    [RKObjectManager objectManagerWithBaseURL:@"http://ec2-46-137-12-115.eu-west-1.compute.amazonaws.com/api"];
    // Setup JSON MIMEType instead of default FORM MIMEType
    [RKObjectManager sharedManager].serializationMIMEType = RKMIMETypeJSON;
    // Setup date format for mapping JSON -> object
    [RKObjectMapping addDefaultDateFormatter: [BaseRESTFulTests JSON_DATE_FORMATTER]];
    // Setup date format for mapping object->JSON
    [RKObjectMapping setPreferredDateFormatter: [BaseRESTFulTests JSON_DATE_FORMATTER]];
    // Enable RestKit debug logging.
    RKLogConfigureByName("RestKit/Network", RKLogLevelTrace);
    // Setup rout pathes
    RKObjectRouter *router = [RKObjectRouter new];
    
    [router routeClass: [EventRequest class] toResourcePath:@"/requests/:locationKey/:date/lunch/:userId" forMethod:RKRequestMethodDELETE];
    [router routeClass: [EventRequest class] toResourcePath:@"/requests" forMethod:RKRequestMethodPOST]; // Params: &locationKey=&userid=&date=
    [router routeClass: [EventRequest class] toResourcePath:@"/users/:userId" forMethod:RKRequestMethodGET];
    
    [router routeClass:[Match class] toResourcePath:@"/users/:userId/matches" forMethod:RKRequestMethodGET];
    
    [RKObjectManager sharedManager].router = router;
    [router release];
}

-(void)tearDown
{
    [super tearDown];
}
@end
