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

@class LocationController;

@protocol LocationControllerDelegate <NSObject>

@required
- (void) transferLocation:(Location *) location;

@end

@interface LocationController : UIViewController <RKObjectLoaderDelegate, UIPickerViewDelegate, UIPickerViewDataSource>
{
@private
    NSMutableArray *locations;
    Location *singleLocation;
    MapPoint *locationPoint;
    MKMapView *mapView;
}

@property (nonatomic, assign) id<LocationControllerDelegate> delegate;
@property (nonatomic, retain) IBOutlet UIPickerView *locationPicker;
@property (nonatomic, retain) IBOutlet MKMapView *mapView;
@property (nonatomic, retain) MapPoint *locationPoint; 
- (IBAction)addLocation:(id)sender;
- (IBAction)cancel:(id)sender;


@end
