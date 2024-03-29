//
//  LocationController.h
//  MixAndMatch
//
//  Created by Florian Schebelle on 22.02.12.
//  Copyright (c) 2012 metafinanz Informationssysteme GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>
#import "Location.h"
#import "MapPoint.h"
#import "SetUserViewController.h"

@class LocationController;

@protocol LocationControllerDelegate <NSObject>

@required
- (void) transferLocation:(Location *) location;

@end

@interface LocationController : UIViewController <RKObjectLoaderDelegate, UIPickerViewDelegate, UIPickerViewDataSource, MKMapViewDelegate,CLLocationManagerDelegate>
{
@private
    CLLocationManager *locationManager;
    NSMutableArray *_locations;
    Location *_singleLocation;
    MapPoint *_locationPoint;
    
    IBOutlet UIPickerView *_locationPicker;
    IBOutlet MKMapView *_mapView;
    IBOutlet UIActivityIndicatorView *_activityIndicator;
}

@property (nonatomic, retain) id<LocationControllerDelegate> setupLunchDelegate;
@property (nonatomic, retain) MapPoint *locationPoint; 
- (IBAction)addLocation:(id)sender;
- (IBAction)cancel:(id)sender;

@end
