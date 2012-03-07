//
//  AppDelegate.m
//  MixAndMatch
//
//  Created by Florian Schebelle on 23.02.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"

#import <RestKit/RestKit.h>

#import "Model/EventRequest.h"
#import "Model/Location.h"
#import "Model/Match.h"
@implementation AppDelegate

@synthesize navigationController = _navigationController;
@synthesize window = _window;

+ (NSDateFormatter *) objectToJson
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter new] autorelease];
    [dateFormatter  setDateFormat:@"yyyyMMdd"];
    dateFormatter.timeZone = [NSTimeZone defaultTimeZone];
    dateFormatter.locale = [NSLocale currentLocale];
    return dateFormatter;
}

+ (NSDateFormatter *) jsonToObject
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter new] autorelease];
    [dateFormatter  setDateFormat:@"dd.MM.yyyy"];
    dateFormatter.timeZone = [NSTimeZone defaultTimeZone];
    dateFormatter.locale = [NSLocale currentLocale];
    return dateFormatter;
    
}

- (void)dealloc
{
    [_window release];
    [_navigationController release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Setup the RKObjectManager for the RESTFul Webservice URL.
    [RKObjectManager objectManagerWithBaseURL:@"http://ec2-46-137-12-115.eu-west-1.compute.amazonaws.com/api"];
    // Setup the default date handling
    [RKObjectMapping addDefaultDateFormatter: [AppDelegate objectToJson]];
    [RKObjectMapping setPreferredDateFormatter: [AppDelegate jsonToObject]];
    [self setupObjectMapping];
    [self setupResourcePathes];
    // Override point for customization after application launch.
    self.window.rootViewController = self.navigationController;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void) setupResourcePathes{
    RKObjectRouter *router = [RKObjectRouter new];
    
    //[router routeClass: [EventRequest class] toResourcePath:@"/requests/" forMethod:RKRequestMethodGET];
    //[router routeClass: [EventRequest class] toResourcePath:@"/requests/(locationKey)" forMethod:RKRequestMethodGET];
    //[router routeClass: [EventRequest class] toResourcePath:@"/requests/:locationKey/:date" forMethod:RKRequestMethodGET];
    //[router routeClass: [EventRequest class] toResourcePath:@"/requests/:locationKey/:date/lunch" forMethod:RKRequestMethodGET];
    [router routeClass: [EventRequest class] toResourcePath:@"/requests/:locationKey/:date/lunch/:userId" forMethod:RKRequestMethodGET];
    //[router routeClass: [EventRequest class] toResourcePath:@"/requests/:locationKey/:date/lunch/:userId" forMethod:RKRequestMethodDELETE];
    [router routeClass: [EventRequest class] toResourcePath:@"/requests" forMethod:RKRequestMethodPOST]; // Params: &locationKey=&userid=&date=
    //[router routeClass: [EventRequest class] toResourcePath:@"/users/:userId" forMethod:RKRequestMethodGET];
    
    //[router routeClass:[Match class] toResourcePath:@"/matches" forMethod:RKRequestMethodGET];
    [router routeClass:[Match class] toResourcePath:@"/users/:userId/matches" forMethod:RKRequestMethodGET];
    
    //[router routeClass: [Location class] toResourcePath:@"/locations/:key"];
    [router routeClass: [Location class] toResourcePath:@"/locations" forMethod:RKRequestMethodGET];
    
    [RKObjectManager sharedManager].router = router;
    [router release];
}

- (void) setupObjectMapping
{
    //[[RKObjectManager sharedManager].mappingProvider setSerializationMapping:[EventRequest mapping] forClass:[EventRequest class]];
    [[RKObjectManager sharedManager].mappingProvider addObjectMapping:[EventRequest mapping]];
}

@end
