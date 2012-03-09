//
//  Location.m
//  
//
//  Created by  on 25.09.11.
//  Copyright 2011. All rights reserved.
//

#import "Location.h"

#import "Coordinate.h"

@implementation Location

@synthesize coordinates = _coordinates;
@synthesize descriptionText = _descriptionText;
@synthesize key = _key;
@synthesize label = _label;
@synthesize venue = _venue;

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
    [_coordinates release], _coordinates = nil;
    [_descriptionText release], _descriptionText = nil;
    [_key release], _key = nil;
    [_label release], _label = nil;
    [_venue release], _venue = nil;
    
    [super dealloc];
    
}

+ (RKObjectMapping*) mapping{
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[Location class]];
    [mapping mapKeyPathsToAttributes:
     @"description",@"descriptionText",
     @"key",@"key",
     @"label",@"label",
     @"venue",@"venue", nil];
    [mapping mapRelationship:@"coordinates" withMapping:[Coordinate mapping]];
    return mapping;
}

@end
