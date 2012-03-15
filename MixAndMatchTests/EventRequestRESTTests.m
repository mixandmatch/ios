//
//  EventRequestRESTTests.m
//  MixAndMatch
//
//  Created by Florian Schebelle on 12.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EventRequestRESTTests.h"

@implementation EventRequestRESTTests


-(void)setUp
{
    [super setUp];
    done=NO;
    runTest=YES;
    // Test parameter
    currentDate = [[NSDate alloc] init];
    thinkTime = 20.0;
    // Setup test objects
    requestForTestUser= [[EventRequest alloc] init];
    
    [requestForTestUser setUserid:@"test"];
    [requestForTestUser setLocationKey:@"HVU"];
    [requestForTestUser setDate:currentDate];
}

-(void)tearDown
{
    [super tearDown];
    // Test parameter
    [currentDate release];
    // Release test user;
    [requestForTestUser release];
    
}

- (BOOL)waitForCompletion:(NSTimeInterval)timeoutSecs {
    NSDate *timeoutDate = [NSDate dateWithTimeIntervalSinceNow:timeoutSecs];
    
    do {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:timeoutDate];
        if([timeoutDate timeIntervalSinceNow] < 0.0)
            break;
    } while (!done);
    
    return done;
}


-(void)testGetAllEventRequests
{
    if(runTest)
    {
        // Setup object manager to get all available event request objects.
        [[RKObjectManager sharedManager] loadObjectsAtResourcePath:@"/requests" objectMapping:[EventRequest mapping] delegate:self];
        NSLog(@"RKObjetManager sharedManager: %@",[[RKObjectManager sharedManager] client].baseURL);
        STAssertTrue([self waitForCompletion:thinkTime], @"Failed to get any results in time");
    }
}

-(void)testCreateEventRequest
{
    if(!runTest)
    {
        [[RKObjectManager sharedManager] postObject:requestForTestUser delegate:self];
        STAssertTrue([self waitForCompletion:thinkTime], @"Failed to get any results in time");
    }
}

-(void)testDeleteEventReuquest
{
    if(!runTest)
    {
        [[RKObjectManager sharedManager] deleteObject:requestForTestUser delegate:self];
        STAssertTrue([self waitForCompletion:thinkTime], @"Failed to get any results in time");
    }
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
    
    done = YES;    
}

-(void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error
{
    NSLog(@"%@: Execution error.", self.debugDescription);
}

@end
