//
//  Location.h
//  
//
//  Created by  on 25.09.11.
//  Copyright 2011. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>
#import "BaseModel.h"

@class Coordinate;

@interface Location : NSObject<BaseModel>

@property (nonatomic, retain) Coordinate *coordinates;
@property (nonatomic, copy) NSString *descriptionText;
@property (nonatomic, copy) NSString *key;
@property (nonatomic, copy) NSString *label;
@property (nonatomic, copy) NSString *venue;

@end
