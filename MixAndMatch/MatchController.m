//
//  MatchController.m
//  MixAndMatch
//
//  Created by Florian Schebelle on 23.02.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MatchController.h"
#import "Match.h"

@interface MatchController ()

@end

@implementation MatchController

- (void)dealloc
{
    [matches release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        if(!matches)
        {
            matches = [[NSMutableArray alloc] init];
        }
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
	// Do any additional setup after loading the view, typically from a nib.
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:@"/users/ttt/matches" objectMapping:[Match mapping] delegate:self];
//    Match *match = [[Match alloc]init];
//    [match retain];
//    [match setUsers:[[NSArray alloc] initWithObjects:@"ttt", nil]];
//    [[RKObjectManager sharedManager] getObject:match delegate:self];
//    [match release];
     
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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.textLabel.font = [UIFont boldSystemFontOfSize:16];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    Match *item = [matches objectAtIndex:indexPath.row];
    NSMutableString *itemText = [[NSMutableString alloc] initWithString:item.locationKey];
    cell.textLabel.text = itemText;
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
}
@end
