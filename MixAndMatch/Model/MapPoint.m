//
//  MapPoint.m
//  MixAndMatch
//
//  Created by Florian Schebelle on 06.03.12.
//  Copyright (c) 2012 metafinanz Informationssysteme GmbH. All rights reserved.
//

#import "MapPoint.h"

@implementation MapPoint

@synthesize coordinate, title, subtitle;
- (void)dealloc
{
    [title release];
    [super dealloc];
}

- (id)initWithCoordinate:(CLLocationCoordinate2D)c title:(NSString *)t subtitle: (NSString *) st
{
    self = [super init];
    if(self)
    {
        coordinate=c;
        [self setTitle:t];
        if(st)
        {
            [self setSubtitle:st];
        }
    }
    return self;
}
@end
