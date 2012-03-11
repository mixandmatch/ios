//
//  EventRequestControllerViewController.h
//  MixAndMatch
//
//  Created by Florian Schebelle on 22.02.12.
//  Copyright (c) 2012 metafinanz Informationssysteme GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>
#import "SetUserViewController.h"

@interface EventRequestController : UITableViewController <RKObjectLoaderDelegate>
{
@private
    NSMutableArray *_eventRequests;
    id<MFSetUserDelegate> _masterController;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil masterController:(id<MFSetUserDelegate>)delegate;

@end
