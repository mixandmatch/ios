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

@synthesize setupLunchDelegate=_delegate;
@synthesize locationPoint=_locationPoint;

- (void)dealloc
{
    [_singleLocation release];
    [_locations release];
    [_locationPoint release];
    [_locationPicker release];
    if(locationManager.delegate == self)
    {
        [locationManager setDelegate:nil];
    }
    [_mapView release];
    [_activityIndicator release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self)
    {
        // Create location manager object
        locationManager = [[CLLocationManager alloc] init];
        [locationManager setDelegate:self];
        
        [locationManager setDistanceFilter:kCLDistanceFilterNone];
        [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
        // Fire request for all locations
        [[RKObjectManager sharedManager] loadObjectsAtResourcePath:@"/locations" objectMapping:[Location mapping] delegate:self];
        
    }
    
    return self;
}


- (void)updateMapPoint:(NSInteger) row
{
    if(_singleLocation)
    {
        [_singleLocation release];
    }
    _singleLocation = [_locations objectAtIndex:row];
    [_singleLocation retain];
    
    if(_locationPoint)
    {
        [_mapView removeAnnotation:_locationPoint];
        [_locationPoint release];
    }
    CLLocation *currentLocation=[[CLLocation alloc] initWithLatitude:[[_singleLocation coordinates] lat] longitude:[[_singleLocation coordinates] lon]];
    _locationPoint = [[MapPoint alloc] initWithCoordinate:[currentLocation coordinate] title: _singleLocation.key subtitle:_singleLocation.descriptionText];
    [currentLocation release];
    
    [_mapView addAnnotation:_locationPoint];
    
    [_mapView reloadInputViews];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
# pragma mark UIView
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
        [_delegate transferLocation:_singleLocation];
    }
    [[self presentingViewController] dismissModalViewControllerAnimated:YES];
}
- (IBAction)cancel:(id)sender
{
    [[self presentingViewController] dismissModalViewControllerAnimated:YES];
    
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
# pragma mark MKMapViewDelegate
//-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
//{
//    MKCoordinateRegion mapRegion;   
//    mapRegion.center = mapView.userLocation.coordinate;
//    mapRegion.span.latitudeDelta = 0.2;
//    mapRegion.span.longitudeDelta = 0.2;
//    [mapView setRegion:mapRegion animated: YES];
//}
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)u
{
    CLLocationCoordinate2D loc = [u coordinate];
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(loc, 5000, 5000);
    [mapView setRegion:region animated:YES];
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
# pragma mark LocationManager
- (void)locationManager:(CLLocationManager *)manager 
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"%@", newLocation);
    
    // How many seconds ago was this new location created?
    NSTimeInterval t = [[newLocation timestamp] timeIntervalSinceNow];
    
    // CLLocationManagers will return the last found location of the
    // device first, you don't want that data in this case.
    // If this location was made more than 3 minutes ago, ignore it.
    if (t < -180) {
        // This is cached data, you don't want it, keep looking
        return;
    }
//    [self foundLocation:newLocation];
}

- (void)locationManager:(CLLocationManager *)manager 
       didFailWithError:(NSError *)error
{
    NSLog(@"Could not find location: %@", error);
}

@end
