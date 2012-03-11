//
//  LocationController.m
//  MixAndMatch
//
//  Created by Florian Schebelle on 22.02.12.
//  Copyright (c) 2012 metafinanz Informationssysteme GmbH. All rights reserved.
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
@synthesize _mapView=_mv;

- (void)dealloc
{
    [_locationPicker release]; _locationPicker = nil;
    [singleLocation release];
    [_locations release];
    [_locationPoint release]; _locationPoint = nil;
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self)
    {
        [[RKObjectManager sharedManager] loadObjectsAtResourcePath:@"/locations" objectMapping:[Location mapping] delegate:self];
        
    }
    
    return self;
}


- (void)updateMapPoint:(NSInteger) row
{
    if(singleLocation)
    {
        [singleLocation release];
    }
    singleLocation = [_locations objectAtIndex:row];
    [singleLocation retain];
    
    if(_locationPoint)
    {
        [_mv removeAnnotation:_locationPoint];
        [_locationPoint release];
    }
    _locationPoint = [[MapPoint alloc] initWithCoordinate:[[[CLLocation alloc] initWithLatitude:[[singleLocation coordinates] lat] longitude:[[singleLocation coordinates] lon]]coordinate] title: singleLocation.key subtitle:singleLocation.descriptionText];
    
    [_mv addAnnotation:_locationPoint];
    
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
    if(_locations)
    {
        [_locations release];
    }else {
        _locations = [[NSMutableArray alloc] initWithCapacity:[objects count]];
    }
    
    [_locations addObjectsFromArray:objects];
    
    [_locationPicker reloadAllComponents];
    [self updateMapPoint:0];
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error
{
    NSLog(@"Error: %@", error.localizedDescription);  
    [AppDelegate showDefaultErrorAlert:self];
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
    return [_locations count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    Location *loc = [_locations objectAtIndex:row];
    return [loc label];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [self updateMapPoint:row];
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
# pragma mark IBAction
- (IBAction)addLocation:(id)sender
{
    if([_delegate respondsToSelector:@selector(transferLocation:)])
    {
        [_delegate transferLocation:singleLocation];
    }
    [[self presentingViewController] dismissModalViewControllerAnimated:YES];
}
- (IBAction)cancel:(id)sender
{
    [[self presentingViewController] dismissModalViewControllerAnimated:YES];
    
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
# pragma mark MKMapViewDelegate
-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    MKCoordinateRegion mapRegion;   
    mapRegion.center = mapView.userLocation.coordinate;
    mapRegion.span.latitudeDelta = 0.2;
    mapRegion.span.longitudeDelta = 0.2;
    [mapView setRegion:mapRegion animated: YES];
}

@end
