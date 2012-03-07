//
//  Coordinate.h
//  
//
//  Created by  on 25.09.11.
//  Copyright 2011. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>
#import <MapKit/MapKit.h>
#import "BaseModel.h"

@interface Coordinate : NSObject<BaseModel>

@property (nonatomic, assign) CLLocationDegrees lat;
@property (nonatomic, assign) CLLocationDegrees lon;
@end
