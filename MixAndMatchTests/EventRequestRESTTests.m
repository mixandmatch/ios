//
//  EventRequestRESTTests.m
//  MixAndMatch
//
//  Created by Florian Schebelle on 12.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EventRequestRESTTests.h"
#import "EventRequest.h"

@implementation EventRequestRESTTests

-(void)setUp
{
    [super setUp];
    
}

-(void)tearDown
{
    [super tearDown];
    
}

-(void)testGetAllEventRequests
{
    // Setup object manager to get all available event request objects.
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:@"/requests" objectMapping:[EventRequest mapping] delegate:self];
    NSLog(@"RKObjetManager sharedManager: %@",[[RKObjectManager sharedManager] debugDescription]);
    
}

-(void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects
{
    if(objects)
    {
        int i = 0;
        NSLog(@"Retrieved %i EventReuqest instances.", [objects count]);
        for (EventRequest *item in objects) {
            NSLog(@"EventRequest object: %i", ++i);
            NSLog(@"EventReuqest.location: %@", item.locationKey);
            NSLog(@"EventReuqest.date: %@", item.date);
            NSLog(@"EventReuqest.userid: %@", item.userid);
        }
    }
    else
    {
        NSLog(@"No EventReuest instanes found!"); 
    }
    
}

-(void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error
{
    NSLog(@"%@: Execution error.", self.debugDescription);
}

@end
