//
//  MyClass.h
//  
//
//  Created by Florian Schebelle on 25.09.11.
//  Copyright 2011. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>
#import "BaseModel.h"

@interface EventRequest : NSObject <BaseModel>

@property (nonatomic, copy) NSDate *date;
//@property (nonatomic, copy) NSString *eventRequestId;
@property (nonatomic, copy) NSString *locationKey;
//@property (nonatomic, copy) NSString *rev;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *userId;

@end
