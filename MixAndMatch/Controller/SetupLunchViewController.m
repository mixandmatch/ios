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
@synthesize table = _table;
@synthesize barButtonItemAdd = _barButtonItemAdd;

- (void)dealloc
{
    [_tableContentDate release];
    [_tableContentLocation release];
    [_tableSections release];
    [_location release]; _location=nil;
    [_date release]; _date=nil;
    [_userName release]; _userName=nil;
    [_masterController release]; _masterController=nil;
    [super dealloc];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil masterController:(id)delegate
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self)
    {
        _masterController = delegate;
        [_masterController retain];
        
        _tableContentDate = [[NSArray arrayWithObjects:@"Date",nil] retain];
        _tableContentLocation = [[NSArray arrayWithObjects:@"Location", nil] retain];
        // Setup the sections of the table (group layout)
        _tableSections = [[NSArray arrayWithObjects:@"Date", @"Location",nil] retain];
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

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if([_masterController respondsToSelector:@selector(loginUserName)])
    {
        [self setUserName:[_masterController loginUserName]];
        
    }
    [_table reloadData];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Table view data source

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_tableSections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [_tableSections objectAtIndex:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier];
        [cell autorelease];
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
    
    [CellIdentifier release];
    [cellLabel release];
    [CellIdentifier release];
    
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
    }else{
        viewNibName = @"";
        controllerName = @"";
        title=@"";
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
    
    [viewNibName release];
    [controllerName release];
    [title release];
    
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
# pragma mark IBAction

- (void)cancel:(id)sender
{
    [self resetView];    
}

-(void)save:(id)sender
{
    EventRequest *eventRequest = [[EventRequest alloc] init];
    [eventRequest setDate:[self selectedDate]];
    [eventRequest setLocationKey:[[self selectedLocation] key]];
    [eventRequest setUserid:[self userName]];
    [eventRequest setType:@"request"];
    
    [[RKObjectManager sharedManager] postObject:eventRequest mapResponseWith:[EventRequest mapping] delegate:self];
    
    [eventRequest release];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
# pragma mark LocationControllerDelegate
-(void)transferLocation:(Location *)location
{
    [self setSelectedLocation:location];
    [_table reloadData];
    [self toggleAddButton];
    NSLog(@"Indexpath: %i",[[_table indexPathForSelectedRow] section]);
}
- (void) transferDate:(NSDate *) date
{
    [self setSelectedDate:date];
    [_table reloadData];
    [self toggleAddButton];
}

-(void)toggleAddButton
{
    if(_location && _date)
    {
        [_barButtonItemAdd setEnabled:YES];
    }
    else {
        [_barButtonItemAdd setEnabled:NO];
    }
}

- (void)resetView
{
    [_date release];_date=nil;
    [_location release]; _location=nil;
    [_table reloadData];
    [self toggleAddButton];
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
# pragma mark RestKit call back
-(void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects
{
    // to change the style of presentation
    UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Event Request Creation" message:@"The event request creation was successfully!" delegate:self cancelButtonTitle:nil otherButtonTitles:nil] autorelease];
    // optional - add more buttons:
    [alert addButtonWithTitle:@"O.k."];
    [alert show];
    [self resetView];
}
-(void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error
{
    NSLog(@"Error: %@", error.localizedDescription);  
    [AppDelegate showDefaultErrorAlert:self];}
@end
