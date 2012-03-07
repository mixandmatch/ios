//
//  Match.m
//  
//
//  Created by  on 25.09.11.
//  Copyright 2011. All rights reserved.
//

#import "Match.h"

@implementation Match

@synthesize date = date;
@synthesize locationKey = locationKey;
@synthesize type = type;
@synthesize users = users;

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
    [date release], date = nil;
    [locationKey release], locationKey = nil;
    [type release], type = nil;
    [users release], users = nil;
    
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
