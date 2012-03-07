//
//  MapViewController.h
//  MixAndMatch
//
//  Created by Florian Schebelle on 05.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "MapPoint.h"

@interface MapViewController : UIViewController <MKMapViewDelegate>
{
    MapPoint *locationPoint;
}
@property (nonatomic, retain) MapPoint *locationPoint; 
@end
