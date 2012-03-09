//
//  Match.m
//  
//
//  Created by  on 25.09.11.
//  Copyright 2011. All rights reserved.
//

#import "Match.h"

@implementation Match

@synthesize date = _date;
@synthesize locationKey = _locationKey;
@synthesize type = _type;
@synthesize users = _users;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}


- (void)dealloc
{
    [_date release], _date = nil;
    [_locationKey release], _locationKey = nil;
    [_type release], _type = nil;
    [_users release], _users = nil;
    
    [super dealloc];
    
}

+ (RKObjectMapping*) mapping{
    return [RKObjectMapping mappingForClass:[Match class] block:^(RKObjectMapping* mapping) {
        [mapping mapKeyPathsToAttributes:
         @"date",@"date",
         @"locationKey",@"locationKey",
         @"type",@"type",
         @"users",@"users", nil];
    }];
}

@end
