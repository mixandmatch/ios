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
    [eventRequests release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        if(!eventRequests)
        {
            eventRequests = [[NSMutableArray alloc] init];
        }
    }
    return self;
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:@"/users/FSE" objectMapping:[EventRequest mapping] delegate:self];
    
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
    EventRequest *item = [eventRequests objectAtIndex:indexPath.row];
    
    static NSString *cellIdentifier = @"EventRequest";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.textLabel.font = [UIFont boldSystemFontOfSize:16];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    NSMutableString *itemText = [[NSMutableString alloc] initWithString:@"["];
    NSDateFormatter *formatter = [AppDelegate GERMAN_DATE_FORMATTER];
    [itemText appendString:[formatter stringFromDate: item.date]];
    [itemText appendString:@"] mit: "];
    if(![NSString isBlank:item.userid])
    {
        [itemText appendString:item.userid];
    }
    [itemText appendString:@" in: "];
    [itemText appendString:item.locationKey];
    cell.textLabel.text = itemText;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [eventRequests count];
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark RestKit Object Loader

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects
{
    NSLog(@"Received event requests!");
    [eventRequests removeAllObjects];
    
    [eventRequests addObjectsFromArray:objects];
    NSLog(@"Count: %i",[eventRequests count]);
    [[self tableView] reloadData];
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error
{
    
}

@end
