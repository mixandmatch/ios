//
//  BaseLunchController.m
//  
//
//  Created by Florian Schebelle on 11.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BaseLunchController.h"
#import "AppDelegate.h"

@implementation BaseLunchController

@synthesize activityIndicatorView = _activityIndicatorView;
@synthesize tableView = _tableView;
@synthesize entriesHVU = _entriesHVU;
@synthesize entriesKP = _entriesKP;
@synthesize entriesOthers = _entriesOthers;
@synthesize masterController = _masterController;

-(void)dealloc
{
    [self resetEvents];
    [_masterController release]; _masterController=nil;
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil masterController:(id<MFSetUserDelegate>)delegate
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self)
    {
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

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self resetEvents];
    [_tableView reloadData];
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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return (section==HVU ? @"HVU" : (section == KP ? @"Kistenpfennig" : @"Others"));
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (section==HVU ? [_entriesHVU count] : (section == KP ? [_entriesKP count] : [_entriesOthers count]));
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
# pragma mark Helper methods
-(void)resetEvents
{
    // Reset old arrays
    [_entriesHVU release]; _entriesHVU = nil;
    [_entriesKP release]; _entriesKP = nil;
    [_entriesOthers release]; _entriesOthers = nil;
}



////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark RestKit Object Loader

-(void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error
{
    [self.activityIndicatorView stopAnimating];
    
    NSLog(@"Error: %@", error.localizedDescription);  
    [AppDelegate showDefaultErrorAlert:self];
}
@end
