//
//  AppDelegate.m
//  MixAndMatch
//
//  Created by Florian Schebelle on 23.02.12.
//  Copyright (c) 2012 metafinanz Informationssysteme GmbH. All rights reserved.
//

#import "AppDelegate.h"

#import <RestKit/RestKit.h>

#import "Model/EventRequest.h"
#import "Model/Location.h"
#import "Model/Match.h"
#import "SetupLunchViewController.h"
#import "EventRequestController.h"
#import "MatchController.h"
#import "SetUserViewController.h"

@implementation AppDelegate

@synthesize navigationController = _navigationController;
@synthesize window = _window;
@synthesize tabBarController=_tabBarController;

+ (NSDateFormatter *) JSON_DATE_FORMATTER
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter new] autorelease];
    [dateFormatter  setDateFormat:@"yyyyMMdd"];
    dateFormatter.timeZone = [NSTimeZone defaultTimeZone];
    dateFormatter.locale = [NSLocale currentLocale];
    return dateFormatter;
}

+ (NSDateFormatter *) GERMAN_DATE_FORMATTER
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter new] autorelease];
    [dateFormatter  setDateFormat:@"dd.MM.yyyy"];
    dateFormatter.timeZone = [NSTimeZone defaultTimeZone];
    dateFormatter.locale = [NSLocale currentLocale];
    return dateFormatter;
    
}

+ (void)showDefaultErrorAlert:(id)currentView
{
    UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Error" message:@"New event request couldn't be created!" delegate:currentView cancelButtonTitle:nil otherButtonTitles:nil] autorelease];
    [alert addButtonWithTitle:@"Close"];
    [alert show];
}

- (void)dealloc
{
    [_userName release]; _userName=nil;
    [_window release];_window=nil;
    [_navigationController release];_navigationController=nil;
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Setup the RKObjectManager for the RESTFul Webservice URL.
    [RKObjectManager objectManagerWithBaseURL:@"http://ec2-46-137-12-115.eu-west-1.compute.amazonaws.com/api"];
    // Setup JSON MIMEType instead of default FORM MIMEType
    [RKObjectManager sharedManager].serializationMIMEType = RKMIMETypeJSON;
    // Setup date format for mapping JSON -> object
    [RKObjectMapping addDefaultDateFormatter: [AppDelegate JSON_DATE_FORMATTER]];
    // Setup date format for mapping object->JSON
    [RKObjectMapping setPreferredDateFormatter: [AppDelegate JSON_DATE_FORMATTER]];
    // Enable RestKit debug logging.
    RKLogConfigureByName("RestKit/Network", RKLogLevelTrace);
    [self setupObjectMapping];
    [self setupResourcePathes];
    // Override point for customization after application launch.
//    self.window.rootViewController = self.navigationController;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    [self enableTabNavigationBar];
    // This will enlarge the time to see the launch image ;-)
    sleep(2);
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
    
    [router routeClass: [EventRequest class] toResourcePath:@"/requests/:locationKey/:date/lunch/:userId" forMethod:RKRequestMethodDELETE];
    [router routeClass: [EventRequest class] toResourcePath:@"/requests" forMethod:RKRequestMethodPOST]; // Params: &locationKey=&userid=&date=
    [router routeClass: [EventRequest class] toResourcePath:@"/users/:userId" forMethod:RKRequestMethodGET];
    
    [router routeClass:[Match class] toResourcePath:@"/users/:userId/matches" forMethod:RKRequestMethodGET];
    
    [RKObjectManager sharedManager].router = router;
    [router release];
}

- (void) setupObjectMapping
{
    [[RKObjectManager sharedManager].mappingProvider setSerializationMapping:[Location mapping] forClass:[Location class]];
    
    [[RKObjectManager sharedManager].mappingProvider setSerializationMapping:[EventRequest mapping] forClass:[EventRequest class]];
    
    [[RKObjectManager sharedManager].mappingProvider setSerializationMapping:[Match mapping] forClass:[Match class]];
}

