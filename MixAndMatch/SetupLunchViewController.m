//
//  SetupLunchViewController.m
//  MixAndMatch
//
//  Created by Florian Schebelle on 25.02.12.
//  Copyright (c) 2012 metafinanz Informationssysteme GmbH. All rights reserved.
//

#import "SetupLunchViewController.h"
#import "EventRequest.h"
#import "AppDelegate.h"

@interface SetupLunchViewController ()

@end

@implementation SetupLunchViewController
@synthesize selectedLocation=_location;
@synthesize selectedDate=_date;
@synthesize userName=_userName;

- (void)dealloc
{
    [tableContentDate release];
    [tableContentLocation release];
    [tableSections release];
    [_location release]; _location=nil;
    [_date release]; _date=nil;
    [_userName release]; _userName=nil;
    [super dealloc];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil forUser: (NSString *) selectedUserName
{
    self = [self initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if(self)
    {
        [self setUserName:selectedUserName];
    }
    
    return self;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self)
    {
        tableContentDate = [[NSArray arrayWithObjects:@"Date",nil] retain];
        tableContentLocation = [[NSArray arrayWithObjects:@"Location", nil] retain];
        // Setup the sections of the table (group layout)
        tableSections = [[NSArray arrayWithObjects:@"Date", @"Location",nil] retain];
        
    }
    return self;
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [tableSections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [tableSections objectAtIndex:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier];
    }
    
    NSString *cellDetail=@"";
    NSString *cellLabel=@"";
    
    if(indexPath.section==0)
    {
        if(_date)
        {
            NSDateFormatter *formatter = [AppDelegate GERMAN_DATE_FORMATTER];
            cellDetail=[formatter stringFromDate:_date];
        }
        cellLabel=@"Date:";
    }else if(indexPath.section==1)
    {
        if(_location)
        {
            cellDetail=[_location key];
        }
        cellLabel=@"Location:";
    }
    
    cell.textLabel.text=cellLabel;
    cell.detailTextLabel.text=cellDetail;
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    NSString *viewNibName;
    NSString *controllerName;
    NSString *title;
    if(indexPath.section == 0){
        viewNibName = @"DatePickerView_iPhone";
        controllerName = @"DatePickerViewController";
        title=@"DatePicker";
    }else if(indexPath.section == 1){
        viewNibName = @"LocationView_iPhone";
        controllerName = @"LocationController";
        title=@"LocationPicker";
    }
    
    Class controllerClass = NSClassFromString(controllerName);
    UIViewController* viewController = [[controllerClass alloc] initWithNibName:viewNibName bundle:nil];
    // Setup delegation
    [viewController setDelegate:self];
    
    if (viewController) {
        [self presentViewController:viewController animated:YES completion: nil];
        
        if (viewController.title == nil) {
            viewController.title = title;
        }
        
        [viewController release];
    }
    
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
# pragma mark IBAction

- (void)cancel:(id)sender
{
    
    [_date release];_date=nil;
    [_location release]; _location=nil;
    [table reloadData];
    [self toggleAddButton];
}

-(void)save:(id)sender
{
    EventRequest *eventRequest = [[EventRequest alloc] init];
    [eventRequest retain];
    [eventRequest setDate:[self selectedDate]];
    [eventRequest setLocationKey:[[self selectedLocation] key]];
    //NSLog(@"_userName: %@", [self userName]);
    [eventRequest setUserid:[self userName]];
    [eventRequest setType:@"request"];
    
    //[[RKObjectManager sharedManager] postObject:eventRequest delegate:self];
    [[RKObjectManager sharedManager] postObject:eventRequest mapResponseWith:[EventRequest mapping] delegate:self];
    
    [eventRequest release];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
# pragma mark LocationControllerDelegate
-(void)transferLocation:(Location *)location
{
    [self setSelectedLocation:location];
    [table reloadData];
    [self toggleAddButton];
    NSLog(@"Indexpath: %i",[[table indexPathForSelectedRow] section]);
}
- (void) transferDate:(NSDate *) date
{
    [self setSelectedDate:date];
    [table reloadData];
    [self toggleAddButton];
}

-(void)toggleAddButton
{
    if(_location && _date)
    {
        [barButtonItemAdd setEnabled:YES];
    }
    else {
        [barButtonItemAdd setEnabled:NO];
    }
}
@end
