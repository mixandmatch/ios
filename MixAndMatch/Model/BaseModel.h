//
//  BaseModel.h
//  Mix And Match
//
//  Created by Florian Schebelle on 28.09.11.
//  Copyright 2011 metafinanz Informationssysteme GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

@protocol BaseModel <NSObject>

+ (RKObjectMapping*) mapping;

@end
