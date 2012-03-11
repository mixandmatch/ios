//
//  MatchController.m
//  MixAndMatch
//
//  Created by Florian Schebelle on 23.02.12.
//  Copyright (c) 2012 metafinanz Informationssysteme GmbH. All rights reserved.
//

#import "MatchController.h"
#import "Match.h"
#import "AppDelegate.h"

@interface MatchController ()

@end

@implementation MatchController

- (void)dealloc
{
    [matches release];
    [_masterController release];
    [super dealloc];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil masterController:(id<MFSetUserDelegate>)delegate
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self)
    {
        _masterController = delegate;
        [_masterController retain];
        
        if(!matches)
        {
            matches = [[NSMutableArray alloc] init];
        }
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
	// Do any additional setup after loading the view, typically from a nib.
    NSMutableString *requestPath = [[NSMutableString alloc] initWithString:@"/users/"];
    if([_masterController respondsToSelector:@selector(loginUserName)])
    {
        [requestPath appendString:[_masterController loginUserName]];
    }
    [requestPath appendString:@"/matches"];
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:requestPath objectMapping:[Match mapping] delegate:self];
    [requestPath release];
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
#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [matches count];   
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Match";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        [cell autorelease];
        cell.textLabel.font = [UIFont boldSystemFontOfSize:16];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    Match *item = [matches objectAtIndex:indexPath.row];
    [item retain];
    NSMutableString *itemText = [[NSMutableString alloc] initWithString:@""];
    NSDateFormatter *formatter = [AppDelegate GERMAN_DATE_FORMATTER];
    [formatter retain];
    
    for(NSString *user in item.users)
    {
        [itemText appendString:user];
        [itemText appendString:@" "];
    }
    [itemText appendString:@", "];
    [itemText appendString:[formatter stringFromDate: item.date]];
    cell.detailTextLabel.text = itemText;
    
    NSMutableString *detailText = [[NSMutableString alloc] initWithString:item.locationKey];
    [detailText appendString:@":"];
    cell.textLabel.text=detailText;
    
    [cellIdentifier release];
    [item release];
    [itemText release];
    [detailText release];
    [formatter release];
    
    return cell;
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark RestKit Object Loader

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects
{
    NSLog(@"Received matches!");
    [matches removeAllObjects];
    
    [matches addObjectsFromArray:objects];
    NSLog(@"Count: %i",[matches count]);
    for (Match *item in objects) {
        NSLog(@"Item: %@", item);
    }
    [self.tableView reloadData];
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error
{
    NSLog(@"Error: %@", error.localizedDescription);  
    [AppDelegate showDefaultErrorAlert:self];
}
@end
