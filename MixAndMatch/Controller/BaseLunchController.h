//
//  BaseLunchController.h
//  
//
//  Created by Florian Schebelle on 11.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>
#import "SetUserViewController.h"

typedef enum _LocationTypes{
    HVU=0,
    KP=1
}_LocationEnum;

@interface BaseLunchController : UIViewController <RKObjectLoaderDelegate, UITableViewDelegate,UITableViewDataSource>
{   
    IBOutlet UIActivityIndicatorView* _activityIndicatorView;
    IBOutlet UITableView *_tableView;
    
    @private
    NSArray *_entriesHVU;
    NSArray *_entriesKP;
    NSArray *_entriesOthers;
    id<MFSetUserDelegate> _masterController;
}

@property(nonatomic, retain) NSArray *entriesHVU;
@property(nonatomic, retain) NSArray *entriesKP;
@property(nonatomic, retain) NSArray *entriesOthers;
@property(nonatomic, assign) id<MFSetUserDelegate> masterController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil masterController:(id<MFSetUserDelegate>)delegate;
-(void)resetEvents;
@end
