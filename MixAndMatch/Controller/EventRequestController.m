//
//  EventRequestControllerViewController.m
//  MixAndMatch
//
//  Created by Florian Schebelle on 22.02.12.
//  Copyright (c) 2012 metafinanz Informationssysteme GmbH. All rights reserved.
//

#import "EventRequestController.h"
#import "EventRequest.h"
#import "AppDelegate.h"
#import "NSString+StringUtils.h"

@interface EventRequestController ()

@end

@implementation EventRequestController

-(void)dealloc
{
    [_eventRequests release];
    [_masterController release]; _masterController=nil;
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil masterController:(id<MFSetUserDelegate>)delegate
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self)
    {
        if(!_eventRequests)
        {
            _eventRequests = [[NSMutableArray alloc] init];
        }
        _masterController = delegate;
        [_masterController retain];
    }
    
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    @throw [NSException exceptionWithName:@"Wrong initializer"
                                   reason:@"Use initWithNibName: bundle: masterController:"
                                 userInfo:nil];
    return nil;
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSMutableString *requestPath = [[NSMutableString alloc] initWithString:@"/users/"];
    if([_masterController respondsToSelector:@selector(loginUserName)])
    {
        [requestPath appendString:[_masterController loginUserName]];
    }
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:requestPath objectMapping:[EventRequest mapping] delegate:self];
    [requestPath release];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark UITable
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EventRequest *item = [_eventRequests objectAtIndex:indexPath.row];
    [item retain];
    
    static NSString *cellIdentifier = @"EventRequest";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        [cell autorelease];
        cell.textLabel.font = [UIFont boldSystemFontOfSize:16];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    NSMutableString *itemText = [[NSMutableString alloc] initWithString:@""];
    NSDateFormatter *formatter = [AppDelegate GERMAN_DATE_FORMATTER];
    [formatter retain];
    
    if(![NSString isBlank:item.userid])
    {
        [itemText appendString:item.userid];
    }
    [itemText appendString:@", "];
    [itemText appendString:[formatter stringFromDate: item.date]];
    cell.detailTextLabel.text = itemText;
    
    NSMutableString *detailText = [[NSMutableString alloc] initWithString:item.locationKey];
    [detailText appendString:@":"];
    cell.textLabel.text=detailText;
    
    [item release];
    [itemText release];
    [detailText release];
    [cellIdentifier release];
    [formatter release];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_eventRequests count];
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark RestKit Object Loader

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects
{
    [_eventRequests removeAllObjects];
    [_eventRequests addObjectsFromArray:objects];
    [[self tableView] reloadData];
}

-(void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error
{
    NSLog(@"Error: %@", error.localizedDescription);  
    [AppDelegate showDefaultErrorAlert:self];
}

@end
