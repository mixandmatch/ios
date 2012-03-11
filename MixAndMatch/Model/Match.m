//
//  Match.m
//  
//
//  Created by  on 25.09.11.
//  Copyright 2011. All rights reserved.
//

#import "Match.h"

@implementation Match

@synthesize date;
@synthesize locationKey;
@synthesize type;
@synthesize users;

+ (RKObjectMapping*) mapping{
    return [RKObjectMapping mappingForClass:[Match class] block:^(RKObjectMapping* mapping) {
        [mapping mapKeyPathsToAttributes:
         @"date",@"date",
         @"locationKey",@"locationKey",
         @"type",@"type",
         @"users",@"users", nil];
    }];
}

- (NSComparisonResult) compareDate: (Match *) other
{
    return (other ? [other.date compare:self.date] : NSOrderedDescending);
}

@end
