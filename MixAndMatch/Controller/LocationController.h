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

@interface LocationController : UIViewController <RKObjectLoaderDelegate, UIPickerViewDelegate, UIPickerViewDataSource, MKMapViewDelegate>
{
@private
    NSMutableArray *_locations;
    Location *singleLocation;
    MapPoint *locationPoint;
    MKMapView *_mapView;
}

@property (nonatomic, assign) id<LocationControllerDelegate> delegate;
@property (nonatomic, retain) IBOutlet UIPickerView *locationPicker;
@property (nonatomic, retain) IBOutlet MKMapView *_mapView;
@property (nonatomic, retain) MapPoint *locationPoint; 
- (IBAction)addLocation:(id)sender;
- (IBAction)cancel:(id)sender;

@end
