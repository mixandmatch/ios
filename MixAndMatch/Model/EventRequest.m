//
//  MyClass.m
//  
//
//  Created by Florian Schebelle on 25.09.11.
//  Copyright 2011. All rights reserved.
//

#import "EventRequest.h"

@implementation EventRequest

@synthesize date = _date;
//@synthesize eventRequestId = _eventRequestId;
@synthesize locationKey = _locationKey;
//@synthesize rev = _rev;
@synthesize type = _type;
@synthesize url = _url;
@synthesize userId = _userId;

- (id)init
{
    self = [super init];
    if (self) {
    }
    
    return self;
}


- (void)dealloc {
    [_date release], _date = nil;
    //[_eventRequestId release], _eventRequestId = nil;
    [_locationKey release], _locationKey = nil;
    //[_rev release], _rev = nil;
    [_type release], _type = nil;
    [_url release], _url = nil;
    [_userId release], _userId = nil;
    
    [super dealloc];
    
}

+ (RKObjectMapping*) mapping{
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[EventRequest class]];
     [mapping mapKeyPath:@"date" toAttribute:@"date"];
    //[mapping mapKeyPath:@"_id" toAttribute:@"_eventRequestId"];
     [mapping mapKeyPath:@"locationKey" toAttribute:@"locationKey"];
    //[mapping mapKeyPath:@"_rev" toAttribute:@"_rev"];
     [mapping mapKeyPath:@"type" toAttribute:@"type"];
     [mapping mapKeyPath:@"url" toAttribute:@"url"];
     [mapping mapKeyPath:@"userid" toAttribute:@"userId"];
    return mapping;
}
@end
