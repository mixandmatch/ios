//
//  EventRequestControllerViewController.h
//  MixAndMatch
//
//  Created by Florian Schebelle on 22.02.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>

@interface EventRequestController : UITableViewController <RKObjectLoaderDelegate>
{
@private
    NSMutableArray *eventRequests;
    
}

@end