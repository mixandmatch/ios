//
//  Coordinate.m
//  
//
//  Created by  on 25.09.11.
//  Copyright 2011. All rights reserved.
//

#import "Coordinate.h"

@implementation Coordinate

@synthesize lat = _lat;
@synthesize lon = _lon;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

+ (RKObjectMapping*) mapping{
    return [RKObjectMapping mappingForClass:[Coordinate class] block:^(RKObjectMapping* mapping) {
        [mapping mapKeyPathsToAttributes:
         @"lat",@"lat",
         @"lon",@"lon", nil];
    }];
}

@end
