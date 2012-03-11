//
//  Match.h
//  
//
//  Created by  on 25.09.11.
//  Copyright 2011. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>
#import "BaseModel.h"

@interface Match : NSObject<BaseModel>

@property (nonatomic, copy) NSDate *date;
@property (nonatomic, copy) NSString *locationKey;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSArray *users;

@end