- (void)enableTabNavigationBar
{
    self.tabBarController = [[UITabBarController alloc] init];
    
    NSString *eventView;
    NSString *matchView;
    NSString *setupLunchView;
    NSString *setUserView;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        eventView=@"EventRequestView_iPhone";
        matchView=@"MatchView_iPhone";
        setupLunchView=@"SetupLunchView_iPhone";
        setUserView=@"SetUserViewController";
    }else {
        eventView=@"EventRequestView_iPad";
        matchView=@"MatchView_iPad";
        setupLunchView=@"SetupLunchView_iPad";
        setUserView=@"SetUserView_iPad";
    }
    
    // Setup Event Request controller with tab bar item. Disable this tab bar item.
    EventRequestController *eventRequestController = [[EventRequestController alloc] initWithNibName:eventView bundle:nil masterController:self];
    [eventRequestController setTabBarItem:[[UITabBarItem alloc]initWithTabBarSystemItem:UITabBarSystemItemMostViewed tag:1]];

    // Setup match controller with tab bar item. Disable this tab bar item.
    MatchController *matchController = [[MatchController alloc] initWithNibName:matchView bundle:nil masterController:self];
    [matchController setTabBarItem:[[UITabBarItem alloc]initWithTabBarSystemItem:UITabBarSystemItemFavorites tag:2]];
    
    // Setup lunch controller with tab bar item. Disable this tab bar item.
    SetupLunchViewController *setupLunchController = [[SetupLunchViewController alloc] initWithNibName:setupLunchView bundle:nil masterController:self];
    [setupLunchController setTabBarItem:[[UITabBarItem alloc]initWithTabBarSystemItem:UITabBarSystemItemMostRecent tag:3]];
    
    // Setup user controller with tab bar item.
    SetUserViewController *setUserViewController = [[SetUserViewController alloc] initWithNibName:setUserView bundle:nil masterController:self];
    [setUserViewController setTabBarItem:[[UITabBarItem alloc]initWithTabBarSystemItem:UITabBarSystemItemContacts tag:0]];
    
    NSArray *controllers = [[NSArray alloc] initWithObjects:setUserViewController, eventRequestController,matchController,setupLunchController, nil];
    
    [self.tabBarController setViewControllers:controllers];
    [setUserView release];
    [eventView release];
    [matchView release];
    [setupLunchView release];
    [setUserViewController release];
    [eventRequestController release];
    [matchController release];
    [setupLunchController release];
    [controllers release];
    
    [self.window setRootViewController:_tabBarController];
    
    //Disable all controllers, despite the user login controller.
    [self enableControllers:NO];
    
//    [self setupNotificationCenter];
    // Show the window
    [[self window] makeKeyAndVisible];
}

- (void)enableControllers:(BOOL)flag
{
    UITabBarController *controller = (UITabBarController *)[self tabBarController];
    // Disable all other tabs
    for(int i = 1; i<4; i++)
    {
        UIViewController *viewController = [controller.viewControllers objectAtIndex:i];
        [viewController.tabBarItem setEnabled:flag];
    }
}

- (void)setupNotificationCenter
{
    UIDevice *device=[UIDevice currentDevice];
    
    [device beginGeneratingDeviceOrientationNotifications];
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    
    [nc addObserver:self selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification object:device];
}

- (void)orientationChanged:(NSNotification *)note
{
    // to change the style of presentation
    UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Really reset?" message:@"Do you really want to reset this game?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil] autorelease];
    // optional - add more buttons:
    [alert addButtonWithTitle:@"Yes"];
    [alert show];
    NSLog(@"orientationChaned: %d", [[note object] orientation]);
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
# pragma mark MFSetUserDelegate
-(void)setLoginUserName:(NSString *)userName
{
    if(_userName)
    {
        [_userName release];
    }
    
    _userName=[userName copy];
}
-(NSString *)loginUserName
{
    return _userName;
}

@end
