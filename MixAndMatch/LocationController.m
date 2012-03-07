//
//  LocationController.m
//  MixAndMatch
//
//  Created by Florian Schebelle on 22.02.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LocationController.h"
#import "Location.h"
#import "AppDelegate.h"
#import "MapPoint.h"
#import "Coordinate.h"

@interface LocationController ()

@end

@implementation LocationController

@synthesize locationPicker=_locationPicker;
@synthesize delegate=_delegate;
@synthesize locationPoint=_locationPoint;
@synthesize mapView=_mapView;

- (void)dealloc
{
    [_locationPicker release]; _locationPicker = nil;
    [singleLocation release];
    [locations release];
    [_locationPoint release]; _locationPoint = nil;
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        if(!locations)
        {
            // Do any additional setup after loading the view from its nib.
            [[RKObjectManager sharedManager] loadObjectsAtResourcePath:@"/locations" objectMapping:[Location mapping] delegate:self];
            //[[RKObjectManager sharedManager] getObject:[[Location alloc] init] mapResponseWith:[Location mapping] delegate:self];
        }
    }
    return self;
}

- (void)updateMapPoint:(NSInteger) row
{
    if(singleLocation)
    {
        [singleLocation release];
    }
    singleLocation = [locations objectAtIndex:row];
    [singleLocation retain];
    
    if(_locationPoint)
    {
        [_mapView removeAnnotation:_locationPoint];
        [_locationPoint release];
    }
    _locationPoint = [[MapPoint alloc] initWithCoordinate:[[[CLLocation alloc] initWithLatitude:[[singleLocation coordinates] lat] longitude:[[singleLocation coordinates] lon]]coordinate] title: singleLocation.descriptionText];
    [_mapView addAnnotation:_locationPoint];
    [self reloadInputViews];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
# pragma mark UIView
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    if([_delegate respondsToSelector:@selector(transferLocation:)])
    {
        [_delegate transferLocation:singleLocation];
    }
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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
#pragma mark RestKit Object Loader

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects
{
    if(locations)
    {
        [locations release];
    }else {
        locations = [[NSMutableArray alloc] initWithCapacity:[objects count]];
    }
    
    [locations addObjectsFromArray:objects];
    
    NSLog(@"Count: %i",[objects count]);
    for (Location *item in objects) {
        NSLog(@"Item: %@", item.label);
        NSLog(@"Coordinate lat: %g lon: %g", [[item coordinates] lat], [[item coordinates] lon]);
    }    
    [_locationPicker reloadAllComponents];
    [self updateMapPoint:0];
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error
{
    
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
# pragma mark Picker

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [locations count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    Location *loc = [locations objectAtIndex:row];
    return [loc label];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [self updateMapPoint:row];
}

@end
